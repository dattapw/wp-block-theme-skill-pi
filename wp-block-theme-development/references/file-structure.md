# Block Theme File Structure

## Standard Directory Layout
Every WordPress 6.x block theme follows this layout:

```text
my-theme/
├── style.css                  # REQUIRED: Theme header metadata & optional global CSS
├── theme.json                 # REQUIRED: Design tokens, block settings, & global styles
├── functions.php              # OPTIONAL: PHP hooks, script/style enqueuing, custom functions
├── screenshot.png             # OPTIONAL: 1200x900 theme preview image in WP admin
├── parts/                     # REQUIRED: Reusable layout parts (.html only)
│   ├── header.html            # Site header part
│   └── footer.html            # Site footer part
├── templates/                 # REQUIRED: Full page block templates (.html only)
│   ├── index.html             # REQUIRED: Ultimate fallback template
│   ├── front-page.html        # Site homepage (optional)
│   ├── single.html            # Single blog post (optional)
│   ├── page.html              # Single page (optional)
│   ├── archive.html           # Archive/category listing (optional)
│   └── 404.html               # 404 Not Found page (optional)
└── patterns/                  # OPTIONAL: Block patterns (.php only)
    └── hero.php               # Auto-registered block pattern
```

## What Belongs Where

| File / Folder | Permitted File Types | Role |
| :--- | :--- | :--- |
| `style.css` | `.css` | Theme identification header (Theme Name, Author, Version). |
| `theme.json` | `.json` | Global settings (colors, typography, spacing) and styles. |
| `parts/` | `.html` ONLY | Header, footer, and sidebar partials included by templates. |
| `templates/` | `.html` ONLY | Full page layouts matching WordPress template hierarchy. |
| `patterns/` | `.php` ONLY | Pre-designed block layouts auto-registered in the block inserter. |
| `functions.php` | `.php` ONLY | Enqueue custom scripts, register block styles or PHP filters. |

## Strict Rules
1. Never put `.html` files in the theme root. They must be inside `parts/` or `templates/`.
2. Never put `.php` files in `templates/` or `parts/`.
3. `templates/index.html` is the only mandatory template. WordPress will not recognize a block theme without `style.css` and `templates/index.html`.
