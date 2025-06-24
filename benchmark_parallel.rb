#!/usr/bin/env ruby

require 'fileutils'

# Test with a small subset
test_sizes = [1, 2, 4, 8]
test_model = ARGV[0] || 'moondream:1.8b'

puts "Benchmarking parallelism with model: #{test_model}"
puts "This will resize some test images and run quick tests"
puts "=" * 60

# Create test images if needed
unless Dir.exist?('photo-512')
  puts "Creating test images..."
  system('./resize_images.rb')
end

# Run tests with different parallelism levels
results = {}

test_sizes.each do |parallel|
  puts "\nTesting with #{parallel} parallel requests..."

  start_time = Time.now

  # Run with just one prompt and limited images
  success = system(
    "./extract_tags.rb -p #{parallel} -m #{test_model} -v"
    out: File::NULL,
    err: File::NULL
  )

  elapsed = Time.now - start_time
  results[parallel] = elapsed

  puts "  Time: #{elapsed.round(1)}s"

  # Clean up results between runs
  FileUtils.rm_rf('results')
end

puts "\n" + "=" * 60
puts "RESULTS:"
puts "=" * 60

baseline = results[1]
results.each do |parallel, time|
  speedup = baseline / time
  puts "#{parallel} parallel: #{time.round(1)}s (#{speedup.round(2)}x speedup)"
end

optimal = results.min_by { |_, time| time }
puts "\nOptimal parallelism: #{optimal[0]} (#{optimal[1].round(1)}s)"
