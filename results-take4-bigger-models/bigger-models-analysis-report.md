# Vision Model Analysis: People-First Evaluation 👥

## Executive Summary

We tested 6 vision models prioritizing what matters most: detecting people, their emotions, and interactions. With people being our top priority, followed by objects, mood, and scene context, the results reveal a surprising winner.

**Clear Winner: Qwen2.5VL:7b** - Best at detecting people and their emotions
**Runner-up: MiniCPM-V:8b** - Richest emotional descriptions and mood understanding  
**Surprise: LLaVA:13b** struggled with people detection despite its size

## 🎯 What Matters Most: People & Emotion Detection

| Model | People Detection | Emotions/Image | Mood Quality | Overall People Score |
|-------|-----------------|----------------|--------------|---------------------|
| qwen2.5vl:7b | Excellent | 2.5 | Good | ⭐⭐⭐⭐⭐ |
| minicpm-v:8b | Good | 2.6 | Excellent | ⭐⭐⭐⭐ |
| llava:7b | Good | 1.2 | Moderate | ⭐⭐⭐ |
| llava:13b | Moderate | 1.5 | Good | ⭐⭐⭐ |
| bakllava:7b | Good | 0.2 | Poor | ⭐⭐ |
| llama3.2-vision:11b | Poor | N/A* | Poor | ❌ |

*Too much repetition to extract meaningful emotion data

## 👥 The People Detection Champion: Qwen2.5VL

### Why Qwen Wins:
- **Reliably detects people presence** in all types of scenes
- **Good emotion range**: Captures "happy", "cheerful", "relaxed", "casual", "socializing"
- **Understands interactions**: "couple dining", "friends gathering", "family celebration"
- **Handles groups well**: Distinguishes between couples, small groups, and larger gatherings

### Example Performance:
```
Image: Restaurant group dinner
Qwen: "group, happy, socializing, dining, cheerful atmosphere"
MiniCPM: "people, convivial, warm lighting, social gathering"
LLaVA-13b: "group, eating" (minimal emotional context)
```

## 😊 Best for Emotional Intelligence: MiniCPM-V

MiniCPM-V excels at capturing the human element:
- **2.6 emotions per image** (highest of all models)
- Rich descriptors: "convivial atmosphere", "intimate moment", "contemplative mood"
- Catches subtle social dynamics and group interactions
- Perfect for applications prioritizing emotional understanding

## 🚨 Critical Failures in People Detection

### The 13B Disappointment
Despite being the largest successful model, LLaVA:13b showed surprisingly poor people awareness:
- Often missed people entirely or provided minimal context
- Limited emotional vocabulary compared to smaller models
- Better at objects than understanding human elements

### The 11B Disaster
Llama3.2-vision:11b is unusable for people-focused applications:
- Frequently missed people presence entirely
- Minimal emotion detection capability
- Repetition issues make output unreliable

## 📊 Secondary Priorities Performance

### Objects & Scene Elements
1. **LLaVA:13b** - Most comprehensive object detection
2. **MiniCPM-V:8b** - Good balance of objects and context
3. **Qwen2.5VL:7b** - Adequate but focused on people

### Mood & Atmosphere
1. **MiniCPM-V:8b** - Best atmospheric descriptions
2. **Qwen2.5VL:7b** - Good mood detection alongside people
3. **LLaVA:13b** - Decent but inconsistent

### Background & Context (e.g., The Quiche Test)
- **BakLLaVA:7b**: Best at detecting "water in background"
- **LLaVA:7b**: Good background awareness
- **Qwen2.5VL:7b**: Missed ocean context (focused on person/food)

## 🎯 Recommended Model Configurations

### For People-First Applications:
**Primary Choice: Qwen2.5VL:7b at 1024px**
- Use prompt 01 (structured-comprehensive) or 03 (single-list)
- Excellent at detecting people presence and emotions
- Clean output with minimal repetition on simple prompts

### For Emotion-Rich Applications:
**Alternative: MiniCPM-V:8b at 768px**
- Best for capturing mood and atmosphere
- Zero repetition issues
- Most descriptive emotional analysis

### For Balanced Detection:
**Fallback: LLaVA:7b at 768px**
- Good people detection with decent emotions
- Strong all-around performance
- Reliable and predictable

## ⚠️ Models to Avoid for People-Focused Use

1. **Llama3.2-vision:11b** - Catastrophic failure at people detection
2. **LLaVA:13b** - Surprisingly poor despite size/cost
3. **BakLLaVA:7b** - Minimal emotion detection (0.2 per image)

## 🔮 Next Steps

1. **Optimize Qwen2.5VL for Production**
   - Test with your specific people-focused prompts
   - Fine-tune for your emotion vocabulary
   - Implement at 1024px for best accuracy

2. **Create People-Focused Test Set**
   - Images with verified people counts
   - Expected emotions and interactions
   - Challenging scenarios (crowds, partial visibility)

3. **Consider Ensemble Approach**
   - Qwen for counting + MiniCPM for emotions
   - Could achieve best of both worlds

## Final Verdict

For applications where people matter most, **Qwen2.5VL:7b** is the clear winner. It excels at detecting when people are present and understanding their emotions, moods, and interactions. While exact counting becomes less important with larger groups, Qwen reliably distinguishes between individuals, couples, small groups, and crowds while capturing the emotional context that matters.

The surprise? Bigger models (LLaVA:13b, Llama3.2:11b) performed worse at understanding people than their smaller counterparts. For people-first applications, Qwen2.5VL:7b offers the best combination of human understanding, efficiency, and reliability. 👥