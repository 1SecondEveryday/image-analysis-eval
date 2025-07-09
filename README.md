# Image Analysis Evaluation Framework

An evaluation framework for testing Vision-Language Models (VLMs) on their ability to extract meaningful tags from images. This project helps identify the optimal combination of model, image size, and prompt strategy for generating searchable tags from video diary snippets.

## Overview

This framework is designed to enable natural language search for video diary content by evaluating different VLMs' performance at extracting contextual tags from images. The goal is to find the best approach for generating tags that users can search with natural language queries like "when was I happy with friends" or "snowy mountain scenes."

## Quick Start

### Prerequisites

- Ruby (standard library only - no gems required)
- [Ollama](https://ollama.ai) running locally with vision models installed
- Image files to analyze

### Basic Usage

1. **Install Ollama models:**
   ```bash
   ollama pull llava:7b
   ollama pull qwen2.5vl:7b
   ollama pull minicpm-v:8b
   ```

2. **Add your images:**
   ```bash
   # Place original images in photos-original/
   cp your_images/* photos-original/
   
   # Resize images for testing
   ./resize_images.rb
   ```

3. **Run evaluation:**
   ```bash
   # Test all models with default settings
   ./extract_tags.rb
   
   # Test specific models
   ./extract_tags.rb -m llava:7b,qwen2.5vl:7b
   
   # Test with limited images
   ./extract_tags.rb --max-images 10
   ```

4. **View results:**
   ```bash
   # Combine all results into master files
   ./aggregate_results.rb
   
   # Check results/ directory for CSV outputs
   ls results/
   ```

## Architecture

The framework tests different combinations of:

- **Models**: Ollama-hosted vision models (llava:7b, qwen2.5vl:7b, minicpm-v:8b, gemma3:12b)
- **Image sizes**: 768px and 1024px (optimized from testing 128px to 2048px)
- **Prompts**: Three refined strategies focusing on different aspects

### Evaluation Priorities

The framework prioritizes tags in this order:
1. **People detection** - Human presence, emotions, expressions, moods, activities, interactions
2. **Overall mood/atmosphere** - Emotional tone and feeling of scenes
3. **Objects** - Important items that provide context
4. **Scene details** - Colors, lighting, setting/location, time of day
5. **Camera perspective** - Selfies and POV (first-person) shots

## Project Structure

```
├── photos-original/          # Source images (add your images here)
├── photo-768/               # Resized images (768px)
├── photo-1024/              # Resized images (1024px)
├── prompts/                 # Prompt strategies
│   ├── 01-structured-comprehensive.txt
│   ├── 03-single-list.txt
│   └── 05-detailed-elements.txt
├── results/                 # Evaluation outputs (CSV files)
├── expected-tags/           # Ground truth tags (optional)
├── claude-scratchpad/       # Analysis scripts and reports
└── *.rb                     # Ruby evaluation scripts
```

## Scripts

### Core Evaluation

#### `extract_tags.rb` - Main evaluation script
```bash
Usage: ./extract_tags.rb [options]

Options:
  -m, --models MODELS              Comma-separated list of models
  -t, --timeout SECONDS            Request timeout (default: 120)
      --max-images NUM             Limit number of images processed
      --no-unload                  Keep models loaded between tests
      --single-prompt NAME         Test only one prompt (01, 03, or 05)
  -v, --verbose                    Enable verbose output
  -h, --help                       Show this help message

Examples:
  ./extract_tags.rb                                    # Test all models
  ./extract_tags.rb -m llava:7b --max-images 5        # Quick test
  ./extract_tags.rb --single-prompt 03 --no-unload    # Test one prompt
```

### Data Management

#### `resize_images.rb` - Image preparation
Resizes images from `photos-original/` to different sizes for testing.

```bash
./resize_images.rb
```

#### `aggregate_results.rb` - Results compilation
Combines individual CSV results into master files for analysis.

```bash
./aggregate_results.rb
```

#### `rename_photos.rb` - Interactive photo management
Interactive tool for renaming photos with descriptive names.

```bash
./rename_photos.rb
```

#### `auto_rename_photos.rb` - Automated photo renaming
Uses AI to automatically generate descriptive names for photos.

```bash
./auto_rename_photos.rb
```

## Prompts

The framework uses three refined prompt strategies:

### 01-structured-comprehensive.txt
```
List comma-separated keywords only. For this image include: people presence (if humans visible, include 'people' and describe as 'couple', 'group', or 'crowd'); their emotions, expressions, and mood (happy, relaxed, contemplative, excited, etc.); what they're doing and how they're interacting; camera perspective (include 'selfie' if self-portrait or 'pov' if first-person view); dominant colors; key objects; overall atmosphere and mood; lighting quality; and setting/location.
```

### 03-single-list.txt
```
Provide a single comma-separated list of keywords. If people are present, capture their emotions, expressions, moods, and what they're doing. Note if it's a selfie or POV shot. Include overall atmosphere, key objects, dominant colors, lighting, and setting/location—nothing else.
```

### 05-detailed-elements.txt
```
Create keywords as comma-separated values only. Focus on: people's emotions, expressions, moods, and activities if present; camera perspective (selfie or pov if applicable); the emotional atmosphere and overall mood; important objects; dominant colors; lighting quality; and location/setting details.
```

## Output Format

Results are saved as CSV files with the following columns:
- `filename` - Image filename
- `model` - Model used for analysis
- `size` - Image size (768 or 1024)
- `prompt` - Prompt strategy used (01, 03, or 05)
- `tags` - Extracted comma-separated tags
- `response_time` - Processing time in seconds
- `success` - Boolean indicating if request succeeded

## Model Performance Insights

Based on extensive testing, here are key findings:

### Model Strengths
- **Qwen2.5VL**: Best for emotion keywords and mood detection
- **MiniCPM-V**: Best for comprehensive scene understanding
- **LLaVA 7B**: Most reliable with minimal repetition

### Optimization Findings
- **768px images**: Optimal balance of quality and performance
- **Simple prompts**: Complex prompts cause repetition without adding value
- **Emotion focus**: Users care more about how people feel than precise counting
- **Background details**: Details like "bicycles in distance" enable memory-based searches

## Configuration

The framework uses these defaults:
- **Ollama URL**: `http://localhost:11434/api/generate`
- **Default models**: `llava:7b`, `qwen2.5vl:7b`, `minicpm-v:8b`, `gemma3:12b`
- **Image sizes**: 768px and 1024px
- **Timeout**: 120 seconds
- **Image formats**: `.jpg`, `.jpeg`, `.png`, `.gif`, `.bmp`, `.tiff`, `.tif`

## API Integration

The framework communicates with Ollama's REST API:

```ruby
# Example API call structure
{
  "model": "llava:7b",
  "prompt": "Provide a single comma-separated list of keywords...",
  "images": ["base64_encoded_image_data"],
  "stream": false
}
```

## Development

### Adding New Models

1. Install the model with Ollama:
   ```bash
   ollama pull model_name:tag
   ```

2. Add to the models list in `extract_tags.rb`:
   ```ruby
   DEFAULT_MODELS = ['llava:7b', 'qwen2.5vl:7b', 'minicpm-v:8b', 'your_model']
   ```

### Adding New Prompts

1. Create a new prompt file in `prompts/`:
   ```bash
   echo "Your prompt text here" > prompts/06-new-strategy.txt
   ```

2. The framework will automatically detect and use the new prompt.

### Custom Analysis

The `claude-scratchpad/` directory contains analysis scripts and reports for deeper insights into model performance.

## Error Handling

The framework includes robust error handling:
- Continues processing on individual failures
- Logs errors in result files
- Provides verbose output for debugging
- Includes timeout protection for long-running requests

## Performance Tips

- Use `--no-unload` to keep models loaded between tests (faster)
- Start with `--max-images 5` for quick testing
- Use `--single-prompt` to test prompt variations efficiently
- Monitor Ollama's resource usage during evaluation

## Contributing

This framework is designed for experimentation and can be extended with:
- New prompt strategies
- Additional models
- Different image preprocessing approaches
- Advanced analysis scripts
- Ground truth comparison tools

## License

This project is part of the 1 Second Everyday ecosystem and is designed for internal research and development.