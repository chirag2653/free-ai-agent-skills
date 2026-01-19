---
name: gemini-image-generation
version: 1.1.0
description: Generate professional images using Google's Gemini 3 Pro or Gemini 2.5 Flash image models. Supports custom aspect ratios (1:1, 16:9, 9:16), resolutions (1K-4K), reference images, and Google Search grounding. Use when user mentions "Gemini", "Gemini image", "generate with Gemini", "Imagen", or explicitly requests Gemini-based image generation.
author: Chirag Jain
tags:
  - image-generation
  - gemini
  - google-ai
  - media
  - graphics
  - imagen
platforms:
  - cursor
  - claude-code
  - codex
  - gemini-cli
  - any-agent-supporting-skill-md
allowed-tools:
  - Read
  - Shell
  - Grep
dependencies:
  - bash
  - curl
  - python3
  - base64
lastUpdated: 2026-01-19
---

# Gemini Image Generation

> Generate professional images using Google's frontier Gemini image models with interactive AI-guided workflow

## 🚨 WHEN TO USE THIS SKILL

**ONLY activate when user EXPLICITLY mentions:**
- "Gemini" / "Gemini 3 Pro" / "Gemini Flash" / "Gemini Image Model"
- "using Gemini" / "via Gemini" / "with Gemini model"
- "Imagen" (Google's image model brand)
- Requests image generation specifically with Gemini

**DO NOT activate for generic image requests** without Gemini mentioned.

---

## 🤖 AI AGENT QUICK REFERENCE

**Windows (PowerShell environment):**

```powershell
# Check API key
Select-String -Path ".env.local" -Pattern "GEMINI_API_KEY" -Quiet

# Execute generation (use full Git Bash path to avoid WSL issues)
& "C:\Program Files\Git\bin\bash.exe" "$env:USERPROFILE\.cursor\skills\gemini-image-generation\scripts\generate-image.sh" --prompt "your prompt here" --output "output.png" --aspect-ratio "16:9" --size "1K" --model "gemini-3-pro-image-preview"
```

**Linux/macOS (bash environment):**

```bash
# Check API key
grep -q "GEMINI_API_KEY" .env.local 2>/dev/null

# Execute generation
bash "$HOME/.cursor/skills/gemini-image-generation/scripts/generate-image.sh" --prompt "your prompt here" --output "output.png" --aspect-ratio "16:9" --size "1K" --model "gemini-3-pro-image-preview"
```

**Important for AI Agents (all types - coding, marketing, design, etc.):**
- Use the Shell tool with the appropriate command above based on the operating system
- The skill automatically reads `GEMINI_API_KEY` from the project's `.env.local` or `.env` file
- On Windows, always use the full Git Bash path to avoid WSL execution errors
- Skill directory varies by agent: `~/.cursor/skills/`, `~/.claude/skills/`, `~/.codex/skills/`, etc.

---

## 📋 Overview

This skill provides an **interactive, AI-guided workflow** for generating images using Google's Gemini API. Works with any AI agent (coding, marketing, design, writing - any domain) in any project folder.

**Key Benefits:**
- 🔑 **Project-Aware**: Automatically uses API key from your project's `.env.local` file
- 📁 **Context-Aware**: Saves images to your project's folders (public/images/, assets/, etc.)
- 🤖 **Universal**: Works with any AI agent supporting the SKILL.md standard (Cursor, Claude, Codex, Gemini CLI, etc.)
- 🎯 **Interactive**: Agent asks questions and guides you through the workflow

### Available Models

| Model | Quality | Speed | Parameters |
|-------|---------|-------|------------|
| **Gemini 3 Pro** | Professional | Slower | Full control (aspect ratio, resolution) |
| **Gemini 2.5 Flash** | Good | Faster | Basic (prompt only) |

---

## 🎯 INTERACTIVE WORKFLOW FOR AI AGENTS

When this skill is triggered, follow this **step-by-step interactive workflow**:

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

**If API key is MISSING, show this setup guide and STOP:**

```
🔑 **Gemini API Key Required**

To generate images with Gemini, you need a free API key from Google.

**Quick Setup (takes 2 minutes):**
1. Visit: https://aistudio.google.com/
2. Sign in with your Google account
3. Click "Get API Key" → "Create API Key"
4. Copy your API key
5. Add it to `.env.local` in your project folder:

   GEMINI_API_KEY=your-api-key-here

6. Try again!

💡 The `.env.local` file is gitignored automatically - your key stays private.
```

**Do NOT proceed without a valid API key.**

---

### STEP 2: Gather the Image Prompt

Ask the user for a detailed image description:

**Say to user:**
> "What image would you like to generate? (Be as detailed as possible - describe style, colors, composition, etc.)"

**Guidelines for prompts:**
- ✅ Detailed prompts work best: "Modern minimalist logo for 'TechFlow' with blue gradient, circuit board elements, transparent background"
- ✅ Include style, colors, mood, composition
- ❌ Avoid vague prompts: "a logo"

**Store the prompt** for use in the script command.

---

### STEP 3: Determine Output Path

Ask where to save the image:

**Say to user:**
> "Where should I save the image? (Provide a path like `public/images/logo.png` or just `logo.png` for current directory)"

**Smart defaults:**
- If user is working on a web project: suggest `public/images/` or `assets/images/`
- If unclear: suggest current directory with descriptive filename
- **Always include `.png` extension**

**Validate the path:**
```bash
# Check if parent directory exists
OUTPUT_DIR=$(dirname "$OUTPUT_PATH")
if [ ! -d "$OUTPUT_DIR" ] && [ "$OUTPUT_DIR" != "." ]; then
    # Inform user: "I'll create the directory $OUTPUT_DIR for you."
fi
```

**Store the output path** for the script command.

---

### STEP 4: Interactive Parameter Selection

Ask the user for parameters conversationally:

#### 4a. Ask for Aspect Ratio

**Say to user:**
> "What aspect ratio would you like?
> - `1:1` - Square (logos, icons, profile pics)
> - `16:9` - Widescreen (YouTube banners, presentations)
> - `9:16` - Vertical (Instagram Stories, TikTok)
> - `3:2` - Landscape (photos, horizontal banners)
> - `4:5` - Portrait (Instagram posts)
>
> (Or press Enter for default: 1:1)"

**Defaults:** Use `1:1` if user doesn't specify or says "default"

**Valid options:** `1:1`, `2:3`, `3:2`, `3:4`, `4:3`, `4:5`, `5:4`, `9:16`, `16:9`, `21:9`

#### 4b. Ask for Resolution

**Say to user:**
> "What resolution?
> - `1K` (~1024px) - Web, quick previews
> - `2K` (~2048px) - High-quality web, social media
> - `4K` (~4096px) - Print, HD displays
>
> (Or press Enter for default: 1K)"

**Defaults:** Use `1K` if user doesn't specify

**Valid options:** `1K`, `2K`, `4K`

#### 4c. Ask for Model

**Say to user:**
> "Which Gemini model?
> - `Pro` - Gemini 3 Pro: Professional quality, full control (recommended)
> - `Flash` - Gemini 2.5 Flash: Faster iterations, prototyping
>
> (Or press Enter for default: Pro)"

**Map user response to model ID:**
- If user says "Pro", "pro", "3 Pro", or presses Enter: use `gemini-3-pro-image-preview`
- If user says "Flash", "flash", "2.5 Flash": use `gemini-2.5-flash-image`

**Note for Flash model:** If user selects Flash, inform them:
> "Note: Flash model doesn't support custom aspect ratios or sizes - it uses defaults. For full control, I recommend Gemini 3 Pro instead. Continue with Flash?"

---

### STEP 5: Find the Generation Script

Locate the skill's installation directory and script:

```bash
# Method 1: Check common installation paths
SKILL_PATHS=(
    "$HOME/.claude/skills/gemini-image-generation"
    "$HOME/.cursor/skills/gemini-image-generation"
    "./skills/gemini-image-generation"
    "$(pwd)/skills/gemini-image-generation"
)

SCRIPT_PATH=""
for path in "${SKILL_PATHS[@]}"; do
    if [ -f "$path/scripts/generate-image.sh" ]; then
        SCRIPT_PATH="$path/scripts/generate-image.sh"
        break
    fi
done

if [ -z "$SCRIPT_PATH" ]; then
    echo "❌ Error: Could not find generate-image.sh script"
    exit 1
fi
```

**Alternative method using find:**
```bash
SKILL_DIR=$(find ~/.claude/skills ~/.cursor/skills . -name "gemini-image-generation" -type d 2>/dev/null | head -1)
SCRIPT_PATH="$SKILL_DIR/scripts/generate-image.sh"
```

---

### STEP 6: Execute the Script

**Determine script path based on OS:**
- Windows: `$env:USERPROFILE\.cursor\skills\gemini-image-generation\scripts\generate-image.sh`
- Linux/macOS: `~/.cursor/skills/gemini-image-generation/scripts/generate-image.sh`

**Run the appropriate command using the Shell tool:**

**Windows (PowerShell):**

```powershell
& "C:\Program Files\Git\bin\bash.exe" "$env:USERPROFILE\.cursor\skills\gemini-image-generation\scripts\generate-image.sh" `
    --prompt "$PROMPT" `
    --output "$OUTPUT_PATH" `
    --aspect-ratio "$ASPECT_RATIO" `
    --size "$SIZE" `
    --model "$MODEL"
```

**Linux/macOS:**

```bash
bash "$HOME/.cursor/skills/gemini-image-generation/scripts/generate-image.sh" \
    --prompt "$PROMPT" \
    --output "$OUTPUT_PATH" \
    --aspect-ratio "$ASPECT_RATIO" \
    --size "$SIZE" \
    --model "$MODEL"
```

**Important Notes:**
- The Shell tool automatically uses PowerShell on Windows and bash on Unix systems
- On Windows, use the **full Git Bash path** (`C:\Program Files\Git\bin\bash.exe`) to avoid WSL execution errors
- Simply use `bash` command directly on Linux/macOS

**If Git Bash is not installed on Windows:**

Show this message and stop:

```
❌ Git Bash Required

This skill requires Git Bash on Windows.

Quick install: https://git-scm.com/download/win
(Includes bash automatically)

Alternative: Install WSL if you prefer a full Linux environment.
```

---

### STEP 7: Handle Results

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

### Using Reference Images

If user has existing images to use as style references:

**Ask:** "Do you have any reference images for style guidance?"

If yes:
```bash
bash "$SCRIPT_PATH" \
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
bash "$SCRIPT_PATH" \
    --prompt "$PROMPT" \
    --output "$OUTPUT_PATH" \
    --grounding true
```

---

## 🖥️ PLATFORM-SPECIFIC NOTES

### Linux & macOS
- Bash is pre-installed
- Script runs directly
- No additional setup needed

### Windows
- **Option 1 (Recommended):** Git for Windows includes Git Bash
  - Download: https://git-scm.com/download/win
  - Installs bash automatically
  
- **Option 2:** Windows Subsystem for Linux (WSL)
  - Run: `wsl --install` in PowerShell
  - Provides full Linux environment

- **Option 3:** PowerShell wrapper (if needed)
  ```powershell
  # PowerShell can invoke bash if Git Bash is installed
  & "C:\Program Files\Git\bin\bash.exe" "$SCRIPT_PATH" --prompt "$PROMPT" --output "$OUTPUT_PATH"
  ```

**For AI Agents:** Use the Shell tool normally - it handles platform detection automatically.

---

## 💡 EXAMPLE CONVERSATION FLOWS

### Example 1: Quick Logo

**User:** "Generate a logo using Gemini"

**Agent:**
1. ✅ Check API key (found)
2. Ask: "What image would you like to generate?"
   - User: "Modern minimalist logo for CloudFlow with blue colors"
3. Ask: "Where should I save it?"
   - User: "public/images/logo.png"
4. Show options for aspect ratio, size, model
   - User selects: 1:1, 2K, Gemini 3 Pro
5. Execute script
6. Report: "✅ Image saved to public/images/logo.png (245 KB)"

### Example 2: YouTube Banner

**User:** "Create a YouTube banner with Gemini"

**Agent:**
1. ✅ Check API key
2. Gather prompt: "Professional banner for AI tutorials channel"
3. Suggest: "public/images/youtube-banner.png"
4. Pre-suggest 16:9 aspect ratio (optimal for YouTube)
5. Show size and model options
6. Execute and report results

### Example 3: First-Time User

**User:** "Generate an image with Gemini"

**Agent:**
1. ❌ Check API key (NOT found)
2. Show setup guide
3. STOP and wait for user to configure
4. (After user confirms): Proceed with workflow

---

## 🔍 TROUBLESHOOTING FOR AI AGENTS

| Symptom | Platform | Solution |
|---------|----------|----------|
| "bash not found" or "execvpe" error | Windows | Use full Git Bash path: `& "C:\Program Files\Git\bin\bash.exe"` instead of just `bash` |
| "WSL (9 - Relay) ERROR" | Windows | Shell tool tried to use WSL - use full Git Bash path instead |
| "No such file or directory" | Any | Verify script exists at `~/.cursor/skills/gemini-image-generation/scripts/generate-image.sh` |
| Permission denied | Windows | Check file is not read-only; try running Cursor as admin |
| Permission denied | Linux/macOS | Run `chmod +x ~/.cursor/skills/gemini-image-generation/scripts/generate-image.sh` |
| Script path not found | Any | Skill may not be installed - check `~/.cursor/skills/` directory |
| Command fails silently | Any | Check if Git Bash is installed on Windows or bash is available on Unix |

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
- ✅ Always check API key FIRST before asking questions
- ✅ Guide users with smart defaults based on context
- ✅ Validate paths before execution
- ✅ Create directories if needed
- ✅ Provide clear, actionable error messages
- ✅ Confirm success with file size and location
- ✅ Suggest appropriate aspect ratios based on use case

### DON'T:
- ❌ Proceed without API key
- ❌ Use this skill for non-Gemini image requests
- ❌ Hardcode paths or parameters
- ❌ Show raw error messages without translation
- ❌ Skip the interactive questions
- ❌ Forget to check if script path exists

---

## 📊 SKILL METADATA

- **Input**: User's image request mentioning "Gemini"
- **Output**: PNG image file at specified location
- **Average execution time**: 10-30s (Pro), 5-15s (Flash)
- **Dependencies**: bash, curl, python3 (standard on most systems)
- **API limits**: Based on Google AI Studio free tier
- **Supported platforms**: Linux, macOS, Windows (with Git Bash/WSL)

---

## 🔄 VERSION HISTORY

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
