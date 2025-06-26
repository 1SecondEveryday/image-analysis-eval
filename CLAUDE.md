# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is an image analysis evaluation framework designed to test Vision-Language Models (VLMs) on their ability to extract meaningful tags from images. The project's goal is to enable natural language search for video diary snippets by finding the optimal combination of model, image size, and prompt strategy.

## Architecture

The evaluation framework tests different combinations of:
- **Models**: Ollama-hosted vision models (currently focused on llava:7b and qwen2.5vl:3b)
- **Image sizes**: 768px and 1024px (optimized from testing 128px to 2048px)
- **Prompts**: Various strategies in `prompts/` directory for extracting searchable tags

## Key Scripts

### Core Evaluation
- **`extract_tags.rb`**: Main evaluation script
  ```bash
  ./extract_tags.rb [options]
    -m, --models MODELS              # Comma-separated list of models
    -t, --timeout SECONDS            # Request timeout (default: 120)
    --max-images NUM                 # Limit number of images
    --no-unload                      # Keep models loaded between tests
    --single-prompt NAME             # Test only one prompt
  ```

### Data Preparation
- **`resize_images.rb`**: Resizes images from `photos-original/` to various sizes
  ```bash
  ./resize_images.rb
  ```

### Results Processing
- **`aggregate_results.rb`**: Combines individual CSV results into master files
  ```bash
  ./aggregate_results.rb
  ```

### Photo Organization
- **`rename_photos.rb`**: Interactive photo renaming
- **`auto_rename_photos.rb`**: Automated renaming based on AI analysis
- **`execute_rename.rb`**: Applies rename operations

## Development Workflow

1. **Prepare images**: Place original photos in `photos-original/` and run `resize_images.rb`
2. **Run evaluation**: Use `extract_tags.rb` with desired models/prompts
3. **Aggregate results**: Run `aggregate_results.rb` to combine outputs
4. **Analyze**: Check `results/` directory for CSV outputs and performance metrics

## Project Structure

```
├── photos-original/     # Source images
├── photo-768/          # Resized images (768px)
├── photo-1024/         # Resized images (1024px)
├── prompts/            # Prompt strategies (01-11)
├── results/            # Evaluation outputs (CSV)
├── expected-tags/      # Ground truth tags (optional)
└── *.rb               # Ruby scripts
```

## Technical Details

- **API**: Communicates with local Ollama server at `localhost:11434`
- **Output Format**: CSV with columns: filename, model, size, prompt, tags, response_time, success
- **No Dependencies**: Pure Ruby using standard library only
- **Error Handling**: Continues on failures, logs errors in results

## Current Focus

Based on git history, the project has narrowed from broad testing to:
- **Models**: llava:7b, qwen2.5vl:7b, and minicpm-v:8b
- **Sizes**: 768px (optimal balance of quality and performance)
- **Prompts**: Simplified to 01, 03, and 05 (complex prompts removed)
- **Goal**: Optimal tag extraction for video diary search functionality

## Evaluation Priorities

When evaluating model performance, our priorities are (in order):
1. **People detection** - Detecting human presence, emotions, expressions, moods, activities, and interactions
2. **Overall mood/atmosphere** - Capturing the feeling and emotional tone of scenes
3. **Objects** - Important items that provide context
4. **Scene details** - Colors, lighting, setting/location, time of day
2. **Camera perspective** - Identifying selfies and POV (first-person) shots

### Key Insights from Testing
- **Emotion focus**: We prioritize understanding how people feel over precisely counting them
- **Background matters**: Details like "bicycles in distance" enable memory-based searches
- **Simple prompts win**: Complex prompts cause repetition without adding value
- **Model strengths vary**:
  - Qwen2.5VL: Best for emotion keywords
  - MiniCPM-V: Best for comprehensive scene understanding
  - LLaVA:7b: Most reliable with minimal repetition
