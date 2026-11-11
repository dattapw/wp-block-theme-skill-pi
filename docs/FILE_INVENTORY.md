# Complete File Inventory

| Path | Role / Description |
| :--- | :--- |
| [README.md](README.md) | Project documentation, model benchmarks, installation instructions. |
| [CONTEXT_SIZE.md](CONTEXT_SIZE.md) | Token breakdown and analysis for small LLMs (e.g. LFM3-1.7B). |
| [LICENSE](LICENSE) | MIT License. |
| [wp-block-theme-development/SKILL.md](../wp-block-theme-development/SKILL.md) | Agent skill definition, DO NOT rules, 8-step workflow, command index. |
| **`scripts/`** | **Automated bash verification suite** |
| [check-all.sh](../wp-block-theme-development/scripts/check-all.sh) | Runner for all theme validation scripts. |
| [check-theme-json.sh](../wp-block-theme-development/scripts/check-theme-json.sh) | Validates JSON format and version (`>= 2`, typically 3) via `jq`, `node`, or `python3`. |
| [check-style-css.sh](../wp-block-theme-development/scripts/check-style-css.sh) | Verifies `Theme Name`, `Version`, and `Requires at least` headers. |
| [check-part-refs.sh](../wp-block-theme-development/scripts/check-part-refs.sh) | Ensures every `wp:template-part` slug has an existing HTML file in `parts/`. |
| [check-hex-colors.sh](../wp-block-theme-development/scripts/check-hex-colors.sh) | Scans templates, parts, and `style.css` to prevent hardcoded hex colors. |
| [check-wp-env.sh](../wp-block-theme-development/scripts/check-wp-env.sh) | Optional runtime verification running WordPress via Docker and `wp-env`. |
| **`templates/`** | **Copy-and-adapt starter files** |
| [style.css](../wp-block-theme-development/templates/style.css) | Standard theme header metadata stylesheet. |
| [theme.json](../wp-block-theme-development/templates/theme.json) | Complete valid v3 configuration with palettes, fonts, layout, and element styles. |
| [parts/header.html](../wp-block-theme-development/templates/parts/header.html) | Semantic header with `wp:site-title` and `wp:navigation`. |
| [parts/footer.html](../wp-block-theme-development/templates/parts/footer.html) | Semantic footer layout. |
| [templates/index.html](../wp-block-theme-development/templates/templates/index.html) | Required fallback template featuring query loop & pagination. |
| [templates/front-page.html](../wp-block-theme-development/templates/templates/front-page.html) | Homepage template incorporating pattern inclusion and post grid. |
| [templates/single.html](../wp-block-theme-development/templates/templates/single.html) | Single post layout with title, date, and content. |
| [templates/page.html](../wp-block-theme-development/templates/templates/page.html) | Standard static page layout. |
| [patterns/hero.php](../wp-block-theme-development/templates/patterns/hero.php) | Auto-registered block pattern with DocBlock metadata and CTA button. |
| **`references/`** | **On-demand technical references** |
| [file-structure.md](../wp-block-theme-development/references/file-structure.md) | Layout specifications and file placement rules. |
| [theme-json.md](../wp-block-theme-development/references/theme-json.md) | Schema v3 guide, presets, syntax, and settings reference. |
| [block-markup.md](../wp-block-theme-development/references/block-markup.md) | Gutenberg comment delimiters, void vs wrapper blocks, and code snippets. |
| [templates-parts-patterns.md](../wp-block-theme-development/references/templates-parts-patterns.md) | Differences, hierarchy rules, and embedding mechanisms. |
| [php-security.md](../wp-block-theme-development/references/php-security.md) | Prefixing, output escaping, standard `functions.php`, and security constraints. |
| [troubleshooting.md](../wp-block-theme-development/references/troubleshooting.md) | Diagnostic reference table ("If You See X, Do Y"). |