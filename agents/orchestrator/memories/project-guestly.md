---
name: project-guestly
description: Guestly — Guest management app for Thai events, LIVE at guestly-one.vercel.app
metadata:
  type: project
---

**Project:** Guestly — ระบบบริหารจัดการแขกงาน (งานบวช, งานแต่ง, ฯลฯ)
**Repo:** https://github.com/Sahagan/guestly.git (branch: develop)
**Project dir:** `D:\working\guestly\projects\guestly`
**Workspace:** `D:\working\guestly`
**Status:** LIVE — https://guestly-one.vercel.app

**Why:** เจ้าภาพต้องการทราบจำนวนแขกจริง → วางแผนอาหาร/โต๊ะ/งบได้แม่นยำ

**Stack:** Next.js 16.2.7 + TypeScript + Tailwind + shadcn/ui + Supabase (Auth + Postgres)
**Auth:** Google OAuth (เปลี่ยนจาก magic link เพราะ rate limit ตอนทดสอบ)
**Deploy:** Vercel — `npx vercel --prod` จาก local

**Flow หลัก:**
- Host สร้างงาน → ได้ QR 1 อัน (event-level invite token)
- ส่ง QR ให้แขกทาง LINE → แขกสแกน → กรอกชื่อ+จำนวนเอง → confirmed อัตโนมัติ
- Host เพิ่มแขกมือเอง → confirmed ทันที
- Dashboard: summary โต๊ะ/ค่าอาหาร/งบ real-time
- Check-in: search by name + optimistic update

**DB Migrations:**
- `001_initial.sql` — events, guests, rsvp_tokens + RLS
- `002_invite_token.sql` — events.invite_token + public_register_guest() function

**Known issues / lessons:**
- RLS circular reference: guests ↔ rsvp_tokens → แก้ด้วย `security definer` function [[feedback-nextjs16-proxy]]
- Next.js 16 → `proxy.ts` ไม่ใช่ `middleware.ts`
- Vercel deploy ใช้ `npx vercel --prod` จาก local เสมอ [[feedback-vercel-deploy-pattern]]

**Features ครบ MVP:**
- ✅ Google OAuth login
- ✅ Create/manage events
- ✅ Event invite QR (download + share)
- ✅ Guest self-registration (/join/[token])
- ✅ Manual guest add (confirmed immediately)
- ✅ Planning summary (tables/food/budget)
- ✅ Check-in screen
- ✅ Responsive (mobile + desktop)
- ✅ Thai UI + favicon
