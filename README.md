# WordPress Block Theme Development — Pi Agent Skill

[![Agent Skills Standard](https://img.shields.io/badge/standard-Agent%20Skills-blue.svg)](https://agentskills.io)
[![Target Model](https://img.shields.io/badge/optimized%20for-LFM3--1.7B%20%7C%20Small%20LLMs-success.svg)](https://liquid.ai)
[![WordPress](https://img.shields.io/badge/WordPress-6.x%20Full--Site%20Editing-21759B.svg)](https://wordpress.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An **Agent Skill** for [Pi (`@earendil-works/pi-coding-agent`)](https://github.com/earendil-works/pi) (see [pi.dev](https://pi.dev)) and other [Agent Skills](https://agentskills.io)-compatible coding assistants (such as Claude Code and Codex CLI). 

This skill instructs small local language models (specifically calibrated for **Liquid AI's LFM3-1.7B**, and equally effective on **Qwen 2.5 Coder 1.5B/3B** and **Llama 3.2 1B/3B**) to reliably build modern, standard-compliant **WordPress 6.x Block Themes** (`theme.json`, block templates, template parts, patterns, and `style.css`).

---

## The Challenge with Small Local Models

Local models with ~1.7B parameters typically struggle with full-site editing WordPress development:
- **Hallucinated Markup:** Inventing custom HTML wrappers or malformed block delimiters (`<!-- wp:... -->`).
- **Context Overload:** Complex instructions trigger attention dilution and instruction drift.
- **JSON Breakage:** Leaving trailing commas or comments in `theme.json`.
- **Styling Anti-Patterns:** Injecting hardcoded hex colors (`#ffffff`) into templates instead of utilizing WordPress design tokens (`var:preset|color|<slug>`).

---

## Architectural Highlights

This skill overcomes small model limitations through strict architectural constraints:

1. **Progressive Disclosure:** 
   - **Discovery:** Only ~30 tokens are loaded into the system prompt at startup (`name` and `description`).
   - **Activation:** The main [`SKILL.md`](wp-block-theme-development/SKILL.md) is under 85 lines (~820 tokens).
   - **Zero Idle Overhead:** Reference documentation, templates, and verification scripts remain on disk until needed.
2. **Strict "DO NOT" Guardrails:** Five explicit, non-negotiable negative constraints prevent common pitfalls before code generation starts.
3. **Copy-and-Adapt Over Generation:** Complete, production-grade starter templates (`theme.json` v3, `header.html`, `footer.html`, `index.html`, `front-page.html`, `hero.php`) are bundled so the model modifies working code instead of generating syntax from scratch.
4. **Deterministic Single-Action Workflow:** An 8-step recipe forces the model to work on one file at a time and stop to verify after each step.
5. **Instant Local Verification:** Bundled bash verification scripts provide automated, deterministic `PASS` or `FAIL` feedback directly to the model.

---

## Folder Structure

```text
.
├── README.md                             # Repository overview and instructions
├── CONTEXT_SIZE.md                       # Token consumption & benchmark analysis
└── wp-block-theme-development/           # The installable Pi skill package
    ├── SKILL.md                          # Active skill prompt (<85 lines, ~820 tokens)
    ├── references/                       # On-demand reference guides
    │   ├── file-structure.md             # Block theme folder hierarchy & file roles
    │   ├── theme-json.md                 # theme.json v3 specification & cheat sheet
    │   ├── block-markup.md               # Gutenberg block comment syntax & core blocks
    │   ├── templates-parts-patterns.md   # WP template hierarchy & component rules
    │   ├── php-security.md               # Escaping, prefixing & functions.php standards
    │   └── troubleshooting.md            # "If you see X, do Y" error correction table
    ├── templates/                        # Copy-and-adapt starter templates
    │   ├── style.css                     # Standard theme header metadata
    │   ├── theme.json                    # Minimal, valid theme.json v3
    │   ├── parts/
    │   │   ├── header.html               # Semantic header block markup
    │   │   └── footer.html               # Semantic footer block markup
    │   ├── templates/
    │   │   ├── index.html                # Mandatory fallback query loop template
    │   │   ├── front-page.html           # Homepage with pattern & query grid
    │   │   ├── single.html               # Single post layout
    │   │   └── page.html                 # Standard static page layout
    │   └── patterns/
    │       └── hero.php                  # Auto-registered pattern with DocBlock header
    └── scripts/                          # Automated verification suite (PASS/FAIL)
        ├── check-all.sh                  # Full verification runner
        ├── check-theme-json.sh           # Strict JSON syntax & version validator
        ├── check-style-css.sh            # Theme header validator
        ├── check-part-refs.sh            # Template-part reference integrity checker
        ├── check-hex-colors.sh           # Scans for forbidden hardcoded hex colors
        └── check-wp-env.sh               # Optional local runtime verification (wp-env)
```

---

## Installation

### Method 1: Global Installation for Pi (All Projects)
Clone or copy the `wp-block-theme-development` folder into your global Pi skills directory:

```bash
# Create the global skills directory if it does not exist
mkdir -p ~/.pi/agent/skills/

# Clone repository and link the skill
git clone https://github.com/your-username/skill-wordpress-block-theme.git /tmp/skill-wp
cp -r /tmp/skill-wp/wp-block-theme-development ~/.pi/agent/skills/
rm -rf /tmp/skill-wp
```

### Method 2: Project-Local Installation
To vendor the skill directly inside a WordPress theme repository:

```bash
cd /path/to/my-theme
mkdir -p .pi/skills/
cp -r /path/to/skill-wordpress-block-theme/wp-block-theme-development .pi/skills/
```

### Method 3: Cross-Agent Standard (`~/.agents/skills/`)
For universal compatibility across Pi, Claude Code, and Codex CLI:

```bash
mkdir -p ~/.agents/skills/
cp -r wp-block-theme-development ~/.agents/skills/
```

---

## How It Works

Once installed, Pi automatically detects the skill description. When you prompt the agent with a WordPress theme task, Pi activates the skill and dynamically replaces `{baseDir}` with the absolute path to `wp-block-theme-development`.

### The 8-Step Workflow
The agent executes the following steps in strict linear order:

1. **Scaffold Folder Structure:** Creates `parts/`, `templates/`, and `patterns/`.
2. **Scaffold `style.css`:** Copies the template and runs `scripts/check-style-css.sh`.
3. **Scaffold `theme.json`:** Copies the v3 template, adapts the color palette/typography, and runs `scripts/check-theme-json.sh`.
4. **Build Template Parts:** Copies and customizes `parts/header.html` and `parts/footer.html`, verifying with `scripts/check-hex-colors.sh`.
5. **Build `templates/index.html`:** Builds the fallback query loop and verifies with `scripts/check-part-refs.sh`.
6. **Build Additional Templates:** Adds `front-page.html`, `single.html`, or `page.html` as requested.
7. **Build Patterns:** Creates auto-registered PHP block patterns in `patterns/`.
8. **Final Full Suite Run:** Executes `scripts/check-all.sh` to ensure zero regressions.

---

## Verification Scripts

Each script is lightweight, self-contained (using standard Bash, `jq`, `python3`, or `node`), and outputs a clear, single-line decision:

| Script | Purpose | Output Format |
| :--- | :--- | :--- |
| `check-all.sh [dir]` | Executes the entire test suite in sequence | `PASS: All checks passed` / `FAIL` |
| `check-theme-json.sh [dir]` | Confirms valid JSON syntax and `"version": 2` or `3` | `PASS: theme.json is valid (version 3)` |
| `check-style-css.sh [dir]` | Validates required WordPress theme headers | `PASS: style.css header fields verified` |
| `check-part-refs.sh [dir]` | Ensures every `wp:template-part` references an existing file in `parts/` | `PASS: All referenced template parts exist in parts/` |
| `check-hex-colors.sh [dir]` | Greps `templates/`, `parts/`, and `style.css` for forbidden hex codes | `PASS: No hardcoded hex colors found` |
| `check-wp-env.sh [dir]` | *(Optional)* Starts `wp-env` and verifies HTTP 200 | `PASS: wp-env site running (HTTP 200)` / `SKIP` |

You can run the suite manually at any time:
```bash
./wp-block-theme-development/scripts/check-all.sh /path/to/theme
```

---

## Model Benchmark Prompts (Easy to Hard)

Use these 5 prompts to test whether your local 1.7B model follows instructions and runs the self-checks:

### Level 1 (Easy): Create a `theme.json` Palette
> *"Use the wp-block-theme-development skill. Copy the starter theme.json into my current directory. Edit the color palette to include only 4 colors: `base` (#ffffff), `contrast` (#1a1a1a), `primary` (#0d6efd), and `accent` (#ffc107). Verify the file using the check-theme-json script."*

### Level 2 (Easy-Medium): Header Template Part
> *"Use the wp-block-theme-development skill. Create `parts/header.html` containing a full-width header with a site-title block linked to home on the left and a core navigation block on the right. Do not use PHP. Do not use hardcoded hex colors. Verify using the check-hex-colors script."*

### Level 3 (Medium): Blog Index Template
> *"Use the wp-block-theme-development skill. In an existing theme folder that has `parts/header.html` and `parts/footer.html`, create `templates/index.html`. It must reference both template parts and display blog posts using the core query block with post-title (linked), post-date, and post-excerpt. Run the check-part-refs script to verify."*

### Level 4 (Medium-Hard): Auto-Registered CTA Pattern
> *"Use the wp-block-theme-development skill. Create a block pattern in `patterns/cta.php` for a theme with slug `minimal-press`. It must have Title 'Call to Action Banner', slug 'minimal-press/cta', categories 'banner', and be visible in the inserter. Inside, create a full-width group with a heading, paragraph, and a button using the 'primary' background color preset slug. Do not use hardcoded hex codes. Run check-hex-colors."*

### Level 5 (Hard): Full Minimal Portfolio Theme
> *"Use the wp-block-theme-development skill. Build a complete minimal block theme named 'folio-clean' (slug: `folio-clean`) from scratch. Follow the 8-step workflow strictly, working on one file at a time. The theme must include: `style.css`, `theme.json` (with base, contrast, primary colors), `parts/header.html`, `parts/footer.html`, `templates/index.html`, `templates/front-page.html`, `templates/single.html`, and `patterns/hero.php`. Run the check after each step, and run check-all.sh at the end. Fix any failure immediately."*

---

## Token Consumption Analysis

| Phase | Active Tokens | Notes |
| :--- | :--- | :--- |
| **Discovery** | **~30 tokens** | Only YAML frontmatter (`name` + `description`) registered |
| **Active Skill Run** | **~820 tokens** | Full `SKILL.md` prompt loaded into active context |
| **Per-Verification Output** | **~10–25 tokens** | Single-line stdout decision (`PASS:` / `FAIL:`) |

See [`CONTEXT_SIZE.md`](CONTEXT_SIZE.md) for full tokenizer specifications and calculation methodology.

---

## License

This project is licensed under the [MIT License](LICENSE) — feel free to use, modify, and distribute it in your personal and commercial workflows.
