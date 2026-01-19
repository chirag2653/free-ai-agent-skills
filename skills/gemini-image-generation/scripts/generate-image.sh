#!/bin/bash
# Gemini Image Generation Script
# Supports Gemini 3 Pro and Gemini 2.5 Flash models
# A robust, cross-platform script for generating images via Google's Gemini API
#
# Usage: ./generate-image.sh [OPTIONS] --prompt "your prompt" --output "path/to/output.png"
#
# Required:
#   --prompt, -p      Image generation prompt
#   --output, -o      Output file path (PNG)
#
# Optional:
#   --aspect-ratio    Aspect ratio (default: 1:1)
#                     Options: 1:1, 2:3, 3:2, 3:4, 4:3, 4:5, 5:4, 9:16, 16:9, 21:9
#   --size            Image size (default: 1K)
#                     Options: 1K, 2K, 4K
#   --model           Model to use (default: gemini-3-pro-image-preview)
#   --env-file        Path to env file (auto-detects if not specified)
#   --reference       Reference image path (can be used multiple times, max 14)
#   --grounding       Enable Google Search grounding (true/false, default: false)
#   --help, -h        Show this help message

set -e

# =============================================================================
# DEFAULT CONFIGURATION
# =============================================================================
MODEL="gemini-3-pro-image-preview"
ASPECT_RATIO="1:1"
IMAGE_SIZE="1K"
GROUNDING="false"
PROMPT=""
OUTPUT_PATH=""
ENV_FILE=""
REFERENCE_IMAGES=()

# =============================================================================
# PARSE ARGUMENTS
# =============================================================================
show_help() {
    cat << 'HELP'
Gemini 3 Pro Image Generation Script

USAGE:
    ./generate-image.sh --prompt "description" --output "path/to/image.png" [OPTIONS]

REQUIRED ARGUMENTS:
    --prompt, -p <text>       Image generation prompt (detailed description works best)
    --output, -o <path>       Output file path (will be saved as PNG)

OPTIONAL ARGUMENTS:
    --aspect-ratio <ratio>    Aspect ratio for the image
                              Options: 1:1 (square), 2:3, 3:2, 3:4, 4:3, 4:5, 5:4,
                                       9:16 (portrait), 16:9 (landscape), 21:9 (ultrawide)
                              Default: 1:1

    --size <size>             Image resolution
                              Options: 1K (~1024px), 2K (~2048px), 4K (~4096px)
                              Default: 1K

    --model <model>           Gemini model to use
                              Options: gemini-3-pro-image-preview (professional, all params)
                                       gemini-2.5-flash-image (faster, basic)
                              Default: gemini-3-pro-image-preview
                              Note: Flash models don't support aspect ratio or size options

    --env-file <path>         Path to environment file containing GEMINI_API_KEY
                              Default: Auto-detects from .env.local, .env, or ~/.env

    --reference <path>        Reference image for style/content guidance
                              Can be specified multiple times (max 14 images)
                              Example: --reference logo1.png --reference logo2.png

    --grounding <bool>        Enable Google Search grounding for factual accuracy
                              Options: true, false
                              Default: false

    --help, -h                Show this help message

EXAMPLES:
    # Simple image generation
    ./generate-image.sh -p "A blue circle on white background" -o output.png

    # Logo with specific aspect ratio and high resolution
    ./generate-image.sh \
        --prompt "Modern minimalist logo for tech company 'KW Labs'" \
        --output logo.png \
        --aspect-ratio 1:1 \
        --size 2K

    # Image with reference for style
    ./generate-image.sh \
        --prompt "Similar style logo but for a coffee shop" \
        --output coffee-logo.png \
        --reference existing-logo.png

ENVIRONMENT:
    GEMINI_API_KEY    Required. Get from https://aistudio.google.com/
                      Can be set in .env.local, .env, or as environment variable

HELP
    exit 0
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --prompt|-p)
            PROMPT="$2"
            shift 2
            ;;
        --output|-o)
            OUTPUT_PATH="$2"
            shift 2
            ;;
        --aspect-ratio)
            ASPECT_RATIO="$2"
            shift 2
            ;;
        --size)
            IMAGE_SIZE="$2"
            shift 2
            ;;
        --model)
            MODEL="$2"
            shift 2
            ;;
        --env-file)
            ENV_FILE="$2"
            shift 2
            ;;
        --reference)
            REFERENCE_IMAGES+=("$2")
            shift 2
            ;;
        --grounding)
            GROUNDING="$2"
            shift 2
            ;;
        --help|-h)
            show_help
            ;;
        *)
            echo "Error: Unknown option $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# =============================================================================
# VALIDATION
# =============================================================================

# Validate required arguments
if [ -z "$PROMPT" ]; then
    echo "Error: --prompt is required"
    echo "Use --help for usage information"
    exit 1
fi

if [ -z "$OUTPUT_PATH" ]; then
    echo "Error: --output is required"
    echo "Use --help for usage information"
    exit 1
fi

# Validate aspect ratio
VALID_RATIOS=("1:1" "2:3" "3:2" "3:4" "4:3" "4:5" "5:4" "9:16" "16:9" "21:9")
if [[ ! " ${VALID_RATIOS[*]} " =~ " ${ASPECT_RATIO} " ]]; then
    echo "Error: Invalid aspect ratio '$ASPECT_RATIO'"
    echo "Valid options: ${VALID_RATIOS[*]}"
    exit 1
fi

# Validate image size (must be uppercase)
IMAGE_SIZE=$(echo "$IMAGE_SIZE" | tr '[:lower:]' '[:upper:]')
VALID_SIZES=("1K" "2K" "4K")
if [[ ! " ${VALID_SIZES[*]} " =~ " ${IMAGE_SIZE} " ]]; then
    echo "Error: Invalid image size '$IMAGE_SIZE'"
    echo "Valid options: ${VALID_SIZES[*]}"
    exit 1
fi

# Validate reference images count
if [ ${#REFERENCE_IMAGES[@]} -gt 14 ]; then
    echo "Error: Maximum 14 reference images allowed (got ${#REFERENCE_IMAGES[@]})"
    exit 1
fi

# =============================================================================
# DETECT PYTHON
# =============================================================================
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    PYTHON_CMD="python"
else
    echo "Error: Python not found. Please install Python 3."
    exit 1
fi

# =============================================================================
# PATH NORMALIZATION (Windows compatibility)
# =============================================================================
# Convert Windows backslashes to forward slashes for Python compatibility
normalize_path() {
    echo "$1" | sed 's|\\|/|g'
}

# =============================================================================
# LOAD API KEY (with fallback chain)
# =============================================================================
load_api_key() {
    local key=""

    # Priority 1: Explicit env file
    if [ -n "$ENV_FILE" ] && [ -f "$ENV_FILE" ]; then
        key=$(grep -E "^GEMINI_API_KEY=" "$ENV_FILE" 2>/dev/null | cut -d '=' -f2- | tr -d '"' | tr -d "'" | tr -d ' ')
        if [ -n "$key" ]; then
            echo "$key"
            return 0
        fi
    fi

    # Priority 2: Environment variable
    if [ -n "$GEMINI_API_KEY" ]; then
        echo "$GEMINI_API_KEY"
        return 0
    fi

    # Priority 3: .env.local in current directory
    if [ -f ".env.local" ]; then
        key=$(grep -E "^GEMINI_API_KEY=" ".env.local" 2>/dev/null | cut -d '=' -f2- | tr -d '"' | tr -d "'" | tr -d ' ')
        if [ -n "$key" ]; then
            echo "$key"
            return 0
        fi
    fi

    # Priority 4: .env in current directory
    if [ -f ".env" ]; then
        key=$(grep -E "^GEMINI_API_KEY=" ".env" 2>/dev/null | cut -d '=' -f2- | tr -d '"' | tr -d "'" | tr -d ' ')
        if [ -n "$key" ]; then
            echo "$key"
            return 0
        fi
    fi

    # Priority 5: ~/.env.local (user home)
    if [ -f "$HOME/.env.local" ]; then
        key=$(grep -E "^GEMINI_API_KEY=" "$HOME/.env.local" 2>/dev/null | cut -d '=' -f2- | tr -d '"' | tr -d "'" | tr -d ' ')
        if [ -n "$key" ]; then
            echo "$key"
            return 0
        fi
    fi

    # Priority 6: ~/.env (user home)
    if [ -f "$HOME/.env" ]; then
        key=$(grep -E "^GEMINI_API_KEY=" "$HOME/.env" 2>/dev/null | cut -d '=' -f2- | tr -d '"' | tr -d "'" | tr -d ' ')
        if [ -n "$key" ]; then
            echo "$key"
            return 0
        fi
    fi

    return 1
}

GEMINI_API_KEY=$(load_api_key)

if [ -z "$GEMINI_API_KEY" ]; then
    echo "Error: GEMINI_API_KEY not found"
    echo ""
    echo "Please set your API key in one of these locations (checked in order):"
    echo "  1. --env-file <path>     (explicit path)"
    echo "  2. GEMINI_API_KEY        (environment variable)"
    echo "  3. .env.local            (current directory)"
    echo "  4. .env                  (current directory)"
    echo "  5. ~/.env.local          (home directory)"
    echo "  6. ~/.env                (home directory)"
    echo ""
    echo "Get your API key from: https://aistudio.google.com/"
    exit 1
fi

# =============================================================================
# SETUP
# =============================================================================
API_ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"

echo "========================================"
echo "Gemini Image Generation"
echo "========================================"
echo "Model:        $MODEL"
echo "Aspect Ratio: $ASPECT_RATIO"
echo "Image Size:   $IMAGE_SIZE"
echo "Grounding:    $GROUNDING"
echo "Output:       $OUTPUT_PATH"
echo "Prompt:       ${PROMPT:0:80}..."
if [ ${#REFERENCE_IMAGES[@]} -gt 0 ]; then
    echo "References:   ${#REFERENCE_IMAGES[@]} image(s)"
fi
echo "========================================"

# Create output directory
OUTPUT_DIR=$(dirname "$OUTPUT_PATH")
mkdir -p "$OUTPUT_DIR"

# Temp files in output directory (cross-platform compatible)
REQUEST_FILE="$OUTPUT_DIR/.gemini-request-$$.json"
RESPONSE_FILE="$OUTPUT_DIR/.gemini-response-$$.json"

# Cleanup on exit
cleanup() {
    rm -f "$REQUEST_FILE" "$RESPONSE_FILE"
}
trap cleanup EXIT

# =============================================================================
# BUILD REQUEST JSON
# =============================================================================
echo "Building request..."

# Start building parts array
PARTS_JSON="[{\"text\": $($PYTHON_CMD -c "import json; print(json.dumps('''$PROMPT'''))")}"

# Add reference images if provided
for ref_img in "${REFERENCE_IMAGES[@]}"; do
    if [ ! -f "$ref_img" ]; then
        echo "Error: Reference image not found: $ref_img"
        exit 1
    fi

    # Detect mime type
    case "${ref_img,,}" in
        *.png)  MIME_TYPE="image/png" ;;
        *.jpg|*.jpeg)  MIME_TYPE="image/jpeg" ;;
        *.gif)  MIME_TYPE="image/gif" ;;
        *.webp) MIME_TYPE="image/webp" ;;
        *)      MIME_TYPE="image/png" ;;
    esac

    # Base64 encode the image
    if command -v base64 &> /dev/null; then
        IMG_BASE64=$(base64 -w 0 "$ref_img" 2>/dev/null || base64 "$ref_img" | tr -d '\n')
    else
        # Normalize path for Windows compatibility
        REF_IMG_NORMALIZED=$(normalize_path "$ref_img")
        IMG_BASE64=$($PYTHON_CMD -c "import base64; print(base64.b64encode(open('$REF_IMG_NORMALIZED', 'rb').read()).decode())")
    fi

    PARTS_JSON="$PARTS_JSON, {\"inline_data\": {\"mime_type\": \"$MIME_TYPE\", \"data\": \"$IMG_BASE64\"}}"
done

PARTS_JSON="$PARTS_JSON]"

# Build tools array if grounding enabled
TOOLS_JSON=""
if [ "$GROUNDING" = "true" ]; then
    TOOLS_JSON=', "tools": [{"google_search": {}}]'
fi

# Create the full request
# Note: Flash models don't support aspectRatio or imageSize
if [[ "$MODEL" == *"flash"* ]]; then
    # Flash model - minimal config (no imageConfig)
    cat << EOF > "$REQUEST_FILE"
{
  "contents": [
    {
      "role": "user",
      "parts": $PARTS_JSON
    }
  ],
  "generationConfig": {
    "responseModalities": ["TEXT", "IMAGE"]
  }$TOOLS_JSON
}
EOF
    echo "Note: Flash model - using default aspect ratio and size"
else
    # Pro model - full config with imageConfig
    cat << EOF > "$REQUEST_FILE"
{
  "contents": [
    {
      "role": "user",
      "parts": $PARTS_JSON
    }
  ],
  "generationConfig": {
    "responseModalities": ["TEXT", "IMAGE"],
    "imageConfig": {
      "aspectRatio": "$ASPECT_RATIO",
      "imageSize": "$IMAGE_SIZE"
    }
  }$TOOLS_JSON
}
EOF
fi

# =============================================================================
# CALL API
# =============================================================================
echo "Calling Gemini API..."

HTTP_CODE=$(curl -s -w "%{http_code}" -X POST \
    -H "Content-Type: application/json" \
    -H "x-goog-api-key: ${GEMINI_API_KEY}" \
    "${API_ENDPOINT}" \
    -d @"$REQUEST_FILE" \
    -o "$RESPONSE_FILE")

# Check HTTP response
if [ "$HTTP_CODE" != "200" ]; then
    echo "Error: API returned HTTP $HTTP_CODE"
    echo ""
    if [ -f "$RESPONSE_FILE" ]; then
        echo "Response:"
        cat "$RESPONSE_FILE"
    fi
    exit 1
fi

# Check for API errors in response
if grep -q '"error"' "$RESPONSE_FILE"; then
    echo "Error: API returned an error"
    echo ""
    cat "$RESPONSE_FILE"
    exit 1
fi

# =============================================================================
# EXTRACT IMAGE
# =============================================================================
echo "Extracting image from response..."

# Normalize paths for Windows compatibility (backslashes -> forward slashes)
RESPONSE_FILE_PY=$(normalize_path "$RESPONSE_FILE")
OUTPUT_PATH_PY=$(normalize_path "$OUTPUT_PATH")

$PYTHON_CMD << PYTHON_SCRIPT
import json
import base64
import sys

try:
    with open("$RESPONSE_FILE_PY", 'r') as f:
        content = f.read()

    data = json.loads(content)

    # Handle both array (streaming) and object responses
    if isinstance(data, list):
        items = data
    else:
        items = [data]

    image_saved = False
    text_response = []

    for item in items:
        candidates = item.get('candidates', [])
        for candidate in candidates:
            parts = candidate.get('content', {}).get('parts', [])
            for part in parts:
                # Collect text responses
                if 'text' in part and not part.get('thought'):
                    text_response.append(part['text'])

                # Save image
                if 'inlineData' in part and not image_saved:
                    img_data = part['inlineData']['data']
                    with open("$OUTPUT_PATH_PY", 'wb') as f:
                        f.write(base64.b64decode(img_data))
                    image_saved = True

    if text_response:
        print("Model response:", ' '.join(text_response)[:200])

    if not image_saved:
        print("Error: No image found in response")
        print("Response preview:", content[:500])
        sys.exit(1)

    print(f"Image saved to: $OUTPUT_PATH_PY")

except json.JSONDecodeError as e:
    print(f"Error: Invalid JSON response - {e}")
    sys.exit(1)
except Exception as e:
    print(f"Error processing response: {e}")
    sys.exit(1)
PYTHON_SCRIPT

# =============================================================================
# VERIFY OUTPUT
# =============================================================================
if [ -f "$OUTPUT_PATH" ] && [ -s "$OUTPUT_PATH" ]; then
    # Get file size (cross-platform)
    if stat --version &> /dev/null 2>&1; then
        FILE_SIZE=$(stat -c%s "$OUTPUT_PATH")
    else
        FILE_SIZE=$(stat -f%z "$OUTPUT_PATH" 2>/dev/null || echo "unknown")
    fi

    echo "========================================"
    echo "SUCCESS!"
    echo "========================================"
    echo "Output: $OUTPUT_PATH"
    echo "Size:   $FILE_SIZE bytes"
    echo "========================================"
else
    echo "Error: Output file not created or is empty"
    exit 1
fi
