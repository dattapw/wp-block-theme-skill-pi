#!/usr/bin/env bash
# check-wp-env.sh: Optional check to verify theme starts and returns HTTP 200 using wp-env
set -euo pipefail

THEME_DIR="${1:-.}"

# Check for wp-env executable or local install without network downloads
if ! command -v wp-env >/dev/null 2>&1; then
    echo "SKIP: wp-env command not found (optional local runtime check)"
    exit 0
fi

# Check if Docker is running (wp-env requires Docker)
if ! command -v docker >/dev/null 2>&1 || ! docker info >/dev/null 2>&1; then
    echo "SKIP: Docker daemon is not running (wp-env requires Docker)"
    exit 0
fi

echo "INFO: Checking wp-env environment..."

# Start wp-env with timeout
if ! timeout 30s wp-env start >/dev/null 2>&1; then
    echo "FAIL: wp-env failed to start within 30 seconds"
    exit 1
fi

SITE_URL="http://localhost:8888"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$SITE_URL" || true)

if [ "$HTTP_STATUS" = "200" ] || [ "$HTTP_STATUS" = "301" ] || [ "$HTTP_STATUS" = "302" ]; then
    echo "PASS: wp-env site running ($SITE_URL returned HTTP $HTTP_STATUS)"
    exit 0
else
    echo "FAIL: wp-env site responded with HTTP $HTTP_STATUS instead of 200"
    exit 1
fi
