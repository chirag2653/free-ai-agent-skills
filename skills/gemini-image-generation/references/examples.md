# Example Conversation Flows

> Reference examples showing the smart workflow in action. Load this file when you need to see conversation patterns.

## Example 1: Power User (Everything Provided)

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

**Agent:** Generates image → "✅ Image saved to public/sunset.png (1.2 MB)"

**Total questions: 1** (final confirmation only)

---

## Example 2: Typical User (Logo Request)

**User:** "Generate a logo for TechFlow with Gemini"

**Agent:** Asks for model choice (Pro vs Flash)

**User:** "Flash"

**Agent:** Shows confirmation with smart defaults (1:1 ratio, 2K for logos)

**User:** "Save it to assets/logo.png instead"

**Agent:** Updates path, confirms again

**User:** "Yes"

**Agent:** Generates image

**Total questions: 2** (model choice + confirmation with adjustment)

---

## Example 3: Minimal Input with Prompt Enhancement

**User:** "Create an image with Gemini"

**Agent:** "What image would you like to generate?"

**User:** "A futuristic cityscape"

**Agent:** "Would you like me to enhance this prompt using Google's Imagen best practices?"

**User:** "Yes"

**Agent:** Shows before/after:
```
Original: A futuristic cityscape

Enhanced: Futuristic cyberpunk cityscape at night with towering neon-lit skyscrapers,
holographic advertisements floating between buildings, flying vehicles with light trails,
wet pavement reflecting colorful lights, dramatic wide-angle perspective from street level,
cinematic atmosphere with blue and pink neon glow

Added: time (night), style (cyberpunk), elements (neon, holograms, vehicles),
camera (wide-angle), lighting (neon), mood (cinematic)
```

**User:** "Yes" → Asks model → Shows confirmation → Generates

**Total questions: 4** (prompt + enhancement + model + confirmation)

---

## Example 4: YouTube Banner

**User:** "Make a YouTube banner with Gemini Flash"

**Agent:** "What should the YouTube banner show?"

**User:** "AI tutorials channel, dark theme"

**Agent:** Shows confirmation with 16:9 ratio (smart default for YouTube)

**User:** "Make it 4K"

**Agent:** Updates resolution, confirms

**User:** "Yes" → Generates

**Total questions: 2** (prompt + confirmation with adjustment)

---

## Example 5: Prompt Enhancement in Action

**User:** "Generate two cars dodging each other with Gemini Flash"

**Agent:** Offers enhancement

**User:** "Yes"

**Agent:**
```
Original: two cars dodging each other

Enhanced: Two sleek sports cars racing towards each other on a dramatic highway at
sunset, performing a thrilling last-second dodge maneuver with tire smoke and motion blur,
wide-angle shot from low perspective, cinematic action scene with warm golden hour lighting

Added: specifics (sports cars, highway), time (sunset), effects (smoke, blur),
camera (wide-angle, low), lighting (golden hour), mood (cinematic)
```

**User:** "Yes" → Confirmation → Generates

**Total questions: 2** (enhancement + confirmation)
