# Quarto Workflow for Presentations

This repository now supports creating presentations with **Quarto + RevealJS**.

Use this workflow for new decks when you want:
- Markdown-first authoring
- cleaner collaboration in Git
- easier agent-assisted drafting and revision
- reliable rendering to browser-native slides

## Why Quarto here

Quarto keeps the editable source in a readable `index.qmd` file.
That makes it much easier to:
- inspect the narrative spine of a talk
- revise content without hand-editing large HTML files
- render, screenshot, inspect, and iterate
- mix text, code, equations, callouts, columns, and citations cleanly

This aligns with the workflow described in Alfredo Hernandez Suarez's post on Quarto talks.
The key idea is not just "use RevealJS".
It is "keep a clean source format that an agent and a human can both edit well".

## Repository convention for Quarto decks

For a Quarto-backed presentation, use this structure:

```text
presentation-name/
  index.qmd
  theme.scss
  speaker-notes.md        # optional
  index.html              # rendered output, commit this
  screenshots/            # ignored
```

Important:
- `index.qmd` is the source of truth
- `index.html` is the rendered artifact that the repo can serve directly
- `theme.scss` holds deck-level styling
- `speaker-notes.md` is optional working material for talks and rehearsal

## Local Quarto binary

This machine now has Quarto available at:

```bash
/home/hermes/.local/quarto/1.10.18/bin/quarto
```

The helper scripts in `scripts/` will use:
1. system `quarto` if present
2. otherwise the local binary above

## Helper scripts

### Create a new Quarto presentation scaffold

```bash
scripts/create-quarto-presentation.sh utm-ga4-banner-tracking "UTM Tracking for Banner Ads"
```

This creates a new directory with:
- `index.qmd`
- `theme.scss`
- `speaker-notes.md`

### Render a Quarto presentation

```bash
scripts/render-quarto-presentation.sh utm-ga4-banner-tracking
```

This renders `index.qmd` to `index.html`.

## Writing guidelines for Quarto decks

- Draft in `index.qmd`, not in `index.html`
- Prefer deleting content over shrinking everything to make a dense slide fit
- Vary slide rhythm with title slides, 2-column layouts, process slides, comparison slides, and sparse decision slides
- Keep one main point per slide
- Use browser-native features of RevealJS through Quarto rather than manually editing bulky generated HTML
- Render and inspect after meaningful edits

## Rendering and inspection loop

Recommended workflow:

```bash
# Render
scripts/render-quarto-presentation.sh <presentation-dir>

# Export slides to PDF + screenshots
cd <presentation-dir>
npx decktape reveal "file:///$(pwd)/index.html?export" output.pdf \
  --size 1600x900 \
  --pause 400 \
  --load-pause 1500 \
  --screenshots \
  --screenshots-directory screenshots/$(date +%Y%m%d_%H%M%S) \
  --chrome-arg=--no-sandbox
```

## Design defaults

The provided Quarto template uses:
- dark background
- light text
- accent blue, orange, green, and red
- left-aligned content
- 1600x900 layout
- embedded resources for portable HTML output

## Migration note

Existing presentations in this repo can stay as hand-authored RevealJS HTML.
New presentations should prefer Quarto unless there is a strong reason not to.
