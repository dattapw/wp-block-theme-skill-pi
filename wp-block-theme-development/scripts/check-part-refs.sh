#!/usr/bin/env bash
# check-part-refs.sh: Verify that every referenced template-part has a corresponding HTML file in parts/
set -euo pipefail

THEME_DIR="${1:-.}"
PARTS_DIR="$THEME_DIR/parts"
TEMPLATES_DIR="$THEME_DIR/templates"

if [ ! -d "$PARTS_DIR" ]; then
    echo "FAIL: parts/ directory does not exist in $THEME_DIR"
    exit 1
fi

if [ ! -d "$TEMPLATES_DIR" ]; then
    echo "FAIL: templates/ directory does not exist in $THEME_DIR"
    exit 1
fi

# Find all HTML files in templates and parts
HTML_FILES=$(find "$TEMPLATES_DIR" "$PARTS_DIR" -type f -name "*.html" 2>/dev/null || true)

if [ -z "$HTML_FILES" ]; then
    echo "FAIL: No HTML template files found in $TEMPLATES_DIR or $PARTS_DIR"
    exit 1
fi

# Scan for wp:template-part slugs
MISSING_PARTS=()
FOUND_ANY_PARTS=0

while IFS= read -r file; do
    [ -z "$file" ] && continue
    # Extract slugs from <!-- wp:template-part {..."slug":"SLUG"...}
    # Matches patterns like "slug":"header" or "slug":"footer"
    SLUGS=$(grep -oE 'wp:template-part[[:space:]]+{[^}]*"slug"[[:space:]]*:[[:space:]]*"[^"]+"' "$file" 2>/dev/null | sed -E 's/.*"slug"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/' || true)

    for slug in $SLUGS; do
        FOUND_ANY_PARTS=1
        EXPECTED_FILE="$PARTS_DIR/$slug.html"
        if [ ! -f "$EXPECTED_FILE" ]; then
            MISSING_PARTS+=("Part '$slug' referenced in '$file' does not exist at '$EXPECTED_FILE'")
        fi
    done
done <<< "$HTML_FILES"

if [ ${#MISSING_PARTS[@]} -gt 0 ]; then
    echo "FAIL: ${MISSING_PARTS[0]}"
    exit 1
fi

if [ "$FOUND_ANY_PARTS" -eq 0 ]; then
    echo "PASS: No template parts referenced (none missing)"
    exit 0
fi

echo "PASS: All referenced template parts exist in parts/"
exit 0
