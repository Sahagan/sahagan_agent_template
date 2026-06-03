#!/bin/bash
# ============================================================
# ARIA: Single Agent Runner
# ============================================================
# Usage:
#   bash scripts/run-agent.sh backend  "brief file or inline prompt"
#   bash scripts/run-agent.sh frontend _shared/briefs/nova-001.md
#   bash scripts/run-agent.sh qa       _shared/briefs/sage-001.md
#
# Examples:
#   bash scripts/run-agent.sh backend _shared/briefs/kai-001.md
#   bash scripts/run-agent.sh qa "ตรวจสอบ src/app/api/generate-plan/route.ts"
# ============================================================

set -e

AGENT=${1:-""}
INPUT=${2:-""}
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Validate agent
case "$AGENT" in
  backend|kai)
    AGENT_NAME="Kai"
    AGENT_ROLE="Senior Backend Developer ตรง จริงจัง ไม่ชอบ over-engineering"
    TOOLS="Edit,Write,Read,Bash,Glob,Grep"
    ;;
  frontend|nova)
    AGENT_NAME="Nova"
    AGENT_ROLE="Senior Frontend Developer ใส่ใจ UX + accessibility + Thai language"
    TOOLS="Edit,Write,Read,Bash,Glob,Grep"
    ;;
  qa|sage)
    AGENT_NAME="Sage"
    AGENT_ROLE="QA Engineering Lead ช่างสังเกต ไม่ปล่อยผ่านของไม่ดี"
    TOOLS="Read,Bash,Glob,Grep"
    ;;
  *)
    echo "❌ Unknown agent: '$AGENT'"
    echo "   Valid: backend (kai) | frontend (nova) | qa (sage)"
    exit 1
    ;;
esac

# Resolve prompt — รับทั้ง file path หรือ inline text
if [ -f "$INPUT" ]; then
  PROMPT="$(cat "$INPUT")"
elif [ -n "$INPUT" ]; then
  PROMPT="คุณคือ $AGENT_NAME — $AGENT_ROLE

$INPUT"
else
  echo "❌ No brief provided"
  echo "   Usage: bash scripts/run-agent.sh <agent> <brief-file-or-prompt>"
  exit 1
fi

echo "▶ Running $AGENT_NAME..."
echo "  Tools: $TOOLS"
echo "  Project: $PROJECT_DIR"
echo ""

cd "$PROJECT_DIR" && claude -p "$PROMPT" --allowed-tools "$TOOLS"
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
  echo ""
  echo "✅ $AGENT_NAME completed"
else
  echo ""
  echo "❌ $AGENT_NAME failed (exit $EXIT_CODE)"
  exit $EXIT_CODE
fi
