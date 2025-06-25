#!/usr/bin/env ruby

require 'csv'
require 'optparse'
require 'fileutils'

# Get all combinations of model, size, and prompt
def get_all_jobs
  models = [
    'qwen2.5vl:3b',
    'moondream:1.8b',
    'llava:7b',
    'llava:13b',
    # 'llama3.2-vision:11b',
    'llava-phi3:3.8b'
  ]

  sizes = Dir.glob('photo-*').select { |d| File.directory?(d) }
    .map { |d| d.match(/photo-(\d+)/)[1].to_i }
    .sort

  prompts = Dir.glob('prompts/*.txt')
    .map { |f| File.basename(f, '.txt') }
    .sort

  jobs = []
  models.each do |model|
    sizes.each do |size|
      prompts.each do |prompt|
        jobs << { model: model, size: size, prompt: prompt }
      end
    end
  end

  jobs
end

# Check if a job is already complete
def job_complete?(job)
  csv_path = "results/#{job[:model].gsub(':', '-')}/#{job[:size]}/#{job[:prompt]}.csv"
  return false unless File.exist?(csv_path)

  # Check if all images were processed
  csv_count = CSV.read(csv_path).length - 1  # Minus header
  image_count = Dir["photo-#{job[:size]}/*.{jpg,jpeg,png}"].length

  csv_count >= image_count
end

# Main execution
options = {
  parallel: 2,
  models: nil,
  skip_complete: true
}

OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]"

  opts.on("-j", "--parallel NUM", Integer, "Number of parallel workers (default: 2)") do |n|
    options[:parallel] = n
  end

  opts.on("-m", "--models MODELS", "Comma-separated list of models to process") do |m|
    options[:models] = m.split(',').map(&:strip)
  end

  opts.on("--no-skip", "Don't skip completed jobs") do
    options[:skip_complete] = false
  end

  opts.on("-h", "--help", "Show this help") do
    puts opts
    exit
  end
end.parse!

# Get all jobs
all_jobs = get_all_jobs

# Filter by models if specified
if options[:models]
  all_jobs.select! { |job| options[:models].include?(job[:model]) }
end

# Filter completed jobs
if options[:skip_complete]
  remaining_jobs = all_jobs.reject { |job| job_complete?(job) }
  completed = all_jobs.length - remaining_jobs.length

  if completed > 0
    puts "✓ Skipping #{completed} completed jobs"
  end

  all_jobs = remaining_jobs
end

if all_jobs.empty?
  puts "✅ All jobs complete!"
  exit
end

puts "📊 Jobs to process: #{all_jobs.length}"
puts "🚀 Running with #{options[:parallel]} parallel workers"
puts

# Group jobs by model to minimize model switching
jobs_by_model = all_jobs.group_by { |job| job[:model] }

# Process each model's jobs
jobs_by_model.each do |model, model_jobs|
  puts "\n" + "=" * 60
  puts "Processing #{model} (#{model_jobs.length} jobs)"
  puts "=" * 60

  # Ensure model is loaded
  unless `ollama list`.include?(model.split(':').first)
    puts "📦 Pulling #{model}..."
    system("ollama pull #{model}")
  end

  # Process jobs in batches
  model_jobs.each_slice(options[:parallel]) do |batch|
    threads = batch.map do |job|
      Thread.new do
        cmd = [
          "./extract_tags_worker.rb",
          "-m '#{job[:model]}'",
          "-s #{job[:size]}",
          "-p '#{job[:prompt]}'"
        ].join(" ")

        system(cmd)
      end
    end

    # Wait for batch to complete
    threads.each(&:join)
  end

  # Unload model to free memory
  puts "🧹 Unloading #{model}..."
  system("ollama stop #{model}", out: File::NULL, err: File::NULL)
end

puts "\n✅ All jobs complete!"

# Offer to aggregate results
puts "\nRun ./aggregate_results.rb to create the master CSV"
