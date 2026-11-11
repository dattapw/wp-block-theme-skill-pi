# theme.json Cheat Sheet

WordPress 6.x uses `theme.json` to define design tokens (`settings`) and apply default styling (`styles`).

## Version
- Use `"version": 3` for WordPress 6.6+ (current standard).
- Use `"version": 2` for WordPress 5.8 through 6.5.
- Always include `"$schema": "https://schemas.wp.org/trunk/theme.json"`.

## Preset Syntax Rule
When referencing tokens in `styles` or in block markup attributes:
- Format: `var:preset|<category>|<slug>`
- Examples:
  - Color: `var:preset|color|primary`
  - Font Size: `var:preset|font-size|medium`
  - Spacing: `var:preset|spacing|50`

## Settings Reference
- `settings.appearanceTools`: Set to `true` to enable padding, margin, border, and line-height controls in the block editor.
- `settings.layout`:
  - `contentSize`: Default reading width (e.g., `"800px"`).
  - `wideSize`: Wide block alignment width (e.g., `"1200px"`).
- `settings.color.palette`: Array of `{ "slug": "name", "color": "#hex", "name": "Label" }`.
- `settings.typography.fontSizes`: Array of `{ "slug": "name", "size": "1rem", "name": "Label" }`.
- `settings.typography.fontFamilies`: Array of `{ "slug": "name", "fontFamily": "font-stack", "name": "Label" }`.
- `settings.spacing.spacingSizes`: Array of spacing tokens (optional).

## Styles Reference
- `styles.color.background`: Root background color token.
- `styles.color.text`: Root text color token.
- `styles.typography.fontFamily`: Root font family token.
- `styles.typography.fontSize`: Root font size token.
- `styles.elements.link`: Link element styles (`color.text`, `:hover.color.text`).
- `styles.elements.heading`: Heading element styles (`typography.fontWeight`, `color.text`).
- `styles.blocks."core/button"`: Block-specific overrides.

## Complete Minimal theme.json (Version 3)
```json
{
  "$schema": "https://schemas.wp.org/trunk/theme.json",
  "version": 3,
  "settings": {
    "appearanceTools": true,
    "layout": {
      "contentSize": "800px",
      "wideSize": "1200px"
    },
    "color": {
      "defaultPalette": false,
      "palette": [
        {
          "slug": "base",
          "color": "#ffffff",
          "name": "Base / White"
        },
        {
          "slug": "contrast",
          "color": "#111827",
          "name": "Contrast / Dark"
        },
        {
          "slug": "primary",
          "color": "#2563eb",
          "name": "Primary Blue"
        },
        {
          "slug": "secondary",
          "color": "#475569",
          "name": "Secondary Slate"
        },
        {
          "slug": "accent",
          "color": "#f59e0b",
          "name": "Accent Amber"
        }
      ]
    },
    "typography": {
      "fontFamilies": [
        {
          "slug": "body",
          "fontFamily": "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif",
          "name": "System Sans"
        },
        {
          "slug": "heading",
          "fontFamily": "Georgia, Cambria, 'Times New Roman', Times, serif",
          "name": "System Serif"
        }
      ],
      "fontSizes": [
        {
          "slug": "small",
          "size": "0.875rem",
          "name": "Small"
        },
        {
          "slug": "medium",
          "size": "1rem",
          "name": "Medium"
        },
        {
          "slug": "large",
          "size": "1.5rem",
          "name": "Large"
        },
        {
          "slug": "x-large",
          "size": "2.25rem",
          "name": "X-Large"
        }
      ]
    }
  },
  "styles": {
    "color": {
      "background": "var:preset|color|base",
      "text": "var:preset|color|contrast"
    },
    "typography": {
      "fontFamily": "var:preset|font-family|body",
      "fontSize": "var:preset|font-size|medium",
      "lineHeight": "1.6"
    },
    "elements": {
      "link": {
        "color": {
          "text": "var:preset|color|primary"
        }
      },
      "heading": {
        "color": {
          "text": "var:preset|color|contrast"
        },
        "typography": {
          "fontFamily": "var:preset|font-family|heading",
          "fontWeight": "700"
        }
      }
    }
  }
}
```

## Strict Rules
1. JSON strings must use double quotes `"` only. Never single quotes `'`.
2. Do not leave a trailing comma after the last property or array item.
3. No comment lines (`//` or `/* */`).
