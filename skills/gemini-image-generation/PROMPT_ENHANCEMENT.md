# Prompt Enhancement Guide for Gemini Image Generation

> Best practices from Google Imagen for creating high-quality prompts that produce exceptional results

## 🎯 Purpose

This guide helps AI agents enhance user prompts before sending them to Gemini's image generation models (Gemini 3 Pro and Gemini 2.5 Flash). By applying these techniques, users get significantly better results without needing to know professional prompt engineering.

---

## 📚 Core Enhancement Principles

### 1. **Be Hyper-Specific**

**Principle:** The more detail you provide, the more control you have over the output.

**Technique:** Replace generic terms with detailed descriptions.

**Examples:**

| Basic Prompt | Enhanced Prompt |
|--------------|-----------------|
| "fantasy armor" | "ornate elven plate armor, etched with silver leaf patterns, with a high collar and pauldrons shaped like falcon wings" |
| "a dog" | "a golden retriever puppy with floppy ears, sitting on green grass, looking directly at camera with a playful expression" |
| "city skyline" | "futuristic Tokyo skyline at night, with neon-lit skyscrapers, holographic advertisements, and flying vehicles between buildings" |
| "forest" | "dense pine forest with morning mist, dappled sunlight filtering through tall trees, moss-covered fallen logs on the forest floor" |

---

### 2. **Provide Context and Intent**

**Principle:** Explain the purpose of the image. The model's understanding of context influences the final output.

**Technique:** Add context about what the image is for.

**Examples:**

| Basic Prompt | Enhanced Prompt |
|--------------|-----------------|
| "logo" | "logo for a high-end, minimalist skincare brand targeting luxury spa market, clean lines, soft pastel colors" |
| "product photo" | "professional e-commerce product photography of wireless headphones, white background, studio lighting, clean modern aesthetic for online store listing" |
| "banner" | "YouTube channel banner for tech reviews channel, sleek modern design with gadgets and technology theme, 16:9 format with space for channel name on left" |
| "illustration" | "children's book illustration for ages 4-6, friendly animal characters in a whimsical meadow, bright cheerful colors, soft rounded shapes" |

---

### 3. **Control the Camera**

**Principle:** Use photographic and cinematic language to control composition and perspective.

**Camera Angles & Perspectives:**
- `wide-angle shot` - Captures broad view, great for landscapes
- `macro shot` - Extreme close-up, shows fine detail
- `low-angle perspective` - Camera looking up, makes subject look powerful
- `high-angle perspective` - Camera looking down, shows environment
- `eye-level shot` - Natural, neutral perspective
- `bird's eye view` - Directly from above
- `Dutch angle` - Tilted, creates tension or unease

**Focal Length & Depth:**
- `shallow depth of field` - Subject sharp, background blurred
- `deep focus` - Everything in sharp focus
- `bokeh background` - Artistic background blur
- `telephoto lens compression` - Flattened perspective

**Examples:**

| Basic Prompt | Enhanced Prompt |
|--------------|-----------------|
| "portrait of a woman" | "portrait of a woman, shallow depth of field, 85mm lens, eye-level perspective, soft natural lighting on face" |
| "car on street" | "sports car on urban street, low-angle wide-angle shot, dramatic perspective, motion blur background" |
| "food photo" | "gourmet burger, macro shot from 45-degree angle, shallow depth of field, foreground in sharp focus, bokeh background" |

---

### 4. **Specify Lighting & Mood**

**Principle:** Lighting dramatically affects the image's emotion and quality.

**Lighting Types:**
- `golden hour lighting` - Warm, soft sunlight at sunrise/sunset
- `harsh midday sun` - Strong shadows, high contrast
- `soft diffused lighting` - Even, gentle, no harsh shadows
- `dramatic side lighting` - Creates depth and texture
- `rim lighting / backlighting` - Light from behind, creates glow
- `studio lighting` - Controlled, professional setup
- `natural window light` - Soft, directional indoor light
- `neon lighting` - Colorful, artificial, cyberpunk aesthetic
- `candlelight / warm ambient` - Intimate, cozy atmosphere

**Mood & Atmosphere:**
- Cinematic, moody, ethereal, whimsical, dramatic, serene, mysterious, playful, melancholic, energetic

**Examples:**

| Basic Prompt | Enhanced Prompt |
|--------------|-----------------|
| "mountain landscape" | "mountain landscape at golden hour, warm soft lighting, dramatic clouds, serene and peaceful atmosphere" |
| "office interior" | "modern office interior, soft natural window light from left, clean minimalist aesthetic, professional and calm mood" |
| "night scene" | "cyberpunk city street at night, neon lighting in pink and blue, wet pavement reflections, mysterious and atmospheric mood" |

---

### 5. **Use Style & Artistic References**

**Principle:** Reference art styles, mediums, or specific aesthetics to guide the visual style.

**Art Styles:**
- Photography: `photorealistic`, `DSLR photography`, `film photography`, `polaroid style`
- Digital Art: `digital illustration`, `concept art`, `matte painting`, `3D render`
- Traditional: `oil painting`, `watercolor`, `pencil sketch`, `ink drawing`
- Modern: `minimalist design`, `flat design`, `isometric art`, `low poly art`
- Specific: `anime style`, `comic book art`, `pixel art`, `art nouveau`, `vaporwave aesthetic`

**Examples:**

| Basic Prompt | Enhanced Prompt |
|--------------|-----------------|
| "portrait" | "portrait in the style of Renaissance oil painting, dramatic chiaroscuro lighting, rich colors, classical composition" |
| "landscape" | "landscape in watercolor style, soft washes of color, loose brushstrokes, dreamy and impressionistic" |
| "logo design" | "logo in minimalist flat design style, simple geometric shapes, limited color palette, modern and clean" |

---

### 6. **Use Semantic Negative Prompts**

**Principle:** Instead of saying what you DON'T want, describe positively what you DO want.

**Examples:**

| ❌ Negative Approach | ✅ Positive Approach |
|---------------------|---------------------|
| "no cars" | "empty, deserted street with no signs of traffic" |
| "no people" | "pristine uninhabited wilderness landscape" |
| "not blurry" | "sharp focus, high detail, crystal clear" |
| "no dark colors" | "bright, vibrant color palette, well-lit scene" |

---

### 7. **Break Complex Scenes into Steps**

**Principle:** For images with many elements, use step-by-step instructions.

**Example:**

**Basic:** "fantasy scene with forest and altar"

**Enhanced (Step-by-Step):**
```
First, create a background of a serene, misty forest at dawn with tall ancient trees. 
Then, in the foreground, add a moss-covered ancient stone altar with intricate carvings. 
Finally, place a single, glowing magical sword standing upright on top of the altar, 
emanating soft blue light.
```

---

## 🤖 AI Agent Enhancement Workflow

When a user provides a prompt, follow these steps to enhance it:

### Step 1: Analyze the User's Prompt

Identify what's missing:
- [ ] Specific details about the subject?
- [ ] Context or purpose?
- [ ] Camera angle or perspective?
- [ ] Lighting or mood?
- [ ] Style or artistic direction?

### Step 2: Apply Enhancement Techniques

**For each missing element, add appropriate details:**

1. **Subject Details** → Add hyper-specific descriptions (colors, textures, materials, shapes)
2. **Context** → Add purpose or use case (logo for X, illustration for Y)
3. **Camera** → Add perspective terms (wide-angle, macro, low-angle, etc.)
4. **Lighting** → Add lighting type and mood (golden hour, dramatic, soft, etc.)
5. **Style** → Add artistic style if appropriate (photorealistic, minimalist, etc.)

### Step 3: Preserve User Intent

**CRITICAL:** Keep the core idea intact. Only enhance, never replace.

**Example:**
- User: "two cars dodging"
- ❌ Bad: "Two horses racing in a field" (changed subject completely)
- ✅ Good: "Two sleek sports cars racing towards each other on a dramatic highway, performing a thrilling last-second dodge maneuver..."

### Step 4: Show Before/After

Always show both versions for transparency:

```
Original prompt: [user's original prompt]

Enhanced prompt: [your enhanced version with added details]

This adds: [list what you added: camera angle, lighting, mood, etc.]

Use enhanced version? (yes/no/let me edit)
```

---

## 📋 Enhancement Templates

Use these templates as starting points:

### Template 1: Product Photography
```
[product name], professional product photography, [describe product details], 
[background color] background, studio lighting, clean modern aesthetic, 
[camera angle], sharp focus
```

### Template 2: Landscape
```
[location/scene], [time of day] with [lighting quality], [weather/atmosphere], 
[camera perspective], [mood adjectives], [artistic style if needed]
```

### Template 3: Portrait
```
[subject description], [camera angle and lens], [lighting type], 
[background description], [mood/expression], [artistic style]
```

### Template 4: Logo/Brand Design
```
[type] logo for [brand description], [style keywords], [color palette], 
[mood/feeling], suitable for [use case]
```

### Template 5: Action/Dynamic Scene
```
[subjects] [action verb], [location], [camera angle], [motion effects like blur/smoke], 
[lighting], [cinematic/dramatic mood]
```

---

## ✅ Quick Enhancement Checklist

Before sending the prompt to the API, verify:

- [ ] **Specific details** about subject (not generic terms)
- [ ] **Camera angle/perspective** mentioned
- [ ] **Lighting type** specified
- [ ] **Mood/atmosphere** described
- [ ] **Style/medium** noted (if applicable)
- [ ] **Context/purpose** clear
- [ ] **All negative prompts** rephrased positively
- [ ] **User's original intent** preserved

---

## 🎯 Real-World Enhancement Examples

### Example 1: User Request
**User:** "Generate a logo"

**Agent asks:** "Would you like me to enhance this prompt for better results?"

**User:** "Yes"

**Agent enhances:**
```
Original: Generate a logo

Enhanced: Modern minimalist logo design, clean geometric shapes, professional and 
trustworthy aesthetic, limited color palette with navy blue and white, suitable for 
tech startup, simple and memorable

Added: context (tech startup), style (minimalist), colors, mood (professional)

Use this enhanced version?
```

---

### Example 2: User Request
**User:** "Sunset over mountains"

**Agent asks:** "Would you like me to enhance this prompt for better results?"

**User:** "Yes"

**Agent enhances:**
```
Original: Sunset over mountains

Enhanced: Majestic mountain range at golden hour sunset, warm orange and pink light 
illuminating snow-capped peaks, dramatic clouds in the sky, serene and peaceful 
atmosphere, wide-angle landscape shot, photorealistic style with rich colors

Added: lighting (golden hour), details (snow-capped peaks, clouds), mood (serene), 
camera (wide-angle), style (photorealistic)

Use this enhanced version?
```

---

### Example 3: User Request
**User:** "Two cars moving towards each other and dodging them at the last moment"

**Agent asks:** "Would you like me to enhance this prompt for better results?"

**User:** "Yes"

**Agent enhances:**
```
Original: Two cars moving towards each other and dodging them at the last moment

Enhanced: Two sleek sports cars racing towards each other on a dramatic highway at 
sunset, performing a thrilling last-second dodge maneuver with tire smoke and motion 
blur, wide-angle shot from low perspective, cinematic action scene with warm golden 
hour lighting

Added: details (sleek sports cars, highway), camera (wide-angle, low perspective), 
lighting (golden hour), effects (tire smoke, motion blur), mood (cinematic, thrilling)

Use this enhanced version?
```

---

## 🚫 Common Mistakes to Avoid

### 1. Over-Complicating Simple Requests
- If user wants "simple minimalist logo," don't add "intricate details with complex textures"
- Match complexity level to user's intent

### 2. Changing the Subject
- User: "cat" → ❌ "majestic lion in savanna"
- User: "cat" → ✅ "fluffy domestic cat with bright green eyes, sitting on windowsill"

### 3. Adding Contradictory Elements
- Don't add "dramatic harsh lighting" if user wants "soft peaceful mood"
- Keep enhancements coherent with overall vision

### 4. Ignoring Context
- User creating logo → Don't add complex photorealistic details
- User wanting concept art → Don't make it minimal flat design

---

## 🌍 Language Support Note

For best performance with Gemini image models, prompts work best in these languages:
- EN (English), ar-EG, de-DE, es-MX, fr-FR, hi-IN, id-ID, it-IT, ja-JP, ko-KR, pt-BR, ru-RU, ua-UA, vi-VN, zh-CN

If user provides prompt in another language, consider suggesting translation to one of these for optimal results.

---

## 📊 Model-Specific Considerations

### For Gemini 3 Pro (Professional Quality)
- Add MORE detail - this model handles complexity well
- Specify exact camera settings, lighting setup
- Include artistic style references
- Be verbose and precise

### For Gemini 2.5 Flash (Speed & Efficiency)
- Keep enhancements focused on key elements
- Still add detail, but prioritize clarity over complexity
- Focus on subject, lighting, and mood
- Less need for technical camera jargon

---

## 💡 Advanced Techniques

### Technique 1: Iterative Refinement Guidance
After generation, suggest follow-up prompts:
- "Keep everything the same, but make the lighting warmer"
- "Same composition, but change expression to more serious"
- "Maintain style, but add more vibrant colors"

### Technique 2: Reference Image Suggestions
When appropriate, ask:
- "Do you have any reference images for style guidance?"
- Supports up to 14 images (Gemini 3 Pro)

### Technique 3: Text-in-Image Best Practice
If user wants text in the image:
- Suggest generating the text first
- Then ask for image with that text
- Improves text accuracy

---

## 📖 Version History

**1.0.0** (2026-01-20)
- Initial release based on Google Imagen best practices
- Comprehensive enhancement techniques and templates
- AI agent workflow integration guide

---

**For questions or additional techniques, refer to Google's official Gemini API documentation.**
