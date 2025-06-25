#!/usr/bin/env ruby

require 'csv'
require 'json'
require 'fileutils'

puts "🔄 Aggregating results into master.csv..."

# Create master CSV
master_csv = CSV.open('results/master.csv', 'w')
master_csv << %w[model image_size prompt_name image_filename tags raw_output timestamp success]

# Stats tracking
total_rows = 0
missing_files = []

# Walk through all result directories
Dir.glob('results/*/*/*').select { |f| f.end_with?('.csv') }.sort.each do |csv_file|
  # Extract metadata from path
  parts = csv_file.split('/')
  model = parts[-3].gsub('-', ':')
  size = parts[-2].to_i
  prompt_name = File.basename(parts[-1], '.csv')
  
  # Skip the master.csv if it exists
  next if csv_file.include?('master.csv')
  
  print "\r  Processing: #{model}/#{size}/#{prompt_name}..."
  
  begin
    # Read the CSV
    row_count = 0
    CSV.foreach(csv_file, headers: true) do |row|
      master_csv << [
        model,
        size,
        prompt_name,
        row['image_filename'],
        row['tags'],
        row['raw_output'],
        row['timestamp'],
        row['success']
      ]
      row_count += 1
      total_rows += 1
    end
    
    print "\r  ✓ #{model}/#{size}/#{prompt_name}: #{row_count} rows"
    puts
    
  rescue => e
    missing_files << csv_file
    puts "\r  ❌ Error reading #{csv_file}: #{e.message}"
  end
end

master_csv.close

puts "\n" + "=" * 60
puts "AGGREGATION COMPLETE"
puts "=" * 60
puts "Total rows: #{total_rows}"
puts "Output: results/master.csv"

if missing_files.any?
  puts "\n⚠️  Failed to read #{missing_files.length} files:"
  missing_files.each { |f| puts "  • #{f}" }
end

# Generate summary statistics
puts "\n📊 Generating summary statistics..."

summary = {
  total_analyses: total_rows,
  by_model: Hash.new(0),
  by_size: Hash.new(0),
  by_prompt: Hash.new(0),
  success_rate: 0,
  timestamp: Time.now.iso8601
}

success_count = 0

CSV.foreach('results/master.csv', headers: true) do |row|
  summary[:by_model][row['model']] += 1
  summary[:by_size][row['image_size']] += 1
  summary[:by_prompt][row['prompt_name']] += 1
  success_count += 1 if row['success'] == 'true'
end

summary[:success_rate] = (success_count.to_f / total_rows * 100).round(2)

File.write('results/summary.json', JSON.pretty_generate(summary))

puts "\nSummary by model:"
summary[:by_model].each do |model, count|
  puts "  • #{model}: #{count} analyses"
end

puts "\nSummary by size:"
summary[:by_size].sort_by { |size, _| size.to_i }.each do |size, count|
  puts "  • #{size}px: #{count} analyses"
end

puts "\nSuccess rate: #{summary[:success_rate]}%"
puts "\n📄 Full summary saved to: results/summary.json"