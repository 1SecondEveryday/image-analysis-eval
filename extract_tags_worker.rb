#!/usr/bin/env ruby

require 'json'
require 'base64'
require 'net/http'
require 'uri'
require 'fileutils'
require 'csv'
require 'optparse'
require 'time'

# Simplified worker that processes a specific model/size/prompt combination
class TagExtractorWorker
  OLLAMA_URL = 'http://localhost:11434/api/generate'
  
  def initialize(model:, size:, prompt:, timeout: 120)
    @model = model
    @size = size
    @prompt_name = prompt
    @prompt_file = "prompts/#{prompt}.txt"
    @timeout = timeout
    
    unless File.exist?(@prompt_file)
      raise "Prompt file not found: #{@prompt_file}"
    end
    
    @prompt_content = File.read(@prompt_file).strip
  end
  
  def run
    output_dir = "results/#{@model.gsub(':', '-')}/#{@size}"
    FileUtils.mkdir_p(output_dir)
    
    csv_path = File.join(output_dir, "#{@prompt_name}.csv")
    
    # Check if already processed
    if File.exist?(csv_path)
      existing_count = CSV.read(csv_path).length - 1  # Minus header
      total_images = Dir["photo-#{@size}/*.{jpg,jpeg,png}"].length
      
      if existing_count >= total_images
        puts "✓ Already complete: #{@model}/#{@size}/#{@prompt_name} (#{existing_count} images)"
        return
      else
        puts "⚠️  Resuming: #{@model}/#{@size}/#{@prompt_name} (#{existing_count}/#{total_images} done)"
      end
    end
    
    puts "🚀 Processing: #{@model} / size=#{@size} / prompt=#{@prompt_name}"
    
    # Collect images
    images = Dir["photo-#{@size}/*"].select { |f| f.match?(/\.(jpg|jpeg|png)$/i) }.sort
    
    if images.empty?
      puts "❌ No images found in photo-#{@size}/"
      return
    end
    
    # Load existing results to avoid reprocessing
    processed = Set.new
    if File.exist?(csv_path)
      CSV.foreach(csv_path, headers: true) do |row|
        processed << row['image_filename']
      end
    end
    
    # Open CSV for appending
    is_new = !File.exist?(csv_path)
    csv = CSV.open(csv_path, 'a')
    csv << %w[image_filename tags raw_output timestamp success] if is_new
    
    # Process images
    images.each_with_index do |image_path, idx|
      filename = File.basename(image_path)
      
      if processed.include?(filename)
        next
      end
      
      print "\r  Progress: #{idx + 1}/#{images.length} - #{filename}"
      
      # Process image
      result = process_image(image_path)
      
      # Save result
      csv << [
        filename,
        result[:tags],
        result[:raw_output].gsub("\n", " "),
        Time.now.iso8601,
        result[:success]
      ]
      csv.flush
    end
    
    csv.close
    puts "\n✅ Complete: #{images.length} images processed"
    
    # Save metadata
    metadata_path = File.join(output_dir, 'run.json')
    File.write(metadata_path, JSON.pretty_generate({
      model: @model,
      image_size: @size,
      prompt_name: @prompt_name,
      timestamp: Time.now.iso8601,
      images_processed: images.length
    }))
  end
  
  private
  
  def process_image(image_path)
    # Read and encode image
    image_data = File.read(image_path, mode: 'rb')
    image_base64 = Base64.strict_encode64(image_data)
    
    # Query Ollama
    uri = URI.parse(OLLAMA_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.read_timeout = @timeout
    
    request = Net::HTTP::Post.new(uri.path)
    request['Content-Type'] = 'application/json'
    request.body = {
      model: @model,
      prompt: @prompt_content,
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
      raw_output = data['response']
      tags = extract_tags(raw_output)
      { success: true, tags: tags, raw_output: raw_output }
    else
      { success: false, tags: '', raw_output: "HTTP #{response.code}: #{response.message}" }
    end
    
  rescue Net::ReadTimeout
    { success: false, tags: '', raw_output: "Timeout after #{@timeout}s" }
  rescue => e
    { success: false, tags: '', raw_output: "Error: #{e.message}" }
  end
  
  def extract_tags(raw_output)
    cleaned = raw_output.strip
    lines = cleaned.split("\n")
    tag_line = lines.find { |line| line.include?(',') } || cleaned
    
    tag_line
      .gsub(/^(tags:|keywords:|output:)/i, '')
      .gsub(/["\[\]{}]/, '')
      .strip
  end
end

# CLI
if __FILE__ == $0
  options = {}
  
  OptionParser.new do |opts|
    opts.banner = "Usage: #{$0} -m MODEL -s SIZE -p PROMPT [options]"
    
    opts.on("-m", "--model MODEL", "Model to use (required)") do |m|
      options[:model] = m
    end
    
    opts.on("-s", "--size SIZE", Integer, "Image size (required)") do |s|
      options[:size] = s
    end
    
    opts.on("-p", "--prompt PROMPT", "Prompt name without .txt (required)") do |p|
      options[:prompt] = p
    end
    
    opts.on("-t", "--timeout SECONDS", Integer, "Request timeout (default: 120)") do |t|
      options[:timeout] = t
    end
    
    opts.on("-h", "--help", "Show this help") do
      puts opts
      exit
    end
  end.parse!
  
  if options[:model].nil? || options[:size].nil? || options[:prompt].nil?
    puts "Error: Missing required arguments"
    puts "Run with -h for help"
    exit 1
  end
  
  worker = TagExtractorWorker.new(**options)
  worker.run
end