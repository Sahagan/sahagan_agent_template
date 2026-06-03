#!/bin/bash
# ============================================================
# ARIA Orchestration Template
# ============================================================
# Usage: cp scripts/orchestrate-template.sh scripts/orchestrate-[task].sh
#        แล้วแก้ตามงาน → bash scripts/orchestrate-[task].sh
#
# Pattern จาก user: claude -p "prompt" --allowed-tools "..." 2>&1 &
# สิ่งสำคัญ:
#   --allowed-tools  → ห้ามขาด ไม่งั้น agent ขอ permission ทุก action
#   2>&1 &           → background process (parallel)
#   $!               → PID ของ process ล่าสุด
#   wait $PID        → block จนกว่า process เสร็จ
# ============================================================

set -e  # หยุดถ้า command ล้มเหลว

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS_RW="Edit,Write,Read,Bash,Glob,Grep"   # BE/FE — แก้ไขไฟล์ได้
TOOLS_RO="Read,Bash,Glob,Grep"              # QA — read-only

echo "🎯 ARIA Orchestration: $(basename "$0")"
echo "📁 Project: $PROJECT_DIR"
echo ""

# ============================================================
# [PATTERN A] Sequential — Agent B ต้องการผลจาก Agent A
# ============================================================

# --- Round 1: Kai (Backend) ---
echo "⚡ Round 1: Kai — Backend..."
cd "$PROJECT_DIR" && claude -p "
คุณคือ Kai — Senior Backend Developer ตรง จริงจัง ไม่ชอบ over-engineering

งาน: [ระบุงาน]
ไฟล์ที่เกี่ยวข้อง: [paths]
ผลลัพธ์ที่ต้องการ: [expected output]

หลังเสร็จ: npx tsc --noEmit && npm run build แล้วรายงานผล
" --allowed-tools "$TOOLS_RW"
echo "✅ Round 1: Kai done"

# --- Round 2: Nova (Frontend) — รอ Kai เสร็จก่อน ---
echo ""
echo "⚡ Round 2: Nova — Frontend..."
cd "$PROJECT_DIR" && claude -p "
คุณคือ Nova — Senior Frontend Developer ใส่ใจ UX + accessibility

งาน: [ระบุงาน]
API จาก Kai: [endpoints]
ไฟล์ที่เกี่ยวข้อง: [paths]
ผลลัพธ์ที่ต้องการ: [expected output]

หลังเสร็จ: npm run build แล้วรายงานผล
" --allowed-tools "$TOOLS_RW"
echo "✅ Round 2: Nova done"


# ============================================================
# [PATTERN B] Parallel — Agents ทำงาน independent พร้อมกัน
# ============================================================

# --- Round 1: Kai + Nova พร้อมกัน ---
echo ""
echo "⚡ Round 1: Kai + Nova parallel..."

cd "$PROJECT_DIR" && claude -p "
คุณคือ Kai — Senior Backend Developer
งาน: [BE task ที่ independent]
" --allowed-tools "$TOOLS_RW" 2>&1 &
KAI_PID=$!

cd "$PROJECT_DIR" && claude -p "
คุณคือ Nova — Senior Frontend Developer
งาน: [FE task ที่ independent]
" --allowed-tools "$TOOLS_RW" 2>&1 &
NOVA_PID=$!

wait $KAI_PID  && echo "✅ Kai done"
wait $NOVA_PID && echo "✅ Nova done"


# ============================================================
# [PATTERN C] Mixed — Sequential round 1, Parallel round 2
# ============================================================
# (ตัวอย่าง: Kai ทำ API ก่อน → Nova + Sage review พร้อมกัน)

# Round 1: Kai (sequential — Nova ต้องการ API contract)
echo ""
echo "⚡ Round 1: Kai..."
cd "$PROJECT_DIR" && claude -p "
คุณคือ Kai — Senior Backend Developer
งาน: สร้าง API contract + types สำหรับ [feature]
ผลลัพธ์: src/types/[feature].ts + src/app/api/[route]/route.ts
" --allowed-tools "$TOOLS_RW"
echo "✅ Kai done — contract ready"

# Round 2: Nova + Sage พร้อมกัน
echo ""
echo "⚡ Round 2: Nova + Sage parallel..."

cd "$PROJECT_DIR" && claude -p "
คุณคือ Nova — Senior Frontend Developer
งาน: สร้าง UI สำหรับ [feature] โดยใช้ types จาก src/types/[feature].ts
" --allowed-tools "$TOOLS_RW" 2>&1 &
NOVA_PID=$!

cd "$PROJECT_DIR" && claude -p "
คุณคือ Sage — QA Engineering Lead ช่างสังเกต ไม่ปล่อยผ่านของไม่ดี
ตรวจสอบ: src/app/api/[route]/route.ts, src/types/[feature].ts
รายงาน: ✅ ผ่าน / ⚠️ ควรแก้ / ❌ ต้องแก้
" --allowed-tools "$TOOLS_RO" 2>&1 &
SAGE_PID=$!

wait $NOVA_PID && echo "✅ Nova done"
wait $SAGE_PID && echo "✅ Sage pre-check done"

# Round 3: Sage final QA
echo ""
echo "🔍 Round 3: Sage — Final QA..."
cd "$PROJECT_DIR" && claude -p "
คุณคือ Sage — QA Engineering Lead
ตรวจสอบ final: [all changed files]
Checklist: TypeScript ถูกต้อง, Error handling ครบ, Security (OWASP), UX + Thai text
สรุป: APPROVED / NEEDS_CHANGES
" --allowed-tools "$TOOLS_RO"

echo ""
echo "🎉 Orchestration complete"
