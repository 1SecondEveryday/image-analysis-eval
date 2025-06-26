const imageData = [
  {
    filename: "01-street-meditation-couple.jpg",
    keywords: {
      "llava-7b": ["bench", "cold", "couple", "daytime", "people", "sidewalk", "sitting", "street", "urban", "winter"],
      "qwen2.5vl-7b": ["black", "blue", "calm", "casual", "cityscape", "couple", "daylight", "gray", "pov", "relaxed", "sidewalk", "sitting", "stone bench", "street", "urban", "winter clothing"],
      "minicpm-v-8b": ["bicycles parked in distance.", "casual interaction", "cityscape background", "cold weather clothing", "couple", "overcast sky", "public space", "relaxed", "sidewalk pavement", "sitting on bench", "urban street scene"]
    }
  },
  {
    filename: "02-graffiti-skate-park.jpg",
    keywords: {
      "llava-7b": ["abandoned building", "broken", "concrete", "contemplative", "dark", "decaying", "desolate", "desolation", "dilapidated", "dirty", "edgy", "empty", "graffiti", "gritty", "introspective", "melancholic", "metal", "moody", "neglected", "people", "quiet", "run down", "rusted", "skate park", "skateboard", "skateboard ramp", "skateboarder", "skateboarding", "skater", "solitary", "stillness", "street art", "unkempt", "urban", "urban decay", "vandalized"],
      "qwen2.5vl-7b": ["abandoned", "casual", "concrete", "couple", "decay", "dilapidated", "exploration", "graffiti", "graffiti art", "graffiti-covered beams", "graffiti-covered ceiling", "graffiti-covered door", "graffiti-covered floor", "graffiti-covered ramp", "graffiti-covered support beams", "graffiti-covered support columns", "graffiti-covered support pillars", "graffiti-covered support posts", "graffiti-covered support structures", "graffiti-covered walls", "graffiti-covered windows", "gritty", "happy", "industrial", "muted", "people", "pov", "relaxed", "standing", "urban", "urban exploration"],
      "minicpm-v-8b": ["abandoned building", "casual clothing", "colorful walls", "concrete floor", "daytime", "first-person view", "graffiti", "greenery outside", "group activity", "indoor", "industrial atmosphere.", "joyful expressions", "natural light", "people", "ramp", "relaxed", "skateboarding", "urban exploration", "windows"]
    }
  },
  {
    filename: "03-belgian-stew-fries.jpg",
    keywords: {
      "llava-7b": ["dinner", "food", "fork", "fries", "knife", "people", "plate", "restaurant", "sauce", "table"],
      "qwen2.5vl-7b": ["bottle", "casual", "cozy", "dim", "dinner", "food", "fork", "fries", "indoor", "inviting", "ketchup", "knife", "plate", "restaurant", "sauce", "sausage", "table", "warm"],
      "minicpm-v-8b": ["casual dining", "cherry tomato", "condiments", "cozy ambiance.", "food", "fork", "fries", "indoor", "knife", "meat", "plate", "restaurant", "sauce", "spoon", "table", "warm light"]
    }
  },
  {
    filename: "04-cheese-fondue-dinner.jpg",
    keywords: {
      "llava-7b": ["beer", "bread", "casual", "chairs", "cheese", "condiments", "countertop", "dining area", "dining table", "food", "napkins", "oven", "people", "pizza", "restaurant", "sauce", "socializing", "utensils", "wine glass"],
      "qwen2.5vl-7b": ["beer", "black", "casual", "cheese fondue", "cozy", "dining", "food", "group", "indoor", "people", "pov", "red", "relaxed", "restaurant", "table", "warm", "yellow"],
      "minicpm-v-8b": ["bread cubes in bowl", "casual dining", "couple", "cozy atmosphere.", "dark table surface", "dim overhead lights", "enjoying meal together", "fries on plate", "golden yellow beer", "indoor restaurant", "ketchup bottle", "mustard bottle", "people", "red pot with fondue", "relaxed", "warm ambiance"]
    }
  },
  {
    filename: "05-snowboarders-mountain-rest.jpg",
    keywords: {
      "llava-7b": ["camera perspective", "cold", "friends", "fun", "group", "mountain", "outdoor", "people", "recreation", "skiing", "snow", "snowboarding", "socializing", "winter sports"],
      "qwen2.5vl-7b": ["cold", "excited", "group", "mountains", "outdoor", "overcast", "people", "selfie", "snow", "snowboarding", "white"],
      "minicpm-v-8b": ["cloudy day", "cold weather gear", "colorful snowboards", "goggles", "group of people sitting on snow", "helmets", "leisurely pace", "mountainous terrain", "outdoor activity", "overcast sky", "relaxed atmosphere", "snowboarding", "snowy mountainside", "standing person walking away", "white and gray tones.", "winter clothing"]
    }
  },
  {
    filename: "06-alpine-trail-hiker.jpg",
    keywords: {
      "llava-7b": ["camping", "couple", "forest", "nature", "outdoor", "people", "picnic", "relaxation"],
      "qwen2.5vl-7b": ["blue", "campfire", "forest", "green", "group", "natural", "outdoor", "people", "pov", "relaxed", "serene", "snow", "sunny"],
      "minicpm-v-8b": ["casual clothing", "contemplative", "couple", "forest", "green trees", "natural light", "outdoor camping scene", "peaceful ambiance", "people", "relaxed", "serene environment.", "sitting around campfire", "snow patches", "sunny day", "wooden logs for fire pit"]
    }
  },
  {
    filename: "07-restaurant-group-dinner.jpg",
    keywords: {
      "llava-7b": ["casual", "cell phone", "chairs", "dining", "drinks", "evening", "food", "friends", "gathering", "group", "indoor", "people", "relaxed", "restaurant", "socializing", "table"],
      "qwen2.5vl-7b": ["beige", "brown", "casual", "cozy", "dim", "dining", "eating", "green", "group", "indoor", "people", "relaxed", "restaurant", "selfie", "social"],
      "minicpm-v-8b": ["candid moment", "casual dining", "comfortable ambiance", "conversation", "drinking", "eating", "group", "indoor", "informal mealtime.", "painting on wall", "people", "relaxed", "social gathering", "warm tones"]
    }
  },
  {
    filename: "08-neon-bar-friends.jpg",
    keywords: {
      "llava-7b": ["bench", "drinks", "group", "indoor", "night", "people", "purple", "socializing", "table"],
      "qwen2.5vl-7b": ["blue", "casual", "drinks", "festive", "group", "happy", "indoor", "lights", "neon", "people", "plants", "pov", "purple", "relaxed", "socializing"],
      "minicpm-v-8b": ["artificial lights", "casual gathering.", "contemplative", "cozy ambiance", "drinks on table", "greenery", "group", "happy", "indoor", "purple illumination", "relaxed", "socializing"]
    }
  },
  {
    filename: "09-record-store-group-photo.jpg",
    keywords: {
      "llava-7b": ["bookshelves", "bookstore", "casual", "colorful", "group", "happy", "people", "relaxed", "selfie", "socializing", "warm lighting"],
      "qwen2.5vl-7b": ["black", "casual", "excited", "fun", "group", "indoor", "laughing", "lively", "people", "posing", "record store", "vibrant", "warm", "white", "yellow"],
      "minicpm-v-8b": ["casual clothing", "colorful records", "excited", "friendly atmosphere.", "group", "happy", "indoor", "music collection", "people", "posing", "record store", "relaxed ambiance", "social interaction", "vintage vibe", "warm light"]
    }
  },
  {
    filename: "10-alpine-peaks-vista.jpg",
    keywords: {
      "llava-7b": ["adrenaline", "adventure", "alpine", "blue", "breathtaking", "clouds", "cold weather", "crowd", "excitement", "exhilaration", "green", "high altitude", "landscape", "majestic", "mountainous", "nature", "outdoor recreation", "people", "rocky terrain", "scenic", "ski lift", "ski resort", "sky", "snow-covered peaks", "snowy mountain range", "thrill", "tourism", "travel", "vacation destination", "white", "winter sports", "winter wonderland"],
      "qwen2.5vl-7b": ["adventure", "blue", "bright", "clear", "clouds", "cold", "expansive", "high-altitude", "landscape", "mountains", "nature", "outdoor", "peaks", "pov", "serene", "sky", "snow", "snow-capped", "tranquil", "vast", "white", "winter"],
      "minicpm-v-8b": ["adventure", "alpine environment.", "blue skies", "clouds", "cold", "high altitude", "mountains", "outdoor activity", "scenic", "ski resort", "sky", "snow", "tranquil", "winter sports"]
    }
  },
  {
    filename: "11-blue-sneakers-blacklight.jpg",
    keywords: {
      "llava-7b": ["blue", "blurry", "green", "indoor", "night", "people", "purple", "shoes"],
      "qwen2.5vl-7b": ["casual", "couple", "energetic", "illuminated", "lively", "neon", "nightlife", "nightlife setting", "party", "people", "purple", "relaxed", "selfie", "shoes", "sneakers", "urban", "vibrant"],
      "minicpm-v-8b": ["casual attire", "couple", "dimly lit background", "indoor bar/club scene", "laid-back ambiance.", "neon lights", "people", "purple-blue ambient light", "relaxed", "sneakers with nike branding", "socializing", "vibrant decorations", "wooden table"]
    }
  },
  {
    filename: "12-winter-jackets-uv-light.jpg",
    keywords: {
      "llava-7b": ["couple", "dark", "excited", "happy", "holding sign", "indoor", "man", "nighttime", "party", "people", "woman"],
      "qwen2.5vl-7b": ["blue", "casual", "cheerful", "couple", "cozy", "decorations", "festive", "grass", "green", "happy", "holiday", "illuminated", "intimate", "lights", "night", "outdoor", "people", "purple", "relaxed", "selfie", "winter"],
      "minicpm-v-8b": ["casual clothing", "contemplative", "couple", "cozy ambiance", "man", "nighttime outdoor event", "purple lights", "reading book", "relaxed", "sitting on ground", "urban park or garden area.", "warm glow of string lights", "woman"]
    }
  },
  {
    filename: "13-couple-train-selfie.jpg",
    keywords: {
      "llava-7b": ["bench", "comfortable", "couple", "happy", "indoor", "people", "relaxed", "sitting", "smiling", "together", "train", "window"],
      "qwen2.5vl-7b": ["beige", "black", "casual", "couple", "daylight", "happy", "interior", "selfie", "smiling", "train", "travel", "warm"],
      "minicpm-v-8b": ["casual attire", "comfortable interior", "couple", "daylight", "happy", "indoor scene", "modern transportation", "relaxed", "selfie", "sitting together on train", "smiling", "warm tones"]
    }
  },
  {
    filename: "14-freddie-mercury-statue.jpg",
    keywords: {
      "llava-7b": ["daytime", "outdoor", "park", "people", "plaque", "statue"],
      "qwen2.5vl-7b": ["blue sky", "bronze", "grass", "outdoor", "park", "peaceful", "public space", "sculpture", "statue", "sunny", "trees"],
      "minicpm-v-8b": ["bronze", "buildings", "clear sky", "concrete base", "contemplative", "daytime", "excited", "grass", "greenery", "happy", "man", "no people present", "outdoor", "plaque.", "pose", "red leash", "reflective surface", "relaxed", "sculpture", "standing alone", "statue", "trees", "urban park", "walking dog"]
    }
  },
  {
    filename: "15-red-eyes-costume-display.jpg",
    keywords: {
      "llava-7b": ["black", "costume", "display case", "feathers", "people", "red", "white"],
      "qwen2.5vl-7b": ["artificial light", "bright", "costume", "cultural", "display case", "exhibit", "formal", "gold", "indoors", "modern", "museum", "museum exhibit", "no people", "red", "static", "still life", "traditional", "vibrant", "white"],
      "minicpm-v-8b": ["artificial lighting", "contemplative mood", "display case", "eerie ambiance", "indoor museum or exhibition hall.", "no interaction between people", "people presence", "red suit with eyes on it", "selfie perspective", "vibrant reds"]
    }
  },
  {
    filename: "16-highland-cattle-pen.jpg",
    keywords: {
      "llava-7b": ["animals", "cows", "daytime", "dirt", "fence", "field", "grass", "natural light", "pasture", "people", "rural"],
      "qwen2.5vl-7b": ["calm", "cows", "daylight", "earthy", "farm", "grazing", "ground", "natural", "outdoor", "relaxed", "rural"],
      "minicpm-v-8b": ["no people present"]
    }
  },
  {
    filename: "17-european-town-rooftop-view.jpg",
    keywords: {
      "llava-7b": ["360", "above", "aerial view", "balcony", "bird's eye view", "brick building", "cityscape", "cobblestone street", "crowd", "distorted", "elevated", "elevated angle", "elevated camera assistant", "elevated camera holder", "elevated camera man", "elevated camera operator", "elevated camera operator assistant", "elevated camera person", "elevated camera technician", "elevated camera technician aide", "elevated camera technician aide helper", "elevated camera technician aide helper aide", "elevated camera technician aide helper aide aide", "elevated camera technician aide helper aide aide aide", "elevated camera technician aide helper aide aide aide aide", "elevated camera technician assistant", "elevated camera technician assistant aide", "elevated camera technician helper", "elevated camera technician helper aide", "elevated location", "elevated observer", "elevated perspective", "elevated photo taker", "elevated photographer", "elevated position", "elevated setting", "elevated vantage point", "elevated view", "elevated viewer", "elevated viewpoint", "elevation", "fisheye lens", "from above", "high angle", "historical", "old architecture", "overhead view", "panoramic", "people", "perspective", "perspective distortion", "perspective warp", "roof", "selfie", "stairs", "stone", "top-down view", "urban", "wide angle lens", "windows"],
      "qwen2.5vl-7b": ["buildings", "calm", "contemplative", "daytime", "group", "historical", "looking down", "natural light", "old town", "people", "pov", "red", "steeples", "switzerland"],
      "minicpm-v-8b": ["brown tiles", "calm environment.", "cityscape", "cold weather", "contemplative", "couple", "gray tones", "historical architecture", "overcast sky", "people", "red roofs", "serene ambiance", "urban landscape", "walking on bridge", "winter season"]
    }
  },
  {
    filename: "18-poppy-seed-cake-slices.jpg",
    keywords: {
      "llava-7b": ["bakery", "bread", "counter", "dessert", "display", "food", "pastries", "people", "spices"],
      "qwen2.5vl-7b": ["bakery", "bread", "casual", "crusty", "food", "golden", "indoors", "neutral", "pov"],
      "minicpm-v-8b": ["browned breads", "food items", "green pickles", "indoor restaurant environment.", "metallic surface", "overhead light source", "tray display case"]
    }
  },
  {
    filename: "19-louvre-pyramid-courtyard.jpg",
    keywords: {
      "llava-7b": ["architecture", "city", "couple", "crowd", "europe", "grey", "louvre", "museum", "people", "rainy", "selfie", "sightseeing", "stone", "walking"],
      "qwen2.5vl-7b": ["calm", "casual", "cloudy", "gray", "group", "historical", "louvre", "modern", "museum", "outdoor", "overcast", "paris", "people", "pyramid", "relaxed", "stone", "urban", "walking"],
      "minicpm-v-8b": ["cloudy sky", "contemplative", "glass pyramid", "gray pavement", "historic building", "museum courtyard.", "overcast day", "parisian architecture", "people", "tourists", "urban environment", "walking"]
    }
  },
  {
    filename: "20-woman-admiring-classical-statue.jpg",
    keywords: {
      "llava-7b": ["looking down", "marble", "museum", "people", "selfie", "smiling", "statue", "woman"],
      "qwen2.5vl-7b": ["bright", "formal", "historical", "indoor", "marble", "people", "red", "selfie", "smiling", "statue", "woman"],
      "minicpm-v-8b": ["braided hair", "classical art", "happy expression", "historical display", "indoor environment.", "joy", "laughter", "leaning on statue", "marble background", "museum", "red sweater", "relaxed demeanor", "selfie perspective", "warm light", "woman"]
    }
  },
  {
    filename: "21-jeweled-royal-crown-display.jpg",
    keywords: {
      "llava-7b": ["crowd", "crown", "display", "glass case", "jewelry", "museum", "people"],
      "qwen2.5vl-7b": ["admiring", "bright", "crown", "excited", "formal", "gold", "grand", "group", "jewels", "museum", "ornate", "people", "selfie"],
      "minicpm-v-8b": ["bright illumination", "contemplative", "crowd", "crown", "golden hues", "historical artifacts", "indoor exhibition space.", "museum display", "observing", "opulent", "ornate", "reflective"]
    }
  },
  {
    filename: "22-catacomb-skull-bone-wall.jpg",
    keywords: {
      "llava-7b": ["bones", "dark", "people", "skulls", "underground"],
      "qwen2.5vl-7b": ["bones", "contemplative", "dark", "dim", "eerie", "group", "people", "skulls", "somber", "underground"],
      "minicpm-v-8b": ["darkness", "dimly lit", "eerie", "historical site", "human remains", "macabre", "reflective", "skulls", "somber", "underground chamber."]
    }
  },
  {
    filename: "23-catacomb-ossuary-plaque.jpg",
    keywords: {
      "llava-7b": ["cemetery", "dark", "french", "graveyard", "historical", "old", "people", "sign", "skulls", "stone"],
      "qwen2.5vl-7b": ["bones", "contemplative", "dark", "dim", "group", "historical", "ossuary", "people", "sign", "somber", "underground"],
      "minicpm-v-8b": ["aged", "bones", "cemetery", "dark", "historical", "human remains display.", "natural light", "ossuary", "reflective", "skulls", "somber", "stone-carved", "tombstones", "underground"]
    }
  },
  {
    filename: "24-forest-waterfall-moss-covered.jpg",
    keywords: {
      "llava-7b": ["forest", "green", "landscape", "misty", "moss", "natural", "outdoor", "people", "serene", "waterfall"],
      "qwen2.5vl-7b": ["calm", "flowing", "forest", "green", "greenery", "landscape", "lush", "moss", "moss-covered", "mossy", "natural", "nature", "outdoor", "peaceful", "rocks", "serene", "tranquil", "trees", "verdant", "water", "waterfall"],
      "minicpm-v-8b": ["daylight", "forest", "greenery", "mossy trees", "natural beauty", "outdoor adventure", "peacefulness", "reflection", "rocks", "serene", "tranquility.", "waterfall"]
    }
  },
  {
    filename: "25-dog-playing-in-river.jpg",
    keywords: {
      "llava-7b": ["dog", "forest", "nature", "outdoor", "river", "rocks", "wet"],
      "qwen2.5vl-7b": ["animal", "animal lover", "calm", "clear water", "dog", "forest", "natural", "nature", "outdoor", "outdoor activity", "pet", "pet adventure", "pet exploration", "pet happiness", "pet joy", "pet owner", "pet-friendly", "red bandana", "relaxed", "river", "rocks", "serene", "sunny", "water"],
      "minicpm-v-8b": ["alone", "brownish-red tones", "clear water", "daylight", "dog", "excited", "exploring", "greenery", "happy", "log", "natural environment", "nature scene", "outdoor adventure", "peaceful atmosphere.", "playful", "red bandana", "rocks", "rocky terrain", "stream", "water", "wet fur"]
    }
  },
  {
    filename: "26-outdoor-cedar-plank-cooking.jpg",
    keywords: {
      "llava-7b": ["campfire", "chairs", "evening", "group", "man playing guitar", "outdoor", "people", "picnic table", "relaxed", "tent", "wooded area"],
      "qwen2.5vl-7b": ["campfire", "casual", "chairs", "cloudy", "countryside", "daytime", "friendly", "grass", "group", "informal", "outdoor", "people", "relaxed", "socializing", "tent", "ukulele"],
      "minicpm-v-8b": ["beer bottle", "casual clothing", "cloudy sky", "contemplative", "flag banner", "folding chair", "green grass", "group", "guitar case", "happy", "outdoor gathering", "pavilion", "people", "picnic table", "playing music", "relaxed", "sitting around campfire", "wine glass", "wood logs in fire pit.", "wooden chairs"]
    }
  },
  {
    filename: "27-woman-mountain-summit-view.jpg",
    keywords: {
      "llava-7b": ["athletic", "black and white", "contemplative", "hiking", "mountain", "nature", "outdoor", "people", "woman"],
      "qwen2.5vl-7b": ["adventurous", "black", "blue", "bright", "contemplative", "green", "hiking", "mountain", "outdoor", "pov", "rocky", "scenic", "woman"],
      "minicpm-v-8b": ["active lifestyle", "black tank top", "blue sky with clouds", "casual pose", "clear weather", "contemplative", "daylight", "forested hills in background", "hair tied up.", "healthy activity", "hiking clothing", "looking at mountains", "natural landscape", "outdoors", "relaxed posture", "rocky terrain", "scenic view", "standing on rocks", "woman"]
    }
  },
  {
    filename: "28-theatrical-stage-projection-design.jpg",
    keywords: {
      "llava-7b": ["blue", "boat", "bridge", "cityscape", "crowd", "dark", "lights", "night", "people", "performance", "stage", "water"],
      "qwen2.5vl-7b": ["abstract", "blue", "cold", "dark", "dim", "eerie", "futuristic", "glass", "interior", "isolated", "modern", "mysterious", "reflective", "shadowy", "structure", "suspenseful", "technology"],
      "minicpm-v-8b": ["aquatic life", "artificial structures", "blue light", "coral-like formations", "curiosity", "dark background", "educational display.", "exploration", "fascination", "immersive experience", "large tank", "marine biology interest", "peaceful", "serene", "tranquil ambiance", "underwater aquarium", "underwater environment", "water clarity"]
    }
  },
  {
    filename: "29-excited-black-brown-dog.jpg",
    keywords: {
      "llava-7b": ["blue", "brown", "dog", "excited", "indoor", "mouth open", "people", "red", "selfie"],
      "qwen2.5vl-7b": ["black", "blue", "brown", "casual", "close-up", "cozy", "dog", "friendly", "happy", "indoor", "playful", "relaxed", "selfie", "warm"],
      "minicpm-v-8b": ["black pants", "blue jeans", "brown blanket with animal design", "casual", "comfortable", "couch or sofa.", "dog", "excitement", "home environment", "indoor", "mouth open", "natural light", "playful", "relaxed", "tongue out"]
    }
  },
  {
    filename: "30-woman-smiling-on-boat.jpg",
    keywords: {
      "llava-7b": ["boat", "braid", "clouds", "hair", "jacket", "people", "pier", "sky", "smiling", "standing", "water", "woman"],
      "qwen2.5vl-7b": ["blue", "boat", "casual", "happy", "ocean", "open", "outdoor", "relaxed", "selfie", "serene", "sunny", "woman"],
      "minicpm-v-8b": ["blue sky", "boat ride", "braid in hair", "calm sea", "casual clothing", "clear weather", "distant lighthouse", "horizon line", "joyful mood", "natural light.", "outdoor activity", "peaceful atmosphere", "red coat", "relaxed", "smiling", "sunny day", "water", "white railing", "windblown hair", "woman"]
    }
  },
  {
    filename: "31-wildebeest-herd-grazing-savanna.jpg",
    keywords: {
      "llava-7b": ["animals", "daytime", "field", "grass", "herd", "nature", "outdoor", "people", "wildlife"],
      "qwen2.5vl-7b": ["animals", "animals grazing", "calm", "daytime", "dry", "field", "grass", "herd", "landscape", "natural", "neutral colors", "outdoor", "peaceful", "savanna", "serene", "wildlife"],
      "minicpm-v-8b": ["animals", "dry grassland", "grazing", "natural habitat", "overcast sky", "running", "wildlife conservation area."]
    }
  },
  {
    filename: "32-urban-fire-smoke-city-skyline.jpg",
    keywords: {
      "llava-7b": ["buildings", "cars", "cityscape", "cloudy", "fire", "people", "sky", "smoke", "street", "trees"],
      "qwen2.5vl-7b": ["atmosphere", "blue", "buildings", "bustling", "cityscape", "clear", "industrial", "pov", "sky", "smoke", "smoke plume", "smokestack", "urban"],
      "minicpm-v-8b": ["air pollution", "buildings", "busy street", "cityscape", "construction site", "crane", "dark clouds", "daytime", "environmental impact", "high-rise apartments.", "industrial", "outdoor", "overcast", "polluted", "pollution", "red brick building", "sky", "smoggy", "smoke", "smokestacks", "traffic", "urban", "vehicles"]
    }
  },
  {
    filename: "33-seabird-flying-over-pine-trees.jpg",
    keywords: {
      "llava-7b": ["bird", "couple", "flying", "forest", "nature", "outdoor", "people", "sky", "trees"],
      "qwen2.5vl-7b": ["blue", "cloudy", "eagle", "flying", "freedom", "gray", "green", "majestic", "nature", "outdoor", "serene", "trees", "wilderness", "wildlife"],
      "minicpm-v-8b": ["birds", "cloudy day", "flight", "freedom", "nature exploration", "outdoor adventure", "peacefulness", "sky", "trees", "wildlife tour"]
    }
  },
  {
    filename: "34-humpback-whale-breaching-ocean.jpg",
    keywords: {
      "llava-7b": ["animal", "aquatic", "coastal", "gray", "large", "marine life", "nature", "ocean", "outdoor", "sea", "swimming", "water", "wet", "whale", "wilderness", "wildlife"],
      "qwen2.5vl-7b": ["black", "blue", "calm", "expansive", "majestic", "natural", "nature", "ocean", "open", "serene", "sunlight", "tranquil", "water", "whale", "white", "wild", "wildlife"],
      "minicpm-v-8b": ["blue sky", "calmness", "clear day.", "marine life", "natural habitat", "ocean", "peaceful", "sunlight reflection", "water spray", "whale", "wildlife watching tours"]
    }
  },
  {
    filename: "35-whale-tail-diving-forest-coastline.jpg",
    keywords: {
      "llava-7b": ["adventure", "boat", "excitement", "leisure", "marine life", "nature", "ocean", "outdoor", "people", "recreation", "sightseeing", "tourism", "travel", "vacation", "water", "whale", "wildlife"],
      "qwen2.5vl-7b": ["blue", "calm", "forest", "majestic", "natural", "nature", "outdoor", "rocks", "serene", "sunlight", "tranquil", "water", "whale", "wildlife"],
      "minicpm-v-8b": ["calmness", "clear sky", "daytime.", "forested coastline", "natural habitat", "nature", "ocean", "peaceful", "sunlight reflection on water", "water", "whale tail fin in air", "whale watching", "wildlife"]
    }
  },
  {
    filename: "36-quiche-held-coastal-landscape.jpg",
    keywords: {
      "llava-7b": ["clouds", "daytime", "food", "grass", "hand", "muffin", "outdoor", "people", "sky", "water"],
      "qwen2.5vl-7b": ["blue", "brown", "casual", "countryside", "food", "grass", "hand", "natural", "outdoor", "pov", "relaxed", "sky", "sunny"],
      "minicpm-v-8b": ["casual", "countryside", "daylight", "food", "fresh air", "grassland", "hand", "holding", "horizon", "landscape", "leisurely activity.", "natural scenery", "open-air", "outdoors", "peaceful", "picnic", "quiche", "relaxed", "rural", "sky", "sunny", "tranquil"]
    }
  },
  {
    filename: "37-urban-deer-family-crossing-street.jpg",
    keywords: {
      "llava-7b": ["building", "cars", "deer", "evening", "fence", "grass", "parking lot", "people", "road", "sign", "street light", "urban"],
      "qwen2.5vl-7b": ["brown", "calm", "daytime", "deer", "fawns", "gray", "green", "natural", "outdoor", "peaceful", "residential", "street", "suburban", "urban", "walking"],
      "minicpm-v-8b": ["adult deer eating grass", "apartment building", "calm atmosphere", "canadian flag on balcony.", "deer", "fawns", "flowers", "greenery", "natural wildlife interaction", "no people present", "overcast sky", "parked cars", "paved road", "sidewalk", "urban residential area"]
    }
  },
  {
    filename: "38-sunset-reflection-over-water.jpg",
    keywords: {
      "llava-7b": ["boat", "calm", "clouds", "dock", "evening", "horizon", "ocean", "peaceful", "serene", "sky", "sunset", "tranquil", "water"],
      "qwen2.5vl-7b": ["calm", "evening", "horizon", "landscape", "natural", "orange", "outdoor", "people", "relaxed", "serene", "soft", "sunset", "tranquil", "water", "yellow"],
      "minicpm-v-8b": ["calmness", "evening ambiance", "golden hour", "horizon line", "natural beauty", "orange hues", "outdoor environment.", "peaceful", "silhouette", "sky gradient", "still waters", "sunset", "tranquil scene", "water reflection"]
    }
  },
  {
    filename: "39-orange-sunset-lake-silhouette.jpg",
    keywords: {
      "llava-7b": ["calm", "clouds", "evening", "golden", "horizon", "landscape", "leisure", "nature", "ocean", "orange", "peaceful", "reflection", "relaxation", "serene", "sky", "sunset", "tranquil", "warm"],
      "qwen2.5vl-7b": ["beach", "calm", "evening", "golden", "houses", "landscape", "natural", "orange", "outdoor", "peaceful", "people", "reflection", "relaxed", "seaside", "serene", "setting", "silhouette", "sunset", "tranquil", "trees", "warm", "water", "yellow"],
      "minicpm-v-8b": ["evening light", "horizon line", "natural beauty", "peacefulness", "silhouette of trees", "sky gradient", "stillness", "sunset", "tranquil scene", "warm tones", "water reflection"]
    }
  },
  {
    filename: "40-sleeping-dog-close-up-portrait.jpg",
    keywords: {
      "llava-7b": ["blanket", "cozy", "curled up", "dog", "indoor", "paws", "relaxed", "resting"],
      "qwen2.5vl-7b": ["black", "blanket", "brown", "close-up", "cozy", "dog", "indoor", "natural light", "peaceful", "relaxed", "sleeping", "soft"],
      "minicpm-v-8b": ["black coat", "close-up", "comfortable", "cozy blanket", "dog", "home environment.", "indoors", "peaceful", "resting", "soft light", "tan markings", "warm color palette"]
    }
  },
  {
    filename: "41-black-dog-on-rocky-riverbed.jpg",
    keywords: {
      "llava-7b": ["black and white", "dog", "forest", "ground", "rocks"],
      "qwen2.5vl-7b": ["beach", "calm", "dog", "gray", "lying", "natural", "outdoor", "overcast", "pebble", "relaxed"],
      "minicpm-v-8b": ["alert posture", "black coat", "contemplative", "dog", "focused", "gray stones", "natural light", "outdoor environment", "overhead shot", "rocky terrain"]
    }
  },
  {
    filename: "42-abandoned-blue-wheelbarrow-forest.jpg",
    keywords: {
      "llava-7b": ["abandoned", "blue", "broken", "car", "damaged", "debris", "decaying", "desolate", "destroyed", "dirt", "forest", "green", "junk", "moody", "nature", "neglected", "old", "outdoor", "overturned", "people", "rocks", "rusted", "tires", "wheels", "wrecked"],
      "qwen2.5vl-7b": ["abandoned", "car", "debris", "decay", "desolate", "forest", "gloomy", "muted", "natural", "outdoor", "overcast", "rocks", "rust", "trees", "wilderness"],
      "minicpm-v-8b": ["abandoned", "blue paint peeling", "daytime", "debris", "forest", "natural surroundings", "neglected", "outdoor scene", "overgrown vegetation", "overturned", "quiet", "rocky ground", "rusted bicycle", "solitude.", "somber", "stillness"]
    }
  },
  {
    filename: "43-purple-foxglove-with-raindrops.jpg",
    keywords: {
      "llava-7b": ["close up", "dew", "droplets of water", "garden", "outdoor", "purple flowers", "vibrant"],
      "qwen2.5vl-7b": ["close-up", "daylight", "flowers", "green", "nature", "outdoor", "pink", "serene", "waterdrops"],
      "minicpm-v-8b": ["dewy", "flowers", "garden", "lush", "natural light", "outdoor", "pink", "serene", "vibrant", "water droplets"]
    }
  },
  {
    filename: "44-foxglove-flowers-forest-meadow.jpg",
    keywords: {
      "llava-7b": ["daytime", "flowers", "forest", "green", "nature", "outdoor", "people", "purple", "sunlight", "wildflowers"],
      "qwen2.5vl-7b": ["daylight", "flowers", "forest", "green", "lush", "natural", "nature", "outdoor", "peaceful", "purple", "serene", "tranquil"],
      "minicpm-v-8b": ["daylight.", "forest", "green foliage", "natural environment", "outdoor activity", "peacefulness", "purple flowers", "serene", "sunlight", "tall plants", "tranquil ambiance", "vibrant hues"]
    }
  },
  {
    filename: "45-hiker-with-dog-forest-trail.jpg",
    keywords: {
      "llava-7b": ["bench", "dog", "forest", "nature", "outdoor", "path", "people", "sign", "trees"],
      "qwen2.5vl-7b": ["couple", "daylight", "dirt path", "forest", "green", "hiking", "natural", "outdoor", "people", "relaxed", "serene", "trees", "yellow sign"],
      "minicpm-v-8b": ["casual clothing", "contemplative", "dirt trail", "dog", "forest path", "greenery", "natural light", "nature", "outdoor activity", "overcast sky", "peacefulness", "signpost", "solitude", "trees", "walking", "woman", "wooded area.", "wooden bench"]
    }
  },
  {
    filename: "46-aerial-view-coastal-town.jpg",
    keywords: {
      "llava-7b": ["aerial view", "airplane", "buildings", "calm", "cityscape", "clear", "clouds", "daytime", "grass", "houses", "people", "plane", "serene", "sky", "street", "suburban", "trees", "urban", "water"],
      "qwen2.5vl-7b": ["adventure", "aerial", "airplane", "buildings", "calm", "cityscape", "daytime", "exploration", "golden", "landscape", "natural", "outdoor", "peaceful", "pov", "serene", "sunset", "tranquil", "travel", "urban", "view", "water", "wing"],
      "minicpm-v-8b": ["aerial", "airplane wing", "buildings", "calmness", "cars", "cityscape", "greenery", "horizon line", "human presence (couple)", "mountains", "nature", "peaceful", "relaxed mood", "residential area", "scenic view", "serene", "streets", "sunset", "travel perspective", "urban environment", "warm light", "waterway"]
    }
  },
  {
    filename: "47-office-party-snack-table.jpg",
    keywords: {
      "llava-7b": ["ambiance", "artificial light", "bags", "bonjour 1se", "bowl", "bowls", "casual", "celebration", "cheerful", "city", "colorful", "comfortable", "contemporary", "conversation", "cooking", "couch", "cozy", "decoration", "dining", "dining area", "dining room", "drinking", "eating", "elegant", "event", "festive", "food", "food preparation", "furniture", "gathering", "gifts", "group", "holiday", "home decor", "indoor", "interaction", "interior design", "inviting", "kitchen", "leisurely", "lighting", "living room", "luxurious", "modern", "mood", "napkins", "natural light", "party", "people", "pov", "relaxed", "residential", "room", "selfie", "sign", "snack", "snacks", "social", "socializing", "sophisticated", "stylish", "table", "table setting", "tablecloth", "tableware", "text", "upscale", "urban", "utensils", "vibrant", "window"],
      "qwen2.5vl-7b": ["blue", "bowls", "bright", "candy", "casual", "indoor", "lightbox", "modern", "no interaction", "no people", "pov", "relaxed", "snacks"],
      "minicpm-v-8b": ["blue tissue paper", "bonjour sign", "bowls of food", "casual gathering", "comfortable ambiance", "contemporary apartment interior.", "couple", "daylight", "enjoying snacks", "indoor", "modern decor", "natural light", "people", "relaxed", "urban skyline outside window"]
    }
  },
  {
    filename: "48-elephant-art-gallery-display.jpg",
    keywords: {
      "llava-7b": ["colorful", "elephant", "indoor", "people", "statue"],
      "qwen2.5vl-7b": ["art", "artificial", "calm", "contemplative", "eagle", "elephant", "exhibit", "gallery", "indoor", "large", "modern", "neutral", "people"],
      "minicpm-v-8b": ["artistic display", "blue clothing", "bright light", "contemplative", "contemporary design", "eagle portrait", "elephant portrait", "indoor space", "modern art", "reflection", "urban environment."]
    }
  },
  {
    filename: "49-restaurant-dinner-gathering.jpg",
    keywords: {
      "llava-7b": ["dining table", "drinking", "eating", "food", "friends", "gathering", "happy", "people", "plates", "relaxed", "restaurant", "socializing"],
      "qwen2.5vl-7b": ["casual", "cozy", "dim", "dining", "drinks", "eating", "food", "group", "happy", "people", "plates", "pov", "relaxed", "restaurant", "table", "warm"],
      "minicpm-v-8b": ["casual dining experience.", "colorful dishes", "couple", "dim lighting", "enjoying meal", "happy", "people", "red tablecloth", "restaurant", "smiling", "socializing", "warm ambiance"]
    }
  },
  {
    filename: "50-war-memorial-statue-night.jpg",
    keywords: {
      "llava-7b": ["city", "fountain", "lit", "night", "people", "statue"],
      "qwen2.5vl-7b": ["architecture", "blue", "building", "cityscape", "contemplative", "dome", "fountain", "group", "illuminated", "lighting quality", "night", "people", "serene", "setting", "statue", "still", "urban"],
      "minicpm-v-8b": ["blue sky", "building", "contemplative", "darkened windows.", "fountain", "historic", "illumination", "night", "reflective", "statue", "stillness", "urban"]
    }
  },
  {
    filename: "51-green-dessert-molecular-spheres.jpg",
    keywords: {
      "llava-7b": ["cooking", "food", "green", "herbs", "kitchen", "meal", "people", "plate", "spices", "spoon", "table", "white", "yellow"],
      "qwen2.5vl-7b": ["appetizer", "appetizing", "dessert", "food", "green", "leftover", "plate", "spoon", "white"],
      "minicpm-v-8b": ["artificial light", "dessert", "food", "green spheres", "indoor restaurant", "plate", "spoon", "white background", "yellow spheres"]
    }
  },
  {
    filename: "52-rose-shaped-dessert-edible-flower.jpg",
    keywords: {
      "llava-7b": ["cake", "chocolate", "dessert", "frosting", "indoor", "people", "plate", "sprinkles", "swirl", "table", "whipped cream"],
      "qwen2.5vl-7b": ["appetizing", "black", "casual", "cinnamon", "close-up", "cozy", "dessert", "food", "indoor", "inviting", "pastry", "pov", "soft", "sugar", "sweet", "table", "warm", "wood"],
      "minicpm-v-8b": ["blue flowers", "cinnamon roll", "close-up", "cozy", "dessert", "food", "inviting", "plate", "powdered sugar", "restaurant", "table", "warm"]
    }
  },
  {
    filename: "53-mountain-restaurant-couple-dining.jpg",
    keywords: {
      "llava-7b": ["couple", "dining", "evening", "happy", "indoor", "mountain", "people", "relaxed", "restaurant", "ski resort", "snow", "winter"],
      "qwen2.5vl-7b": ["alpine", "ca", "cafe", "couple", "cozy", "dominant", "drinking", "happy", "lighting", "neutral", "scenery", "smiling", "view", "window"],
      "minicpm-v-8b": ["brown drinks in glasses", "couple", "cozy ambiance", "embracing", "happy", "indoor cafe", "mountainous landscape background", "people", "relaxed", "smiling", "snowy mountains outside window", "warm light"]
    }
  },
  {
    filename: "54-family-birthday-lunch-patio.jpg",
    keywords: {
      "llava-7b": ["casual", "dining table", "drinks", "evening", "food", "group", "indoor", "people", "relaxed", "restaurant", "socializing"],
      "qwen2.5vl-7b": ["balcony", "blue", "bright", "casual", "daytime", "dining", "drinks", "food", "group", "happy", "hotel", "ocean view", "people", "relaxed", "selfie", "table", "white", "yellow"],
      "minicpm-v-8b": ["burgers", "casual dining restaurant", "coffee cups", "couple", "daylight", "daytime atmosphere.", "enjoying meal together", "fries", "happy", "natural light", "ocean view in background", "orange juice", "outdoor terrace with railing", "people", "relaxed", "selfie", "silverware", "white plates", "wooden table"]
    }
  },
  {
    filename: "55-mountain-restaurant-group-dining.jpg",
    keywords: {
      "llava-7b": ["dining", "drinks", "evening", "group", "happy", "indoor", "people", "restaurant", "socializing"],
      "qwen2.5vl-7b": ["cozy", "drinks", "group", "happy", "mountain view", "people", "relaxed", "restaurant", "selfie", "warm lighting", "winter", "wooden table"],
      "minicpm-v-8b": ["alpine resort or ski lodge environment.", "casual attire", "drinks on table", "group", "happy", "indoor restaurant", "mountainous landscape outside window", "natural light", "relaxed", "socializing", "warm ambiance"]
    }
  },
  {
    filename: "56-summit-selfie-sunny-snowboard.jpg",
    keywords: {
      "llava-7b": ["adventure", "blue sky", "couple", "hiking", "mountain", "outdoor", "people", "smiling", "snow", "sunny"],
      "qwen2.5vl-7b": ["blue", "bright", "couple", "happy", "mountain", "outdoor", "people", "selfie", "smiling", "snow", "sunny"],
      "minicpm-v-8b": ["adventure", "blue sky", "bright sunlight", "cheerful", "clear day", "cold weather gear", "couple", "excited", "happy", "high altitude", "mountainous landscape", "natural beauty.", "outdoor activity", "outdoors", "people", "scenic view", "selfie", "smiling", "snow-covered mountains"]
    }
  },
  {
    filename: "57-mountain-hut-group-window-view.jpg",
    keywords: {
      "llava-7b": ["building", "daytime", "group", "mountain", "outdoor", "people", "sky", "smiling", "snow", "window"],
      "qwen2.5vl-7b": ["adventure", "blue", "bright", "cold", "cold-weather clothing", "excited", "green", "group", "happy", "high-altitude", "joy", "mountain", "outdoor", "people", "red", "selfie", "snow", "sunny", "winter"],
      "minicpm-v-8b": ["black beanie", "blue jacket", "bright sunlight", "clear sky", "cold weather clothing", "excitement", "green hoodie", "group of friends", "happy", "high altitude environment.", "mountainous landscape", "outdoor adventure", "people", "posing for photo", "red jacket", "selfie", "smiling", "snow-covered peaks", "sunglasses"]
    }
  },
  {
    filename: "58-rustic-alpine-restaurant-group.jpg",
    keywords: {
      "llava-7b": ["dining table", "group", "happy", "indoor", "menu", "people", "restaurant", "socializing", "wine glasses"],
      "qwen2.5vl-7b": ["brown", "casual", "cozy", "friendly", "group", "happy", "indoor", "napkins", "people", "restaurant", "selfie", "smiling", "table", "warm", "wine glasses", "wooden"],
      "minicpm-v-8b": ["casual attire", "cozy atmosphere", "group of friends", "happy", "indoor restaurant", "natural light", "people", "plates", "posing for photo", "relaxed", "rustic decor", "smiling", "warm ambiance", "wine glasses", "wooden table"]
    }
  }
];