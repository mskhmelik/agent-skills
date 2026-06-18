#!/usr/bin/env node
/**
 * validate-skills.js
 *
 * Validates every skill in skills/<group>/<name>/SKILL.md against the contract in
 * docs/skill-anatomy.md.
 *
 * Errors (block, exit 1):
 *   - SKILL.md exists in every skill directory
 *   - YAML frontmatter present with 'name' and 'description'
 *   - frontmatter 'name' matches the leaf directory name
 *   - description does not exceed 1024 characters
 *   - required sections present (unless the skill is exempt, below)
 *   - a skill cannot declare its own section exemption in frontmatter
 *
 * Warnings (do not block):
 *   - missing 'allowed-tools' on a skill that appears to do I/O
 *   - missing '## Feedback' section (the repo's self-annealing loop)
 *   - dead cross-skill references
 *
 * Cross-platform: pure Node, no dependencies. Run: node scripts/validate-skills.js
 */

'use strict';

const fs   = require('fs');
const path = require('path');

const SKILLS_DIR = path.resolve(__dirname, '..', 'skills');
const MAX_DESCRIPTION_LENGTH = 1024;

// Required sections. Each entry is a list of acceptable headings — first match wins,
// so the core-process row accepts several equivalent headings.
const REQUIRED_SECTIONS = [
  ['## Overview'],
  ['## When to Use'],
  ['## Steps', '## Process', '## Workflow', '## Step '],   // core process (aliases)
  ['## Common Rationalizations'],
  ['## Red Flags'],
  ['## Verification'],
  ['## Feedback'],
];

// Skills intentionally exempt from section checks. Exemptions live HERE, not in skill
// frontmatter, so a skill cannot bypass the validator by editing itself. Document each.
const SECTION_EXEMPT_SKILLS = {
  caveman: 'Mode-switch skill, not a workflow — has no steps/verification to check.',
};

const SKILL_REF_PATTERNS = [
  /\buse the `([a-z][a-z0-9-]+[a-z0-9])` skill/g,
  /\bfollow the `([a-z][a-z0-9-]+[a-z0-9])` skill/g,
  /\binvoke the `([a-z][a-z0-9-]+[a-z0-9])` skill/g,
  /`([a-z][a-z0-9-]+[a-z0-9])` skill\b/g,
  /\bvia \*\*`\/([a-z][a-z0-9-]+[a-z0-9])`\*\*/g,
];

// ─── Frontmatter parsing (handles folded/block scalars: `description: >`) ──────

function parseFrontmatter(content) {
  const match = content.match(/^---[ \t]*\r?\n([\s\S]*?)\r?\n---[ \t]*\r?\n/);
  if (!match) return null;

  const lines = match[1].split(/\r?\n/);
  const result = {};
  let i = 0;
  while (i < lines.length) {
    const line = lines[i];
    // A key starts at column 0 (no leading whitespace) and has a colon.
    const keyMatch = line.match(/^(\S[^:]*):[ \t]?(.*)$/);
    if (!keyMatch) { i++; continue; }

    const key = keyMatch[1].trim();
    let value = keyMatch[2];

    if (value === '>' || value === '|' || value === '') {
      // Block scalar: gather following indented lines.
      const collected = [];
      i++;
      while (i < lines.length && /^[ \t]+/.test(lines[i])) {
        collected.push(lines[i].trim());
        i++;
      }
      value = collected.join(value === '|' ? '\n' : ' ').trim();
    } else {
      value = value.trim().replace(/^['"]|['"]$/g, '');
      i++;
    }
    result[key] = value;
  }
  return result;
}

function extractSkillReferences(content) {
  const refs = new Set();
  for (const pattern of SKILL_REF_PATTERNS) {
    pattern.lastIndex = 0;
    let m;
    while ((m = pattern.exec(content)) !== null) refs.add(m[1]);
  }
  return refs;
}

// Find all skills: skills/<group>/<name>/SKILL.md
function findSkills() {
  const out = [];
  for (const group of fs.readdirSync(SKILLS_DIR)) {
    const groupPath = path.join(SKILLS_DIR, group);
    if (!fs.statSync(groupPath).isDirectory()) continue;
    for (const name of fs.readdirSync(groupPath)) {
      const skillPath = path.join(groupPath, name);
      if (!fs.statSync(skillPath).isDirectory()) continue;
      out.push({ group, name, dir: skillPath });
    }
  }
  return out.sort((a, b) => a.name.localeCompare(b.name));
}

// ─── Validator ───────────────────────────────────────────────────────────────

function validateSkill(skill, knownSkills) {
  const errors = [], warnings = [];
  let exempt = false;
  const skillFile = path.join(skill.dir, 'SKILL.md');

  if (!fs.existsSync(skillFile)) {
    errors.push('Missing SKILL.md');
    return { errors, warnings, exempt };
  }

  const content = fs.readFileSync(skillFile, 'utf8');
  const fm = parseFrontmatter(content);
  if (!fm) {
    errors.push('Missing or malformed YAML frontmatter');
    return { errors, warnings, exempt };
  }

  if (!fm.name) errors.push("Frontmatter missing required field: 'name'");
  else if (fm.name !== skill.name)
    errors.push(`Frontmatter name '${fm.name}' does not match directory '${skill.name}'`);

  if (!fm.description) errors.push("Frontmatter missing required field: 'description'");
  else if (fm.description.length > MAX_DESCRIPTION_LENGTH)
    errors.push(`Description is ${fm.description.length} chars — exceeds ${MAX_DESCRIPTION_LENGTH}`);

  // A skill must not declare its own exemption.
  if ((fm.type === 'meta' || fm.exempt === 'sections') && !SECTION_EXEMPT_SKILLS[skill.name]) {
    errors.push(
      `Frontmatter declares an exemption but '${skill.name}' is not in the validator's ` +
      `SECTION_EXEMPT_SKILLS allowlist — add it there with a documented reason.`);
  }

  exempt = skill.name in SECTION_EXEMPT_SKILLS;
  if (!exempt) {
    for (const aliases of REQUIRED_SECTIONS) {
      if (!aliases.some(h => content.includes(h))) {
        // '## Feedback' missing is a warning, not an error (legacy skills append it as a step).
        if (aliases[0] === '## Feedback') warnings.push('Missing "## Feedback" section (self-annealing loop)');
        else errors.push(`Missing required section: ${aliases[0]}`);
      }
    }
  }

  // I/O without declared tools → warn.
  const doesIO = /```bash|gh |git |curl |mktemp|Write the file|Bash/i.test(content);
  if (!fm['allowed-tools'] && doesIO && !exempt)
    warnings.push("Skill appears to do I/O but has no 'allowed-tools' in frontmatter");

  for (const ref of extractSkillReferences(content))
    if (!knownSkills.has(ref)) warnings.push(`Dead cross-reference: \`${ref}\` is not a known skill`);

  return { errors, warnings, exempt };
}

function main() {
  if (!fs.existsSync(SKILLS_DIR)) {
    console.error(`ERROR: skills directory not found at ${SKILLS_DIR}`);
    process.exit(1);
  }

  const skills = findSkills();
  const knownSkills = new Set(skills.map(s => s.name));
  let totalErrors = 0, totalWarnings = 0;

  for (const skill of skills) {
    const { errors, warnings, exempt } = validateSkill(skill, knownSkills);
    totalErrors += errors.length;
    totalWarnings += warnings.length;
    const label = `${skill.group}/${skill.name}`;
    if (errors.length === 0 && warnings.length === 0) {
      console.log(`  ✓  ${label}${exempt ? ' (section checks exempt)' : ''}`);
    } else {
      console.log(`${errors.length ? '  ✗ ' : '  ⚠ '} ${label}`);
      for (const m of errors)   console.log(`       ERROR: ${m}`);
      for (const m of warnings) console.log(`       WARN:  ${m}`);
    }
  }

  const status = totalErrors ? 'FAILED' : totalWarnings ? 'PASSED WITH WARNINGS' : 'PASSED';
  console.log(`\n${skills.length} skills checked — ${totalErrors} error(s), ${totalWarnings} warning(s) — ${status}`);
  if (totalErrors > 0) process.exit(1);
}

try {
  main();
} catch (err) {
  console.error(`\nERROR: validate-skills failed unexpectedly: ${err.message}`);
  process.exit(1);
}
