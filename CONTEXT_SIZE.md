On the initial run, the coding agent loads **~800 tokens** actively into its context.

Because this skill is designed around **Progressive Disclosure**, the agent does *not* load the entire folder (references, starter templates, or scripts) into memory at once.

---

### Token Breakdown by Stage

| Stage | What Gets Loaded | Chars | Words | Estimated Tokens (128K BPE)* |
| :--- | :--- | :--- | :--- | :--- |
| **1. Discovery / Registration** *(Pi startup)* | Only YAML frontmatter (`name` + `description`) injected into system prompt | 142 | 16 | **~30 tokens** |
| **2. Initial Activation** *(When task triggers)* | Complete [`SKILL.md`](file:///home/saurabhdatta/Work/code/skill-wordpress-block-theme-for-pi-lfm3-1-7B-antigravity/SKILL.md) instructions | 3,846 | 416 | **~780 – 850 tokens** |
| **Total Active Context on Initial Run** | | | | **~810 – 880 tokens** |

*\*Note: Liquid AI’s LFM3 family uses a 128,000-token multilingual byte-level BPE tokenizer. For structured technical markdown with paths and backticks, the token-to-word ratio is approximately 1.8–2.0×.*

---

### Section-by-Section Breakdown of `SKILL.md`

```text
Section                                 Words    Chars    Est. Tokens
───────────────────────────────────────────────────────────────────────
Frontmatter (Metadata)                     16      142        ~30
Header & Critical DO NOT Rules             67      478       ~120
8-Step Workflow (Numbered steps & paths)  219    2,065       ~420
Reference Guides Index                     46      483       ~115
Verification Commands Summary              68      678       ~135
───────────────────────────────────────────────────────────────────────
Total SKILL.md                            416    3,846       ~820 tokens
```

---

### What Consumes 0 Tokens on Initial Run

The modular structure keeps heavy assets out of the model's active window until explicitly required:

1. **Reference Docs (`references/*.md`):** **0 tokens**  
   Files like [`theme-json.md`](file:///home/saurabhdatta/Work/code/skill-wordpress-block-theme-for-pi-lfm3-1-7B-antigravity/references/theme-json.md) and [`block-markup.md`](file:///home/saurabhdatta/Work/code/skill-wordpress-block-theme-for-pi-lfm3-1-7B-antigravity/references/block-markup.md) (~2,500 tokens combined) remain on disk. The agent reads a specific reference file only if it needs syntax details for a specific step.
2. **Templates (`templates/`):** **0 tokens**  
   Files are copied directly on the filesystem via shell commands (`cp`) rather than streamed through the agent's context window.
3. **Verification Scripts (`scripts/*.sh`):** **0 tokens**  
   The script source code is executed in bash. The agent's context window only receives the single-line stdout output:
   ```text
   PASS: theme.json is valid (version 3)   --> (~10 tokens added to conversation history)
   ```

---

### Impact on LFM3-1.7B Performance

- **Attention Retention:** Small 1.7B models suffer from attention dilution and instruction drift when system prompts exceed 1,500–2,000 tokens. Keeping the active skill prompt under **850 tokens** ensures the model retains all 5 "DO NOT" rules and follows the 8 steps in strict sequence.
- **Memory Footprint:** 850 tokens occupies less than **0.3%** of LFM3's 256K context limit, ensuring fast local time-to-first-token (TTFT) and minimal KV-cache memory pressure on edge hardware.
