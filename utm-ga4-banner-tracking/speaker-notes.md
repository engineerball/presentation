# UTM Tracking for Banner Ads - Speaker Notes

## Slide 1 - Title
- เป้าหมายของ deck นี้ไม่ใช่สอน GA4 ทั้งระบบ
- เป้าหมายคือทำให้ทีมตัดสินใจเรื่อง UTM standard และ operating model ร่วมกันได้

## Slide 2 - Why now
- ตอนนี้ foundation พร้อมแล้ว เพราะมี GA4, Enhanced Measurement, Realtime
- สิ่งที่ยังขาดคือ naming convention กลาง
- ถ้าไม่ทำตอนนี้ data จะยิ่งย้อนกลับมา clean ยาก

## Slide 3 - Mental model
- UTM = where did the visit come from
- Event = what happened on site
- Key event = which outcomes matter to the business
- เน้นว่าถ้า track แค่ click volume เราจะ optimize ผิดเป้าได้

## Slide 4 - Proposed standard
- ใช้ utm_medium=banner เป็น default ก่อน เพราะทีมเข้าใจง่าย
- source คือ publisher
- campaign คือ objective ระดับธุรกิจ
- content คือ banner variant

## Slide 5 - Examples
- สาธิตตัวอย่าง URL จริง
- ชี้ให้เห็นว่าการตั้งชื่อ campaign ตาม business initiative สำคัญกว่าตามสีของ banner

## Slide 6 - Data flow
- อธิบาย flow ให้ทีมเห็นว่าการยิง event หลัง click สำคัญพอๆ กับการติด UTM
- เป้าหมายสุดท้ายคือ answer ว่า banner ไหนพา lead ที่มีคุณภาพมาได้ดีที่สุด

## Slide 7 - Events
- ถ้ายังไม่มี generate_lead หรือ success event ที่เชื่อถือได้ ควร prioritize ตรงนี้
- ถ้าต้องเลือกรอบแรก ให้เลือก event success หลักเพียงหนึ่งตัวก่อน

## Slide 8 - Operating model
- ต้องมี owner ของ naming และ owner ของ QA
- ไม่ควรปล่อยให้แต่ละคน generate ลิงก์แบบอิสระโดยไม่มี dictionary กลาง

## Slide 9 - Rollout
- รอบแรกไม่ต้องทำทุกอย่าง
- เอาให้ team standard ใช้งานได้จริงก่อน แล้วค่อยเพิ่ม reporting sophistication

## Slide 10 - Decisions
- ปิดด้วย decision questions 3 ข้อ
- พยายามให้ที่ประชุมจบด้วย owner และ next step ที่ชัดเจน
