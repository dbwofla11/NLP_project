---
name: idea-json
description: Create or update an idea JSON file in this project's ideas collection from a rough idea, notes, or source document. Use when asked to turn an idea into JSON or to add an idea to the project.
metadata:
  short-description: Create project idea JSON
---

# Project idea JSON

Create a machine-readable idea record under `ideas/`, following this repository's existing files and conventions.

## Workflow

1. Read `ideas/README.md` and inspect one or two nearby `ideas/*.json` files before editing. If the user points to source material, read it first and use it as the source of truth.
2. Extract the idea's title, intended users, situation, problem, proposed solution, validation plan, and limitations. Keep claims tied to the supplied material. Do not invent research findings, URLs, customer evidence, or validation results.
3. If the source is incomplete, preserve the uncertainty. Use `null` for an unknown scalar/object field, `[]` for an unknown list, and explain important gaps in `open_questions` or `notes`. Do not fill gaps with plausible-sounding assumptions.
4. Choose a concise, stable English `id` in `snake_case` from the core idea. Keep it distinct from existing IDs. Save as `ideas/NN_<id>.json`, using the next available two-digit number unless the user specifies a path or number.
5. Write valid UTF-8 JSON with two-space indentation and no comments or trailing commas. Keep strings in Korean when the source is Korean.
6. Parse the finished file as JSON and check that its `id` matches the filename, its title is meaningful, its analysis fields use project values, and no unsupported claims were added.
7. If adding a new numbered idea, update the file list/table in `ideas/README.md` only when enough information is available and the user asked to add it to the collection. Do not create a companion Markdown document unless asked.

## Record shape

Use the fields that fit the maturity of the idea. Existing records have some variation, so do not force an unknown value into a fabricated answer.

```json
{
  "id": "short_english_snake_case",
  "title": "아이디어 이름",
  "source_url": null,
  "analysis": {
    "status": "시작 전",
    "topic_fit": "하",
    "nlp_difficulty": "하",
    "market_competitiveness": "하"
  },
  "target_users": [],
  "problem": null,
  "proposed_solution": null,
  "open_questions": [],
  "validation": null,
  "limitations": [],
  "notes": null
}
```

### Field conventions

- `id`: unique lowercase English `snake_case`; omit the numeric filename prefix.
- `title`: concise Korean name for the idea.
- `source_url`: source page URL, or `null` when none was supplied.
- `analysis.status`: use the repository's labels such as `시작 전`, `진행 중`, or `완료`; do not imply completion unless the source supports it.
- `analysis.topic_fit`, `analysis.nlp_difficulty`, `analysis.market_competitiveness`: use `상`, `중`, `하` when assessed. If not assessed, use `null` rather than guessing.
- `target_users` / `candidate_users`: use a short array of specific user groups when known. Prefer `target_users`; preserve `candidate_users` only when the source intentionally lists unselected candidates.
- `problem`: a short array of concrete pain points when known, otherwise `null`.
- `proposed_solution`: a concise string or a structured object when the source includes distinct components (for example `agents`, `principle`, and `mvp_outputs`).
- `validation`: a concrete next validation step or evidence-backed validation plan; do not state a proposed study as already completed.
- `limitations`: an array of material risks, uncertainties, or constraints.
- `open_questions`: an array of unresolved decisions, especially for an early-stage idea.
- `notes`: source or context details that do not fit elsewhere; use `null` if unnecessary.

## Output and edits

- When the user gives only an idea and asks for JSON, create the numbered JSON file in `ideas/` and report its path.
- When the user asks for a draft without writing files, return only a valid JSON object unless they ask for explanation.
- When updating an existing idea, preserve its ID and filename. Change only fields supported by the new source material.
- Do not rename, renumber, or normalize other idea records as part of a single idea request.
