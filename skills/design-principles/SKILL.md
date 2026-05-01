---
name: design-principles
description: >
  Apply universal design principles when designing UI, documents, presentations, dashboards,
  or any user-facing content. Use this skill for layout decisions, visual hierarchy, typography,
  color usage, component structure, or design critique — regardless of brand or medium.
  Trigger on: "design this", "critique this design", "how should I lay this out", "visual hierarchy",
  "make this cleaner", "design feedback", or any request to design or evaluate a visual artifact.
---

# Design Principles Skill

Design plays a crucial role in helping people understand and act on information. When designing anything — a UI, document, presentation, or dashboard — apply all five principles below. They are equally important and often interact.

---

## The Five Principles

### 1. Focus on What Matters — Remove Clutter
**Goal:** Help the audience make sense of information by eliminating distraction.

**In practice:**
- Strip every element that doesn't serve a direct comprehension or action purpose
- Reduce the number of steps, clicks, or modals required to accomplish tasks
- Use typography, color, and layout to guide attention — not decorate
- Ask: "Does this element help the user understand or act? If not, remove it."
- Prefer inline interactions and inline information over popups and overlays wherever possible

**Watch out for:** Feature creep, excessive labeling, redundant controls, decorative borders or shadows that add no information, explanatory text that repeats what a well-designed layout already communicates.

---

### 2. Balance Flexibility and Excellent Outcomes
**Goal:** Let users personalize their experience while preventing poor decisions or substandard results.

**In practice:**
- Apply defensive design: anticipate errors and make it hard to produce bad outputs
- Enforce guardrails (warn before destructive operations, validate inputs, set safe defaults)
- Design holistic solutions that address multiple needs — avoid one-off features or edge-case patches
- Provide customization options, but always optimize toward the best default outcome
- Constrain choices intelligently (curated presets, smart defaults) rather than exposing every raw option

**Watch out for:** Giving users so much flexibility that they produce incorrect or misleading outputs; feature additions that serve only one narrow use case; missing guardrails on irreversible actions.

---

### 3. Unfold Complexity Gradually
**Goal:** Make the first step easy; let advanced users discover more over time.

**In practice:**
- Lead with the core action or insight — advanced options come later (collapsed, in a secondary panel, or behind a disclosure)
- Design flows that introduce one concept at a time
- Use familiar terminology before introducing domain-specific concepts
- Only introduce new terminology when it's essential to the value being delivered
- Tailor progressive disclosure per audience: a first-time user gets a simpler surface than an expert

**Watch out for:** Showing every configuration option upfront; using jargon without explanation; overwhelming new users with empty states that require expertise to act on; hiding the primary path behind secondary options.

---

### 4. Encourage Direct Interaction
**Goal:** Empower users to learn and experiment by interacting with content directly — not through intermediaries.

**In practice:**
- Make surfaces directly interactive where possible — click to act, drag to reorder, inline edit
- Provide safe sandbox environments for experimentation without consequence
- Give clear, immediate feedback for every interaction (highlight affected areas, confirm applied changes)
- Make the impact of changes transparent: show before/after, undo paths, or contextual confirmations
- Lower the cost of experimentation so users build confidence

**Watch out for:** Actions that require users to open a separate config panel to do something they could do directly; feedback that's delayed, ambiguous, or buried; no undo for consequential actions.

---

### 5. Optimize for Information Density
**Goal:** Present information densely but clearly so users can compare and decide with confidence.

**In practice:**
- Default to compact, information-rich layouts for content-heavy surfaces
- Use whitespace deliberately and sparingly — to create hierarchy and focus attention, not as decoration
- Avoid wasting vertical/horizontal space on padding, large headers, or empty states when content is present
- Enable side-by-side comparisons naturally within the layout
- Support scanning: use consistent alignment, subtle grid lines, and clear typographic hierarchy

**Watch out for:** Overly spacious layouts that show little information per screen; inconsistent column widths; content without reference lines or comparative context; padding that crowds out the actual content.

---

## Color Guidelines

**Functional, not decorative**
- Color should encode meaning: status, category, magnitude, or hierarchy — never applied purely for aesthetics
- Use a restrained palette: 1–2 neutrals for structure, 1 primary action color, a small semantic set (success, warning, error, info)
- Colors used for categorical distinctions must be perceptually distinct and accessible (WCAG AA minimum); avoid red/green as the only differentiator

**Hierarchy through contrast**
- High contrast for primary content values; subdued tones for metadata, labels, and supporting chrome
- Backgrounds should recede — avoid competing with the content surface
- Avoid gradients on functional elements; reserve them for illustrative or decorative contexts

**Density-aware color usage**
- In dense layouts, prefer subtle alternating row shading over heavy borders
- Use color sparingly in dense views — a single accent draws the eye; multiple accents create noise

---

## Typography Guidelines

**Clarity over character**
- Choose type that is highly legible at small sizes — labels and captions often render at 12–13px
- Use a single typeface family with weight and size variation to create hierarchy (avoid mixing multiple typefaces)
- Use tabular-figure (monospaced) numerals for any column of numbers so digits align vertically

**Scale and hierarchy**
- Establish a clear, minimal type scale: title → section header → label → body → caption
- The primary content (the thing users came to read) should be visually dominant over labels and chrome
- Reduce label prominence: lighter weight, smaller size, or muted color — labels support content, they don't compete with it

**Density considerations**
- Line height in dense layouts should be compact but not cramped — enough to distinguish rows, not so much that fewer items fit per screen
- Avoid all-caps for long labels; use sentence case or title case for readability at small sizes
- Left-align text, right-align numbers — always, without exception in tabular layouts

---

## How to Apply These Principles

When designing any artifact, work through this checklist mentally:

1. **Clutter check** — What can I remove? Can I reduce a step or layer?
2. **Guardrails check** — Can a user make a bad mistake here? What's the defensive design?
3. **Complexity check** — Is the simplest path obvious? Is advanced functionality appropriately deferred?
4. **Interaction check** — Can the user act directly, or are they forced through indirection?
5. **Density check** — Is the layout using space efficiently? Can users compare what they need to?

---

## Output Format

When applying this skill to a design task, structure your response as:
1. **Design recommendation** — the concrete proposal
2. **Principle alignment** — briefly note which principles drove the key decisions
3. **Trade-offs** — flag any tension between principles and how you resolved it

When critiquing an existing design, note which principles are being violated and suggest specific fixes.
