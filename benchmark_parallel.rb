#!/usr/bin/env ruby

require 'fileutils'
require 'json'

# Configuration
test_model = ARGV[0] || 'moondream:1.8b'
test_parallel_sizes = [1, 2, 4, 8]
test_prompt = '01-structured-comprehensive'
num_images = 8
num_runs = 3  # Multiple runs for averaging

puts "=" * 60
puts "PARALLELISM BENCHMARK"
puts "=" * 60
puts "Model: #{test_model}"
puts "Images: #{num_images}"
puts "Prompt: #{test_prompt}"
puts "Runs per setting: #{num_runs}"
puts

# Ensure we have test images
unless Dir.exist?('photo-512')
  puts "Creating test images (one-time setup)..."
  system('./resize_images.rb')
end

# Pull model if needed
puts "Ensuring model is available..."
unless `ollama list`.include?(test_model)
  system("ollama pull #{test_model}")
end

results = {}

test_parallel_sizes.each do |parallel|
  puts "\n" + "-" * 40
  puts "Testing #{parallel} parallel requests..."

  times = []

  num_runs.times do |run|
    print "  Run #{run + 1}/#{num_runs}... "

    # Clean up previous results
    FileUtils.rm_rf('results')

    start_time = Time.now

    # Run the extraction with specific parameters
    cmd = [
      "./extract_tags.rb",
      "-p #{parallel}",
      "-m #{test_model}",
      "--max-images #{num_images}",
      "--single-prompt #{test_prompt}",
      "--no-unload"  # Keep model loaded between runs
    ].join(" ")

    success = system(cmd, out: File::NULL, err: File::NULL)

    elapsed = Time.now - start_time
    times << elapsed

    puts "#{elapsed.round(2)}s"
  end

  avg_time = times.sum / times.length
  std_dev = Math.sqrt(times.map { |t| (t - avg_time) ** 2 }.sum / times.length)

  results[parallel] = {
    times: times,
    average: avg_time,
    std_dev: std_dev,
    per_image: avg_time / num_images
  }
end

# Analysis
puts "\n" + "=" * 60
puts "RESULTS SUMMARY"
puts "=" * 60

baseline = results[1][:average]

puts "\n%-10s %-12s %-12s %-12s %-12s" % ["Parallel", "Avg Time", "Std Dev", "Speedup", "Per Image"]
puts "-" * 60

results.each do |parallel, data|
  speedup = baseline / data[:average]
  puts "%-10d %-12.2f %-12.2f %-12.2f %-12.3f" % [
    parallel,
    data[:average],
    data[:std_dev],
    speedup,
    data[:per_image]
  ]
end

# Find optimal
optimal = results.min_by { |_, data| data[:average] }
puts "\n✅ Optimal parallelism: #{optimal[0]} (#{optimal[1][:average].round(2)}s average)"

# Save detailed results
File.write('benchmark_results.json', JSON.pretty_generate({
  model: test_model,
  num_images: num_images,
  prompt: test_prompt,
  timestamp: Time.now.iso8601,
  results: results
}))

puts "\n📊 Detailed results saved to: benchmark_results.json"

# Cleanup
puts "\n🧹 Cleaning up..."
system("ollama stop #{test_model}", out: File::NULL, err: File::NULL)
