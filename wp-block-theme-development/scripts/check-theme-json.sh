#!/usr/bin/env bash
# check-theme-json.sh: Validate theme.json syntax and required version
set -euo pipefail

THEME_DIR="${1:-.}"
THEME_JSON="$THEME_DIR/theme.json"

if [ ! -f "$THEME_JSON" ]; then
    echo "FAIL: theme.json does not exist in $THEME_DIR"
    exit 1
fi

# Validate JSON format
if command -v jq >/dev/null 2>&1; then
    if ! jq empty "$THEME_JSON" 2>/dev/null; then
        echo "FAIL: theme.json contains invalid JSON syntax"
        exit 1
    fi
    VERSION=$(jq -r '.version // empty' "$THEME_JSON")
elif command -v node >/dev/null 2>&1; then
    PARSE_OUT=$(node -e "
        try {
            const data = JSON.parse(require('fs').readFileSync('$THEME_JSON', 'utf8'));
            console.log(data.version || '');
        } catch (e) {
            console.error('ERROR');
            process.exit(1);
        }
    " 2>/dev/null) || {
        echo "FAIL: theme.json contains invalid JSON syntax"
        exit 1
    }
    VERSION="$PARSE_OUT"
elif command -v python3 >/dev/null 2>&1; then
    PARSE_OUT=$(python3 -c "
import json, sys
try:
    with open('$THEME_JSON') as f:
        data = json.load(f)
    print(data.get('version', ''))
except Exception:
    sys.exit(1)
" 2>/dev/null) || {
        echo "FAIL: theme.json contains invalid JSON syntax"
        exit 1
    }
    VERSION="$PARSE_OUT"
else
    echo "FAIL: Neither jq, node, nor python3 is installed to validate JSON"
    exit 1
fi

if [ -z "$VERSION" ] || [ "$VERSION" = "null" ]; then
    echo "FAIL: theme.json is missing the required top-level \"version\" key"
    exit 1
fi

if [ "$VERSION" -lt 2 ] 2>/dev/null; then
    echo "FAIL: theme.json version must be 2 or 3 (found: $VERSION)"
    exit 1
fi

echo "PASS: theme.json is valid (version $VERSION)"
exit 0
