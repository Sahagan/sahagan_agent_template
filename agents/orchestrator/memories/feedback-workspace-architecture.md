---
name: feedback-workspace-architecture
description: ARIA อยู่ใน agent-template แยกจาก project folder — workspace เห็นทั้งคู่
metadata:
  type: feedback
---

แยก ARIA (agent-template) ออกจาก project folder — ไม่ต้อง copy template files เข้าไปใน project

**Why:** VS Code workspace รู้จักทุก folder ใน workspace อยู่แล้ว → ARIA ใช้ absolute path เข้าถึง project ได้โดยตรง  
Project repo จึง clean 100% ไม่มี agent files ปน

**How to apply:**
```
workspace-project/
├── *.code-workspace          ← เพิ่ม project ใหม่แค่ add folder
├── agent-template/           ← ARIA อยู่ที่นี่ (1 instance จัดการทุก project)
│   └── _shared/briefs/
│       └── [project-name]/  ← briefs แยกตาม project
└── [project-name]/           ← Pure project code เท่านั้น
```

เมื่อสั่งงาน agent ให้ระบุ absolute path ใน brief:  
`Working dir: D:\working\[project-name]\[project-name]`
