# Troubleshooting Guide: "If You See X, Do Y"

| Issue (X) | Cause | Fix (Y) |
| :--- | :--- | :--- |
| **White Screen / 500 Internal Server Error** | PHP syntax error in `functions.php` or a file in `patterns/`. | Run `php -l functions.php` and `php -l patterns/*.php` to find the syntax error and fix it. |
| **Template not loading / Falls back to index.html** | 1. Filename typo (e.g. `frontpage.html` instead of `front-page.html`).<br>2. Template placed in theme root instead of `templates/`. | Move template to `templates/<name>.html` and match the exact WordPress template hierarchy spelling. |
| **`theme.json` changes ignored** | 1. Invalid JSON syntax (trailing comma, unquoted key).<br>2. Wrong version number.<br>3. Theme cache or child theme override. | Run `bash {baseDir}/scripts/check-theme-json.sh .`. Fix syntax errors. Ensure `"version": 3` is present. |
| **"Template part has been deleted or is unavailable"** | Slug in template comment does not match a file in `parts/`. | Check `<!-- wp:template-part {"slug":"header"} /-->`. Verify that `parts/header.html` exists with matching lowercase name. Run `bash {baseDir}/scripts/check-part-refs.sh .`. |
| **"This block contains unexpected or invalid content" in Editor** | Block comment syntax or HTML inner markup does not match Gutenberg spec. | Check `{baseDir}/references/block-markup.md`. Ensure self-closing blocks use `/-->` and container blocks have matching opening/closing tags. |
| **Colors or font sizes not applying** | 1. Using hardcoded hex instead of slug.<br>2. Malformed token reference. | In `theme.json`, use `var:preset|color|<slug>`. In HTML templates, use CSS class `has-<slug>-color` or `has-<slug>-background-color`. Run `bash {baseDir}/scripts/check-hex-colors.sh .`. |
| **Pattern not appearing in block inserter** | Missing or malformed DocBlock header in `patterns/<name>.php`. | Ensure pattern starts with `<?php /** Title: ... Slug: ... Categories: ... */ ?>`. Check that `Inserter: no` is NOT present. |
| **Styles from `style.css` not applying** | Block themes load styles via `theme.json` by default; `style.css` is only enqueued if explicitly hooked in `functions.php`. | Place styling in `theme.json` under `styles`. If custom CSS is necessary, verify `functions.php` enqueues `get_stylesheet_uri()`. |
