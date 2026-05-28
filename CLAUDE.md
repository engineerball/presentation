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

### Established design tokens (harness-engineering reference)

| Variable | Value |
|---|---|
| `--background-color` | `#0D1117` |
| `--primary-color` (red/danger) | `#E33737` |
| `--secondary-color` (orange/warn) | `#F08800` |
| `--accent-green` | `#3FB950` |
| `--accent-blue` | `#58A6FF` |
| Fonts | Inter + JetBrains Mono (Google Fonts) |

