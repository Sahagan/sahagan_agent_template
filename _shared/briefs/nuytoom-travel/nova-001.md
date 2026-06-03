# Brief: nova-001 — Family Trip Planner UI
**From:** ARIA | **To:** Nova | **Priority:** High

## Persona
คุณคือ Nova — Senior Frontend Developer ไฟแรง เชี่ยวชาญ React/Next.js + Tailwind + shadcn/ui
บุคลิก: perfectionist ด้าน UI, ใส่ใจทุก pixel, ภาษาไทยต้องอ่านสบาย, accessibility first

## Context
Project: nuytoom-travel — Family Trip Planner
Working dir: D:\working\nuytoom-travel\nuytoom-travel
Stack: Next.js 14, TypeScript, Tailwind CSS, shadcn/ui (already installed)
Types: src/types/trip.ts (TripInput, TripPlan, DayPlan, BudgetBreakdown, Traveler ฯลฯ)
Destinations: src/data/destinations.ts (DESTINATIONS array grouped by region)
API: POST /api/generate-plan — รับ TripInput → return { plan: TripPlan }
shadcn components available: Button, Input, Label, Select, Card, Progress, Badge, Separator

## What to Do

### 1. src/components/TripForm.tsx — Multi-step Form (4 steps)

State type:
```typescript
interface FormData {
  travelers: { name: string; age: number }[]
  totalBudget: number
  departDate: string
  returnDate: string
  destination: string
  tripStyle: 'family' | 'adventure' | 'relaxed' | 'culture'
  accommodation: 'budget' | 'standard' | 'luxury'
}
```

**Step 1 — สมาชิกในครอบครัว:**
- ปุ่มเพิ่มสมาชิก (default 1 คน)
- แต่ละคน: ช่องชื่อ + ช่องอายุ
- ปุ่มลบ (ถ้ามีมากกว่า 1 คน)
- Validate: ต้องมีอย่างน้อย 1 คน, ชื่อไม่ว่าง, อายุ 1-99

**Step 2 — งบประมาณและวันเดินทาง:**
- งบรวมทั้งทริป (บาท) — number input
- วันออกเดินทาง (date picker)
- วันกลับ (date picker)
- Validate: budget > 0, returnDate > departDate

**Step 3 — ปลายทางและสไตล์:**
- Dropdown ปลายทาง: grouped select จาก DESTINATIONS (group label + cities)
- สไตล์การเที่ยว: 4 card choices (family/adventure/relaxed/culture) พร้อม icon emoji + คำอธิบายภาษาไทย
- ระดับที่พัก: 3 card choices (budget/standard/luxury) พร้อม emoji + ราคาประมาณ
- Validate: ต้องเลือกครบทั้ง 3

**Step 4 — ยืนยันและสร้างแผน:**
- สรุปข้อมูลทั้งหมดใน card (read-only)
- ปุ่ม "สร้างแผนเที่ยว ✈️" — trigger onSubmit
- ปุ่มย้อนกลับแก้ไข

**UI requirements:**
- Progress bar บอก step 1/4 ที่ top
- ปุ่ม "ถัดไป" / "ย้อนกลับ" ที่ bottom ทุก step
- Smooth transition ระหว่าง step
- สีหลัก: sky/blue tones เหมาะกับ travel

Props: `onSubmit: (data: TripInput) => void`

---

### 2. src/components/TripPlanView.tsx — Plan Display

รับ `plan: TripPlan` แล้วแสดง:

**Header section:**
- ชื่อทริป (ใหญ่ bold)
- สมาชิก: badge แต่ละคน (ชื่อ + อายุ)
- วันที่: ออกเดินทาง → กลับ (X วัน)
- งบรวม: แสดงยอดรวม + breakdown bar

**Budget breakdown:**
- 5 categories: ที่พัก / อาหาร / กิจกรรม / การเดินทาง / อื่นๆ
- แสดงเป็น progress bars หรือ visual breakdown พร้อมยอดเงินแต่ละ category

**Daily plan:**
- แต่ละวันเป็น Card แยก (Day 1, Day 2, ...)
- ภายในแต่ละวัน:
  - ที่พัก: badge
  - Activities: timeline list (เวลา + กิจกรรม + สถานที่ + ราคา)
  - Meals: เช้า/กลางวัน/เย็น พร้อมร้านและราคา
  - ยอดรวมรายวัน

**Transportation & Tips:**
- Transportation notes section
- Tips: bullet list

**Action buttons:**
- ปุ่ม "โหลด PDF" (trigger PdfExport)
- ปุ่ม "วางแผนใหม่" (reset)

Props: `plan: TripPlan`, `onReset: () => void`

---

### 3. src/components/PdfExport.tsx — PDF Download

ใช้ @react-pdf/renderer:

**PDF structure:**
- หน้าปก: ชื่อทริป, สมาชิก, วันที่, งบรวม
- Budget summary table
- แต่ละวัน: activities + meals + daily total
- Transportation notes
- Tips

**Thai font:** ใช้ Sarabun — ต้อง register font จาก Google Fonts CDN:
```typescript
Font.register({
  family: 'Sarabun',
  fonts: [
    { src: 'https://fonts.gstatic.com/s/sarabun/v13/DtVmJx26TKEr37c9YK5sulFf.woff2' },
    { src: 'https://fonts.gstatic.com/s/sarabun/v13/DtVhJx26TKEr37c9YHZ5spFf2tZO.woff2', fontWeight: 700 },
  ]
})
```

Props: `plan: TripPlan` — ปุ่ม download PDF inline

---

### 4. src/app/page.tsx — Main Page (อัปเดต)

State machine:
```
'form' → 'loading' → 'result'
```

- **'form'**: แสดง hero section + TripForm
- **'loading'**: full-screen loading (spinner + "กำลังสร้างแผนเที่ยว..." + animation)
- **'result'**: แสดง TripPlanView

Hero section (ขณะอยู่ใน form state):
- ✈️ ชื่อ app: "Trip Planner สำหรับครอบครัว"
- Tagline: "ให้ AI ช่วยวางแผนการเดินทางที่เหมาะกับทุกคนในครอบครัว"
- Design สวย มี gradient background

Error handling:
- ถ้า API error: toast หรือ alert ภาษาไทย
- ปุ่มลองใหม่

## Verification Gate
```
npx tsc --noEmit
npm run build
```
ทั้งสองต้องผ่านโดยไม่มี error

## Report Back
```json
{
  "status": "complete | blocked",
  "filesCreated": [],
  "buildResult": "pass | fail",
  "errors": [],
  "notes": ""
}
```
