---
name: idea-problem-validation
description: Validate and assess an idea's problem definition, quantitative evidence of recurring pain, and existing solutions, then create a sourced evaluation report. Use when asked to validate an idea, test whether a problem is real, quantify repeated pain points, research alternatives or competitors, or prepare a problem validation document.
metadata:
  short-description: Validate an idea's problem and evidence
---

# Idea problem validation

Evaluate whether an idea is grounded in a specific, recurring user problem and whether current alternatives leave a meaningful gap. Produce a reviewable Markdown report with evidence and uncertainty clearly separated.

## Inputs and scope

1. Identify the idea and its source material. In this repository, check the matching `ideas/*.json` and `ideas/*.md`, `ideas/README.md`, and any user-provided documents. Treat those as hypotheses and context, not proof that the problem exists.
2. If the idea, target user, or market/geography cannot be identified from available material, make the best bounded assessment possible and list the missing scope in the report. Ask a concise question only when the ambiguity prevents meaningful research.
3. Do not contact people, submit forms, create accounts, or access private data. Interviews and surveys can be recommended as future validation steps; do not report them as completed unless the user supplies results.
4. Browse for current external claims, statistics, and existing solutions. Prefer primary sources, such as government statistics, peer-reviewed research, official product documentation/pricing, and original company materials. Cite each factual claim with a direct URL and publication/access date when available. Search snippets alone are not evidence. If sources conflict or the evidence cannot be accessed, say so.

## Validation workflow

### 1. Problem definition and validity

Rewrite the proposed problem as a testable statement with as many of these elements as evidence supports:

> `[specific user]` encounters `[trigger/context]` while trying to `[task]`; this causes `[observable cost, risk, delay, or failure]`; today they `[workaround/current behavior]`.

Check separately:

- **Specificity:** Is the user a defined group rather than “everyone”? Is the situation observable and bounded?
- **Behavior:** Is there evidence people actually encounter and respond to this situation, beyond a stated preference or assumed need?
- **Consequence:** Is the cost or outcome concrete (time, money, errors, risk, missed opportunity, or effort)?
- **Problem validity:** Do independent evidence sources or user-provided observations support that the situation occurs? Does evidence support the proposed cause, or only a related symptom?
- **Scope and counterevidence:** Who does not experience it, what conditions change it, and what evidence could disprove the problem statement?

Mark unsupported elements as hypotheses. Do not treat technical feasibility, general interest in AI, or the existence of a proposed feature as proof of a user problem.

### 2. Quantitative evidence of recurring pain

Look for numbers that establish that the problem is experienced repeatedly by the intended users. For each statistic, record:

- the measured event or pain (not merely a broad market-size figure),
- population and geography,
- sample size and sampling method when available,
- time period and frequency/recurrence,
- source, date, and limitations,
- how directly it represents the proposed target users.

Distinguish prevalence (how many people experience it), frequency (how often one person experiences it), severity (impact per event), and behavior (whether users already spend time or money addressing it). Do not infer frequency from one-time incidents, infer target-user rates from an unrelated population, or treat search volume, complaints, market size, or social posts as representative prevalence without qualification. Label proxies explicitly.

If no reliable numeric evidence is found, report **정량 근거 부족** rather than inventing a value. Recommend a practical next measurement (for example, a narrowly scoped interview log, diary study, survey with a defined sampling frame, or anonymized workflow count) and state what question it should answer.

### 3. Existing solutions and alternatives

Search for solutions the target user can already use, including:

- direct products that solve the same task for the same user,
- adjacent products or general-purpose tools used as substitutes,
- manual workarounds, experts, agencies, internal processes, or doing nothing,
- free, public, or built-in options where relevant.

For each relevant alternative, record its name, target user, job covered, evidence of current availability, price/access model if confirmed, strengths, limitations for this problem, and source. Distinguish a real gap from an unverified differentiation claim. The mere existence of a competitor neither proves demand nor invalidates the idea. Do not claim “no competitors” based on a limited search; state search scope and unresolved coverage.

### 4. Score and synthesize

Score each of the three dimensions from 0 to 3 and attach a separate evidence confidence:

| Score | Meaning |
| --- | --- |
| 0 | No supporting evidence, or available evidence contradicts the claim |
| 1 | Plausible hypothesis; weak, indirect, or narrow evidence |
| 2 | Some direct evidence, but coverage, recurrence, impact, or differentiation remains uncertain |
| 3 | Clear, relevant, and corroborated evidence for the intended user and scope |

Evidence confidence is `높음`, `중간`, or `낮음` based on source quality, directness, recency, and representativeness. A high score with low confidence requires explanation; do not make arithmetic precision imply certainty.

Dimensions:

1. `문제 정의·타당성`
2. `반복 pain point의 정량 근거`
3. `기존 솔루션 조사와 미충족 영역`

Give an overall judgment: `검증 신호 강함`, `부분 검증`, `가설 단계`, or `근거 부족/반증`. The weakest dimension constrains the overall result: a strong problem statement cannot compensate for no recurrence evidence, and a large market cannot compensate for no user-specific problem. Include counterevidence and the main unresolved assumption before recommending whether to continue, narrow, or pause validation.

## Report output

Create a UTF-8 Markdown report at `ideas/reports/<idea_id>_problem_validation.md`, unless the user specifies another location or requests an inline report. Create the `ideas/reports/` directory if needed. Preserve all existing idea source files. If there is no stable idea ID, derive a short English `snake_case` filename from the title.

Use `references/report-template.md` as the structure. The report must include:

- idea, target user, geography, research date, scope, and overall judgment;
- a refined testable problem statement and separate assessment of its validity;
- all three scores and confidence ratings with reasons;
- quantitative evidence, including sample/population/timeframe and limitations;
- direct/adjacent alternatives and manual workarounds with sourced comparison;
- counterevidence, unknowns, and evidence quality limitations;
- prioritized next validation actions with a measurable question or threshold;
- direct source links near claims and a source list.

Use tables for evidence and alternatives. Keep observed facts, inference, and recommendation clearly labeled. Avoid false precision and unsupported claims. When a dimension has no credible evidence, state that plainly and make the recommended next step specific enough to carry out.
