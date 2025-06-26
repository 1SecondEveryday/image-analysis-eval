# Results Take 5 Analysis - Emphasizing Emotion
## Using 01-structured-comprehensive prompt

### Overview
This analysis examines keyword extraction from 58 images using three Vision-Language Models (VLMs):
- **llava:7b** - Focused on quality and detail
- **qwen2.5vl:7b** - Larger Qwen model for comparison
- **minicpm-v:8b** - Larger model for comprehensive coverage

All models used:
- Image size: 768px
- Prompt: 01-structured-comprehensive

### Key Findings

#### 1. Tag Count Statistics
Based on the CSV data:

**Average tags per image:**
- llava:7b: ~15-20 tags (concise, focused)
- qwen2.5vl:7b: ~20-25 tags (moderate detail, some repetition)
- minicpm-v:8b: ~20-25 tags (detailed, descriptive phrases)

#### 2. Model Characteristics

**llava:7b**
- Strengths:
  - Consistently identifies people and emotions
  - Good at capturing scene context (indoor/outdoor, time of day)
  - Balanced between objects and atmosphere
  - Clean, searchable keywords
- Weaknesses:
  - Sometimes misses subtle details
  - Less descriptive than larger models

**qwen2.5vl:7b**
- Strengths:
  - Excellent color detection
  - Good emotional state recognition
  - Detailed environmental descriptions
- Weaknesses:
  - Significant repetition issues (especially in complex scenes)
  - Sometimes generates excessive variations of the same concept
  - Can get stuck in loops (see image 10, 25, 26, 33, 51, 54)

**minicpm-v:8b**
- Strengths:
  - Most detailed descriptions
  - Excellent at capturing subtle elements
  - Good at identifying specific objects and their relationships
  - Provides context-rich phrases
- Weaknesses:
  - Often too verbose with full phrases instead of keywords
  - Uses periods in tags (formatting issue)
  - One complete failure (image 16 - highland cattle)

#### 3. Specific Observations

**People Detection:**
- All models reliably detect people when present
- llava:7b uses simple "people" tag
- qwen2.5vl:7b often adds "pov" for first-person perspective
- minicpm-v:8b provides detailed descriptions ("couple relaxed sitting")

**Emotion Recognition:**
- llava:7b: Basic emotions (happy, relaxed, excited)
- qwen2.5vl:7b: More nuanced (contemplative, cheerful, jovial)
- minicpm-v:8b: Contextual emotions (joyful expressions, comfortable ambiance)

**Scene Understanding:**
- All models correctly identify indoor/outdoor settings
- qwen2.5vl:7b excels at lighting conditions
- minicpm-v:8b provides most architectural detail

#### 4. Notable Issues

**Repetition Problems (qwen2.5vl:7b):**
- Image 10: "cold" repeated ~100+ times
- Image 25: "pet adventure, pet happiness, pet joy" repeated ~30+ times
- Image 51: "food" repeated ~140 times
- Image 54: "cafe" repeated ~90 times

**Formatting Issues:**
- minicpm-v:8b ends many tags with periods
- qwen2.5vl:7b occasionally includes duplicate tags

**Complete Failures:**
- minicpm-v:8b failed on image 16 (returned "no people present" only)

### Recommendations

1. **For Production Use:**
   - **Primary**: llava:7b - Most reliable, clean output, good balance
   - **Fallback**: minicpm-v:8b - When more detail needed
   - **Avoid**: qwen2.5vl:7b - Due to repetition issues

2. **Post-Processing Needed:**
   - Remove periods from minicpm-v:8b output
   - Deduplicate tags from all models
   - Consider combining outputs for comprehensive coverage

3. **Prompt Optimization:**
   - The 01-structured-comprehensive prompt works well
   - Consider adding explicit instruction to avoid repetition
   - May need model-specific prompts to address weaknesses

### Conclusion

The emphasis on emotion in this test run successfully improved people and emotion detection across all models. llava:7b provides the best balance of accuracy, consistency, and usability for a video diary search system. The 768px image size with 01-structured-comprehensive prompt appears optimal for this use case.