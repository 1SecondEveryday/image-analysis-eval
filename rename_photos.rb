#!/usr/bin/env ruby

require 'fileutils'

# Get all image files
images = Dir.glob('photos-original/*').select do |f|
  ext = File.extname(f).downcase
  ['.jpg', '.jpeg', '.png'].include?(ext) && File.file?(f)
end.sort

puts "Found #{images.length} images to rename"
puts "This script will help you rename them interactively."
puts

# Create a mapping of old names to new names
mappings = []

images.each_with_index do |old_path, index|
  old_name = File.basename(old_path)
  number = sprintf("%02d", index + 1)
  
  puts "\n---"
  puts "Image #{number}: #{old_name}"
  puts "Opening image for preview..."
  
  # Open the image in Preview
  system("open -a Preview '#{old_path}'")
  
  puts "\nEnter a descriptive name (e.g., 'beach-sunset', 'family-dinner', 'mountain-hike'):"
  puts "Or press Enter to skip this image:"
  
  description = gets.chomp.strip
  
  if description.empty?
    puts "Skipping..."
    next
  end
  
  # Clean up the description
  description = description.downcase.gsub(/[^a-z0-9-]/, '-').gsub(/-+/, '-').gsub(/^-|-$/, '')
  
  # Get the extension
  ext = File.extname(old_path).downcase
  ext = '.jpg' if ext == '.jpeg'  # Normalize jpeg to jpg
  
  new_name = "#{number}-#{description}#{ext}"
  new_path = File.join('photos-original', new_name)
  
  mappings << [old_path, new_path, old_name, new_name]
  
  puts "Will rename: #{old_name} → #{new_name}"
end

if mappings.empty?
  puts "\nNo images to rename."
  exit
end

puts "\n\n=== SUMMARY ==="
puts "Will rename #{mappings.length} images:"
puts

mappings.each do |old_path, new_path, old_name, new_name|
  puts "  #{old_name} → #{new_name}"
end

puts "\nProceed with renaming? (y/n)"
confirm = gets.chomp.downcase

if confirm == 'y'
  mappings.each do |old_path, new_path, old_name, new_name|
    FileUtils.mv(old_path, new_path)
    puts "✓ Renamed: #{new_name}"
  end
  puts "\nDone! Renamed #{mappings.length} images."
else
  puts "Cancelled."
end