# Plan — Overhaul `writing-agent-guidance` into the one guidance & skill-authoring skill

Status: awaiting review (plan only; no skill edits yet)
Branch: `overhaul-agent-guidance-skill`
Supersedes: PR #29, PR #30 (both close on merge of this work)

---

## 1. Objective and the reframe

Merge `writing-effective-skills` into `writing-agent-guidance` and rebuild it
around a positive frame: **how to write guidance an agent will actually
follow**, with stripping rotted guidance demoted to one part rather than the
opening.

The pivot in one line: the skill stops being its `tidy-agent-guidance` origin
(a fixer for already-rotten text) and becomes the canonical home for *writing,
improving, and reviewing* any agent guidance or skill. A positive,
all-encompassing frame can absorb both source skills; a fixer frame cannot.

This captures the lesson of the `writing-pr-bodies` overhaul (PR #25), which is
twofold:

1. **Content the source skills lack** — a register/voice model (tells the agent
   what language to produce) and concrete recognition tables (literal bad
   sentences, the fix, why, caught at write-time).
2. **Register conversion** — its prose was rewritten from long, winding,
   conceptual, academic exposition into direct, grounded, accessible
   directives. This is not cosmetic: winding academic prose is not reliably
   followed by an LLM, so making it legible changes what the agent produces.

Both source skills are written in exactly the prose style that fails. The work
is the content port **and** the register conversion, applied to every section —
not one or the other.

## 2. Decisions (locked with the user)

| Decision | Resolution |
|---|---|
| One skill or two | One. `writing-effective-skills/` deleted, content absorbed |
| Canonical home | `writing-agent-guidance/` (broadest scope owns the home; skills become a specialised part within it) |
| Skill name | `writing-agent-guidance` retained; `tidy-agent-guidance` symlink kept as a back-compat alias |
| Alignment / reset step | In scope for this overhaul (structurally load-bearing in sections 3, 6, 7) — not a follow-up |
| Prose register conversion | In scope and required — winding/academic → direct/grounded/accessible, every section; only change-for-change's-sake on already-direct text is excluded |
| Sequencing | Single PR: plan commit (draft PR opens) → implementation commits → mark ready |

**Responsibility placement.** The canonical home is `writing-agent-guidance`
because it owns the broadest scope (all agent guidance). Skill-specific material
is a *specialisation* of general guidance, so it lives as a subsection, not a
peer skill. Alternative rejected: keep two skills cross-referencing each other —
rejected because the duplication is the documented root cause of the #29/#30
failures (same idea edited into two files in two registers) and routing should
be single-target.

## 3. The model to hold the rewrite against

The alignment statement already produced against `writing-pr-bodies/SKILL.md`
(the cleanest specimen we have) is the model. Condensed:

- **Register:** imperative policy. The unit is the atomic line, prefixed
  `DO` / `DO NOT` / `PRIORITISE` / `DEPRIORITISE`. Hard constraints are
  ALL-CAPS-headed (`HARD RESTRICTION:`, `RECOGNISE`, `STOP`).
- **Prose is licensed in only three places:** one load-bearing reader-cost
  anchor; worked-example explanations that *are* the artifact being taught;
  a one-line gloss under a heading before its directive list.
- **Devices:** cost anchor · flat DO/DO NOT spine · `RECOGNISE` + 2-col
  recognition table · `REJECT | PREFER | WHY` triple · definition+example
  catalogue · numbered `## Procedure` with trailing DO NOTs · `Thought |
  Reality` STOP table · spirit-closing line.

Every section below is judged: does it read like that, or like an essay
explaining itself.

## 4. Target structure

```
Frontmatter (broadened scope + operational TRIGGER/SKIP)
When to use
Self-specimen clause ("this skill obeys its own rules; a violation here is a defect")
│
1. Core requirements / key principles   — prime the agent: you are writing
│                                          guidance FOR agents; here is what
│                                          effective guidance must do
2. Writing style                        — how guidance is written decides
│                                          whether it is followed (register/
│                                          voice model, the writing-pr-bodies
│                                          analogue)
3. Hard restrictions + reset            — concrete bad-pattern recognition
│                                          tables; condition the agent to
│                                          reset and not over-contextualise
4. How to make a rule stick / Pattern   — catalogue of devices/sections
│   Library                                available when writing a skill
5. How to strip bad guidance            — the current writing-agent-guidance
│                                          core, demoted to a part
6. Procedure — writing/revising any     — alignment step is step 1
│   guidance
7. Procedure & caveats — skills         — pressure testing, strict-workflow
│   specifically                           technique, skill-only caveats
│
Spine: one ## Red flags — STOP table · spirit-closing line
```

### Section-by-section content map

| § | Purpose | Form | Source content | Net-new |
|---|---|---|---|---|
| 1 | Prime the agent; what effective guidance must do | short cost anchor + flat DO/DO NOT | `w-e-s` rationalisation problem + actionable core of the 7 principles (compressed, not the essays); `w-a-g` cost anchor (directives authoritative, tokens count) | reframed positive |
| 2 | The register/voice model for guidance | gloss + DO/DO NOT + worked contrast example | `w-a-g` principles 1–3 (lead with directive, fresh reader, consolidate) recast as a voice model | **new framing/section** |
| 3 | Recognise and kill bad patterns; reset register | `HARD RESTRICTION:` + `RECOGNISE` + 2-col tables + `REJECT\|PREFER\|WHY` | `w-a-g` principles 2/4/5 (war stories, strawmen, alignment leakage, weak justification) converted from categories to concrete sentence catalogues | **net-new content** |
| 4 | Device catalogue for making a rule stick | definition + when-to-use + template per item | `w-e-s` Pattern Library, 7 principles as *when to use each*, hard/soft triggers, anti-rationalisation tables, letter/spirit; `w-a-g` §4 promotion forms incl. human-only guardrails | consolidated |
| 5 | Strip rotted guidance | definition + before/after + `Test:` | `w-a-g` Common violations + Safe vs destructive + What to keep | relocated |
| 6 | Procedure for any guidance | numbered `## Procedure`, trailing DO NOTs | `w-a-g` Reviewing changes + Verifying improvements; **alignment step as step 1** | + alignment step |
| 7 | Skills-specific procedure & caveats | numbered steps + caveats + reusable blocks | `w-e-s` Testing before shipping + Extracting from docs + CLAUDE.md notes; **strict-workflow technique** with `writing-pr-bodies` as worked exemplar | + strict-workflow technique |

(`w-a-g` = current `writing-agent-guidance`; `w-e-s` = current
`writing-effective-skills`.)

## 5. Net-new content specifications

These are the only parts that are genuinely new writing. Everything else is
relocation into the positive frame.

### 5a. Section 2 — register/voice model for guidance

A guidance-writing analogue of `writing-pr-bodies` "Writing style". Specifies
the language to produce, not just formatting:

- DO lead every rule with the directive; caveats and exceptions follow.
- DO write for a fresh reader with zero session context.
- DO state the rule once, in one canonical place; link, don't restate.
- DO name the consequence in terms the reader already holds (observable
  breakage, shared knowledge), not internal mechanism.
- DO NOT argue, justify, essay, or signpost the text's own structure.
- One worked contrast example (same rule, weak prose form vs promoted
  directive form), explained — the explanation is the artifact, so it stays
  prose.

### 5b. Section 3 — concrete recognition tables + reset

The highest-value content. Today the skill says "remove war stories"; this
gives the agent the actual sentence shapes:

- `RECOGNISE — war story` table: literal patterns ("the previous approach was
  removed because…", "this was changed from X to Y", "we tried Z and it
  broke") | why it fails a fresh reader.
- `RECOGNISE — strawman` table: "this is X, not Y" against a position no
  reader holds | why.
- `RECOGNISE — alignment leakage` table: design recap the agent already has,
  role disambiguation, trust-boundary explanation it doesn't act on,
  conversational meta-talk | why (true and well-formed, wrong audience).
- `REJECT | PREFER | WHY` triples for weak-justification → directive+cost
  promotion (generalise `w-a-g` §4's single before/after pair into the table
  form).
- **Reset / don't over-contextualise** block: condition the agent that when
  editing existing guidance it must not carry its own composition register or
  the editing-conversation's shared understanding into the file. This is the
  write-time half of the alignment step (the procedure half is §6).

### 5c. Section 6 — the alignment step (Procedure step 1)

`## Procedure` for writing/revising any guidance. Step 1 is the alignment
step, stated as a hard, mandatory gate:

1. **Align.** Read the target file end to end. State its objective, audience,
   register, and structural devices in the file's *own* register (the
   artifact shape demonstrated in §3 of this plan). Get the user to confirm
   or correct it. Hold that statement as the model of correct output for this
   file.
2. Diff the current text and any proposed change against the alignment
   statement and the rules above.
3. Edit against the file, not from composition memory.
4. Review the delta; run the self-application check (the skill's own standard
   against its own text).
5. Pressure-test if behaviour changed.

The alignment statement is a **commitment artifact**: once written and
confirmed, editing in a different register is a visible violation of the
agent's own stated model. Trigger is hard: "before editing the load-bearing
text of any existing guidance or skill" — not "when editing", which invites
the skip.

### 5d. Section 7 — the strict-workflow technique

Skills-specific caveats and procedure. Includes the named technique: how to
give clear direction on a strict, ordered workflow. The transferable
mechanism, with `writing-pr-bodies` cited as the canonical worked exemplar:
recognition tables of concrete failure patterns + a numbered `## Procedure`
that produces an artifact + per-step interception. Plus the existing
pressure-test scenarios and extraction technique, kept as reusable blocks.

## 6. Invariants to preserve

- **Human-only authorship guardrails.** Existential-cost statements and
  personality-setting directives stay human-authored only. The constraint
  must survive in the §4 catalogue entries, in §5 (Safe vs destructive), and
  as a `## Red flags — STOP` row. The agent identifies and preserves existing
  ones; never introduces them on its own initiative.
- **Public personal repo.** No work/employer org, repo, ticket, or internal
  references anywhere in the skill. All examples generic (consistent with the
  maintained invariant in PR #33).
- **Symlink.** `tidy-agent-guidance` → `writing-agent-guidance` stays. Edit
  the real `writing-agent-guidance/` path only; never stage via the symlink.
- **No loss of load-bearing content.** Every directive, guardrail, and
  reusable block in either source skill maps to a destination section in the
  table above before any deletion.

## 7. Mechanics

- Rewrite `writing-agent-guidance/SKILL.md` to the target structure.
- Broaden the frontmatter `description` to cover all guidance *and* skills,
  with operational `TRIGGER` / `SKIP` (the one sound idea in the #29/#30
  scaffolding). Keep `name: writing-agent-guidance`.
- `git rm -r writing-effective-skills/`.
- Grep the whole repo for references to `writing-effective-skills` (README,
  CLAUDE.md, other skills, sync-skills, meta skills) and update or remove
  them. Internal — delete, do not deprecate.
- Close PR #29 and PR #30 with a comment pointing to this PR as the
  superseding consolidation.

## 8. Verification

- **Self-application check.** Run the merged skill's own standard against its
  own text top-to-bottom as a first-time reader. A skill that violates its
  own rules has rotted; fix the text.
- **Prose register check.** No section retains long, winding, conceptual, or
  academic sentences. Every directive reads as direct, grounded, and
  accessible to a context-saturated model on first pass.
- **Head-to-head subagent test.** Dispatch two subagents on the same realistic
  guidance-editing task — one against the pre-merge `writing-agent-guidance`,
  one against the new merged skill. The new one must produce tighter,
  more directive-led, less-rotting output.
- **Pressure test.** One time-pressure and one sunk-cost scenario against a
  subagent for the alignment step specifically (the rule most likely to be
  rationalised away).

## 9. Out of scope / non-goals

- Change-for-change's-sake reformatting of text that is already direct and
  followable (e.g. splitting a clear two-sentence directive into bullets to
  look more skill-like). Rewriting winding, conceptual, or academic prose into
  direct, grounded, accessible form is in scope and required.
- Deprecation shims for the old skill name (internal; delete and update).
- Any change to `writing-pr-bodies` (it is the reference, not a target).
- Inventing new persuasion principles or guardrail forms.

## Corrections logged during build

- **Consolidation-rule scope (§2, §5).** The consolidation pressure is
  primarily a multi-file concern: parallel full explanations across files
  drift out of sync. Within a single file, still cut dead redundancy (the same
  point restated in the same form, adding nothing), but never strip deliberate
  multi-form reinforcement (the same rule as a directive, a recognition row, a
  red flag, the spirit line). When §5 is written, its "Duplicated
  explanations" violation must flag (a) cross-file parallel full explanations
  and (b) dead in-file redundancy, and must not flag deliberate multi-form
  reinforcement.

## 10. Implementation task checklist

- [ ] Confirm plan with user (this commit)
- [ ] Draft new `SKILL.md` skeleton (headings + frontmatter) to the target structure
- [ ] Section 1 — Core requirements / key principles (port + reframe)
- [ ] Section 2 — Writing style register model (net-new)
- [ ] Section 3 — Hard restrictions + recognition tables + reset (net-new content)
- [ ] Section 4 — Pattern Library / how to make a rule stick (consolidate, preserve human-only guardrails)
- [ ] Section 5 — How to strip bad guidance (relocate)
- [ ] Section 6 — Procedure incl. alignment step as step 1 (net-new step)
- [ ] Section 7 — Skills procedure, caveats, strict-workflow technique (net-new technique)
- [ ] Spine — consolidated Red flags STOP table + spirit line
- [ ] `git rm` `writing-effective-skills/`; update/remove all references repo-wide
- [ ] Register pass: every ported section rewritten from winding/academic prose to direct, grounded, accessible directives
- [ ] Self-application check pass
- [ ] Head-to-head subagent test
- [ ] Pressure test the alignment step
- [ ] Close #29 / #30 with superseding-PR comment
- [ ] Mark PR ready

## 11. Risks

| Risk | Mitigation |
|---|---|
| Merged skill is large and itself rots | It is a flat policy stack like `writing-pr-bodies` (611 lines, works). Size is fine; register-mixing is the failure — the self-application check guards it |
| Load-bearing content silently dropped in the merge | §4 content map is the contract; nothing is `git rm`'d until its destination row is filled |
| Human-only guardrails weakened by consolidation | Triple-redundant by design (catalogue + strip section + STOP row); explicit invariant in §6 |
| Routing regressions from the deleted skill name | Repo-wide grep + update step; `tidy-agent-guidance` symlink preserves the existing alias |
| Alignment step rationalised away under load | Hard trigger + commitment artifact + dedicated STOP row + pressure test |
