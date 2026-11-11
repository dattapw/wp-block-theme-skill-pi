#!/usr/bin/env bash
# check-style-css.sh: Validate required WordPress theme headers in style.css
set -euo pipefail

THEME_DIR="${1:-.}"
STYLE_CSS="$THEME_DIR/style.css"

if [ ! -f "$STYLE_CSS" ]; then
    echo "FAIL: style.css does not exist in $THEME_DIR"
    exit 1
fi

# Check for Theme Name
if ! grep -qi "^[[:space:]]*/\*[[:space:]]*Theme Name:" "$STYLE_CSS" && \
   ! grep -qi "^[[:space:]]*\*[[:space:]]*Theme Name:" "$STYLE_CSS" && \
   ! grep -qi "^Theme Name:" "$STYLE_CSS"; then
    echo "FAIL: style.css is missing required 'Theme Name:' header"
    exit 1
fi

# Check for Version
if ! grep -qi "^[[:space:]]*/\*[[:space:]]*Version:" "$STYLE_CSS" && \
   ! grep -qi "^[[:space:]]*\*[[:space:]]*Version:" "$STYLE_CSS" && \
   ! grep -qi "^Version:" "$STYLE_CSS"; then
    echo "FAIL: style.css is missing required 'Version:' header"
    exit 1
fi

# Check for Requires at least
if ! grep -qi "^[[:space:]]*/\*[[:space:]]*Requires at least:" "$STYLE_CSS" && \
   ! grep -qi "^[[:space:]]*\*[[:space:]]*Requires at least:" "$STYLE_CSS" && \
   ! grep -qi "^Requires at least:" "$STYLE_CSS"; then
    echo "FAIL: style.css is missing 'Requires at least:' header (recommended: 6.0)"
    exit 1
fi

THEME_NAME=$(grep -i "Theme Name:" "$STYLE_CSS" | head -n 1 | sed -e 's/^[[:space:]]*\*[[:space:]]*//' -e 's/^[Tt]heme [Nn]ame:[[:space:]]*//' | tr -d '\r')

echo "PASS: style.css header fields verified ($THEME_NAME)"
exit 0
