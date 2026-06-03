---
name: project-nuytoom-travel
description: Family Trip Planner — Next.js 14 app, Vercel-ready, Claude API, สถานะ QA approved
metadata:
  type: project
---

**Project:** nuytoom-travel — Family Trip Planner (วางแผนท่องเที่ยวครอบครัว)
**Repo:** https://github.com/Sahagan/nuytoom-travel-planner.git (branch: master)
**Project dir:** `D:\working\nuytoom-travel\nuytoom-travel`
**Status:** QA Approved, พร้อม deploy — รอ ANTHROPIC_API_KEY ใส่ใน .env.local

**Why:** ครอบครัว input สมาชิก/budget/destination → Claude AI generate แผนเที่ยวรายวัน + budget breakdown → download PDF

**Stack:** Next.js 14.2 + TypeScript + Tailwind + shadcn/ui + Claude API (claude-sonnet-4-6) + @react-pdf/renderer  
**No DB, No Auth** — stateless, Vercel free tier

**How to apply:** ถ้า user ถามเรื่อง project นี้ → ชี้ไปที่ repo และแนะนำ set `ANTHROPIC_API_KEY` ก่อน `npm run dev`

**Known issues (non-blocking):**
- PDF font พึ่ง Google CDN (Sarabun) → bundle ใน /public/fonts/ ถ้าต้องการ offline
- Next.js 14.2.29 มี security vulnerability → upgrade เป็น 15 ครั้งถัดไป
