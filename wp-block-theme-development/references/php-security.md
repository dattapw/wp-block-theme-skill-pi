# PHP Standards and Security

Block themes minimize PHP. PHP belongs only in `functions.php` and `patterns/*.php`.

## Prefixing Rule
Avoid naming collisions by prefixing every function, hook, handle, and global variable with your theme slug.
- If theme slug is `minimalist`:
  - Functions: `minimalist_setup()`, `minimalist_enqueue_scripts()`
  - Constants: `MINIMALIST_VERSION`
  - Style/script handles: `wp_enqueue_style( 'minimalist-custom', ... )`

## Escaping Rules
Never output raw variables in PHP. Use the correct escaping function:

| Output Context | Function | Example |
| :--- | :--- | :--- |
| Plain text inside HTML tags | `esc_html()` | `echo esc_html( $title );` |
| Text inside HTML attribute | `esc_attr()` | `<input value="<?php echo esc_attr( $val ); ?>">` |
| URL in `href`, `src`, or redirect | `esc_url()` | `<a href="<?php echo esc_url( $url ); ?>">` |
| HTML markup (headings, links) | `wp_kses_post()` | `echo wp_kses_post( $content );` |
| Localized plain text | `esc_html__()` | `echo esc_html__( 'Hello', 'my-theme' );` |
| Localized attribute | `esc_attr__()` | `title="<?php echo esc_attr__( 'Search', 'my-theme' ); ?>"` |

---

## Standard functions.php Template
If your theme needs custom stylesheet enqueuing or theme support, use this template:

```php
<?php
/**
 * Functions and definitions for My Theme.
 *
 * @package My_Theme
 */

if ( ! defined( 'ABSPATH' ) ) {
    exit; // Exit if accessed directly.
}

/**
 * Enqueue theme assets.
 */
function my_theme_scripts() {
    wp_enqueue_style(
        'my-theme-style',
        get_stylesheet_uri(),
        array(),
        wp_get_theme()->get( 'Version' )
    );
}
add_action( 'wp_enqueue_scripts', 'my_theme_scripts' );
```

## Strict Security Rules
1. Never execute raw SQL queries; use WordPress API (`WP_Query`).
2. Never access superglobals (`$_POST`, `$_GET`) without sanitizing (`sanitize_text_field()`) and verifying nonces (`wp_verify_nonce()`).
3. Never use `eval()` or `exec()`.
4. Never include PHP inside `.html` files in `parts/` or `templates/`.
