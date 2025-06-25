# Big Model Showdown: Vision Model Analysis Report 🏆

## Executive Summary

We tested 6 vision models across 5 prompts at 2 image sizes (768px, 1024px). The results reveal that bigger isn't always better - the 11B parameter model was the worst performer, while 13B and 8B models delivered excellent results.

**Clear Winner: LLaVA:13b** - Zero issues, great detail, catches background elements
**Runner-up: MiniCPM-V:8b** - Perfect repetition score, concise and accurate  
**Surprise: BakLLaVA:7b** - Correctly identified "quiche" (not muffin!)

## The Contenders

| Model | Parameters | Avg Output Length | Repetition on Simple Prompts | Ocean/Beach Detection |
|-------|------------|-------------------|------------------------------|----------------------|
| llava:13b | 13B | 235 chars | ~0% | ✅ Good |
| minicpm-v:8b | 8B | 169 chars | 0% | ✅ Good |
| bakllava:7b | 7B | 71 chars | ~0% | ✅ Best |
| llava:7b | 7B | 178 chars | ~0% | ✅ Good |
| qwen2.5vl:7b | 7B | 158 chars | ~0% | ❌ Failed |
| llama3.2-vision:11b | 11B | 346 chars | 64% (all prompts) | ❌ Failed |

## 🎯 The Quiche Test (Image 36)

Our tough scoring on the coastal quiche photo revealed interesting model behaviors:

### Winners (Detected water/ocean/beach):
- **bakllava:7b**: "body of water in the background" ✅
- **llava:7b**: "water, sky" ✅
- **llava:13b**: Detected water element ✅
- **minicpm-v:8b** (768px): Found "water body" ✅

### Failures (Missed the coastal context):
- **llama3.2-vision:11b**: Despite verbose output, completely missed water
- **qwen2.5vl:7b**: Only saw "hand, food" - tunnel vision on the quiche

### Food Identification:
- **BakLLaVA** correctly called it "quiche"! 🥧
- Everyone else: "muffin" or "pastry" 🧁

## 🚨 The Repetition Disaster (Raw Model Output)

Note: While the extraction script successfully deduplicates keywords, these models generate severely repetitive raw output that wastes compute and indicates poor model behavior.

### Llama3.2-vision:11b's Epic Fail
```
"walking, walking, walking, walking, walking, walking, walking, walking, 
walking, walking, walking, walking, walking, walking, walking, walking..."
```
This repeated **121 times** in the raw output! 64% of all outputs had severe repetition before deduplication.

### Other Repetition Issues (Raw Output):
- **qwen2.5vl:7b**: 47% repetitive outputs on memory search prompt (but fine on simple prompts)
- **llava:7b**: 20% on complex prompts (performs well on production prompts)

### Models with Clean Raw Output:
- **minicpm-v:8b**: Perfect 0% repetition across all prompts
- **bakllava:7b**: Nearly perfect (minimal issues)
- **llava:13b**: Excellent across all prompt types

## 📊 Best Model-Prompt-Size Combinations

### Top 3 Winners:

1. **llava:13b + 01-structured-comprehensive + 768px**
   - Perfect balance of detail and structure
   - No repetition issues
   - Catches background elements reliably

2. **minicpm-v:8b + 03-single-list + 768px**
   - Ultra-clean outputs
   - Perfect for keyword extraction
   - Zero repetition guarantee

3. **bakllava:7b + 05-detailed-elements + 768px**
   - Concise but accurate
   - Best at food identification
   - Minimal compute requirements

## 🔍 Interesting Discoveries

### 1. The Brevity Champion
**BakLLaVA** averages only 71 characters but packs surprising accuracy. It's like the haiku master of vision models.

### 2. Resolution Paradox
Several models performed WORSE at 1024px than 768px for coastal detection. Higher resolution ≠ better context understanding.

### 3. Prompt Sensitivity Confirms Simple is Better
- Simple prompts (01, 03, 05) work best across all models
- Complex prompts (08, 11) cause issues but won't be used in production anyway
- Models that fail on complex prompts but excel on simple ones (like qwen2.5vl) are still viable

### 4. The 11B Disappointment
Llama3.2-vision proves that parameter count isn't everything. It generated verbose, repetitive nonsense while smaller models delivered clean, accurate results.

## 🎬 Recommendations & Next Steps

### For Production Use:
1. **Primary**: llava:13b at 768px with prompt 01 or 03
2. **Budget option**: minicpm-v:8b at 768px with prompt 03
3. **Food focus**: bakllava:7b for culinary applications

### Immediate Next Steps:

1. **Create Expected Tags Dataset**
   - Start with tricky images like #36 (must include: ocean, beach, coastal, water)
   - Focus on commonly missed elements
   - Build evaluation scoring based on these ground truths

2. **Implement Strict Scoring**
   - Fail any output missing important context elements
   - Penalize hallucinations heavily
   - Reward conciseness with accuracy

3. **Post-Processing Pipeline**
   - Repetition detection and removal
   - Format validation

4. **Model-Specific Optimizations**
   - Fine-tune llava:13b for coastal/water detection
   - Test ensemble approaches for difficult cases
   - Implement fallback strategies for repetition-prone outputs

### Avoid At All Costs:
- ❌ llama3.2-vision:11b (unusable due to repetition on ALL prompts)
- ❌ Complex prompts in general (not needed for production)
- ❌ 1024px when 768px suffices (save 25% compute)

## Final Verdict

**LLaVA:13b** emerges as the clear winner - it's the Goldilocks of vision models: not too verbose, not too terse, with minimal failures on challenging cases. While BakLLaVA surprised us with its quiche identification skills, and MiniCPM impressed with perfect repetition scores, LLaVA:13b delivers the most reliable all-around performance for production use.

The real lesson? Test rigorously with tough scoring criteria. A model that struggles with tricky context like the ocean in image #36 shows there's room for improvement, but LLaVA:13b handles both people (our priority) and these challenging cases well! 🌊