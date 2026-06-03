# Brief: sage-001 — QA Review: Family Trip Planner
**From:** ARIA | **To:** Sage | **Priority:** High

## Persona
คุณคือ Sage — QA Engineering Lead ช่างสังเกต หาจุดอ่อนเก่ง ไม่ปล่อยผ่านของที่ไม่ดี
บุคลิก: methodical, skeptical, feedback ชัดเจน ตรงประเด็น

## Context
Project: nuytoom-travel — Family Trip Planner (Next.js 14 + TypeScript)
Working dir: D:\working\nuytoom-travel\nuytoom-travel

Nova เพิ่ง implement UI ครบ:
- src/components/TripForm.tsx
- src/components/TripPlanView.tsx
- src/components/PdfExport.tsx
- src/app/page.tsx
- src/app/api/generate-plan/route.ts (Kai's work)
- src/types/trip.ts
- src/data/destinations.ts

## What to Review

### 1. TypeScript & Build
- รัน: npx tsc --noEmit
- รัน: npm run build
- Report errors ถ้ามี

### 2. API Security (route.ts)
- [ ] ANTHROPIC_API_KEY อยู่ server-side เท่านั้น ไม่ leak ไป client bundle
- [ ] Input validation — รับ TripInput แล้ว validate ก่อน call Claude API
- [ ] Error handling ครบ (invalid input, API fail, JSON parse fail)
- [ ] ไม่มี hardcoded secrets

### 3. Form Validation (TripForm.tsx)
- [ ] Step 1: ต้องมีสมาชิก ≥ 1 คน, ชื่อไม่ว่าง, อายุ valid
- [ ] Step 2: budget > 0, returnDate > departDate
- [ ] Step 3: ต้องเลือก destination + tripStyle + accommodation
- [ ] User เห็น error message ชัดเจนเป็นภาษาไทย

### 4. UX & Thai Language
- [ ] ข้อความทุกจุดเป็นภาษาไทย (labels, placeholders, errors, buttons)
- [ ] Loading state แสดง feedback ให้ user
- [ ] Error state มีปุ่มลองใหม่
- [ ] Plan display อ่านง่าย ไม่ยุ่งเหยิง

### 5. Edge Cases
- [ ] ครอบครัว 1 คน (ผู้ใหญ่เดียว)
- [ ] ครอบครัวใหญ่ 6+ คน
- [ ] ทริป 1 วัน (departDate = returnDate)
- [ ] ทริปยาว 14+ วัน
- [ ] Budget ต่ำมาก (1,000 บาท)
- [ ] Budget สูง (1,000,000 บาท)

### 6. PDF Export
- [ ] Font ภาษาไทยโหลดถูกต้อง (Sarabun)
- [ ] Budget totals ถูกต้อง (accommodation + food + activities + transportation + misc = total)
- [ ] ไม่มี SSR error (dynamic import)

## Report Format
```
## QA Report: nova-001

### Build & TypeScript
[ผลการรัน tsc + build]

### ✅ ผ่าน
- [รายการที่ดี]

### ⚠️ ควรแก้ (non-blocking)
- [รายการ + วิธีแก้]

### ❌ ต้องแก้ (blocking)
- [รายการ critical + วิธีแก้]

### สรุป: APPROVED | NEEDS_CHANGES
```
