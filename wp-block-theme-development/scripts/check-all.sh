#!/usr/bin/env bash
# check-all.sh: Run the complete WordPress block theme verification suite
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_DIR="${1:-.}"

echo "========================================"
echo "WordPress Block Theme Verification Suite"
echo "Target directory: $THEME_DIR"
echo "========================================"

FAILED=0

run_check() {
    local script_name="$1"
    local desc="$2"
    echo -n "Checking $desc... "
    local output
    if output=$(bash "$SCRIPT_DIR/$script_name" "$THEME_DIR" 2>&1); then
        echo "$output"
    else
        echo "$output"
        FAILED=1
    fi
}

run_check "check-style-css.sh" "style.css header"
run_check "check-theme-json.sh" "theme.json validity"
run_check "check-part-refs.sh" "template part references"
run_check "check-hex-colors.sh" "hardcoded hex colors"

echo "----------------------------------------"
if [ "$FAILED" -eq 0 ]; then
    echo "PASS: All WordPress block theme checks passed successfully!"
    exit 0
else
    echo "FAIL: One or more checks failed. See errors above."
    exit 1
fi
