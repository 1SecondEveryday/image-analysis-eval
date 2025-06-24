#!/usr/bin/env ruby

require 'fileutils'

# Mapping of old names to new descriptive names
renames = [
  ["09160499-83e5-471d-8de5-7f1aa9eafddf.jpg", "01-street-meditation-couple.jpg"],
  ["20dd3b19-eee4-48d5-af49-0259a38e2408.jpg", "02-graffiti-skate-park.jpg"],
  ["2624ca42-b7f3-4261-aa72-5a501d1629f5.jpg", "03-belgian-stew-fries.jpg"],
  ["27258f38-bdfa-4b69-a1da-36dbb33cc12f.jpg", "04-cheese-fondue-dinner.jpg"],
  ["31306e90-1530-4ed8-b4bb-94d5a7a405d3.jpg", "05-snowboarders-mountain-rest.jpg"],
  ["4307aca3-5681-46d7-985e-1d3e66cb22dd.jpg", "06-alpine-trail-hiker.jpg"],
  ["66b590df-261e-4bd5-bad2-73265a069850.jpg", "07-restaurant-group-dinner.jpg"],
  ["753732ab-6bfc-4e6c-bffa-3d32950e5364.jpg", "08-neon-bar-friends.jpg"],
  ["7aaad732-2118-4fae-b740-3f22a3648be5.jpg", "09-record-store-group-photo.jpg"],
  ["IMG_1074.jpeg", "10-alpine-peaks-vista.jpg"],
  ["IMG_1106.jpeg", "11-blue-sneakers-blacklight.jpg"],
  ["IMG_1107.jpeg", "12-winter-jackets-uv-light.jpg"],
  ["IMG_1126.jpeg", "13-couple-train-selfie.jpg"],
  ["IMG_1142.jpeg", "14-freddie-mercury-statue.jpg"],
  ["IMG_1147.jpeg", "15-red-eyes-costume-display.jpg"],
  ["IMG_1227.jpeg", "16-highland-cattle-pen.jpg"],
  ["IMG_1519.jpeg", "17-european-town-rooftop-view.jpg"],
  ["IMG_1549.jpeg", "18-poppy-seed-cake-slices.jpg"],
  ["IMG_1555.jpeg", "19-louvre-pyramid-courtyard.jpg"],
  ["IMG_1580.jpeg", "20-woman-admiring-classical-statue.jpg"],
  ["IMG_1584.jpeg", "21-jeweled-royal-crown-display.jpg"],
  ["IMG_1631.jpeg", "22-catacomb-skull-bone-wall.jpg"],
  ["IMG_1632.jpeg", "23-catacomb-ossuary-plaque.jpg"],
  ["IMG_1886.jpeg", "24-forest-waterfall-moss-covered.jpg"],
  ["IMG_1892.jpeg", "25-dog-playing-in-river.jpg"],
  ["IMG_1896.jpeg", "26-outdoor-cedar-plank-cooking.jpg"],
  ["IMG_1955.jpeg", "27-woman-mountain-summit-view.jpg"],
  ["IMG_2026.jpeg", "28-theatrical-stage-projection-design.jpg"],
  ["IMG_2099.jpeg", "29-excited-black-brown-dog.jpg"],
  ["IMG_2132.jpeg", "30-woman-smiling-on-boat.jpg"],
  ["IMG_2152.jpeg", "31-wildebeest-herd-grazing-savanna.jpg"],
  ["IMG_2169.jpeg", "32-urban-fire-smoke-city-skyline.jpg"],
  ["IMG_2189.JPG", "33-seabird-flying-over-pine-trees.jpg"],
  ["IMG_2193.JPG", "34-humpback-whale-breaching-ocean.jpg"],
  ["IMG_2198.JPG", "35-whale-tail-diving-forest-coastline.jpg"],
  ["IMG_2205.jpeg", "36-quiche-held-coastal-landscape.jpg"],
  ["IMG_2206.jpeg", "37-urban-deer-family-crossing-street.jpg"],
  ["IMG_2207.jpeg", "38-sunset-reflection-over-water.jpg"],
  ["IMG_2208.jpeg", "39-orange-sunset-lake-silhouette.jpg"],
  ["IMG_2226.jpeg", "40-sleeping-dog-close-up-portrait.jpg"],
  ["IMG_2245.jpeg", "41-black-dog-on-rocky-riverbed.jpg"],
  ["IMG_2247.jpeg", "42-abandoned-blue-wheelbarrow-forest.jpg"],
  ["IMG_2250.jpeg", "43-purple-foxglove-with-raindrops.jpg"],
  ["IMG_2251.jpeg", "44-foxglove-flowers-forest-meadow.jpg"],
  ["IMG_2252.jpeg", "45-hiker-with-dog-forest-trail.jpg"],
  ["IMG_2256.jpeg", "46-aerial-view-coastal-town.jpg"],
  ["IMG_2260.jpeg", "47-office-party-snack-table.jpg"],
  ["IMG_2261.jpeg", "48-elephant-art-gallery-display.jpg"],
  ["IMG_2266.jpeg", "49-restaurant-dinner-gathering.jpg"],
  ["IMG_2267.jpeg", "50-war-memorial-statue-night.jpg"],
  ["IMG_2273.jpeg", "51-green-dessert-molecular-spheres.jpg"],
  ["IMG_2274.jpeg", "52-rose-shaped-dessert-edible-flower.jpg"],
  ["a6b53740-4fbc-4942-ab9e-9f6d1cfae3a0.jpg", "53-mountain-restaurant-couple-dining.jpg"],
  ["c07e04d3-aca7-46fe-a484-4e03968f0d53.jpg", "54-family-birthday-lunch-patio.jpg"],
  ["c899718b-598a-472b-b17e-37f59f0c72d4.jpg", "55-mountain-restaurant-group-dining.jpg"],
  ["c93135b2-008f-460e-b6c6-948f9ac584d2.jpg", "56-summit-selfie-sunny-snowboard.jpg"],
  ["d0ed54ba-7c8c-435e-92d1-50f4f7f4c36b.jpg", "57-mountain-hut-group-window-view.jpg"],
  ["d3e1f734-ed77-4ec9-8fe6-493f423b1802.jpg", "58-rustic-alpine-restaurant-group.jpg"]
]

puts "=" * 60
puts "IMAGE RENAMING SCRIPT"
puts "=" * 60
puts "\nThis will rename #{renames.length} images in photos-original/"
puts "\nNew names will be descriptive and numbered sequentially."
puts "\nExamples:"
puts "  • 09160499-83e5-471d-8de5-7f1aa9eafddf.jpg → 01-street-meditation-couple.jpg"
puts "  • IMG_1074.jpeg → 10-alpine-peaks-vista.jpg"
puts "\nProceed with renaming? (yes/no)"

response = gets.chomp.downcase

if response == 'yes' || response == 'y'
  success_count = 0
  error_count = 0
  
  renames.each do |old_name, new_name|
    old_path = File.join('photos-original', old_name)
    new_path = File.join('photos-original', new_name)
    
    if File.exist?(old_path)
      begin
        FileUtils.mv(old_path, new_path)
        puts "✓ #{old_name} → #{new_name}"
        success_count += 1
      rescue => e
        puts "✗ Error renaming #{old_name}: #{e.message}"
        error_count += 1
      end
    else
      puts "✗ File not found: #{old_name}"
      error_count += 1
    end
  end
  
  puts "\n" + "=" * 60
  puts "SUMMARY:"
  puts "  • Successfully renamed: #{success_count} files"
  puts "  • Errors: #{error_count} files" if error_count > 0
  puts "=" * 60
else
  puts "\nRenaming cancelled."
end

# Clean up temporary files
FileUtils.rm_f('rename_mapping.txt')