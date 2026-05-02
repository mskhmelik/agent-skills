---
name: [local-skill]
description: >
  Turn an Upwork brief into a shareable 3-slide HTML proposal deck saved to the Desktop.
  Use when the user pastes a brief, shares a screenshot, or provides an Upwork URL.
  Trigger on: "/[local-skill]", "create a plan for this brief", "analyze this upwork brief",
  "make a plan for this job", "plan this opportunity", or any pasted Upwork job description.
argument-hint: "[upwork_url or paste brief text]"
---

# Upwork Plan Skill

Turn a raw Upwork brief into a **3-slide fullscreen HTML proposal deck** saved to Desktop.
Each slide fills 100vh — no scrolling within a slide. Navigate with keyboard arrows or dot nav.

Output: `~/Desktop/YYMMDD-opp-slug-plan.html`

---

## Contractor Profile

Use throughout — matching requirements, writing fit bullets, drafting screening answers.

```
Headline: Former strategy consultant who builds AI automation systems for
professional services and operations teams.

What I've shipped:
- End-to-end lead enrichment and warmup pipelines for a Series D SaaS
  (Claude, LinkedIn, ZoomInfo, Outreach, Sumble)
- Took a robotics startup from zero to €200K ARR — built the full sales operation:
  HubSpot CRM, lead gen, partnerships, first enterprise deals
- Generated £2M+ in new revenue for a global consultancy — pitched and delivered
  data analytics to FTSE 100 teams

What I build:
- AI workflow automation (n8n, Make, Claude API)
- Lead generation and CRM systems
- Voice AI and internal ops tooling (Vapi, Claude API)
- Custom internal dashboards and data pipelines (Python, SQL)

Differentiators:
- Consultant background — understands the business problem, not just the tech
- Ships v1 fast from fuzzy goals; no 10-page spec needed
- Solo contractor — one person who designs, builds, and owns the work
- Uses Claude Code and AI tools as daily drivers
```

---

## Workflow

### Step 0 — Get the brief

- If `$ARGUMENTS` starts with `https://`: fetch with WebFetch. If page returns login wall or empty content, tell user: *"Upwork requires login — open in Chrome, paste the text directly."* Stop.
- If user message contains an image: read visually, extract brief text.
- If user message contains pasted text: use that.
- If none: ask for brief.

### Step 1 — Extract metadata

Parse from brief:
- **Title**: stated or inferred (e.g. "Automation Engineer – Monthly Retainer")
- **Budget / rate**: mark `Not stated` if absent
- **Engagement type**: hourly / monthly retainer / fixed-price
- **Timezone / location preference**
- **Screening questions**: capture verbatim if present

### Step 2 — Design Slide 1 diagram

Identify from the brief:
- **Input nodes**: data sources, triggers, tools client already uses (APIs, Sheets, webhooks, cron)
- **Processing nodes**: what happens to the data (AI enrichment, scoring, dedup, orchestration)
- **Output nodes**: where results land (CRM, outreach tool, dashboard, Sheets, Slack)

Generate a `flowchart LR` Mermaid diagram with 3 subgraphs:
```
subgraph IN["📥  Inputs"]     direction TB  — data sources, triggers
subgraph PROC["⚙️  Processing"] direction LR  — pipeline steps left-to-right
subgraph OUT["📤  Outputs"]   direction TB  — destinations
```

Edges: `IN nodes --> first PROC node`, `last PROC node -->|label| OUT nodes`, error branch from processing to dead-letter.

Every node uses HTML label (flex icon + two-line text):
```
NODE["<div style='display:flex;align-items:center;gap:9px;padding:3px 2px'>
  <span style='font-size:1.4em;flex-shrink:0;line-height:1'>EMOJI</span>
  <div>
    <div style='font-weight:700;color:#58a6ff;font-size:12px;font-family:Inter,system-ui,sans-serif;text-align:left;line-height:1.3'>Title</div>
    <div style='color:#8b949e;font-size:10.5px;font-family:Inter,system-ui,sans-serif;text-align:left;line-height:1.3'>Subtitle</div>
  </div>
</div>"]
```

### Step 3 — Design Slide 2 plan steps

Generate 5–6 steps **specific to this brief**. Philosophy: discover fast → build v1 → get feedback early → deploy to prod for real value → then improve, support, educate. Not waterfall.

Template per step:
- Emoji + short name (2–3 words) + time estimate
- 3 bullets: what you'd *specifically* do for this project (name their tools, their data, their pain points)

Default arc (adapt names/content to brief):
1. 🔍 **Audit & Scope** — understand current state, identify highest-value pipeline first
2. 🏗️ **Design** — data contracts, error branches, orchestration choice before any code
3. 🔧 **Build v1** — implement core pipeline, first real output to prod
4. 🔗 **Wire outputs** — connect CRM / outreach / dashboard layer
5. 🧪 **Harden** — retries, dead-letter, alerts, edge cases
6. 🔄 **Ship & Iterate** — deploy, monitor, weekly async updates, monthly scope calls

### Step 4 — Write Slide 3 fit bullets

3–5 bullets. Format:
> *"[exact quote from brief]"* → [concrete example from contractor profile]

Quote their exact language (no agencies, fuzzy goals, specific tools, mindset criteria). Respond with a specific shipped thing, not a generic claim.

### Step 5 — Write cover letter opener

2–3 sentences. Do NOT start with "I". Reference the specific role + matching experience. End with a forward hook (trial task, call, next step).

### Step 6 — Draft screening answers (if questions present)

Answer each in 2–4 sentences, first-person, drawing on contractor profile. Specific + concrete. Omit section if no questions in brief.

### Step 7 — Derive file name

- Date: `YYMMDD` (current date)
- Slug: 2–3 word lowercase hyphenated slug from title
- Windows: `$env:USERPROFILE\Desktop\YYMMDD-opp-slug-plan.html`
- macOS: `~/Desktop/YYMMDD-opp-slug-plan.html`

### Step 8 — Generate HTML deck

Self-contained. CDN allowed: Google Fonts (Inter) + Mermaid@10.

#### CDN links (always exact)
```html
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
```

#### Mermaid initialize block
```js
mermaid.initialize({
  startOnLoad: true,
  securityLevel: 'loose',
  theme: 'dark',
  flowchart: { useMaxWidth: true, htmlLabels: true, curve: 'basis' },
  themeVariables: {
    primaryColor: '#1a2332',
    primaryTextColor: '#e6edf3',
    primaryBorderColor: '#58a6ff',
    lineColor: '#58a6ff',
    secondaryColor: '#161b22',
    tertiaryColor: '#0d1117',
    clusterBkg: '#0f1318',
    clusterBorder: '#30363d',
    edgeLabelBackground: 'transparent',
    fontFamily: 'Inter,system-ui,sans-serif',
    fontSize: '13px'
  }
});
```

#### Mermaid init block (top of every diagram)
```
%%{init: {'theme':'dark','themeVariables':{'primaryColor':'#1a2332','primaryTextColor':'#e6edf3','primaryBorderColor':'#58a6ff','lineColor':'#58a6ff','secondaryColor':'#161b22','tertiaryColor':'#0d1117','clusterBkg':'#0f1318','clusterBorder':'#30363d','edgeLabelBackground':'transparent','fontFamily':'Inter,system-ui,sans-serif','fontSize':'13px'}}}%%
```

#### Color palette
```
Background:      #0d1117
Card bg:         #161b22
Hover bg:        #1a2332
Border:          #30363d
Divider:         #21262d
Text primary:    #e6edf3
Text secondary:  #c9d1d9
Text muted:      #8b949e
Accent blue:     #58a6ff
Accent green:    #3fb950
Accent yellow:   #e3b341
Accent purple:   #bc8cff
Accent red:      #f85149
```

#### Deck shell
```html
<body style="overflow:hidden;height:100vh;width:100vw">
  <button class="nav-arrow" id="btn-prev">&#8249;</button>
  <button class="nav-arrow" id="btn-next">&#8250;</button>
  <div id="dots"> <!-- 3 dot divs --> </div>
  <div id="deck" style="display:flex;width:300vw;height:100vh;transition:transform 0.45s cubic-bezier(0.4,0,0.2,1)">
    <div class="slide" id="s1"></div>
    <div class="slide" id="s2"></div>
    <div class="slide" id="s3"></div>
  </div>
</body>
```

Nav arrows: `position:fixed; top:50%; transform:translateY(-50%); width:38px; height:38px; border-radius:50%`. Left: `left:10px`. Right: `right:10px`. `z-index:999`.

Dot nav: `position:fixed; bottom:14px; left:50%; transform:translateX(-50%)`. Active dot: `background:#58a6ff; width:20px`.

Navigation JS:
```js
var current = 0;
function goTo(n) {
  n = Math.max(0, Math.min(2, n));
  current = n;
  document.getElementById('deck').style.transform = 'translateX(-' + (n * 100) + 'vw)';
  // update dot active states
}
document.addEventListener('keydown', function(e) {
  if (e.key === 'ArrowRight' || e.key === 'ArrowDown') goTo(current + 1);
  if (e.key === 'ArrowLeft'  || e.key === 'ArrowUp')   goTo(current - 1);
});
```

---

#### Slide 1 — The Solution

```
[Header bar 52px: "SOLUTION: [punchy one-line desc]" left | badges right]
[Diagram area: flex:1, padding 14px 64px 24px (64px clears nav buttons)]
```

Header: `padding: 0 10px 0 10px` — title left edge aligns with left nav button, badges right edge aligns with right nav button. No slide counter.

Badges (budget, engagement, timezone): `background:#161b22; border:1px solid #30363d; border-radius:20px; padding:4px 10px; font-size:0.72rem`.

Diagram wrap: `flex:1; display:flex; align-items:center; justify-content:center; padding:14px 64px 24px; overflow:hidden`.
SVG: `width:100% !important; height:auto !important; max-height:calc(100vh - 80px) !important`.

#### Post-render JS (run after Mermaid renders — poll with setInterval until svg present)

```js
var svgCheckInterval = setInterval(function() {
  var svg = document.querySelector('.diagram-wrap svg');
  if (!svg) return;

  // 1. Fit SVG
  svg.removeAttribute('width'); svg.removeAttribute('height');
  svg.style.cssText = 'width:100% !important;height:auto !important;max-height:calc(100vh - 80px) !important;';

  // 2. Rounded corners on nodes and clusters
  var rects = svg.querySelectorAll('.node rect, .cluster rect');
  for (var r = 0; r < rects.length; r++) {
    rects[r].setAttribute('rx','8'); rects[r].setAttribute('ry','8');
  }

  // 3. Edge labels as accent pills, brought to front
  var edgeLabelGroups = svg.querySelectorAll('.edgeLabel');
  for (var eg = 0; eg < edgeLabelGroups.length; eg++) {
    var group = edgeLabelGroups[eg];
    group.style.overflow = 'visible';
    var bgRect = group.querySelector('rect');
    if (bgRect) bgRect.setAttribute('fill','transparent');
    var fo = group.querySelector('foreignObject');
    if (fo) {
      fo.style.overflow = 'visible';
      var inner = fo.querySelector('div,span,p');
      if (inner) inner.style.cssText = 'background:#58a6ff;color:#0d1117;font-weight:600;font-size:10.5px;padding:3px 10px;border-radius:4px;font-family:Inter,system-ui,sans-serif;white-space:nowrap;display:inline-block;box-sizing:content-box';
    }
    group.parentNode && group.parentNode.appendChild(group);
  }

  // 4. Cluster labels — style + prevent descender clipping
  var clusterLabels = svg.querySelectorAll('.cluster-label');
  for (var cl = 0; cl < clusterLabels.length; cl++) {
    var label = clusterLabels[cl];
    var lfo = label.querySelector('foreignObject');
    if (lfo) {
      lfo.style.overflow = 'visible';
      var curY = parseFloat(lfo.getAttribute('y') || 0);
      lfo.setAttribute('y', curY + 6);
      var ldiv = lfo.querySelector('div,span,p');
      if (ldiv) { ldiv.style.fontWeight='700'; ldiv.style.color='#c9d1d9'; ldiv.style.fontSize='12px'; ldiv.style.fontFamily='Inter,system-ui,sans-serif'; }
    }
    var ltexts = label.querySelectorAll('text');
    for (var lt = 0; lt < ltexts.length; lt++) {
      if (!lfo) { var ty=parseFloat(ltexts[lt].getAttribute('y')||0); ltexts[lt].setAttribute('y',ty+6); }
      ltexts[lt].style.fontWeight='700'; ltexts[lt].style.fill='#c9d1d9'; ltexts[lt].style.fontSize='12px';
    }
  }

  // 5. Force left-align on all node content (fixes TB-direction centering)
  var nodeFOs = svg.querySelectorAll('.node foreignObject');
  for (var nf = 0; nf < nodeFOs.length; nf++) {
    var nDiv = nodeFOs[nf].querySelector('div');
    if (nDiv) { nDiv.style.display='flex'; nDiv.style.alignItems='center'; nDiv.style.justifyContent='flex-start'; nDiv.style.textAlign='left'; }
  }

  clearInterval(svgCheckInterval);
}, 100);
```

---

#### Slide 2 — The Plan

```
[Title: "🗺️ How I'll Build This"]
[Horizontal stepper: emoji circles connected by gradient lines]
[Detail panel: positioned below active step, expands with 3 bullets on click]
```

Stepper circles: `width:52px; height:52px; border-radius:50%; background:#161b22; border:2px solid #30363d`.
Active: `border-color:#58a6ff; box-shadow:0 0 0 5px rgba(88,166,255,0.12); background:#1a2332`.
Done: `border-color:#3fb950; background:#0f2118`.
Connectors: `flex:1; height:2px; background:#21262d; margin-top:26px`. Done: `background:linear-gradient(90deg,#3fb950,#58a6ff)`.

Detail panel: `position:absolute; width:420px; background:#161b22; border:1px solid #30363d; border-radius:10px; padding:16px 20px`.
Position dynamically below active circle:
```js
var cr = activeCircle.getBoundingClientRect();
var br = s2body.getBoundingClientRect();
var sr = stepper.getBoundingClientRect();
panel.style.top = (sr.bottom - br.top + 16) + 'px';
var left = cr.left + cr.width/2 - panelW/2 - br.left;
panel.style.left = Math.max(0, Math.min(br.width - panelW, left)) + 'px';
```

Init: `pick(0)` on load. Resize listener re-runs `pick(currentStep)`.

---

#### Slide 3 — Why Me

```
[Profile card: photo ring + name + headline + about + tag pills]
[Fit section: "Why I'm the right fit" label + fit-list]
```

Profile card: `display:flex; gap:20px; background:#161b22; border:1px solid #30363d; border-radius:12px; padding:20px 24px`.
Photo ring: `width:88px; height:88px; border-radius:50%; background:#21262d; border:2px dashed #30363d`. Camera emoji `📷` centered.

Fit items — icon spans both text lines:
```html
<li class="fit-item">
  <span class="fit-icon">EMOJI</span>
  <span class="fit-text">
    <span class="q">"exact quote from brief"</span>
    <span class="a"> — response from contractor profile</span>
  </span>
</li>
```
`.fit-item`: `display:flex; align-items:center; gap:12px; background:#161b22; border:1px solid #30363d; border-radius:8px; padding:9px 14px`.
`.fit-icon`: `font-size:1.5rem; flex-shrink:0; line-height:1; display:flex; align-items:center`.
`.q`: `color:#e3b341; font-style:italic`. `.a`: `color:#c9d1d9`.

Cover letter box (at bottom of s3, or inside fit section):
`background:#161b22; border-left:3px solid #58a6ff; padding:16px 20px; border-radius:0 8px 8px 0`.
Add `📋 Copy` button — pure JS clipboard copy.

Screening answers: only if brief contained questions. Else omit.

---

### Step 9 — Save and report

**Windows:**
```powershell
Set-Content -Path "$env:USERPROFILE\Desktop\YYMMDD-opp-slug-plan.html" -Value $htmlContent -Encoding UTF8
```

**macOS/Linux:**
```bash
cat > ~/Desktop/YYMMDD-opp-slug-plan.html << 'HTMLEOF'
...html...
HTMLEOF
```

Tell user: `Saved → Desktop/YYMMDD-opp-slug-plan.html`

---

## Feedback

Ask after completing: "Useful? 👍 / 👎"

Append to `%USERPROFILE%\.claude\skills\[local-skill]\feedback.jsonl` (Windows) or `~/.claude/skills/[local-skill]/feedback.jsonl` (macOS):
```json
{"ts":"<ISO8601>","rating":<1|-1>,"comment":<string|null>}
```
