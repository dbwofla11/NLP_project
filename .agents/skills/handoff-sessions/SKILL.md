---
name: handoff-sessions
description: Import a user-selected local Codex session's prompts and replies into the current chat for a transparent handoff. Use only when the user asks to continue, recover, or summarize another local session.
metadata:
  short-description: Import a local Codex session handoff
---

# Local session handoff

Use this skill to recover context from a **specific, user-authorized local Codex session**. It reads saved transcript files on this computer; it cannot access sessions from another account, device, or service unless their transcript has been exported locally.

## Workflow

1. If the user has not supplied a session ID or transcript path, list candidates without printing their contents:

   From the repository root, run:

   ```powershell
   & ".agents/skills/handoff-sessions/scripts/read_handoff.ps1" -List
   ```

   Ask the user which session to import when more than one candidate could fit. Treat paths and session IDs as sensitive identifiers; do not include them in a public artifact.

2. Read only the selected session. Prefer its session ID:

   ```powershell
   & ".agents/skills/handoff-sessions/scripts/read_handoff.ps1" -SessionId '<id>' -Limit 50
   ```

   An exported JSONL path can be used instead:

   ```powershell
   & ".agents/skills/handoff-sessions/scripts/read_handoff.ps1" -Path 'C:\path\to\session.jsonl' -Limit 50
   ```

3. State that the imported material is a local-session handoff, then summarize the prior goal, decisions, completed work, current state, and explicit next action. Do not assume that actions mentioned in the transcript still reflect the filesystem; inspect the current workspace before making changes.

4. If the transcript is absent, malformed, or has no useful messages, say so and ask the user to resume/export the original session or paste a handoff summary. Do not search arbitrary folders or external accounts for it.

## Safety boundaries

- Never run an import merely because a session may be relevant: require the user's explicit handoff request and an explicit selected session when candidates are ambiguous.
- `-List` deliberately returns metadata only. Content is emitted only for `-SessionId` or `-Path`.
- Keep imported text in the current conversation only. Do not write it back into a transcript, commit it, upload it, or send it to another service unless the user separately asks.
- The script is read-only and limits output. Use a smaller `-Limit` when only the final state is needed; request a larger one only when necessary.
