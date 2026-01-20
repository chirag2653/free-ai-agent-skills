#!/usr/bin/env python3
"""
Gemini Image Generation Script
A universal, cross-platform script for generating images via Gemini API

Usage: python generate-image.py --prompt "your prompt" --output "path/to/output.png" [OPTIONS]

Required:
    --prompt, -p      Image generation prompt
    --output, -o      Output file path (PNG)

Optional:
    --aspect-ratio    Aspect ratio (default: 1:1)
                      Options: 1:1, 2:3, 3:2, 3:4, 4:3, 4:5, 5:4, 9:16, 16:9, 21:9
    --size            Image size (default: 1K)
                      Options: 1K, 2K, 4K
    --model           Model to use (default: gemini-3-pro-image-preview)
                      Options: gemini-3-pro-image-preview (Pro - full control)
                              gemini-2.5-flash-image (Flash - faster)
    --env-file        Path to env file (auto-detects if not specified)
    --reference       Reference image path (can be used multiple times, max 14)
    --grounding       Enable Google Search grounding (true/false, default: false)
    --help, -h        Show this help message
"""

import argparse
import base64
import json
import os
import sys
import urllib.request
import urllib.error
from pathlib import Path


# =============================================================================
# CONFIGURATION
# =============================================================================
VALID_RATIOS = ["1:1", "2:3", "3:2", "3:4", "4:3", "4:5", "5:4", "9:16", "16:9", "21:9"]
VALID_SIZES = ["1K", "2K", "4K"]
DEFAULT_MODEL = "gemini-3-pro-image-preview"


# =============================================================================
# ARGUMENT PARSING
# =============================================================================
def parse_args():
    parser = argparse.ArgumentParser(
        description="Generate images using Google's Gemini API",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
    # Simple image generation
    python generate-image.py -p "A blue circle on white background" -o output.png

    # Logo with specific aspect ratio and high resolution
    python generate-image.py \\
        --prompt "Modern minimalist logo for tech company 'KW Labs'" \\
        --output logo.png \\
        --aspect-ratio 1:1 \\
        --size 2K

    # Image with reference for style
    python generate-image.py \\
        --prompt "Similar style logo but for a coffee shop" \\
        --output coffee-logo.png \\
        --reference existing-logo.png

Environment:
    GEMINI_API_KEY    Required. Get from https://aistudio.google.com/
                      Can be set in .env.local, .env, or as environment variable
        """
    )

    parser.add_argument(
        "--prompt", "-p",
        required=True,
        help="Image generation prompt (detailed description works best)"
    )

    parser.add_argument(
        "--output", "-o",
        required=True,
        help="Output file path (will be saved as PNG)"
    )

    parser.add_argument(
        "--aspect-ratio",
        default="1:1",
        choices=VALID_RATIOS,
        help="Aspect ratio for the image (default: 1:1)"
    )

    parser.add_argument(
        "--size",
        default="1K",
        help="Image resolution: 1K, 2K, or 4K (default: 1K)"
    )

    parser.add_argument(
        "--model",
        default=DEFAULT_MODEL,
        help=f"Gemini model: gemini-3-pro-image-preview (Pro) or gemini-2.5-flash-image (Flash). Default: {DEFAULT_MODEL}"
    )

    parser.add_argument(
        "--env-file",
        help="Path to environment file containing GEMINI_API_KEY"
    )

    parser.add_argument(
        "--reference",
        action="append",
        dest="references",
        help="Reference image for style/content guidance (can be used multiple times, max 14)"
    )

    parser.add_argument(
        "--grounding",
        default="false",
        choices=["true", "false"],
        help="Enable Google Search grounding for factual accuracy (default: false)"
    )

    return parser.parse_args()


# =============================================================================
# API KEY LOADING
# =============================================================================
def load_api_key(env_file=None):
    """Load API key from various sources with priority fallback."""
    
    # Priority 1: Explicit env file
    if env_file and os.path.exists(env_file):
        key = _read_key_from_file(env_file)
        if key:
            return key

    # Priority 2: Environment variable
    key = os.environ.get("GEMINI_API_KEY")
    if key:
        return key

    # Priority 3-6: Check multiple .env files
    env_paths = [
        ".env.local",
        ".env",
        os.path.expanduser("~/.env.local"),
        os.path.expanduser("~/.env")
    ]

    for path in env_paths:
        if os.path.exists(path):
            key = _read_key_from_file(path)
            if key:
                return key

    return None


def _read_key_from_file(filepath):
    """Read GEMINI_API_KEY from a file."""
    try:
        with open(filepath, 'r') as f:
            for line in f:
                line = line.strip()
                if line.startswith("GEMINI_API_KEY="):
                    # Extract value and remove quotes
                    value = line.split("=", 1)[1]
                    value = value.strip().strip('"').strip("'")
                    if value:
                        return value
    except Exception:
        pass
    return None


# =============================================================================
# REQUEST BUILDING
# =============================================================================
def build_request(prompt, aspect_ratio, image_size, model, references, grounding):
    """Build the JSON request for Gemini API."""
    
    # Build parts array starting with text prompt
    parts = [{"text": prompt}]

    # Add reference images if provided
    if references:
        if len(references) > 14:
            print(f"Error: Maximum 14 reference images allowed (got {len(references)})")
            sys.exit(1)

        for ref_path in references:
            if not os.path.exists(ref_path):
                print(f"Error: Reference image not found: {ref_path}")
                sys.exit(1)

            # Detect mime type
            ext = Path(ref_path).suffix.lower()
            mime_types = {
                ".png": "image/png",
                ".jpg": "image/jpeg",
                ".jpeg": "image/jpeg",
                ".gif": "image/gif",
                ".webp": "image/webp"
            }
            mime_type = mime_types.get(ext, "image/png")

            # Read and encode image
            with open(ref_path, "rb") as f:
                img_data = base64.b64encode(f.read()).decode("utf-8")

            parts.append({
                "inline_data": {
                    "mime_type": mime_type,
                    "data": img_data
                }
            })

    # Build the request
    request_data = {
        "contents": [{
            "role": "user",
            "parts": parts
        }],
        "generationConfig": {
            "responseModalities": ["TEXT", "IMAGE"]
        }
    }

    # Add imageConfig for Pro models (Flash doesn't support it)
    if "flash" not in model.lower():
        request_data["generationConfig"]["imageConfig"] = {
            "aspectRatio": aspect_ratio,
            "imageSize": image_size.upper()
        }

    # Add grounding if enabled
    if grounding == "true":
        request_data["tools"] = [{"google_search": {}}]

    return request_data


# =============================================================================
# API CALL
# =============================================================================
def call_gemini_api(api_key, model, request_data):
    """Make the API call to Gemini."""
    
    endpoint = f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent"
    
    headers = {
        "Content-Type": "application/json",
        "x-goog-api-key": api_key
    }

    json_data = json.dumps(request_data).encode("utf-8")
    
    req = urllib.request.Request(endpoint, data=json_data, headers=headers)

    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        error_body = e.read().decode("utf-8")
        print(f"Error: API returned HTTP {e.code}")
        print(f"Response: {error_body}")
        sys.exit(1)
    except Exception as e:
        print(f"Error calling API: {e}")
        sys.exit(1)


# =============================================================================
# IMAGE EXTRACTION
# =============================================================================
def extract_and_save_image(response_data, output_path):
    """Extract image from response and save to file."""
    
    # Handle both array (streaming) and object responses
    items = response_data if isinstance(response_data, list) else [response_data]

    image_saved = False
    text_responses = []

    for item in items:
        candidates = item.get("candidates", [])
        for candidate in candidates:
            parts = candidate.get("content", {}).get("parts", [])
            for part in parts:
                # Collect text responses
                if "text" in part and not part.get("thought"):
                    text_responses.append(part["text"])

                # Save image
                if "inlineData" in part and not image_saved:
                    img_data = part["inlineData"]["data"]
                    
                    # Create output directory if needed
                    os.makedirs(os.path.dirname(output_path) or ".", exist_ok=True)
                    
                    # Write image
                    with open(output_path, "wb") as f:
                        f.write(base64.b64decode(img_data))
                    image_saved = True

    if text_responses:
        preview = " ".join(text_responses)[:200]
        print(f"Model response: {preview}")

    if not image_saved:
        print("Error: No image found in response")
        print(f"Response preview: {json.dumps(response_data)[:500]}")
        sys.exit(1)

    return image_saved


# =============================================================================
# MAIN
# =============================================================================
def main():
    args = parse_args()

    # Normalize size to uppercase
    args.size = args.size.upper()
    if args.size not in VALID_SIZES:
        print(f"Error: Invalid image size '{args.size}'")
        print(f"Valid options: {', '.join(VALID_SIZES)}")
        sys.exit(1)

    # Load API key
    api_key = load_api_key(args.env_file)
    if not api_key:
        print("Error: GEMINI_API_KEY not found")
        print()
        print("Please set your API key in one of these locations (checked in order):")
        print("  1. --env-file <path>     (explicit path)")
        print("  2. GEMINI_API_KEY        (environment variable)")
        print("  3. .env.local            (current directory)")
        print("  4. .env                  (current directory)")
        print("  5. ~/.env.local          (home directory)")
        print("  6. ~/.env                (home directory)")
        print()
        print("Get your API key from: https://aistudio.google.com/")
        sys.exit(1)

    # Print configuration
    print("=" * 50)
    print("Gemini Image Generation")
    print("=" * 50)
    print(f"Model:        {args.model}")
    print(f"Aspect Ratio: {args.aspect_ratio}")
    print(f"Image Size:   {args.size}")
    print(f"Grounding:    {args.grounding}")
    print(f"Output:       {args.output}")
    print(f"Prompt:       {args.prompt[:80]}...")
    if args.references:
        print(f"References:   {len(args.references)} image(s)")
    print("=" * 50)

    if "flash" in args.model.lower():
        print("Note: Flash model - using default aspect ratio and size")

    # Build request
    print("Building request...")
    request_data = build_request(
        args.prompt,
        args.aspect_ratio,
        args.size,
        args.model,
        args.references,
        args.grounding
    )

    # Call API
    print("Calling Gemini API...")
    response_data = call_gemini_api(api_key, args.model, request_data)

    # Extract and save image
    print("Extracting image from response...")
    extract_and_save_image(response_data, args.output)

    # Verify output
    if os.path.exists(args.output) and os.path.getsize(args.output) > 0:
        file_size = os.path.getsize(args.output)
        print("=" * 50)
        print("SUCCESS!")
        print("=" * 50)
        print(f"Output: {args.output}")
        print(f"Size:   {file_size:,} bytes")
        print("=" * 50)
    else:
        print("Error: Output file not created or is empty")
        sys.exit(1)


if __name__ == "__main__":
    main()
