#!/usr/bin/env ruby

require 'json'
require 'base64'
require 'net/http'
require 'uri'
require 'fileutils'
require 'csv'
require 'optparse'
require 'time'
require 'concurrent'

class TagExtractor
  OLLAMA_URL = 'http://localhost:11434/api/generate'
  DEFAULT_MODELS = ['qwen2.5vl:3b', 'moondream:1.8b', 'llava:7b', 'llava:13b', 'llama3.2-vision:11b', 'llava-phi3:3.8b']
  VALID_EXTENSIONS = %w[.jpg .jpeg .png .gif .bmp .tiff .tif].freeze

  def initialize(options = {})
    @parallel = options[:parallel] || 8
    @models = options[:models] || DEFAULT_MODELS
    @timeout = options[:timeout] || 120
    @verbose = options[:verbose] || false
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
    puts "  • #{prompts.length} prompts loaded"
    puts "  • #{@models.length} models to test"
    puts "  • #{@parallel} parallel requests"
    puts

    total_tasks = images.length * prompts.length * @models.length
    completed = Concurrent::AtomicFixnum.new(0)
    start_time = Time.now

    # Create master CSV
    master_csv = CSV.open('results/master.csv', 'w')
    master_csv << %w[model image_size prompt_name image_filename tags raw_output timestamp success]

    # Process in batches by model to allow proper cleanup
    @models.each do |model|
      puts "\n📊 Processing model: #{model}"

      # Ensure model is loaded
      ensure_model_loaded(model)

      # Create thread pool for this model
      pool = Concurrent::FixedThreadPool.new(@parallel)

      prompts.each do |prompt_file, prompt_content|
        prompt_name = File.basename(prompt_file, '.*')

        images.each do |image_info|
          pool.post do
            process_single_image(
              model: model,
              image_info: image_info,
              prompt_name: prompt_name,
              prompt_content: prompt_content,
              master_csv: master_csv,
              completed: completed,
              total: total_tasks
            )
          end
        end
      end

      # Wait for all tasks for this model to complete
      pool.shutdown
      pool.wait_for_termination

      # Unload model to free memory
      puts "  🧹 Unloading model #{model}..."
      unload_model(model)
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

    Dir.glob('photo-*').select { |d| File.directory?(d) }.each do |dir|
      size = dir.match(/photo-(\d+)/)[1]

      Dir.entries(dir).each do |file|
        next unless valid_image?(file)

        images << {
          path: File.join(dir, file),
          filename: file,
          size: size.to_i
        }
      end
    end

    images.sort_by { |img| [img[:size], img[:filename]] }
  end

  def valid_image?(filename)
    ext = File.extname(filename).downcase
    VALID_EXTENSIONS.include?(ext) && !filename.start_with?('.')
  end

  def load_prompts
    prompts = {}

    Dir.glob('prompts/*.txt').each do |file|
      content = File.read(file).strip
      prompts[file] = content
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

  def unload_model(model)
    uri = URI.parse('http://localhost:11434/api/delete')
    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Delete.new(uri.path)
    request['Content-Type'] = 'application/json'
    request.body = { name: model }.to_json

    begin
      response = http.request(request)
      if response.code == '200'
        puts "  ✓ Model unloaded successfully"
      else
        puts "  ⚠️  Failed to unload model: #{response.body}"
      end
    rescue => e
      puts "  ⚠️  Error unloading model: #{e.message}"
    end
  end

  def process_single_image(model:, image_info:, prompt_name:, prompt_content:, master_csv:, completed:, total:)
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

    # Save to master CSV (thread-safe)
    @mutex ||= Mutex.new
    @mutex.synchronize do
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
    end

    # Update progress
    count = completed.increment
    progress = (count.to_f / total * 100).round(1)
    elapsed = Time.now - start

    if @verbose || count % 10 == 0
      print "\r  Progress: #{progress}% (#{count}/#{total}) - Last: #{elapsed.round(1)}s"
    end

  rescue => e
    puts "\n  ❌ Error processing #{image_info[:filename]}: #{e.message}"
    @mutex ||= Mutex.new
    @mutex.synchronize do
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
  end

  def query_ollama(model:, image_base64:, prompt:)
    uri = URI.parse(OLLAMA_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.read_timeout = @timeout

    request = Net::HTTP::Post.new(uri.path)
    request['Content-Type'] = 'application/json'
    request.body = {
      model: model,
      prompt: prompt,
      images: [image_base64],
      stream: false,
      options: {
        temperature: 0.1,
        num_predict: 500
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
    # Clean up the output to extract just the tags
    cleaned = raw_output.strip

    # Remove any explanatory text before or after tags
    lines = cleaned.split("\n")
    tag_line = lines.find { |line| line.include?(',') } || cleaned

    # Clean up common patterns
    tag_line
      .gsub(/^(tags:|keywords:|output:)/i, '')
      .gsub(/["\[\]{}]/, '')
      .strip
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
    parallel: 8,
    models: TagExtractor::DEFAULT_MODELS,
    timeout: 120,
    verbose: false
  }

  OptionParser.new do |opts|
    opts.banner = "Usage: #{$0} [options]"

    opts.on("-p", "--parallel NUM", Integer, "Number of parallel requests (default: 8)") do |n|
      options[:parallel] = n
    end

    opts.on("-m", "--models MODELS", "Comma-separated list of models") do |models|
      options[:models] = models.split(',').map(&:strip)
    end

    opts.on("-t", "--timeout SECONDS", Integer, "Request timeout in seconds (default: 120)") do |t|
      options[:timeout] = t
    end

    opts.on("-v", "--verbose", "Verbose output") do
      options[:verbose] = true
    end

    opts.on("-h", "--help", "Show this help") do
      puts opts
      exit
    end
  end.parse!

  extractor = TagExtractor.new(options)
  extractor.run
end
