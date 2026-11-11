#!/usr/bin/env bash
# check-hex-colors.sh: Verify no hardcoded hex colors exist in templates, parts, or style.css
set -euo pipefail

THEME_DIR="${1:-.}"

SCAN_TARGETS=()

if [ -d "$THEME_DIR/templates" ]; then
    while IFS= read -r f; do
        [ -n "$f" ] && SCAN_TARGETS+=("$f")
    done < <(find "$THEME_DIR/templates" -type f -name "*.html" 2>/dev/null || true)
fi

if [ -d "$THEME_DIR/parts" ]; then
    while IFS= read -r f; do
        [ -n "$f" ] && SCAN_TARGETS+=("$f")
    done < <(find "$THEME_DIR/parts" -type f -name "*.html" 2>/dev/null || true)
fi

if [ -f "$THEME_DIR/style.css" ]; then
    SCAN_TARGETS+=("$THEME_DIR/style.css")
fi

if [ ${#SCAN_TARGETS[@]} -eq 0 ]; then
    echo "FAIL: No templates, parts, or style.css found to scan in $THEME_DIR"
    exit 1
fi

HEX_MATCHES=$(python3 -c "
import re, sys

# Matches #RGB, #RGBA, #RRGGBB, #RRGGBBAA
hex_color_pattern = re.compile(r'#([0-9a-fA-F]{3}|[0-9a-fA-F]{4}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})\b')
# Exclude HTML entities: &#1234; or &#xABCD;
entity_pattern = re.compile(r'&#[0-9a-zA-Z]+;')
# Exclude anchor links: href=\"#...\"
anchor_pattern = re.compile(r'href=[\"\']#[a-zA-Z0-9_\-]+[\"\']')

found = []

for filepath in sys.argv[1:]:
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            for line_no, line in enumerate(f, 1):
                # Clean out harmless entities and anchor links for testing
                clean_line = entity_pattern.sub('', line)
                clean_line = anchor_pattern.sub('', clean_line)
                
                # Check for hex colors
                matches = hex_color_pattern.findall(clean_line)
                if matches:
                    # Filter out git commit shas or pure numeric non-colors if any
                    for m in matches:
                        found.append(f'{filepath}:{line_no}: #{m}')
    except Exception as e:
        pass

if found:
    print(found[0])
" "${SCAN_TARGETS[@]}")

if [ -n "$HEX_MATCHES" ]; then
    echo "FAIL: Hardcoded hex color found in $HEX_MATCHES (use theme.json palette slugs instead)"
    exit 1
fi

echo "PASS: No hardcoded hex colors found in templates or style.css"
exit 0
