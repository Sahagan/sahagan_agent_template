# Brief: nova-002 — Fix Form Validation & Error UX
**From:** ARIA | **To:** Nova | **Priority:** High (blocking issues from QA)

## Persona
คุณคือ Nova — Senior Frontend Developer ไฟแรง แก้ให้ถูกต้องและสวยงาม

## Files to Fix
- `src/components/TripForm.tsx`
- `src/app/page.tsx`

## Fix 1 (BLOCKING): Same-day trip validation bug — TripForm.tsx

หา validation ที่ตรวจ returnDate และเปลี่ยน `<=` เป็น `<`:
```typescript
// Before (ผิด — บล็อก same-day trip)
if (... && formData.returnDate <= formData.departDate)

// After (ถูก — อนุญาต same-day)
if (... && formData.returnDate < formData.departDate)
```
Error message: `'วันกลับต้องหลังหรือตรงกับวันออกเดินทาง'`

## Fix 2 (BLOCKING): Error UX — แทน alert() ด้วย proper error state

**page.tsx** — เปลี่ยน:
```typescript
// Before (ผิด)
setAppState('form')
alert('เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง')

// After — เพิ่ม error state
```

เพิ่ม:
1. State: `const [error, setError] = useState<string | null>(null)`
2. ตอน catch: `setError(errorMessage)` + `setAppState('form')` (ไม่ต้อง reset form data ทิ้ง)
3. แสดง error banner ใต้ form (ถ้า error !== null):
   ```tsx
   {error && (
     <div className="...red banner...">
       <p>{error}</p>
       <button onClick={() => setError(null)}>ปิด</button>
     </div>
   )}
   ```
4. Clear error เมื่อ user submit ใหม่

## Fix 3 (non-blocking): Day count display ใน TripForm

หาทุกที่ที่คำนวณจำนวนวัน (`diff / 86400000` หรือ `getTime()`) แล้วเพิ่ม `+ 1` ให้สอดคล้องกับ API:
```typescript
// Before
const days = Math.ceil(diff / 86400000)
// After
const days = Math.ceil(diff / 86400000) + 1
```

## Fix 4 (non-blocking): Cap travelers UI ที่ 10 คน

ซ่อน "เพิ่มสมาชิก" button เมื่อ `travelers.length >= 10` และแสดง note เล็กๆ

## Verification Gate
```
npx tsc --noEmit
npm run build
```
ทั้งสองต้อง pass
