# LLaVA:7b Performance Comparison Report

## Executive Summary

This report analyzes LLaVA:7b performance across three test runs with different configurations:
- **Take 1**: Default settings (temp 0.1)
- **Take 2**: With system prompt (temp 0.2)  
- **Results**: Final run (temp 0.1, refined prompts)

## Key Findings

### 1. Repetition Rate Evolution

| Test Run | 768px | 1024px | Key Change |
|----------|-------|--------|------------|
| Take 1 | 4.6% | 5.2% | Baseline |
| Take 2 | 1.7% | 2.9% | Added system prompt |
| Results | 2.3% | 5.2% | Lower temp, refined prompts |

**Best performer**: Take 2 with system prompt showed 63% reduction in repetitions.

### 2. The Persistent Quiche Problem

Across ALL tests, image 36 (quiche) was consistently misidentified:
- Take 1: "muffin" 
- Take 2: "muffin"
- Results: "muffin"

This suggests a fundamental model limitation that prompting cannot fix.

### 3. Repetition Pattern Examples

#### Take 1 - Extreme Word Repetition
```
Image 37 (768px): "fence, sign, car, parking lot, building, street light..."
[repeated 236 times]
```

#### Take 2 - Reduced but Present
```
Image 02 (1024px): "indoor, empty, concrete, graffiti" 
[minimal repetition]
```

#### Results - New Pattern Types
```
Image 11 (1024px): "purple shoes, purple sneakers, purple tennis shoes..."
[96 purple-prefixed items]
```

### 4. Quality vs Safety Trade-off

| Metric | Take 1 | Take 2 | Results |
|--------|--------|--------|---------|
| Avg Length | 350 chars | 150 chars | 180 chars |
| Detail Level | High | Low | Medium |
| Repetition Risk | High | Low | Medium |
| Hallucinations | 0.1% | 0% | 0% |

### 5. Prompt-Specific Performance

#### Best Prompts (Lowest Repetition)
1. **03-single-list**: 2.6% repetition rate
2. **01-structured-comprehensive**: 5.2% repetition rate

#### Worst Prompts (Highest Repetition)  
1. **05-detailed-elements**: 7.2% repetition rate
2. **04-generate-all-aspects**: 10.3% repetition rate

### 6. Specific Improvements

#### Image 02 - Graffiti Skate Park

**Take 1 (768px)**: 2,730 characters with massive repetition
```
"indoor, graffiti, skateboard, person, building, concrete, metal, urban, 
abandoned, empty, dark, cold, desolate, neglected, gritty, edgy, raw, 
unkempt, run-down, dilapidated, decaying, vandalized, street art, spray 
paint, colorful, vibrant, bold, bright, vivid, red, blue, green, yellow, 
orange, purple, black, white, gray, concrete floor, metal beams, rusted, 
peeling, chipping, broken, dirty, grime, dusty, unclean, unpainted, 
unfinished, unrefurbished, unrestored, unrenovated, unmaintained, 
unattended, unoccupied, uninhabited, uninviting, unwelcoming, unfriendly, 
unappealing, unattractive, uninviting, uninteresting, unstimulating, 
unengaging, unenjoyable, unenriching, unfulfilling, uninspiring, 
unmotivating, uninspired, uninspiring, uninspiring, uninspiring..."
[continues for 2000+ more characters]
```

**Take 2 (768px)**: 135 characters, clean
```
"abandoned building, graffiti walls, skateboard ramp, person standing, 
indoor warehouse, concrete floor, metal beams, urban decay"
```

**Results (768px)**: 169 characters, balanced
```
"2-people, abandoned building, concrete floor, dark, desolate atmosphere, 
doors, empty, graffiti, indoor, metal beams, neutral tone, no activities, 
no interactions, no people, skateboard ramp, urban, vandalism, windows"
```

### 7. Temperature Impact

- **Temp 0.1**: Prevented hallucinations but didn't stop repetitions
- **Temp 0.2**: Similar repetition patterns, no significant difference
- **Temp 0**: Slightly increased repetitions in some cases

Temperature alone is not sufficient to control repetitive behavior.

## Conclusions

1. **System prompts are critical** - They reduced repetitions by 63%
2. **Simple prompts work best** - Complex prompts trigger more repetitions
3. **Temperature has minimal impact** - System design matters more than temp
4. **Some errors are persistent** - Quiche→muffin across all configurations
5. **Quality/safety trade-off exists** - Less repetition means less detail

## Recommendations

1. Use Take 2 configuration (system prompt) for production
2. Implement post-processing to catch remaining repetitions
3. Use prompt 03 (single-list) for most reliable results
4. Stay at 768px - no benefit to 1024px
5. Consider fine-tuning for food recognition tasks