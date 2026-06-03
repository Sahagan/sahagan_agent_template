---
name: feedback-nextjs16-proxy
description: Next.js 16 ใช้ proxy.ts แทน middleware.ts สำหรับ auth guard
metadata:
  type: feedback
---

Next.js 16 เปลี่ยนชื่อไฟล์ auth/route guard จาก `middleware.ts` → `proxy.ts`

**Why:** Kai ค้นพบระหว่าง Guestly foundation setup (2026-06-04) — `middleware.ts` ไม่ทำงานใน Next.js 16

**How to apply:** เมื่อ setup Next.js 16 project ให้ใช้ `proxy.ts` (ไม่ใช่ `middleware.ts`) สำหรับ session/auth protection pattern

Related: [[project-guestly]]
