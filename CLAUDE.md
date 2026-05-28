# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Collection of standalone Reveal.js presentations. No build step — open any `index.html` in a browser. Each subdirectory is a self-contained presentation with its own `index.html` and `styles.css`.

## Creating/Editing Presentations

Always invoke the `revealjs:revealjs` skill before doing any presentation work — it contains the full workflow.

**When creating a new presentation:** after the presentation is complete, add a card for it in `/index.html`. Match the existing card pattern — pick the appropriate tag color (`tag-eng`, `tag-gcp`, `tag-ml`, `tag-data`, `tag-finops`) and write a one-line description.


### Common commands

```bash
# Generate HTML scaffold
node <skill-scripts>/create-presentation.js --structure 1,d,3,1 --title "Title" --output index.html

# Check for content overflow
node <skill-scripts>/check-overflow.js index.html

# Capture screenshots of all slides
cd <presentation-dir>
npx decktape reveal "index.html?export" output.pdf \
  --screenshots \
  --screenshots-directory "screenshots/$(date +%Y%m%d_%H%M%S)"

# In-browser text editor
node <skill-scripts>/edit-html.js <presentation-dir>/index.html
```

## Architecture

Each presentation follows this pattern:
- `index.html` — slides using Reveal.js 5.1.0 from CDN; all slides are flat (horizontal-only, no vertical stacks)
- `styles.css` — CSS variables for colors/fonts, component classes (`.card`, `.warning-box`, etc.)
- `speaker-notes.md` — optional per-slide timing and talking points (not loaded by Reveal.js, just reference doc)
- `screenshots/` — timestamped directories of slide PNGs captured via decktape

### CSS conventions

- Font sizes always in `pt` (not `px`/`em`/`rem`)
- Theme via CSS variables in `:root` — change colors there, not inline
- Dark background (`#0D1117`) with light text (`#E6EDF3`) is the established pattern
- Section dividers use `class="section-divider" data-state="is-section-divider"` for darker background
- Grid layouts use inline `style="display: grid; ..."` — not utility classes
- All visible text goes in `<p>`, `<li>`, or heading tags — never bare in `<div>`/`<span>`

## Advanced Features

These are opt-in per presentation. See `harness-engineering/index.html` as the reference implementation.

### CDN additions

In `<head>`:
```html
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/5.1.0/plugin/highlight/monokai.min.css">
```

Before `</body>`, after `reveal.min.js`:
```html
<script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/5.1.0/plugin/highlight/highlight.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/5.1.0/plugin/math/math.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
```

### Reveal.initialize() additions

```javascript
plugins: [ ..., RevealHighlight, RevealMath.MathJax3 ],
highlight: { highlightOnLoad: true },
math: { mathjax: 'https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js' },
```

After `Reveal.initialize()`:
```javascript
mermaid.initialize({ startOnLoad: false, theme: 'dark', darkMode: true });
Reveal.on('ready', () => mermaid.run());
Reveal.on('slidechanged', () => mermaid.run());
```

### Usage

**Syntax-highlighted code block:**
```html
<pre><code data-trim class="language-python">
def hello(): return "world"
</code></pre>
```

**Interactive code storytelling** (arrow keys step through highlights):
```html
<pre><code data-trim data-line-numbers="1|3-5|7" class="language-javascript">
// each | is one arrow-key step
</code></pre>
```

**LaTeX math:**
```html
<p>Inline: \( E = mc^2 \)</p>
<p>Block: \[ \sum_{i=1}^{n} x_i \]</p>
```

**Mermaid diagram:**
```html
<div class="mermaid">
graph TD
    A[Start] --> B{Decision}
    B -->|Yes| C[Done]
</div>
```

### Established design tokens (harness-engineering reference)

| Variable | Value |
|---|---|
| `--background-color` | `#0D1117` |
| `--primary-color` (red/danger) | `#E33737` |
| `--secondary-color` (orange/warn) | `#F08800` |
| `--accent-green` | `#3FB950` |
| `--accent-blue` | `#58A6FF` |
| Fonts | Inter + JetBrains Mono (Google Fonts) |

