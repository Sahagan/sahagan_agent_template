---
name: feedback-claude-cli-spawning
description: ใช้ claude -p CLI แทน Agent tool เพื่อ spawn agents ที่ Pixel AGENTS เห็นเป็น session แยก
metadata:
  type: feedback
---

ใช้ `claude -p "..." --allowed-tools "..."` ผ่าน Bash tool แทน Agent tool เสมอ

**Why:** Agent tool spawn sub-agent in-process (same session) → Pixel AGENTS เห็นเป็น session เดียว  
ส่วน `claude -p` สร้าง OS process จริง → Pixel AGENTS detect เป็น session แยก

**How to apply:**
```bash
# Single agent
cd /project && claude -p "$(cat _shared/briefs/[agent]-[id].md)" \
  --allowed-tools "Edit,Write,Read,Bash,Glob,Grep"

# Parallel
claude -p "..." --allowed-tools "..." 2>&1 & PID=$!
wait $PID
```

⚠️ ต้องใส่ `--allowed-tools` เสมอ — ถ้าไม่ใส่ agent ขอ permission ทุก action แล้วค้าง  
- BE/FE: `Edit,Write,Read,Bash,Glob,Grep`  
- QA (read-only): `Read,Bash,Glob,Grep`
