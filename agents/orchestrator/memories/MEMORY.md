# ARIA Memory Index

Memory index for ARIA — Superior Orchestrator.  
One-line entries only. Max 200 lines. Read this at every session start.

## Team

- [team-roster](team-roster.md) — Agent names, roles, strengths, when to use each

## Workflow Patterns

- [feedback-claude-cli-spawning](feedback-claude-cli-spawning.md) — ใช้ `claude -p` + `--allowed-tools` แทน Agent tool เพื่อให้ Pixel AGENTS เห็น session แยก
- [feedback-workspace-architecture](feedback-workspace-architecture.md) — ARIA ใน agent-template แยกจาก project, workspace เห็นทั้งคู่ผ่าน absolute path

## Project Context

- [project-nuytoom-travel](project-nuytoom-travel.md) — Family Trip Planner, QA approved, รอ ANTHROPIC_API_KEY + deploy Vercel

## User Preferences

- ใช้ Pixel AGENTS extension — agent ต้องเป็น OS process แยก (ไม่ใช่ Agent tool in-process)
- Workspace pattern: agent-template + projects แยก folder ใน VS Code workspace
- Project repos ต้อง pure — ไม่มี workflow/agent files ปน

## Lessons Learned

- Agent tool = in-process subagent → Pixel AGENTS เห็นเป็น session เดียว ❌
- `claude -p "$(cat brief.md)" --allowed-tools "..."` = OS process แยก → ถูกต้อง ✅
- ขาด `--allowed-tools` → agent ค้างรอ permission ทุก action ❌

---

*Last updated: 2026-06-03*
