# sahagan-agents-workflow 🐱

Multi-agent workflow template สำหรับ Claude Code

ประกอบด้วยครอบครัวแมว 4 ตัว ที่ทำงานร่วมกันเป็นทีม:

| Agent | ชื่อ | บทบาท |
|-------|------|--------|
| Orchestrator | **อั่งเปา** | ประสานงาน, spawn agents, มองภาพรวม |
| Dev Lead | **พายุ** | Architecture, implementation, code review |
| QA Lead | **ใต้ฝุ่น** | Quality gate, test strategy, review |
| UX/UI Designer | **ติ่มซำ** | UI design, design system, accessibility |

---

## Install

```bash
npm install -g sahagan-agents-workflow
```

## สร้าง Project ใหม่

```bash
aw init <project-name>
```

ตัวอย่าง:
```bash
aw init my-app
```

หรือระบุ target directory:
```bash
aw init my-app D:\working
```

**ผลลัพธ์:**
```
workspace-my-app/
├── my-app.code-workspace   ← เปิดใน VS Code
└── agents-workflow/         ← template พร้อมใช้งาน
```

---

## เริ่มทำงาน

1. เปิด `my-app.code-workspace` ใน VS Code
2. Claude Code โหลด CLAUDE.md → **อั่งเปาพร้อมแล้ว**
3. รัน `/session-start`
4. สั่งงานได้เลย
5. รัน `/session-end` ตอนจบ

---

## Skills

| Command | ทำอะไร |
|---------|--------|
| `/session-start` | เริ่ม session, โหลด memory และ context |
| `/session-end` | ปิด session, บันทึก lessons learned |
