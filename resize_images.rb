#!/usr/bin/env ruby

require 'fileutils'
require 'pathname'

SIZES = [128, 256, 512, 768, 1024, 1536, 2048]
SOURCE_DIR = 'photos-original'
VALID_EXTENSIONS = %w[.jpg .jpeg .png .gif .bmp .tiff .tif].freeze

def valid_image?(filename)
  ext = File.extname(filename).downcase
  VALID_EXTENSIONS.include?(ext) && !filename.start_with?('.')
end

def resize_image(source_path, dest_path, size)
  # Using macOS sips command which preserves aspect ratio by default
  # The size parameter is the maximum dimension (width or height)
  cmd = "sips -Z #{size} '#{source_path}' --out '#{dest_path}' 2>&1"
  output = `#{cmd}`
  success = $?.success?
  
  unless success
    puts "  ❌ Failed to resize: #{output.strip}"
  end
  
  success
end

def main
  unless Dir.exist?(SOURCE_DIR)
    puts "❌ Source directory '#{SOURCE_DIR}' not found!"
    exit 1
  end
  
  images = Dir.entries(SOURCE_DIR)
    .select { |f| valid_image?(f) }
    .sort
  
  if images.empty?
    puts "❌ No images found in '#{SOURCE_DIR}'"
    exit 1
  end
  
  puts "Found #{images.length} images to process"
  puts "Resizing to sizes: #{SIZES.join(', ')}"
  puts
  
  total_operations = images.length * SIZES.length
  completed = 0
  
  SIZES.each do |size|
    dest_dir = "photo-#{size}"
    FileUtils.mkdir_p(dest_dir)
    puts "📁 Processing size #{size}px → #{dest_dir}/"
    
    images.each do |image|
      source_path = File.join(SOURCE_DIR, image)
      dest_path = File.join(dest_dir, image)
      
      print "  • #{image}... "
      
      if resize_image(source_path, dest_path, size)
        puts "✓"
      end
      
      completed += 1
      progress = (completed.to_f / total_operations * 100).round(1)
      print "\rProgress: #{progress}% (#{completed}/#{total_operations})" if completed % 10 == 0
    end
    
    puts
  end
  
  puts "\n✅ Resizing complete!"
  puts "Created directories:"
  SIZES.each do |size|
    dir = "photo-#{size}"
    count = Dir.entries(dir).select { |f| valid_image?(f) }.length
    puts "  • #{dir}/ (#{count} images)"
  end
end

if __FILE__ == $0
  main
end