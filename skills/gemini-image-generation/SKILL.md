---
name: gemini-image-generation
description: Generate professional images using Google's Gemini 3 Pro or Gemini 2.5 Flash image models with AI-powered prompt enhancement. Universal Python script works on all platforms. Supports custom aspect ratios (1:1, 16:9, 9:16), resolutions (1K-4K), reference images, and Google Search grounding. Activate when user says "Generate an image with Gemini", "Create using Gemini Pro/Flash", "Use Gemini to make [image]", or any image generation request mentioning Gemini/Imagen.
---

# Gemini Image Generation

Generate images using Google's Gemini API with an interactive, AI-guided workflow.

## Executing the Script

When this skill loads, your agent platform provides the skill's base directory path. Run the script relative to that path:

```bash
python scripts/generate-image.py \
    --prompt "your prompt" \
    --output "output.png" \
    --aspect-ratio "16:9" \
    --size "1K" \
    --model "gemini-3-pro-image-preview"
```

**API Key:** The script reads `GEMINI_API_KEY` from (in order): `--env-file` flag, environment variable, `.env.local`, `.env`, `~/.env.local`, `~/.env`

## Available Models

| Model | ID | Quality | Speed | Aspect/Size Control |
|-------|-----|---------|-------|---------------------|
| **Gemini 3 Pro** | `gemini-3-pro-image-preview` | Professional | Slower | Yes |
| **Gemini 2.5 Flash** | `gemini-2.5-flash-image` | Good | Faster | No (uses defaults) |

---

## Workflow

### STEP 0: Smart Extraction

**Before asking questions**, extract from the user's request:

| Element | Patterns | Example |
|---------|----------|---------|
| Prompt | Descriptive text | "sunset over mountains" |
| Aspect Ratio | `16:9`, `1:1`, `square`, `portrait` | "16:9" |
| Output Path | `.png` paths, "save to" | "save to logo.png" |
| Resolution | `1K`, `2K`, `4K`, `HD` | "4K" |
| Model | `Pro`, `Flash` | "Flash" |

**Smart Defaults:**
- Aspect: `1:1` (logos/icons → `1:1`, banners → `16:9`, stories → `9:16`)
- Size: `1K` (high quality requests → `2K` or `4K`)
- Model: **ALWAYS ASK** (cost implications)
- Output: `{sanitized-prompt}.png` in project root

### STEP 1: Check API Key

```bash
grep -q "GEMINI_API_KEY" .env.local 2>/dev/null || grep -q "GEMINI_API_KEY" .env 2>/dev/null
```

**If missing:** Guide user to https://aistudio.google.com/ to get a free key, then create `.env.local`:
```
GEMINI_API_KEY=your-key-here
```

### STEP 2: Gather Missing Information

**2a. Prompt** (if missing): Ask "What image would you like to generate?"

**2b. Prompt Enhancement** (always offer):
> "Would you like me to enhance this prompt using Google's Imagen best practices?"

If yes, read `references/PROMPT_ENHANCEMENT.md` and apply techniques:
- Add hyper-specific details (colors, textures, materials)
- Include camera angle/perspective (wide-angle, macro, low-angle)
- Specify lighting and mood (golden hour, dramatic, cinematic)
- Add artistic style if appropriate

Show before/after, get approval.

**2c. Model Choice** (if missing): Always ask - users must control cost:
> "Pro (higher quality, more control) or Flash (faster, lower cost)?"

### STEP 3: Final Confirmation

```
✅ Ready to generate:

📝 Prompt: [prompt]
📐 Aspect ratio: [ratio]
📊 Resolution: [size]
🤖 Model: [model]
💾 Output: [path]

Generate now, or change anything?
```

Allow adjustments until user confirms.

### STEP 4: Execute

```bash
python scripts/generate-image.py \
    --prompt "$PROMPT" \
    --output "$OUTPUT_PATH" \
    --aspect-ratio "$ASPECT_RATIO" \
    --size "$SIZE" \
    --model "$MODEL"
```

### STEP 5: Handle Results

**Success:** Report file path and size.

**Errors:**
- `GEMINI_API_KEY not found` → Guide to STEP 1
- `HTTP 401` → Invalid key, verify at aistudio.google.com
- `HTTP 429` → Rate limit, wait and retry
- `HTTP 400` → Invalid parameters, help choose valid options

---

## Parameter Reference

### Aspect Ratios

| Ratio | Use Case |
|-------|----------|
| `1:1` | Logos, icons, profile pics |
| `16:9` | YouTube banners, presentations |
| `9:16` | Stories, Reels, TikTok |
| `3:2` / `2:3` | Photos, posters |
| `4:3` / `3:4` | Standard displays |
| `4:5` / `5:4` | Instagram |
| `21:9` | Ultrawide cinematic |

### Resolutions

| Size | Resolution | Use |
|------|------------|-----|
| `1K` | ~1024px | Web, thumbnails |
| `2K` | ~2048px | High-quality web, social |
| `4K` | ~4096px | Print, HD displays |

---

## Advanced Features

### Reference Images

```bash
python scripts/generate-image.py \
    --prompt "$PROMPT" \
    --output "$OUTPUT" \
    --reference "style1.png" \
    --reference "style2.png"
```

Max 14 references. Formats: PNG, JPEG, GIF, WebP.

### Google Search Grounding

For factually accurate images (landmarks, historical figures):

```bash
python scripts/generate-image.py \
    --prompt "$PROMPT" \
    --output "$OUTPUT" \
    --grounding true
```

---

## Best Practices

**DO:**
- Parse request before asking questions (STEP 0)
- Always ask about model choice (cost control)
- Offer prompt enhancement
- Show final confirmation before generating
- Use relative path: `scripts/generate-image.py`

**DON'T:**
- Skip model choice (users control cost)
- Change core subject during enhancement
- Skip final confirmation
- Use absolute paths

---

## References

- **Prompt Enhancement:** See `references/PROMPT_ENHANCEMENT.md` for detailed techniques
- **Example Flows:** See `references/examples.md` for conversation patterns
