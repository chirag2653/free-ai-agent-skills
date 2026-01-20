---
name: gemini-image-generation
description: Generate professional images using Google's Gemini 3 Pro or Gemini 2.5 Flash image models with AI-powered prompt enhancement. Universal Python script works on all platforms. Supports custom aspect ratios (1:1, 16:9, 9:16), resolutions (1K-4K), reference images, Google Search grounding, and intelligent prompt enhancement using Google's Imagen best practices. Activate when user says "Generate an image with Gemini", "Create using Gemini Pro/Flash", "Use Gemini to make [image]", or any image generation request mentioning Gemini/Imagen.
---

# Gemini Image Generation

> Generate professional images using Google's frontier Gemini image models with interactive AI-guided workflow and intelligent prompt enhancement
>
> **Quick Start:** Say "Generate an image with Gemini" to activate this skill
> 
> **✨ NEW:** AI-powered prompt enhancement using Google's Imagen best practices for superior image quality

## 🚨 WHEN TO USE THIS SKILL

**ONLY activate when user EXPLICITLY mentions Gemini in their image generation request:**

### Trigger Phrases (activate on ANY of these):
- "Generate an image with Gemini"
- "Create an image using Gemini"
- "Make an image with Gemini Pro"
- "Generate with Gemini Flash"
- "Use Gemini to create/make/generate [image description]"
- "Gemini image generation"
- "Generate via Gemini"
- "Create using Imagen" (Google's image model brand)

### Model-Specific Triggers:
- "Gemini 3 Pro" / "Gemini Pro" / "Pro model"
- "Gemini Flash" / "Gemini 2.5 Flash" / "Flash model"
- References to "Gemini image model"

**DO NOT activate for:**
- Generic image requests without "Gemini" mentioned
- Requests for other image generation tools (DALL-E, Midjourney, Stable Diffusion, etc.)

---

## 🤖 AI AGENT QUICK REFERENCE

**Execute the script from this skill's directory:**

```bash
python scripts/generate-image.py --prompt "your prompt" --output "output.png" --aspect-ratio "16:9" --size "1K" --model "gemini-3-pro-image-preview"
```

**Important for AI Agents:**
- Use your Shell tool to run `scripts/generate-image.py` from this skill's base directory
- Works in any shell (PowerShell, Bash, Zsh, etc.) - Python is cross-platform
- The script automatically reads `GEMINI_API_KEY` from multiple locations (checked in order):
  1. `--env-file` flag (explicit path)
  2. `$GEMINI_API_KEY` environment variable
  3. `.env.local` (current directory where command runs)
  4. `.env` (current directory)
  5. `~/.env.local` (home directory)
  6. `~/.env` (home directory)
- **If API key not found:** Guide user to create appropriate file (see STEP 1 workflow)

---

## 📋 Overview

This skill provides an **interactive, AI-guided workflow** for generating images using Google's Gemini API. Uses a universal Python script that works on all platforms.

**Key Benefits:**
- 🔑 **Project-Aware**: Automatically uses API key from your project's `.env.local` file
- 📁 **Context-Aware**: Saves images to your project's folders (public/images/, assets/, etc.)
- 🤖 **Universal**: Python script works everywhere - agents just use their Shell tool
- 🎯 **Interactive**: Agent asks questions and guides you through the workflow
- ✨ **Prompt Enhancement**: AI-powered prompt optimization using Google's Imagen best practices for superior results

### Available Models

| Model | Quality | Speed | Parameters |
|-------|---------|-------|------------|
| **Gemini 3 Pro** | Professional | Slower | Full control (aspect ratio, resolution) |
| **Gemini 2.5 Flash** | Good | Faster | Basic (prompt only) |

---

## 🎯 SMART WORKFLOW FOR AI AGENTS

When this skill is triggered, follow this **intelligent, non-intrusive workflow**:

### STEP 0: Smart Extraction (Parse User's Request First)

**CRITICAL:** Before asking ANY questions, analyze what the user already provided in their request.

**Extract these elements if present:**

| Element | Extraction Patterns | Examples |
|---------|-------------------|----------|
| **Prompt** | Any descriptive text about the image | "sunset over mountains" → PROMPT |
| **Aspect Ratio** | `16:9`, `1:1`, `9:16`, `square`, `portrait`, `landscape` | "16:9" → ASPECT_RATIO |
| **Output Path** | File paths ending in `.png`, `save to`, `output to` | "save to logo.png" → OUTPUT_PATH |
| **Resolution** | `1K`, `2K`, `4K`, `high quality`, `HD` | "4K" → SIZE |
| **Model** | `Pro`, `Flash`, `Gemini 3`, `Gemini 2.5` | "Flash" → MODEL |

**Smart Defaults (use if not specified):**

| Parameter | Default | When to Use Different Default |
|-----------|---------|------------------------------|
| **Aspect Ratio** | `1:1` | If prompt mentions "logo", "icon", "profile pic" → `1:1`<br>If prompt mentions "banner", "YouTube" → `16:9`<br>If prompt mentions "story", "Instagram story" → `9:16` |
| **Size** | `1K` | If user says "high quality", "HD", "print" → `2K` or `4K` |
| **Model** | **ALWAYS ASK** (cost implications) | Never default - must ask user preference |
| **Output Path** | Current directory (root) | `{sanitized-prompt}.png` in project root |

**Examples of Smart Extraction:**

<example>
User: "Create a sunset image, 16:9, save to public/sunset.png, use Gemini Pro"

Extracted:
- PROMPT: "sunset image" ✓
- ASPECT_RATIO: "16:9" ✓
- OUTPUT_PATH: "public/sunset.png" ✓
- SIZE: "1K" (default)
- MODEL: "gemini-3-pro-image-preview" ✓ (user specified Pro)

Action: Go to STEP 3 (final confirmation) with all params ready!
</example>

<example>
User: "Generate a modern logo for TechFlow"

Extracted:
- PROMPT: "modern logo for TechFlow" ✓
- ASPECT_RATIO: "1:1" (smart default for logos)
- OUTPUT_PATH: "techflow-logo.png" (root directory)
- SIZE: "2K" (higher quality for logos)
- MODEL: ❌ Not specified (MUST ASK - cost implications)

Action: Ask about model choice, then go to final confirmation
</example>

<example>
User: "Generate an image with Gemini"

Extracted:
- PROMPT: ❌ Missing
- ASPECT_RATIO: "1:1" (default)
- OUTPUT_PATH: Will generate after getting prompt
- SIZE: "1K" (default)
- MODEL: ❌ Not specified (MUST ASK)

Action: Ask for prompt, then ask for model choice
</example>

<example>
User: "Make a YouTube banner, Flash model, high quality"

Extracted:
- PROMPT: ❌ Missing (need description)
- ASPECT_RATIO: "16:9" (smart default for YouTube)
- OUTPUT_PATH: Will generate after getting prompt
- SIZE: "2K" (user said "high quality")
- MODEL: "gemini-2.5-flash-image" ✓ (user specified Flash)

Action: Only ask: "What should the YouTube banner show?", then final confirmation
</example>

<example>
User: "Create a profile pic, save to assets/profile.png"

Extracted:
- PROMPT: "profile pic" ✓
- ASPECT_RATIO: "1:1" (smart default for profile pics)
- OUTPUT_PATH: "assets/profile.png" ✓
- SIZE: "1K" (default)
- MODEL: ❌ Not specified (MUST ASK)

Action: Ask for model choice, then final confirmation
</example>

**After extraction, communicate efficiently:**

**If everything extracted:**
```
✅ Got it! I'll create:
- Image: [prompt]
- Aspect ratio: [ratio]
- Resolution: [size]
- Output: [path]

Generating now...
```

**If some items missing:**
```
✅ I'll create a [aspect-ratio] image at [size] resolution using [model].

Just need to know: [missing items]
```

**Never ask about:**
- ✅ Items already provided by user
- ✅ Items that have sensible defaults
- ✅ Advanced features unless user seems experienced

---

### STEP 1: Check API Key

Before anything else, verify the Gemini API key exists:

```bash
# Quick check across common locations
if grep -q "GEMINI_API_KEY" .env.local 2>/dev/null || \
   grep -q "GEMINI_API_KEY" .env 2>/dev/null || \
   [ -n "$GEMINI_API_KEY" ]; then
    echo "✅ API key configured"
else
    echo "❌ Missing API key"
fi
```

**If API key is MISSING, follow this interactive setup workflow:**

#### Step 1a: Check if User Has API Key

**Ask the user:**
> "Do you already have a Gemini API key? (yes/no)"

**If NO:**
```
🔑 **Get Your Free Gemini API Key**

1. Visit: https://aistudio.google.com/
2. Sign in with your Google account
3. Click "Get API Key" → "Create API Key"
4. Copy your API key

Once you have it, let me know and I'll help you set it up!
```

**STOP and wait for user to get their key.**

---

#### Step 1b: Determine Best File Location

**If YES (user has API key), intelligently recommend a file based on project type:**

**Detection Logic:**
```bash
# Detect project type
if [ -f "package.json" ]; then
    PROJECT_TYPE="node"
    RECOMMENDED_FILE=".env.local"
elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    PROJECT_TYPE="python"
    RECOMMENDED_FILE=".env"
elif [ -f "Gemfile" ]; then
    PROJECT_TYPE="ruby"
    RECOMMENDED_FILE=".env"
elif [ -f "go.mod" ]; then
    PROJECT_TYPE="go"
    RECOMMENDED_FILE=".env"
else
    PROJECT_TYPE="generic"
    RECOMMENDED_FILE=".env.local"
fi
```

**Context-Aware Recommendations:**

| Project Type | Recommended File | Reason |
|--------------|------------------|--------|
| Node.js/Next.js/React | `.env.local` | Framework convention, auto-gitignored by Next.js/Vite |
| Python/Django/Flask | `.env` | Standard Python convention with python-dotenv |
| Ruby/Rails | `.env` | Standard Ruby convention with dotenv gem |
| Go | `.env` | Common Go convention with godotenv |
| Generic/Unknown | `.env.local` | Safe default, less likely to be committed |

**Say to user (adapt based on detection):**

**For Node.js projects:**
> "I'll create a `.env.local` file in your project root. This is the standard for Node.js/Next.js projects and is automatically gitignored. Is that okay?"

**For Python projects:**
> "I'll create a `.env` file in your project root. This is the Python standard (used with python-dotenv). Make sure it's in your `.gitignore`. Is that okay?"

**For generic/unknown projects:**
> "I'll create a `.env.local` file in your project root. This keeps your key private and separate from production config. Is that okay?"

**Alternative suggestion:**
> "If you prefer, I can use a different file name. The script supports:
> - `.env.local` (recommended for web projects)
> - `.env` (common for Python/Ruby)
> - `~/.env.local` (global, for all your projects)
> - `~/.env` (global alternative)
> 
> Which would you prefer?"

---

#### Step 1c: Create the File

**After getting user approval, create the file:**

**Windows (PowerShell):**
```powershell
# Check if file exists
if (Test-Path ".env.local") {
    Write-Host "⚠️  .env.local already exists. I'll add the key to it."
    # Append or update
    Add-Content -Path ".env.local" -Value "`nGEMINI_API_KEY=paste_your_key_here"
} else {
    Write-Host "Creating .env.local file..."
    New-Item -Path ".env.local" -ItemType File -Force
    Set-Content -Path ".env.local" -Value "# Gemini API Key`nGEMINI_API_KEY=paste_your_key_here"
}
```

**Linux/macOS:**
```bash
# Check if file exists
if [ -f ".env.local" ]; then
    echo "⚠️  .env.local already exists. I'll add the key to it."
    echo "" >> .env.local
    echo "GEMINI_API_KEY=paste_your_key_here" >> .env.local
else
    echo "Creating .env.local file..."
    cat > .env.local << 'EOF'
# Gemini API Key
GEMINI_API_KEY=paste_your_key_here
EOF
fi
```

**After creating the file, say to user:**
```
✅ Created `.env.local` file!

**Next step:** Open `.env.local` and replace `paste_your_key_here` with your actual API key:

GEMINI_API_KEY=your-actual-api-key-here

💡 Security tip: Make sure `.env.local` is in your `.gitignore` so your key stays private!
```

---

#### Step 1d: Verify .gitignore

**IMPORTANT:** Help protect the user's API key by checking `.gitignore`:

```bash
# Check if .gitignore exists and includes the env file
if [ -f ".gitignore" ]; then
    if ! grep -q ".env.local" .gitignore 2>/dev/null; then
        echo ".env.local" >> .gitignore
        echo "✅ Added .env.local to .gitignore"
    fi
else
    echo "# Environment files" > .gitignore
    echo ".env.local" >> .gitignore
    echo ".env" >> .gitignore
    echo "✅ Created .gitignore with .env.local"
fi
```

**Say to user:**
> "✅ I've also ensured `.env.local` is in your `.gitignore` to keep your API key private."

---

#### Step 1e: Final Confirmation

**Ask user to confirm setup:**
> "Have you added your Gemini API key to `.env.local`? (yes/no)"

**If YES:** Proceed to STEP 2
**If NO:** "No problem! Let me know when you're ready, then we'll generate your image."

---

### Supported Environment Files (Complete List)

The script checks these locations **in order of priority**:

| Priority | Location | Use Case |
|----------|----------|----------|
| 1 | `--env-file <path>` | Custom file path (explicit flag) |
| 2 | `$GEMINI_API_KEY` | Environment variable (for CI/CD) |
| 3 | `.env.local` | Project-specific (current directory) |
| 4 | `.env` | Project-specific (current directory) |
| 5 | `~/.env.local` | Global user config (home directory) |
| 6 | `~/.env` | Global user config (home directory) |

**Key Format (MUST use this exact name):**
```bash
GEMINI_API_KEY=your-api-key-here
```

**Common mistakes to avoid:**
- ❌ `GEMINI_KEY=...` (wrong name)
- ❌ `API_KEY=...` (wrong name)
- ❌ `gemini_api_key=...` (wrong case)
- ❌ `GEMINI_API_KEY = ...` (spaces around =)
- ✅ `GEMINI_API_KEY=AIzaSy...` (correct!)

**Do NOT proceed without a valid API key.**

---

### STEP 2: Gather Missing Information (Only Ask What's Needed)

**IMPORTANT:** Only execute the sub-steps below for items NOT extracted in STEP 0.

#### 2a. Get Image Prompt (if missing)

**Only ask if prompt wasn't extracted in STEP 0.**

**Say to user:**
> "What image would you like to generate?"

**Guidelines:**
- ✅ Encourage detail: "Describe the style, colors, colors, mood, composition"
- ❌ Don't lecture about prompt quality unless they give a very vague prompt

#### 2b. Prompt Enhancement (Always Offer)

**CRITICAL:** After obtaining the prompt (whether from user input or extraction), ALWAYS offer to enhance it using Google's Imagen best practices.

**Reference file:** Read `references/PROMPT_ENHANCEMENT.md` (same directory as this SKILL.md) for detailed enhancement techniques.

**Say to user:**
> "Would you like me to enhance this prompt using Google's Imagen best practices for better results? (yes/no)"

**If user says YES:**

1. **Read the enhancement guide:**
   ```
   Read: skills/gemini-image-generation/references/PROMPT_ENHANCEMENT.md
   ```

2. **Apply enhancement techniques** from the guide:
   - Add hyper-specific details (colors, textures, materials, shapes)
   - Include camera angle/perspective terms (wide-angle, macro, low-angle)
   - Specify lighting type and mood (golden hour, dramatic, soft)
   - Add artistic style if appropriate (photorealistic, minimalist, etc.)
   - Provide context about purpose/use case
   - Use positive semantic prompts (avoid negatives)

3. **Preserve user intent** - Keep the core idea intact, only enhance, never replace

4. **Show before/after for transparency:**
   ```
   Original prompt: [user's original prompt]
   
   Enhanced prompt: [your enhanced version with added details]
   
   Added details: [list what you added: camera angle, lighting, mood, style, etc.]
   
   Use this enhanced version? (yes/no/let me edit)
   ```

5. **Handle user response:**
   - **"yes"** → Use enhanced prompt and proceed
   - **"no"** → Use original prompt and proceed
   - **"let me edit"** → Ask user to provide their edited version, then proceed

**If user says NO:**
- Use the original prompt as-is and proceed to next step

**Enhancement Examples:**

<example>
User prompt: "two cars dodging"

Enhanced: "Two sleek sports cars racing towards each other on a dramatic highway at sunset, performing a thrilling last-second dodge maneuver with tire smoke and motion blur, wide-angle shot from low perspective, cinematic action scene with warm golden hour lighting"

Added: details (sleek sports cars, highway), camera (wide-angle, low perspective), lighting (golden hour), effects (tire smoke, motion blur), mood (cinematic)
</example>

<example>
User prompt: "logo for tech company"

Enhanced: "Modern minimalist logo design for innovative tech startup, clean geometric shapes, professional and trustworthy aesthetic, navy blue and white color palette, simple and memorable, suitable for digital platforms"

Added: context (tech startup), style (minimalist), mood (professional), colors (navy blue, white), purpose (digital platforms)
</example>

<example>
User prompt: "mountain landscape"

Enhanced: "Majestic mountain range at golden hour sunset, warm orange and pink light illuminating snow-capped peaks, dramatic clouds in the sky, serene and peaceful atmosphere, wide-angle landscape shot, photorealistic style with rich colors"

Added: lighting (golden hour), details (snow-capped peaks, dramatic clouds), mood (serene), camera (wide-angle), style (photorealistic)
</example>

**Best Practices for Enhancement:**
- ✅ Match complexity to user's intent (simple logo → don't add complex photorealistic details)
- ✅ Keep enhancements coherent with overall vision
- ✅ For Gemini 3 Pro: Add MORE detail - handles complexity well
- ✅ For Gemini 2.5 Flash: Focus on key elements - prioritize clarity
- ✅ Always show what was added for transparency
- ❌ Never change the core subject (cat → lion is wrong)
- ❌ Don't add contradictory elements (harsh lighting + peaceful mood)

**Quick Enhancement Checklist:**
- [ ] Specific details about subject
- [ ] Camera angle/perspective
- [ ] Lighting type specified
- [ ] Mood/atmosphere described
- [ ] Style/medium noted (if applicable)
- [ ] Context/purpose clear
- [ ] User's original intent preserved

#### 2c. Determine Output Path (if missing)

**Only ask if path wasn't extracted in STEP 0.**

**Default behavior: Save to project root**
```bash
# Auto-generate filename from prompt (use enhanced prompt if available)
SANITIZED_PROMPT=$(echo "$PROMPT" | sed 's/[^a-zA-Z0-9]/-/g' | tr '[:upper:]' '[:lower:]' | cut -c1-30)
OUTPUT_PATH="${SANITIZED_PROMPT}.png"
```

**Simple and predictable - no complex directory detection.**

**Note:** User can change this in STEP 3 (final confirmation) if needed.

#### 2d. Ask for Model Choice (if missing)

**ALWAYS ask if model wasn't specified - cost implications!**

**Say to user:**
> "Which Gemini model would you like?
> 
> - **Pro** (Gemini 3 Pro): Professional quality, full control over aspect ratio/size
> - **Flash** (Gemini 2.5 Flash): Faster, lower cost, basic settings
> 
> Pro is more expensive but gives better quality. Which one?"

**Map user response:**
- "Pro", "pro", "3", "Gemini 3" → `gemini-3-pro-image-preview`
- "Flash", "flash", "2.5", "Gemini Flash" → `gemini-2.5-flash-image`

**Store the model choice** for final confirmation and execution.

---

### STEP 3: Final Confirmation (Always Required)

**CRITICAL:** Always show a final confirmation before generating. This gives users a chance to make last-minute adjustments.

**Show all parameters clearly:**

```
✅ Ready to generate your image:

📝 Prompt: [full prompt text]
📐 Aspect ratio: [ratio] ([description, e.g., "square", "widescreen"])
📊 Resolution: [size] ([description, e.g., "~1024px - web quality"])
🤖 Model: [model name] ([cost indicator, e.g., "Gemini 3 Pro - higher cost, better quality"])
💾 Output: [full path]

If you want to change anything (path, ratio, size, etc.), let me know. Otherwise, I'll generate it now!
```

**Wait for user response:**

| User Response | Action |
|--------------|--------|
| "Go ahead", "yes", "proceed", "ok", "generate" | Execute STEP 4 (find script) |
| "Change path to X" | Update OUTPUT_PATH, show confirmation again |
| "Use 16:9 instead" | Update ASPECT_RATIO, show confirmation again |
| "Make it 4K" | Update SIZE, show confirmation again |
| "Switch to Flash" | Update MODEL, show confirmation again |
| "No" or "cancel" | Stop workflow |

**Examples:**

<example>
User: "Save it to public/images instead"

Agent: Updates path, shows new confirmation:
```
✅ Updated:
💾 Output: public/images/[filename]

Ready to generate?
```
</example>

<example>
User: "Actually make it 16:9"

Agent: Updates ratio, shows new confirmation:
```
✅ Updated:
📐 Aspect ratio: 16:9 (widescreen)

Ready to generate?
```
</example>

**Important Notes:**
- ✅ **Always show this confirmation** - don't skip it
- ✅ **Make it easy to scan** - use emojis and clear formatting
- ✅ **Show cost indicator** with model choice
- ✅ **Allow multiple adjustments** - user can change things until satisfied
- ✅ **Be patient** - don't rush the user

---

### STEP 4: Execute the Python Script

Run the Python script using your Shell tool from this skill's base directory:

```bash
python scripts/generate-image.py \
    --prompt "$PROMPT" \
    --output "$OUTPUT_PATH" \
    --aspect-ratio "$ASPECT_RATIO" \
    --size "$SIZE" \
    --model "$MODEL"
```

**Note:** The script works on all platforms (Windows, macOS, Linux). Use your Shell tool to execute it.

---

### STEP 5: Handle Results

**On Success:**

```
✅ **Image Generated Successfully!**

📁 Saved to: $OUTPUT_PATH
📊 File size: [check file size]
🎨 Model used: [Gemini 3 Pro / Flash]
⚙️ Settings: $ASPECT_RATIO, $SIZE

You can now use this image in your project!
```

**On Error:**

Parse the error message and provide specific guidance:

| Error Pattern | User-Friendly Message |
|---------------|----------------------|
| `GEMINI_API_KEY not found` | "Your API key isn't configured. Please follow the setup guide above." |
| `HTTP 401` | "Your API key is invalid. Please verify it at https://aistudio.google.com/" |
| `HTTP 429` | "Rate limit reached. Please wait a moment and try again." |
| `HTTP 400` | "Invalid parameters. Let me help you choose valid options..." |
| `No image in response` | "Generation failed. Try a different or simpler prompt." |
| `Permission denied` | "Cannot write to that location. Try a different output path." |

---

## 📐 PARAMETER REFERENCE

### Aspect Ratios (Full List)

| Ratio | Use Case |
|-------|----------|
| `1:1` | Square - logos, icons, profile pics |
| `3:2` | Landscape - horizontal logos, photos |
| `2:3` | Portrait - posters, vertical graphics |
| `16:9` | Widescreen - YouTube banners, presentations |
| `9:16` | Vertical - Stories, Reels, TikTok |
| `4:3` | Standard - classic displays |
| `3:4` | Portrait - Instagram vertical |
| `4:5` | Portrait - Instagram posts |
| `5:4` | Slight landscape - photos |
| `21:9` | Ultrawide - cinematic banners |

### Resolution Options

| Size | Resolution | Best For |
|------|------------|----------|
| `1K` | ~1024px | Web, thumbnails, quick previews |
| `2K` | ~2048px | High-quality web, social media |
| `4K` | ~4096px | Print, HD displays, professional use |

### Model Comparison

| Feature | Gemini 3 Pro | Gemini 2.5 Flash |
|---------|--------------|------------------|
| Quality | Professional | Good |
| Speed | Slower (~10-30s) | Faster (~5-15s) |
| Aspect Ratio Control | ✅ Yes | ❌ No (uses default) |
| Resolution Control | ✅ Yes | ❌ No (uses default) |
| Reference Images | ✅ Yes | ✅ Yes |
| Google Search Grounding | ✅ Yes | ✅ Yes |

---

## 🔧 ADVANCED FEATURES

### Prompt Enhancement (Recommended for All Users)

**What is it?**
AI-powered prompt optimization that transforms basic prompts into detailed, professional descriptions using Google's Imagen best practices.

**Why use it?**
- 🎨 **Better Quality**: More detailed prompts = more accurate, beautiful images
- 📚 **Professional Techniques**: Leverages techniques from Google's image generation experts
- ⚡ **Effortless**: Agent does the work - you just approve
- 🎯 **Preserves Intent**: Enhances without changing your core idea

**When is it offered?**
ALWAYS - after you provide your prompt, the agent will ask:
> "Would you like me to enhance this prompt using Google's Imagen best practices for better results?"

**What gets enhanced?**
1. **Hyper-specific details** - Colors, textures, materials, shapes
2. **Camera control** - Perspective, angle, focal length
3. **Lighting & mood** - Golden hour, dramatic, soft, cinematic
4. **Artistic style** - Photorealistic, minimalist, watercolor, etc.
5. **Context** - Purpose and use case
6. **Semantic clarity** - Positive descriptions instead of negatives

**Example Enhancement:**

**Original:** "sunset over mountains"

**Enhanced:** "Majestic mountain range at golden hour sunset, warm orange and pink light illuminating snow-capped peaks, dramatic clouds in the sky, serene and peaceful atmosphere, wide-angle landscape shot, photorealistic style with rich colors"

**For full details:** See `references/PROMPT_ENHANCEMENT.md` in the same directory as this skill.

---

### Using Reference Images

If user has existing images to use as style references:

**Ask:** "Do you have any reference images for style guidance?"

If yes:
```bash
python scripts/generate-image.py \
    --prompt "$PROMPT" \
    --output "$OUTPUT_PATH" \
    --aspect-ratio "$ASPECT_RATIO" \
    --size "$SIZE" \
    --reference "path/to/reference1.png" \
    --reference "path/to/reference2.png"
```

Maximum 14 reference images. Supported formats: PNG, JPEG, GIF, WebP.

### Google Search Grounding

For factually accurate images (landmarks, historical figures, etc.):

**Ask:** "Should this image use Google Search for factual accuracy? (Recommended for real-world subjects like landmarks, people, etc.)"

If yes:
```bash
python scripts/generate-image.py \
    --prompt "$PROMPT" \
    --output "$OUTPUT_PATH" \
    --grounding true
```

---

## 🖥️ PLATFORM-SPECIFIC NOTES

### All Platforms (Linux, macOS, Windows)
- Uses **Python script** (`generate-image.py`) - works everywhere
- Only dependency: `python3` (standard library only)
- No shell-specific setup needed
- AI agents: Just use your Shell tool to run `python generate-image.py` with parameters

**For AI Agents:** Use the Shell tool to run the Python script - works identically on all platforms.

---

## 💡 EXAMPLE CONVERSATION FLOWS (Updated Smart Workflow)

### Example 1: Power User (Everything Provided)

**User:** "Create a sunset over mountains, 16:9, save to public/sunset.png, use Gemini Pro"

**Agent:**
```
✅ Ready to generate your image:

📝 Prompt: sunset over mountains
📐 Aspect ratio: 16:9 (widescreen)
📊 Resolution: 1K (~1024px - web quality)
🤖 Model: Gemini 3 Pro (higher cost, better quality)
💾 Output: public/sunset.png

If you want to change anything, let me know. Otherwise, I'll generate it now!
```

**User:** "Go ahead"

**Agent:**
```
Generating...

✅ Image saved to public/sunset.png (1.2 MB)
```

**Total questions: 1** (final confirmation only)

---

### Example 2: Typical User (Logo Request)

**User:** "Generate a logo for TechFlow with Gemini"

**Agent:**
```
Which Gemini model would you like?

- Pro (Gemini 3 Pro): Professional quality, full control
- Flash (Gemini 2.5 Flash): Faster, lower cost

Pro is more expensive but gives better quality. Which one?
```

**User:** "Flash"

**Agent:**
```
✅ Ready to generate your image:

📝 Prompt: logo for TechFlow
📐 Aspect ratio: 1:1 (square - perfect for logos)
📊 Resolution: 2K (~2048px - high quality)
🤖 Model: Gemini 2.5 Flash (faster, lower cost)
💾 Output: logo-for-techflow.png

If you want to change anything, let me know. Otherwise, I'll generate it now!
```

**User:** "Save it to assets/logo.png instead"

**Agent:**
```
✅ Updated:
💾 Output: assets/logo.png

Ready to generate?
```

**User:** "Yes"

**Agent:**
```
Generating...

✅ Image saved to assets/logo.png (856 KB)
```

**Total questions: 2** (model choice + confirmation with 1 adjustment)

---

### Example 3: Minimal Input with Prompt Enhancement

**User:** "Create an image with Gemini"

**Agent:**
```
What image would you like to generate?
```

**User:** "A futuristic cityscape"

**Agent:**
```
Would you like me to enhance this prompt using Google's Imagen best practices for better results? (yes/no)
```

**User:** "Yes"

**Agent:**
```
Original prompt: A futuristic cityscape

Enhanced prompt: Futuristic cyberpunk cityscape at night with towering neon-lit skyscrapers, 
holographic advertisements floating between buildings, flying vehicles with light trails, 
wet pavement reflecting colorful lights, dramatic wide-angle perspective from street level, 
cinematic atmosphere with blue and pink neon glow

Added details: time (night), style (cyberpunk), specific elements (neon skyscrapers, holograms, 
flying vehicles, wet pavement reflections), camera (wide-angle from street level), 
lighting (blue/pink neon), mood (cinematic, dramatic)

Use this enhanced version? (yes/no/let me edit)
```

**User:** "Yes"

**Agent:**
```
Which Gemini model would you like?

- Pro (Gemini 3 Pro): Professional quality, full control
- Flash (Gemini 2.5 Flash): Faster, lower cost

Pro is more expensive but gives better quality. Which one?
```

**User:** "Pro"

**Agent:**
```
✅ Ready to generate your image:

📝 Prompt: Futuristic cyberpunk cityscape at night with towering neon-lit skyscrapers, 
holographic advertisements floating between buildings, flying vehicles with light trails, 
wet pavement reflecting colorful lights, dramatic wide-angle perspective from street level, 
cinematic atmosphere with blue and pink neon glow
📐 Aspect ratio: 1:1 (square)
📊 Resolution: 1K (~1024px - web quality)
🤖 Model: Gemini 3 Pro (higher cost, better quality)
💾 Output: futuristic-cyberpunk-cityscap.png

If you want to change anything, let me know. Otherwise, I'll generate it now!
```

**User:** "Go ahead"

**Agent:**
```
Generating...

✅ Image saved to futuristic-cyberpunk-cityscap.png (1.6 MB)
```

**Total questions: 4** (prompt + enhancement offer + model + confirmation)

---

### Example 4: YouTube Banner with Customization

**User:** "Make a YouTube banner with Gemini Flash"

**Agent:**
```
What should the YouTube banner show?
```

**User:** "AI tutorials channel, dark theme"

**Agent:**
```
✅ Ready to generate your image:

📝 Prompt: AI tutorials channel, dark theme
📐 Aspect ratio: 16:9 (widescreen - YouTube standard)
📊 Resolution: 2K (~2048px - high quality for banners)
🤖 Model: Gemini 2.5 Flash (faster, lower cost)
💾 Output: ai-tutorials-channel-dark-the.png

If you want to change anything, let me know. Otherwise, I'll generate it now!
```

**User:** "Make it 4K"

**Agent:**
```
✅ Updated:
📊 Resolution: 4K (~4096px - print/HD quality)

Ready to generate?
```

**User:** "Yes"

**Agent:**
```
Generating...

✅ Image saved to ai-tutorials-channel-dark-the.png (3.2 MB)
```

**Total questions: 2** (prompt + confirmation with 1 adjustment)

---

### Example 5: Multiple Last-Minute Changes

**User:** "Create a profile picture for my gaming channel, use Gemini Pro"

**Agent:**
```
✅ Ready to generate your image:

📝 Prompt: profile picture for my gaming channel
📐 Aspect ratio: 1:1 (square - perfect for profile pics)
📊 Resolution: 1K (~1024px - web quality)
🤖 Model: Gemini 3 Pro (higher cost, better quality)
💾 Output: profile-picture-for-my-gamin.png

If you want to change anything, let me know. Otherwise, I'll generate it now!
```

**User:** "Make it 2K and save to images/profile.png"

**Agent:**
```
✅ Updated:
📊 Resolution: 2K (~2048px - high quality)
💾 Output: images/profile.png

Ready to generate?
```

**User:** "Also make it 9:16 for Instagram stories"

**Agent:**
```
✅ Updated:
📐 Aspect ratio: 9:16 (portrait - Instagram Stories)

Ready to generate?
```

**User:** "Perfect, go"

**Agent:**
```
Generating...

✅ Image saved to images/profile.png (1.8 MB)
```

**Total questions: 1** (confirmation with 2 adjustments)

---

### Example 6: Prompt Enhancement in Action

**User:** "Generate two cars dodging each other with Gemini Flash"

**Agent:**
```
Would you like me to enhance this prompt using Google's Imagen best practices for better results? (yes/no)
```

**User:** "Yes"

**Agent:**
```
Original prompt: two cars dodging each other

Enhanced prompt: Two sleek sports cars racing towards each other on a dramatic highway at 
sunset, performing a thrilling last-second dodge maneuver with tire smoke and motion blur, 
wide-angle shot from low perspective, cinematic action scene with warm golden hour lighting

Added details: specifics (sleek sports cars, highway), time/setting (sunset), 
action details (tire smoke, motion blur), camera (wide-angle, low perspective), 
lighting (golden hour), mood (cinematic, thrilling)

Use this enhanced version? (yes/no/let me edit)
```

**User:** "Yes"

**Agent:**
```
✅ Ready to generate your image:

📝 Prompt: Two sleek sports cars racing towards each other on a dramatic highway at sunset, 
performing a thrilling last-second dodge maneuver with tire smoke and motion blur, wide-angle 
shot from low perspective, cinematic action scene with warm golden hour lighting
📐 Aspect ratio: 16:9 (widescreen - perfect for action scenes)
📊 Resolution: 1K (~1024px - web quality)
🤖 Model: Gemini 2.5 Flash (faster, lower cost)
💾 Output: two-sleek-sports-cars-racing.png

If you want to change anything, let me know. Otherwise, I'll generate it now!
```

**User:** "Go ahead"

**Agent:**
```
Generating...

✅ Image saved to two-sleek-sports-cars-racing.png (1.5 MB)
```

**Total questions: 2** (enhancement offer + confirmation)
**Result:** Much more detailed, cinematic image compared to basic prompt

---

## 🔍 TROUBLESHOOTING FOR AI AGENTS

| Symptom | Solution |
|---------|----------|
| "python not found" | Python 3 not installed - install from python.org |
| "No such file or directory" | Verify `scripts/generate-image.py` exists in this skill's directory |
| Script path not found | Ensure you're running from the skill's base directory |
| Module import errors | Script uses standard library only - verify Python 3 is installed |

---

## ⚠️ ERROR HANDLING MATRIX

| Error | Detection | AI Agent Response |
|-------|-----------|-------------------|
| Missing API key | Grep returns empty | Show setup guide, STOP |
| Invalid API key | HTTP 401 | "API key invalid - verify at aistudio.google.com" |
| Rate limit | HTTP 429 | "Too many requests - wait 60s and retry?" |
| Bad parameters | HTTP 400 | "Invalid options - let me help you choose..." |
| No output dir | Directory check fails | "I'll create the directory for you" |
| Permission error | Write fails | "Cannot write there - try different path?" |
| Script not found | File check fails | "Skill not properly installed" |
| Bash not found (Windows) | Command check fails | "Install Git for Windows or WSL" |

---

## 🔐 SECURITY & PRIVACY

- ✅ API key loaded from environment at runtime (never hardcoded)
- ✅ Checks 6 locations: explicit flag, env var, .env.local, .env, ~/.env.local, ~/.env
- ✅ `.env.local` gitignored by default in all modern frameworks
- ✅ Temp files auto-cleaned after execution
- ✅ No data sent to third parties (only Google Gemini API)
- ✅ All images include invisible SynthID watermark (Google's standard)

---

## 🎓 BEST PRACTICES FOR AI AGENTS

### DO:
- ✅ **STEP 0 FIRST:** Parse user's request for all parameters before asking anything
- ✅ **Extract everything possible:** prompt, aspect ratio, size, output path, model
- ✅ **Use smart defaults for most things:** aspect ratio, size (logos → 1:1, banners → 16:9)
- ✅ **ALWAYS ask about model if not provided** - cost implications, users must choose
- ✅ **ALWAYS offer prompt enhancement (STEP 2b)** - dramatically improves output quality
- ✅ **Read references/PROMPT_ENHANCEMENT.md** when user accepts enhancement - contains all techniques
- ✅ **Show before/after prompts** when enhancing - transparency builds trust
- ✅ **Preserve user intent** during enhancement - never change core subject
- ✅ **Apply appropriate detail level** - Pro model gets more detail, Flash gets focused detail
- ✅ **ALWAYS show final confirmation (STEP 3)** - give users chance to adjust
- ✅ **Default output to project root** - simple filenames like `sunset.png`
- ✅ **Allow multiple adjustments** during confirmation - be patient
- ✅ **Show cost indicators** with model (Pro = higher cost, Flash = lower cost)
- ✅ **Only ask what's truly missing** - skip questions for items already provided
- ✅ **Auto-generate filenames** from prompt (sanitized, 30 chars max, use enhanced if available)
- ✅ **Acknowledge what was extracted** in final confirmation summary
- ✅ Always check API key FIRST before asking questions
- ✅ **Offer to create env file if missing** - don't just show error and stop
- ✅ **Detect project type** and recommend appropriate file (`.env.local` for Node, `.env` for Python)
- ✅ **Verify/update .gitignore** to protect user's API key
- ✅ Validate paths before execution
- ✅ Create directories if needed
- ✅ Provide clear, actionable error messages
- ✅ Confirm success with file size and location

### DON'T:
- ❌ **Skip model choice question** - users must control cost (exception: if explicitly specified)
- ❌ **Skip prompt enhancement offer** - most users benefit from it, always ask
- ❌ **Change the subject during enhancement** - cat → lion is WRONG
- ❌ **Add contradictory elements** - harsh lighting + peaceful mood don't mix
- ❌ **Over-complicate simple requests** - match complexity to user intent
- ❌ **Forget to read references/PROMPT_ENHANCEMENT.md** - it has all the techniques and examples
- ❌ **Skip before/after comparison** - users need to see what changed
- ❌ **Skip final confirmation (STEP 3)** - users need chance to make last-minute edits
- ❌ **Default to Pro model** - always let users choose based on budget
- ❌ **Guess at complex directory structures** - use simple root paths by default
- ❌ **Start with questions** - always parse the request first
- ❌ **Ask about things already provided** - user will get frustrated
- ❌ **Ask about things with good defaults** (except model) - use smart defaults
- ❌ **Rush through confirmation** - allow multiple adjustments patiently
- ❌ Proceed without API key
- ❌ Stop abruptly when key is missing - offer to help create the file
- ❌ Recommend wrong env file for project type
- ❌ Forget to add env file to .gitignore (security risk!)
- ❌ Use this skill for non-Gemini image requests
- ❌ Hardcode paths or parameters
- ❌ Show raw error messages without translation
- ❌ Use absolute paths - always use relative `scripts/generate-image.py`

---

## 📊 SKILL METADATA

- **Input**: User's image request mentioning "Gemini"
- **Output**: PNG image file at specified location
- **Average execution time**: 10-30s (Pro), 5-15s (Flash)
- **Dependencies**: python3 (standard library only - no extra packages needed)
- **API limits**: Based on Google AI Studio free tier
- **Supported platforms**: All platforms with Python 3 (Linux, macOS, Windows)
- **Enhancement Guide**: `references/PROMPT_ENHANCEMENT.md` - comprehensive prompt optimization techniques
- **Key Features**: Smart extraction, prompt enhancement, cost control, interactive workflow

---

## 🔄 VERSION HISTORY

### 2.1.0 (2026-01-20) - "AI-Powered Prompt Enhancement"
- **✨ NEW FEATURE:** Intelligent prompt enhancement using Google's Imagen best practices
- **Added:** New STEP 2b - Always offer prompt enhancement after getting user's prompt
- **Added:** `references/PROMPT_ENHANCEMENT.md` - Comprehensive guide with 7 core principles and enhancement techniques
- **Added:** Enhancement examples showing before/after transformations
- **Added:** Quick enhancement checklist for AI agents
- **Improved:** Example conversation flows now include prompt enhancement workflow
- **Improved:** Best practices updated with enhancement DO/DON'T guidelines
- **Improved:** Skill description highlights prompt enhancement capability
- **Result:** Users get dramatically better image quality with minimal effort

### 2.0.0 (2026-01-20) - "Universal Python Script"
- **🎯 MAJOR SIMPLIFICATION:** Replaced shell-specific scripts with universal Python script
- **Removed:** Bash script dependency - now works on all platforms without Git Bash/WSL
- **Changed:** Single `generate-image.py` replaces `generate-image.sh`
- **Improved:** Zero shell dependencies - only needs Python 3 (standard library)
- **Simplified:** Same command works in PowerShell, Bash, Zsh, or any shell
- **Updated:** Documentation simplified - removed complex shell-agnostic execution logic

### 1.3.0 (2026-01-20) - "Smart & Efficient Workflow with Cost Control"
- **🚀 MAJOR BEHAVIORAL CHANGE:** Complete workflow overhaul from "typeform-like" to "smart extraction + confirmation"
- **Added:** STEP 0 - Smart Extraction phase that parses user request BEFORE asking questions
- **Added:** Intelligent parameter extraction (prompt, aspect ratio, size, output path, model)
- **Added:** Context-aware smart defaults (logos → 1:1, banners → 16:9, YouTube → 16:9)
- **Added:** STEP 3 - Final Confirmation (always shown) with all parameters for last-minute adjustments
- **Changed:** Model choice ALWAYS asked if not specified (cost control requirement)
- **Changed:** Output path defaults to project root (simple: `filename.png`) instead of complex auto-detection
- **Changed:** Final confirmation allows multiple adjustments before generation
- **Improved:** STEP 2 now ONLY asks for missing information (conditional execution)
- **Improved:** Examples show realistic flows with model choice + final confirmation
- **Improved:** Best Practices emphasizes cost control and user confirmation
- **Improved:** Cost indicators shown with model choice (Pro = higher cost, Flash = lower cost)
- **Removed:** Unnecessary questions when smart defaults exist (except model)
- **Removed:** Complex directory auto-detection (now uses simple root paths)
- **Result:** Balanced workflow - efficient parsing + cost control + final confirmation = 1-2 questions for most use cases

### 1.2.0 (2026-01-20) - "Smart API Key Setup"
- **MAJOR IMPROVEMENT:** Complete overhaul of STEP 1 (API key setup workflow)
- **Added:** Interactive file creation workflow when API key is missing
- **Added:** Project-type detection (Node.js, Python, Ruby, Go) for smart file recommendations
- **Added:** Context-aware env file suggestions (`.env.local` vs `.env` based on project)
- **Added:** Automatic .gitignore verification and updates for security
- **Added:** Complete list of all 6 supported API key locations with priority order
- **Added:** Common mistake guide for API key format
- **Added:** Step-by-step user guidance instead of abrupt error messages
- **Improved:** AI Agent Quick Reference now lists all 6 supported locations
- **Improved:** Best Practices section with new DO/DON'T items for file creation
- **Fixed:** Agents now help CREATE missing env files instead of just showing error

### 1.1.0 (2026-01-19)
- **Added:** AI Agent Quick Reference section with ready-to-use Shell tool commands
- **Added:** Troubleshooting table for common execution errors
- **Improved:** STEP 6 execution with explicit PowerShell/bash commands
- **Improved:** Windows support with full Git Bash path to avoid WSL errors
- **Updated:** Description to include "Imagen" trigger term
- **Updated:** Flash model to current version: `gemini-2.5-flash-image` (replaces deprecated 2.0 model)
- **Fixed:** Cross-platform execution issues on Windows PowerShell environment

### 1.0.0 (2026-01-19)
- Initial release
- Interactive workflow integrated from command
- Cross-platform support (Linux, macOS, Windows)
- Two model options (Gemini 3 Pro, Flash)
- Full parameter control
- Reference images support
- Google Search grounding

---

**For questions or issues, check the skill's `examples/` folder or repository documentation.**
