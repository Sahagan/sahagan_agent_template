---
name: new-session
description: Spawn a new agent session for a specific team member (backend, frontend, or qa)
when_to_use: When ARIA needs to delegate work to Kai (BE), Nova (FE), or Sage (QA)
user-invocable: true
---

# New Session — Spawn Agent

ใช้ spawn agent session ใหม่สำหรับ Kai, Nova, หรือ Sage

## Usage

```
/new-session <agent> [task brief]

/new-session backend   — spawn Kai (Backend Developer)
/new-session frontend  — spawn Nova (Frontend Developer)
/new-session qa        — spawn Sage (QA Engineer)
```

## How Agents Are Spawned

ARIA spawns agents via the **claude CLI** ผ่าน Bash tool — สร้าง OS process จริงๆ ที่ Pixel AGENTS และ extension อื่นๆ จะเห็นเป็น session แยก

```bash
# Single agent (foreground — ARIA รอผล)
cd /project && claude -p "$(cat _shared/briefs/[agent]-[id].md)" \
  --allowed-tools "Edit,Write,Read,Bash,Glob,Grep"

# Background (สำหรับ parallel — รัน &)
cd /project && claude -p "$(cat _shared/briefs/[agent]-[id].md)" \
  --allowed-tools "Edit,Write,Read,Bash,Glob,Grep" 2>&1 &
PID=$!
wait $PID
```

**Tool permissions ตาม role:**
| Agent | Tools | เหตุผล |
|-------|-------|--------|
| Kai (BE) | `Edit,Write,Read,Bash,Glob,Grep` | แก้ไขไฟล์ได้ |
| Nova (FE) | `Edit,Write,Read,Bash,Glob,Grep` | แก้ไขไฟล์ได้ |
| Sage (QA) | `Read,Bash,Glob,Grep` | review อย่างเดียว |

> ⚠️ ถ้าไม่ใส่ `--allowed-tools` → agent จะขอ permission ทุก action → ค้างตลอด

---

## Protocol

### 1. Validate agent name

| Input | Agent | ID | Default Tools |
|-------|-------|-----|---------------|
| `backend` | Kai | `kai-backend` | `Edit,Write,Read,Bash,Glob,Grep` |
| `frontend` | Nova | `nova-frontend` | `Edit,Write,Read,Bash,Glob,Grep` |
| `qa` | Sage | `sage-qa` | `Read,Bash,Glob,Grep` |

ถ้า name ไม่ตรง: แจ้ง user + แสดง valid options

---

### 2. Write brief to `_shared/briefs/[agent]-[taskid].md`

Brief ต้องครบ — agent ไม่มี memory ข้าม session:

```markdown
# Brief: [agent]-[taskid] — [task title]
**From:** ARIA | **To:** [Agent Name] | **Priority:** high | medium | low

## Persona
คุณคือ [ชื่อ] — [role]
บุคลิก: [1-2 ประโยค — tone + style]

## Context
[background + why this task matters]

## What to Do
1. [specific step — not vague]
2. [specific step]
...

## Files Relevant
- [path/to/file — และมันทำอะไร]

## API Contracts (ถ้ามี)
[endpoints, schemas, types]

## Expected Output
- [exact deliverables — files, reports]

## Verification Gate
[commands ที่ต้องผ่านก่อนรายงาน done]
e.g.: npx tsc --noEmit && npm run build

## Report Back
[format ของ done signal]
```

---

### 3. Log handoff in `_shared/messages.jsonl`

```json
{"messageId":"msg-[timestamp]","type":"handoff","from":"aria-orchestrator","to":"[agent-id]","timestamp":"[ISO]","subject":"[summary]","taskId":"[id]","requiresResponse":true}
```

---

### 4. Update `_shared/task-log.jsonl`

```json
{"taskId":"[id]","title":"[title]","assignedTo":"[agent-id]","status":"in_progress","startedAt":"[ISO]","expectedOutput":"[description]"}
```

---

### 5. Run agent via Bash tool

ARIA รัน command นี้ผ่าน Bash tool:

```bash
cd /path/to/project && claude -p "$(cat _shared/briefs/[agent]-[id].md)" \
  --allowed-tools "[tools-for-this-agent]"
```

Agent output จะ stream กลับมาใน Bash tool result

---

### 6. Review & Gate

หลัง agent เสร็จ:
- ✅ **Approved** → update task-log `status: complete`
- 🔄 **Needs changes** → log `request_changes` + update brief + re-run
- 🚨 **Blocked** → escalate to user ทันที

---

## Example

```
/new-session backend "Implement POST /api/users with email validation"
```

ARIA จะ:
1. เขียน brief → `_shared/briefs/kai-001.md`
2. Log handoff ใน messages.jsonl
3. Update task-log status: in_progress
4. รัน Bash: `cd /project && claude -p "$(cat _shared/briefs/kai-001.md)" --allowed-tools "Edit,Write,Read,Bash,Glob,Grep"`
5. Review result → approve / request_changes
6. Update task-log status: complete / blocked
