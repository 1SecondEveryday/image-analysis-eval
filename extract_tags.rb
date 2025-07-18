#!/usr/bin/env ruby

require 'json'
require 'base64'
require 'net/http'
require 'uri'
require 'fileutils'
require 'csv'
require 'optparse'
require 'time'

class TagExtractor
  OLLAMA_URL = 'http://localhost:11434/api/generate'

  DEFAULT_MODELS = ['llava:7b', 'qwen2.5vl:7b', 'minicpm-v:8b', 'gemma3:12b']

  VALID_EXTENSIONS = %w[.jpg .jpeg .png .gif .bmp .tiff .tif].freeze

  DEFAULT_SYSTEM_PROMPT = <<~PROMPT.freeze
    You are an image-keyword assistant. After analyzing each picture, output one line containing concise,
    lowercase English keywords separated by commas. Focus on people's emotions, expressions, moods, and
    activities, if present. When no people are present then ignore that aspect and focus on the rest of the
    scene. Include overall atmosphere, key objects, dominant colors, lighting quality, and setting.
    When there are people then you can include descriptors like 'couple', 'group', 'crowd', 'solo', 'alone',
    etc. When the image appears to be a selfie or POV (point-of-view/first-person perspective),
    include 'selfie' or 'pov' as appropriate but don't guess, just omit if unsure. Prioritize emotional and
    mood keywords. Do not repeat synonyms. DO NOT OUTPUT ANYTHING EXCEPT THE COMMA-SEPARATED LIST. DON'T
    REPEAT KEYWORDS OR THEMES EXCESSIVELY.
  PROMPT

  def initialize(options = {})
    @models = options[:models] || DEFAULT_MODELS
    @timeout = options[:timeout] || 120
    @verbose = options[:verbose] || false
    @max_images = options[:max_images] || nil
    @no_unload = options[:no_unload] || false
    @skip_prompt = options[:skip_prompt] || false
    @system_prompt = options[:system_prompt] || DEFAULT_SYSTEM_PROMPT
  end

  def run
    setup_directories
    images = collect_images
    prompts = load_prompts

    if images.empty?
      puts "❌ No images found in photo-* directories"
      return
    end

    if prompts.empty?
      puts "❌ No prompt files found in prompts/ directory"
      return
    end

    puts "🚀 Starting tag extraction:"
    puts "  • #{images.length} images found"
    puts "  • #{prompts.length} prompts#{@skip_prompt ? ' (system prompt only)' : ' loaded'}"
    puts "  • #{@models.length} models to test"
    puts

    total_tasks = images.length * prompts.length * @models.length
    completed = 0
    start_time = Time.now

    # Create master CSV
    master_csv = CSV.open('results/master.csv', 'w')
    master_csv << %w[model image_size prompt_name image_filename tags raw_output timestamp success]

    # Process each model sequentially
    @models.each_with_index do |model, model_index|
      puts "\n" + "=" * 60
      puts "📊 Model #{model_index + 1}/#{@models.length}: #{model}"
      puts "=" * 60

      # Check if model exists and pull if needed
      unless model_exists?(model)
        puts "  📦 Model #{model} not found locally. Attempting to pull..."
        puts "  ⏳ This may take a while for large models..."

        pull_success = system("ollama pull #{model}")

        unless pull_success
          puts "  ❌ Failed to pull #{model}. Skipping this model."
          puts "     Try running manually: ollama pull #{model}"
          next
        end

        puts "  ✓ Successfully pulled #{model}"
      else
        puts "  ✓ Model #{model} already available"
      end

      # Ensure model is loaded
      ensure_model_loaded(model)

      # Process each prompt/image combination
      prompts.each do |prompt_file, prompt_content|
        prompt_name = File.basename(prompt_file, '.*')

        images.each do |image_info|
          completed += 1
          progress = (completed.to_f / total_tasks * 100).round(1)
          # Clear the line with spaces to prevent leftover characters
          print "\r%-80s" % " "
          print "\r  Progress: #{progress}% (#{completed}/#{total_tasks}) - Processing #{image_info[:filename]}"

          process_single_image(
            model: model,
            image_info: image_info,
            prompt_name: prompt_name,
            prompt_content: prompt_content,
            master_csv: master_csv
          )
        end
      end

      # Unload model to free memory (unless disabled)
      unless @no_unload
        puts "\n  🧹 Unloading model #{model}..."
        unload_model(model)
      end
    end

    master_csv.close

    elapsed = Time.now - start_time
    puts "\n✅ Extraction complete!"
    puts "  • Total time: #{format_duration(elapsed)}"
    puts "  • Results saved to: results/"
    puts "  • Master CSV: results/master.csv"
  end

  private

  def setup_directories
    FileUtils.mkdir_p('results')
    FileUtils.mkdir_p('expected-tags')
  end

  def collect_images
    images = []

    # Only process 768 size
    allowed_sizes = [768]

    Dir.glob('photo-*').select { |d| File.directory?(d) }.each do |dir|
      size_match = dir.match(/photo-(\d+)/)
      next unless size_match

      size = size_match[1].to_i

      # Skip sizes we don't want
      next unless allowed_sizes.include?(size)

      Dir.entries(dir).each do |file|
        next unless valid_image?(file)

        images << {
          path: File.join(dir, file),
          filename: file,
          size: size
        }
      end
    end

    images = images.sort_by { |img| [img[:size], img[:filename]] }

    # Limit images if requested
    if @max_images && @max_images > 0
      images = images.first(@max_images)
    end

    images
  end

  def valid_image?(filename)
    ext = File.extname(filename).downcase
    VALID_EXTENSIONS.include?(ext) && !filename.start_with?('.')
  end

  def load_prompts
    prompts = {}

    if @skip_prompt
      # Use minimal prompt to rely mainly on system prompt
      prompts["no_prompt"] = "Analyze this image."
    else
      # Load all prompts
      Dir.glob('prompts/*.txt').each do |file|
        content = File.read(file).strip
        prompts[file] = content
      end
    end

    prompts
  end

  def ensure_model_loaded(model)
    # Try to generate a simple response to ensure model is loaded
    uri = URI.parse(OLLAMA_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.read_timeout = 30

    request = Net::HTTP::Post.new(uri.path)
    request['Content-Type'] = 'application/json'
    request.body = {
      model: model,
      prompt: "test",
      stream: false
    }.to_json

    begin
      http.request(request)
    rescue => e
      puts "  ⚠️  Failed to ensure model loaded: #{e.message}"
    end
  end

  def model_exists?(model)
    list_output = `ollama list 2>&1`
    # The model name appears at the start of each line in the output
    list_output.lines.any? { |line| line.strip.start_with?("#{model} ") || line.strip.start_with?("#{model}\t") }
  end

  def unload_model(model)
    # Skip unloading if model doesn't exist
    return unless model_exists?(model)

    # Use ollama stop command to unload model from memory
    success = system("ollama stop #{model}", out: File::NULL, err: File::NULL)

    if success
      puts "  ✓ Model unloaded from memory"
    else
      puts "  ⚠️  Failed to unload model from memory"
    end
  end

  def process_single_image(model:, image_info:, prompt_name:, prompt_content:, master_csv:)
    start = Time.now

    # Read and encode image
    image_data = File.read(image_info[:path], mode: 'rb')
    image_base64 = Base64.strict_encode64(image_data)

    # Make API request
    response_data = query_ollama(
      model: model,
      image_base64: image_base64,
      prompt: prompt_content
    )

    # Parse response
    success = response_data[:success]
    raw_output = response_data[:response] || response_data[:error] || "No response"
    tags = success ? extract_tags(raw_output) : ""

    # Check expected tags if available
    expected_file = File.join('expected-tags', image_info[:filename].sub(/\.[^.]+$/, '.txt'))
    if File.exist?(expected_file) && success
      expected = File.read(expected_file).strip.downcase.split(',').map(&:strip)
      found_tags = tags.downcase.split(',').map(&:strip)
      success = expected.all? { |tag| found_tags.include?(tag) }
    end

    # Save to individual CSV
    save_individual_result(
      model: model,
      size: image_info[:size],
      prompt_name: prompt_name,
      filename: image_info[:filename],
      tags: tags,
      raw_output: raw_output,
      success: success
    )

    # Save to master CSV (no longer need thread safety)
    master_csv << [
      model,
      image_info[:size],
      prompt_name,
      image_info[:filename],
      tags,
      raw_output.gsub("\n", " "),
      Time.now.iso8601,
      success
    ]
    master_csv.flush

  rescue => e
    puts "\n  ❌ Error processing #{image_info[:filename]}: #{e.message}"
    master_csv << [
      model,
      image_info[:size],
      prompt_name,
      image_info[:filename],
      "",
      "Error: #{e.message}",
      Time.now.iso8601,
      false
    ]
  end

  def query_ollama(model:, image_base64:, prompt:)
    uri = URI.parse(OLLAMA_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.read_timeout = @timeout

    request = Net::HTTP::Post.new(uri.path)
    request['Content-Type'] = 'application/json'
    request.body = {
      model: model,
      system: @system_prompt,
      prompt: prompt,
      images: [image_base64],
      stream: false,
      options: {
        temperature: 0.1,
        num_predict: 300
      }
    }.to_json

    response = http.request(request)

    if response.code == '200'
      data = JSON.parse(response.body)
      { success: true, response: data['response'] }
    else
      { success: false, error: "HTTP #{response.code}: #{response.message}" }
    end

  rescue Net::ReadTimeout
    { success: false, error: "Request timed out after #{@timeout}s" }
  rescue => e
    { success: false, error: e.message }
  end

  def extract_tags(raw_output)
    # Clean up the output to extract just the keywords
    cleaned = raw_output.strip

    # Remove any explanatory text before or after keywords
    lines = cleaned.split("\n")
    tag_line = lines.find { |line| line.include?(',') } || cleaned

    # Clean up common patterns and remove hashtags
    cleaned_line = tag_line
      .gsub(/^(tags:|keywords:|output:)/i, '')
      .gsub(/["\[\]{}#]/, '')  # Added # to remove hashtags
      .strip

    # Split, clean, deduplicate, sort, and rejoin keywords
    keywords = cleaned_line.split(',')
      .map(&:strip)
      .map(&:downcase)
      .reject(&:empty?)
      .uniq
      .sort
      .join(', ')

    keywords
  end

  def save_individual_result(model:, size:, prompt_name:, filename:, tags:, raw_output:, success:)
    dir = "results/#{model.gsub(':', '-')}/#{size}"
    FileUtils.mkdir_p(dir)

    csv_path = File.join(dir, "#{prompt_name}.csv")

    # Create or append to CSV
    is_new = !File.exist?(csv_path)

    CSV.open(csv_path, 'a') do |csv|
      csv << %w[image_filename tags raw_output timestamp success] if is_new
      csv << [
        filename,
        tags,
        raw_output.gsub("\n", " "),
        Time.now.iso8601,
        success
      ]
    end

    # Save run metadata
    metadata_path = File.join(dir, 'run.json')
    metadata = {
      model: model,
      image_size: size,
      prompt_name: prompt_name,
      timestamp: Time.now.iso8601,
      system: {
        platform: RUBY_PLATFORM,
        ruby_version: RUBY_VERSION
      }
    }

    File.write(metadata_path, JSON.pretty_generate(metadata))
  end

  def format_duration(seconds)
    hours = seconds / 3600
    minutes = (seconds % 3600) / 60
    secs = seconds % 60

    if hours > 0
      "#{hours.floor}h #{minutes.floor}m #{secs.round}s"
    elsif minutes > 0
      "#{minutes.floor}m #{secs.round}s"
    else
      "#{secs.round}s"
    end
  end
end

# CLI interface
if __FILE__ == $0
  options = {
    models: TagExtractor::DEFAULT_MODELS,
    timeout: 120,
    verbose: false,
    max_images: nil,
    no_unload: false,
    skip_prompt: false
  }

  OptionParser.new do |opts|
    opts.banner = "Usage: #{$0} [options]"

    opts.on("-m", "--models MODELS", "Comma-separated list of models") do |models|
      options[:models] = models.split(',').map(&:strip)
    end

    opts.on("-t", "--timeout SECONDS", Integer, "Request timeout in seconds (default: 120)") do |t|
      options[:timeout] = t
    end

    opts.on("-v", "--verbose", "Verbose output") do
      options[:verbose] = true
    end

    opts.on("--max-images NUM", Integer, "Limit number of images to process") do |n|
      options[:max_images] = n
    end

    opts.on("--no-unload", "Don't unload models between tests") do
      options[:no_unload] = true
    end

    opts.on("--skip-prompt", "Skip user prompts and use only system prompt") do
      options[:skip_prompt] = true
    end

    opts.on("-h", "--help", "Show this help") do
      puts opts
      exit
    end
  end.parse!

  extractor = TagExtractor.new(options)
  extractor.run
end
