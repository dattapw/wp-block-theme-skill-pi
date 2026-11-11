# Templates vs Template Parts vs Patterns

## Decision Matrix: When to Use What

| Feature | Templates (`templates/`) | Template Parts (`parts/`) | Patterns (`patterns/`) |
| :--- | :--- | :--- | :--- |
| **Purpose** | Defines entire page structure | Reusable global structural regions | Reusable content layouts |
| **File Extension**| `.html` only | `.html` only | `.php` with DocBlock header |
| **Examples** | `index.html`, `single.html` | `header.html`, `footer.html` | `hero.php`, `pricing.php` |
| **User Editing** | Modifies page layout | Changes apply across whole site | Independent copy inserted into post/page |
| **PHP Allowed?** | NO | NO | YES (DocBlock header + optional i18n) |

---

## 1. Templates (`templates/*.html`)

Templates control the entire layout of a page.

### Required Naming Convention (WordPress Hierarchy)
- `index.html`: MANDATORY. Fallback for every view.
- `front-page.html`: Used for the site front page.
- `single.html`: Used for single blog posts.
- `page.html`: Used for static WordPress pages.
- `archive.html`: Used for category, tag, author, or date archives.
- `404.html`: Used when a page or URL is not found.

### Anatomy of a Template
A template combines template parts and core blocks:
```html
<!-- wp:template-part {"slug":"header","tagName":"header"} /-->

<!-- wp:group {"tagName":"main","layout":{"type":"constrained"}} -->
<main class="wp-block-group">
    <!-- wp:post-title /-->
    <!-- wp:post-content /-->
</main>
<!-- /wp:group -->

<!-- wp:template-part {"slug":"footer","tagName":"footer"} /-->
```

---

## 2. Template Parts (`parts/*.html`)

Template parts are global areas included by multiple templates. When edited in the Site Editor, the change reflects on all templates using that part.

### Naming Rules
- Use lowercase alphanumeric characters and hyphens: `header.html`, `footer.html`, `sidebar.html`.
- The `slug` in the block comment MUST match the filename without `.html`:
  `parts/header.html` -> `{"slug":"header"}`

### Inclusion Syntax
```html
<!-- wp:template-part {"slug":"header","tagName":"header"} /-->
<!-- wp:template-part {"slug":"footer","tagName":"footer"} /-->
```

---

## 3. Patterns (`patterns/*.php`)

Patterns are pre-built block arrangements that users insert via the block inserter, or that templates embed directly.

### File Header (Required)
Every file in `patterns/` MUST begin with a PHP DocBlock header:
```php
<?php
/**
 * Title: Hero Section
 * Slug: my-theme/hero
 * Categories: featured, banner
 * Inserter: yes
 */
?>
<!-- wp:group {"align":"full","layout":{"type":"constrained"}} -->
<div class="wp-block-group alignfull">
    <!-- wp:heading {"level":1} -->
    <h1 class="wp-block-heading">Welcome</h1>
    <!-- /wp:heading -->
</div>
<!-- /wp:group -->
```

### Embedding a Pattern in a Template
To embed an auto-registered pattern directly into a template:
```html
<!-- wp:pattern {"slug":"my-theme/hero"} /-->
```
The slug in the comment MUST match the `Slug:` declared in the pattern's DocBlock header.
