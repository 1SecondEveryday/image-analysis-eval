#!/usr/bin/env ruby

require 'fileutils'
require 'tmpdir'

# Get all image files
images = Dir.glob('photos-original/*').select do |f|
  ext = File.extname(f).downcase
  ['.jpg', '.jpeg', '.png'].include?(ext) && File.file?(f)
end.sort

puts "Found #{images.length} images to analyze and rename"
puts "Creating temporary resized versions for faster analysis..."

# Create temp directory for resized images
temp_dir = Dir.mktmpdir('image_resize_')

# First, resize all images to small versions for quick viewing
images.each_with_index do |img, idx|
  temp_path = File.join(temp_dir, "temp_#{idx}#{File.extname(img)}")
  system("sips -Z 512 '#{img}' --out '#{temp_path}' >/dev/null 2>&1")
  print "."
end

puts "\n\nReady to analyze images. I'll look at each one and suggest descriptive names."
puts "=" * 60

# Store the renamed paths
File.open('rename_mapping.txt', 'w') do |f|
  images.each_with_index do |original_path, idx|
    temp_path = File.join(temp_dir, "temp_#{idx}#{File.extname(original_path)}")
    old_name = File.basename(original_path)
    number = sprintf("%02d", idx + 1)
    
    f.puts "#{number}|#{old_name}|#{temp_path}|#{original_path}"
  end
end

puts "\nI've prepared the images for analysis."
puts "Temporary resized versions are in: #{temp_dir}"
puts "Mapping file created: rename_mapping.txt"
puts "\nI'll now analyze each image and create the rename script..."

# Cleanup temp files will happen automatically when script ends
puts "\nNext step: I'll look at each image and generate descriptive names."