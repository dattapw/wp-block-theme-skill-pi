# Block Markup Rules

WordPress parses block content from HTML comments with a `wp:` prefix.

## Comment Syntax Rules
1. Core blocks omit the `core/` prefix in the comment delimiter:
   - Use `<!-- wp:group -->`, NOT `<!-- wp:core/group -->`.
2. Blocks with inner content require opening and closing delimiters:
   ```html
   <!-- wp:group {"layout":{"type":"constrained"}} -->
   <div class="wp-block-group">
       <!-- inner blocks here -->
   </div>
   <!-- /wp:group -->
   ```
3. Void (self-closing) blocks have no inner HTML and end with `/-->`:
   ```html
   <!-- wp:post-title {"level":1} /-->
   ```
4. Block attributes must be valid JSON in the opening comment.

---

## Block Name to Required Markup Table

| Block Name | Void? | Delimiter & Required Wrapper |
| :--- | :--- | :--- |
| `group` | No | `<!-- wp:group {"layout":{"type":"constrained"}} -->`<br>`<div class="wp-block-group">...</div>`<br>`<!-- /wp:group -->` |
| `columns` | No | `<!-- wp:columns -->`<br>`<div class="wp-block-columns">...</div>`<br>`<!-- /wp:columns -->` |
| `column` | No | `<!-- wp:column -->`<br>`<div class="wp-block-column">...</div>`<br>`<!-- /wp:column -->` |
| `query` | No | `<!-- wp:query {"queryId":1,"query":{"perPage":10,"pages":0,"offset":0,"postType":"post","order":"desc","orderBy":"date","author":"","search":"","exclude":[],"sticky":"","inherit":true}} -->`<br>`<div class="wp-block-query">...</div>`<br>`<!-- /wp:query -->` |
| `post-template` | No | `<!-- wp:post-template -->`<br>`<!-- /wp:post-template -->` (Inside `wp:query`) |
| `query-pagination` | No | `<!-- wp:query-pagination -->`<br>`<!-- wp:query-pagination-previous /-->`<br>`<!-- wp:query-pagination-numbers /-->`<br>`<!-- wp:query-pagination-next /-->`<br>`<!-- /wp:query-pagination -->` |
| `post-title` | Yes | `<!-- wp:post-title {"isLink":true} /-->` |
| `post-content` | Yes | `<!-- wp:post-content {"layout":{"type":"constrained"}} /-->` |
| `post-date` | Yes | `<!-- wp:post-date /-->` |
| `post-excerpt` | Yes | `<!-- wp:post-excerpt /-->` |
| `site-title` | Yes | `<!-- wp:site-title {"level":1} /-->` |
| `navigation` | No/Yes| `<!-- wp:navigation {"layout":{"type":"flex","setCascadingProperties":true,"justifyContent":"right"}} /-->` |
| `template-part`| Yes | `<!-- wp:template-part {"slug":"header","tagName":"header"} /-->` |
| `pattern` | Yes | `<!-- wp:pattern {"slug":"theme-slug/pattern-slug"} /-->` |
| `buttons` | No | `<!-- wp:buttons -->`<br>`<div class="wp-block-buttons">...</div>`<br>`<!-- /wp:buttons -->` |
| `button` | No | `<!-- wp:button {"backgroundColor":"primary"} -->`<br>`<div class="wp-block-button"><a class="wp-block-button__link has-primary-background-color has-background wp-element-button">Click</a></div>`<br>`<!-- /wp:button -->` |
| `image` | No | `<!-- wp:image {"sizeSlug":"large"} -->`<br>`<figure class="wp-block-image size-large"><img src="..." alt="..."/></figure>`<br>`<!-- /wp:image -->` |
| `heading` | No | `<!-- wp:heading {"level":2} -->`<br>`<h2 class="wp-block-heading">Heading</h2>`<br>`<!-- /wp:heading -->` |
| `paragraph` | No | `<!-- wp:paragraph -->`<br>`<p>Text</p>`<br>`<!-- /wp:paragraph -->` |

---

## Copy-and-Paste Block Snippets

### 1. Group with Constrained Width
```html
<!-- wp:group {"layout":{"type":"constrained"}} -->
<div class="wp-block-group">
    <!-- wp:paragraph -->
    <p>Constrained content goes here.</p>
    <!-- /wp:paragraph -->
</div>
<!-- /wp:group -->
```

### 2. Group Full Width with Inner Container
```html
<!-- wp:group {"align":"full","layout":{"type":"constrained"}} -->
<div class="wp-block-group alignfull">
    <!-- Inner blocks span within contentSize -->
</div>
<!-- /wp:group -->
```

### 3. Two Columns Layout
```html
<!-- wp:columns -->
<div class="wp-block-columns">
    <!-- wp:column -->
    <div class="wp-block-column">
        <!-- wp:paragraph -->
        <p>Column 1</p>
        <!-- /wp:paragraph -->
    </div>
    <!-- /wp:column -->

    <!-- wp:column -->
    <div class="wp-block-column">
        <!-- wp:paragraph -->
        <p>Column 2</p>
        <!-- /wp:paragraph -->
    </div>
    <!-- /wp:column -->
</div>
<!-- /wp:columns -->
```

### 4. Query Loop for Blog Posts (Inherits Main Query)
```html
<!-- wp:query {"queryId":1,"query":{"perPage":10,"pages":0,"offset":0,"postType":"post","order":"desc","orderBy":"date","author":"","search":"","exclude":[],"sticky":"","inherit":true}} -->
<div class="wp-block-query">
    <!-- wp:post-template -->
        <!-- wp:post-title {"isLink":true} /-->
        <!-- wp:post-date /-->
        <!-- wp:post-excerpt /-->
    <!-- /wp:post-template -->

    <!-- wp:query-pagination {"layout":{"type":"flex","justifyContent":"space-between"}} -->
        <!-- wp:query-pagination-previous /-->
        <!-- wp:query-pagination-numbers /-->
        <!-- wp:query-pagination-next /-->
    <!-- /wp:query-pagination -->
</div>
<!-- /wp:query -->
```

### 5. Buttons
```html
<!-- wp:buttons {"layout":{"type":"flex","justifyContent":"center"}} -->
<div class="wp-block-buttons">
    <!-- wp:button {"backgroundColor":"primary"} -->
    <div class="wp-block-button"><a class="wp-block-button__link has-primary-background-color has-background wp-element-button">Learn More</a></div>
    <!-- /wp:button -->
</div>
<!-- /wp:buttons -->
```
