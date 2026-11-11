---
name: wp-block-theme-development
description: Develop WordPress 6.x block themes using theme.json, block templates, parts, patterns, and style.css.
---

# WordPress Block Theme Development

Follow these steps in exact order. Work on one file at a time. Stop and run the verification command after each file before proceeding.

## DO NOT Rules
1. DO NOT put PHP code inside `.html` files in `templates/` or `parts/`.
2. DO NOT use hardcoded hex colors (`#fff`, `#000000`, etc.) in `.html` templates or `style.css`. Use palette slug classes (e.g., `has-primary-color`) or `var:preset|color|<slug>`.
3. DO NOT invent custom block names or HTML wrappers. Use only valid core blocks from `{baseDir}/references/block-markup.md`.
4. DO NOT omit `wp:` prefix in block comment delimiters. Use `<!-- wp:name -->` and `<!-- /wp:name -->`, or `<!-- wp:name /-->` for void blocks.
5. DO NOT write invalid JSON in `theme.json`. No comments, no trailing commas.

## 8-Step Workflow

Execute one step at a time. Stop after each step and run the check command.

1. **Create directories**: Run this exact command in your theme root:
   ```bash
   mkdir -p parts templates patterns
   ```

2. **Create `style.css`**: Copy `{baseDir}/templates/style.css` to `style.css`. Change `Theme Name:` and `Text Domain:`. Verify:
   ```bash
   bash {baseDir}/scripts/check-style-css.sh .
   ```

3. **Create `theme.json`**: Copy `{baseDir}/templates/theme.json` to `theme.json`. Edit colors and fonts using slugs. Read `{baseDir}/references/theme-json.md` for options. Verify:
   ```bash
   bash {baseDir}/scripts/check-theme-json.sh .
   ```

4. **Create template parts**: Copy `{baseDir}/templates/parts/header.html` to `parts/header.html` and `{baseDir}/templates/parts/footer.html` to `parts/footer.html`. Edit block contents using `{baseDir}/references/block-markup.md`. Verify:
   ```bash
   bash {baseDir}/scripts/check-hex-colors.sh .
   ```

5. **Create `templates/index.html`**: Copy `{baseDir}/templates/templates/index.html` to `templates/index.html`. Verify part references:
   ```bash
   bash {baseDir}/scripts/check-part-refs.sh .
   ```

6. **Create additional templates**: Copy and adapt templates as requested:
   - `templates/front-page.html` from `{baseDir}/templates/templates/front-page.html`
   - `templates/single.html` from `{baseDir}/templates/templates/single.html`
   - `templates/page.html` from `{baseDir}/templates/templates/page.html`
   Verify part references:
   ```bash
   bash {baseDir}/scripts/check-part-refs.sh .
   ```

7. **Create patterns**: Copy `{baseDir}/templates/patterns/hero.php` to `patterns/hero.php`. Change `Title:` and `Slug:`. Verify colors:
   ```bash
   bash {baseDir}/scripts/check-hex-colors.sh .
   ```

8. **Final verification**: Run the full validation suite:
   ```bash
   bash {baseDir}/scripts/check-all.sh .
   ```
   If any check outputs `FAIL`, open `{baseDir}/references/troubleshooting.md`, apply the fix, and re-run.

## Reference Guides (Read only when needed)
- Directory layout: `{baseDir}/references/file-structure.md`
- theme.json schema & presets: `{baseDir}/references/theme-json.md`
- Block comment syntax & core blocks: `{baseDir}/references/block-markup.md`
- Templates vs parts vs patterns: `{baseDir}/references/templates-parts-patterns.md`
- PHP escaping & functions.php standards: `{baseDir}/references/php-security.md`
- Error fixes: `{baseDir}/references/troubleshooting.md`

## Verification Commands
- Check all: `bash {baseDir}/scripts/check-all.sh .`
- Check theme.json: `bash {baseDir}/scripts/check-theme-json.sh .`
- Check style.css: `bash {baseDir}/scripts/check-style-css.sh .`
- Check template parts: `bash {baseDir}/scripts/check-part-refs.sh .`
- Check hex colors: `bash {baseDir}/scripts/check-hex-colors.sh .`
- Check wp-env runtime: `bash {baseDir}/scripts/check-wp-env.sh .`
