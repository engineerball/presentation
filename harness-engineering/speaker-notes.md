# Speaker Notes — Harness Engineering

## Slide 1: Title — Harness Engineering
**Time:** 30 sec

**Notes:**
- ทักทาย บอกว่าวันนี้จะพูดถึง Harness Engineering — concept ที่กำลังเป็น talk of the town ในวงการ AI Engineering
- คำถามสำคัญบนสไลด์: "เมื่อ AI เขียนโค้ดได้ 10x แต่อะไรจะพังก่อน?" — นี่คือ core question ของทั้ง presentation
- ดึงจากหลายบริษัทชั้นนำ: Google, OpenAI, Anthropic, Stripe, Trae/ByteDance, ThoughtWorks, Meta

---

## Slide 2: Section Divider — 10x Moment
**Time:** 10 sec (transition)

**Notes:**
- ช่วงนี้จะสร้าง context ว่าทำไมต้องมี Harness Engineering

---

## Slide 3: ทีม Dev ของคุณ... ใช้ AI ทั้งทีมแล้ว
**Time:** 2 min

**Notes:**
- เริ่มด้วยสถานการณ์ที่ developer ในห้องนี้คุ้นเคย — PR และ Code Review
- **ก่อน AI:** PR ประมาณ 10 อัน/สัปดาห์, Review ทัน, Deploy ลื่น
- **หลัง AI:** PR 100+ อัน/สัปดาห์ (10x) แต่ Review ล้านหลัง, Pipeline เดี้ยง, Bug เยอะ
- **จริงๆในโลก dev:** AI agents ทำให้ปริมาณโค้ดเพิ่ม 10-15x ใน 18 เดือน แต่ Deploy pipeline, Code Review, Release process ยังเดิม
- **คำพูดสำคัญ:** ปัญหาไม่ใช่ AI ไม่ดี — ปัญหาคือทุกอย่างรอบๆ AI ไม่ได้เตรียมรับ
- ให้ถามว่าใครในห้องเคยเจอแล้ว — PR เยอะเกินไป review ไม่ทัน

---

## Slide 4: Release บ่อยแค่ไหน? — นั่นแหละจุดอ่อน
**Time:** 2 min

**Notes:**
- ให้คิดว่า release cadence ของทีมตัวเองเป็นยังไง
- **เดือนละครั้ง:** Code ก้อนใหญ่ → root cause หายาก → war room → stress → burnout
- **อาทิตย์ละครั้ง:** build time นานขึ้น → CI cost พุ่ง → ต้อง optimize
- **หลายครั้ง/สัปดาห์:** focus ย้ายจาก "output" (ทำเสร็จ) → "outcome" (สร้าง business impact)
- **4 คำที่ต้องแยก:** Deploy ≠ Release ≠ Output ≠ Outcome
  - Deploy = ขึ้น server
  - Release = เปิดให้ user ใช้
  - Output = feature ทำเสร็จ
  - Outcome = feature สร้าง impact จริง
- ถ้า team deploy ได้หลายครั้ง แต่ outcome ไม่เพิ่ม → กำลัง optimize ตัวผิด

---

## Slide 5: ทีมคุณ... ตามทันไหม?
**Time:** 1.5 min

**Notes:**
- ให้ดูแต่ละ role — ใครเจออะไรเมื่อ AI เข้ามา
- **Dev:** ผลิต 10x → ส่งงานเข้าคิวเยอะเกิน → ตามไม่ทัน
- **QA:** ตรวจเท่าเดิม → bug หลุดรอดเพราะรีบระบาย
- **DevOps:** pipeline เดิม → code conflict ดันขึ้น prod ไม่ทัน
- **Designer:** ออกสเปคไม่ทัน → รื้อแก้ซ้ำซาก
- **Conway's Law:** "โครงสร้างซอฟต์แวร์สะท้อนโครงสร้างทีม" — ถ้าเปลี่ยนเทคโนโลยีแต่ไม่ปรับ org → bottleneck ย้ายที่ไม่หาย

---

## Slide 6: Software Ecology — มองภาพใหญ่
**Time:** 1.5 min

**Notes:**
- Adam Bender (Google I/O 2026) มอง developer ecosystem เป็น Socio-Technical System
- **Socio (คน):** ทีม, บทบาท, Agile, Scrum, Code Review, วัฒนธรรม
- **Technical (เครื่องมือ):** โค้ด, Framework, CI/CD, AI Tools, Monitoring
- **กุญแจสำคัญ:** ทั้ง 2 ส่วนเชื่อมโยงกันแยกไม่ได้
- ถ้าเร่งฝั่ง Technical (เพิ่ม AI tools) โดยไม่ปรับฝั่ง Socio (process, roles) = สร้าง bottleneck ใหม่
- ตัวอย่าง: ซื้อ AI tool แพงๆ ให้ dev แต่ไม่เปลี่ยน review process → tool ใช้ประโยชน์ไม่ได้

---

## Slide 7: Section Divider — Harness Engineering คืออะไร?
**Time:** 10 sec (transition)

---

## Slide 8: คิดแบบ Computer Architecture
**Time:** 2 min

**Notes:**
- ใช้ analogy Computer Architecture เพราะ developer เข้าใจง่าย
- **AI Model = CPU:** แรงแค่ไหนก็ตาม แต่มันเป็นแค่ processor
- **Context Window = RAM:** จำกัดเหมือนกัน — เต็มแล้วต้องจัดการ
- **Agent = Application:** รันอยู่บน model แต่ต้องมี OS ควบคุม
- **Harness = OS:** นี่แหละจุดสำคัญ — OS คือที่กำหนด policy, จัดการ resource, ควบคุมทุกอย่าง
- **Philipp Schmid (Hugging Face):** "CPU + RAM แรงแค่ไหน ถ้าไม่มี OS ก็ใช้งานไม่ได้"
- **Trae/ByteDance analogy:** SOTA Model = Wild Horse, Harness = Control System, รวมกัน = Elite Performer

---

## Slide 9: ใครบัญญัติคำนี้?
**Time:** 1.5 min

**Notes:**
- **Mitchell Hashimoto** (HashiCorp co-founder — Terraform, Vault) พูดถึง harness concept ก่อน OpenAI
- เขาบอกว่า "เมื่อ AI ทำผิด ใช้ Engineering principles ป้องกัน ไม่ต้องแก้ซ้ำ"
- **OpenAI Codex Team** บล็อกอย่างเป็นทางการ กุมภา 2026
- Case study: แอป Sora Android — โค้ด 1 ล้านบรรทัด ที่คนไม่ได้เขียนเองสักบรรทัด
- แค่ 6 วันหลัง Mitchell พูด → OpenAI ปล่อยบทความ → จุดเริ่มต้นของ trend
- แสดงว่า concept นี้ "อยู่ในอากาศ" — หลายคนคิดพร้อมกัน

---

## Slide 10: สมการหลัก: Agent = Model + Harness
**Time:** 2 min

**Notes:**
- **สมการ:** Agent = Model + Harness — นี่คือ fundamental equation
- Harness คือทุกอย่างรอบ Model ที่ engineer ควบคุมได้:
  - Repository Structure — โครงสร้างโฟลเดอร์
  - CI/CD Configuration — Pipeline + Tests
  - Project Instructions — AGENTS.md, CLAUDE.md
  - Formatting & Linters — Rules enforcement
  - Tool Integrations — MCP, APIs, CLIs
  - Feedback Mechanisms — Tests, review loops
- ให้คิดว่าทีมตัวเองมีอะไรบ้างใน 6 อย่างนี้ — ส่วนใหญ่มีแค่ 2-3 อย่าง
- Key insight: ถ้ายิ่งลงทุน harness ดี → agent output ดีขึ้นเป็นทวีคูณ

---

## Slide 11: บทบาทเราเปลี่ยนไปแล้ว
**Time:** 1.5 min

**Notes:**
- นี่คือสไลด์ที่สำคัญมาก — เพราะมันกระทบทุกคนในห้อง
- **ก่อน:** เขียนโค้ดเอง, Review PR ทีละบรรทัด, Fix bug เมื่อเกิด, Document ให้คนอ่าน
- **หลัง (Harness):** ออกแบบ Environment, Review Agent Outcomes, Encode Bug Prevention, Document ให้ Agent อ่าน
- **เปลี่ยนจาก "Coder" เป็น "Architect"** — เหมือนกับเปลี่ยนจากคนถูกถ่านเป็นวิศวกรออกแบบระบบ
- Quote: "The discipline shows up more in the scaffolding rather than the code"
- ถ้ายังเขียนโค้ดเองทั้งหมด → กำลังสูญเสีย leverage ของ AI

---

## Slide 12: Section Divider — OpenAI Environment-First
**Time:** 10 sec (transition)

---

## Slide 13: OpenAI Codex Experiment — ผลลัพธ์
**Time:** 1.5 min

**Notes:**
- ตัวเลขที่ impressive ที่สุด:
  - **1 ล้านบรรทัด** โค้ด — ที่คนไม่ได้เขียนเองสักบรรทัด
  - **1,500 PRs** merged
  - **3.5 PRs/Dev/Day** — ปกติ dev ดีๆ ทำได้ 0.5-1
  - **3 → 7 Engineers** — เริ่ม 3 คน ตอนจบ 7 คน
  - **10x speedup**
- สร้าง Sora Android App — แอปจริงที่ใช้งานได้ 100% AI code
- 5 เดือนจาก commit แรก ถึง delivery
- ให้คิด: ถ้าทีม 3-7 คนทำแอประดับ Sora ได้ใน 5 เดือน โดยไม่ต้องเขียนโค้ดเอง → future ของ dev จะเป็นยังไง?

---

## Slide 14: Lesson 1: Repository as Knowledge System
**Time:** 2 min

**Notes:**
- **สิ่งที่ล้มเหลว:** Giant AGENTS.md — ไฟล์ใหญ่เกินไป ทำให้ agent confused
- ปัญหา: ไฟล์ใหญ่ crowd out task context + code context + docs → agent ทำงานผิดจุด
- **สิ่งที่ work:** Progressive Disclosure
  - AGENTS.md เป็น TOC ~100 บรรทัด — เป็นดัชนีชี้ไป docs/ เท่านั้น
  - docs/ directory แยก — Architecture maps, design docs, product specs
- **Quote สำคัญ:** "If the agent can't see it, it doesn't exist"
  - ความรู้สำคัญต้องเป็น readable markdown ใน repo
  - ถ้า knowledge อยู่ใน Confluence หรือ Notion → agent เห็นไม่ได้ = ไม่มีอยู่
- ให้นึกภาพ library: ถ้าหนังสือทุกเล่มวางกองรวมกัน → หาไม่ได้ ต้องมี catalog system

---

## Slide 15: Lesson 2: Architectural Constraints
**Time:** 2 min

**Notes:**
- OpenAI ใช้ **strict layered dependency model** — บังคับ AI สร้าง infrastructure ก่อนเสมอ
- Layer แบ่งเป็น: Types → Config → Repo → Service → Runtime → UI
- หมายความว่า AI ต้องทำ Types เสร็จก่อน ถึงจะทำ Config, ทำ Config เสร็จก่อน ถึงจะทำ Service
- **Cross-cutting concerns** (auth, telemetry, feature flags) เข้ามาได้ผ่าน explicit Provider interfaces เท่านั้น — ไม่ให้ AI inject ไปมา
- **Validated mechanically** ด้วย custom linters — ไม่ต้องพึ่งคนตรวจ
- **Surprising insight:** สิ่งที่เคยเป็น "enterprise over-engineering" กลายเป็น prerequisite สำหรับ autonomous agent development
- ถ้าไม่มี architectural control → AI จะสร้าง spaghetti code ได้เร็วมาก

---

## Slide 16: Lessons 3-6: Visibility, Merge, Entropy, Boring Tech
**Time:** 3 min

**Notes:**
4 lessons เร็วๆ แต่ละอัน:

- **Agent Visibility:** Agent ทำงานต่อเนื่อง 6+ ชม/feature ต้องเห็นว่าเกิดอะไรขึ้น
  - Chrome DevTools สำหรับ UI validation
  - Observability stack (LogQL/PromQL)
  - Per-worktree isolated instances

- **Merge Philosophy:** Blocking gates = counterproductive
  - PR lifespan สั้น ๆ ดีกว่า
  - Test flakes → follow-up runs ไม่ block
  - **Corrections ถูกกว่า indefinite waiting** — ให้ merge เร็วแล้วแก้ ดีกว่ารอ

- **Entropy Management:** Tech debt = compound interest
  - Golden principles ใน repo + lint enforcement
  - Background agents scan drift ตลอดเวลา
  - Auto-generate refactoring PRs

- **Boring Technology Wins:** Framework ที่ established ทำงานดีกว่า
  - Training data ใน LLM มีมากกว่า → model เข้าใจดีกว่า
  - Reimplement library เองบางครั้งดีกว่า import → เพราะ full control + test coverage

---

## Slide 17: Section Divider — Anthropic Multi-Agent
**Time:** 10 sec (transition)

---

## Slide 18: ปัญหา: AI ตรวจโค้ดตัวเอง
**Time:** 2 min

**Notes:**
- **Core problem:** Self-Serving Bias — AI ตรวจโค้ดตัวเอง → เข้าข้างตัวเองเสมอ
- เหมือนให้นักเรียนตรวจข้อสอบตัวเอง → จะบอกว่าถูกหมดเสมอ
- **Solution:** Multi-Agent Decoupling — แยกตัวเขียนกับตัวตรวจ
  - Planner: รับ requirement, ซอยเป็น tasks
  - Generator: เขียนโค้ดตาม tasks
  - Evaluator: black-box test ผ่าน browser/API
- **Trade-off ที่ต้องรู้:** Cost พุ่งจาก $9 → $200/งาน, ใช้เวลา 6 ชม
- Agent ตีกันเอง → Generator เขียนผิด → Evaluator ตำหนิ → แก้ → ตำหนิอีก → วน loop เผา Token ฟรี
- ท้ายสุด Dev ก็ต้องมาเขียน orchestration code เอง

---

## Slide 19: Two-Role Architecture
**Time:** 2 min

**Notes:**
- ปัญหา long-running tasks: context window หมด ก่อนจะทำเสร็จ
- Anthropic แก้ด้วย **Two-Role Architecture:**
  - **Initializer Agent:** รันครั้งเดียวใน session แรก
    - สร้าง init.sh (dev server setup)
    - สร้าง claude-progress.txt (track ความคืบหน้า)
    - เขียน feature list (JSON)
    - ทำ initial git commit
  - **Coding Agent:** ทุก session ถัดไป
    - อ่าน progress → เลือก feature ถัดไป
    - ทำงาน 1 feature ต่อ session
    - Git commit + update progress
    - State clean สำหรับ merge
- **Key concept:** Git commits + claude-progress.txt = structured artifacts ที่ทำให้ agent ตัวต่อไปรู้ว่าทำอะไรมาแล้ว
- ให้คิดว่าเหมือน "save game" ในวิดีโอเกม — ตายแล้ว respawn ได้จาก checkpoint

---

## Slide 20: 4 Failure Modes และวิธีแก้
**Time:** 2 min

**Notes:**
4 ปัญหาที่พบบ่อย:

1. **One-shotting:** Agent พยายาม build ทุกอย่างพร้อมกัน → chaos
   - Fix: Feature list JSON — 200+ features ทั้งหมดเริ่มจาก "failing"

2. **Premature Completion:** Agent เห็น progress บางส่วนแล้วประกาศเสร็จ
   - Fix: บังคับ ทำ 1 feature/session อย่างเดียว

3. **Buggy State:** Agent ทิ้งโค้ดไว้ในสภาพพัง
   - Fix: Git commits + progress file — อ่านทุกครั้งก่อนเริ่ม

4. **Premature Test Passing:** Test ผ่านแต่ feature ใช้งานไม่ได้
   - Fix: Browser automation (Puppeteer MCP) ตรวจ E2E

- Key insight: ถ้าไม่มี explicit prompting → Claude จะไม่ recognize เองว่า features ไม่ทำงาน E2E

---

## Slide 21: Feature List Pattern — ตัวอย่าง
**Time:** 1.5 min

**Notes:**
- แสดง concrete example — นี่คือ pattern ที่ใช้จริงกับ claude.ai clone project
- 200+ features ใน JSON file ทั้งหมดเริ่มจาก "passes: false"
- Coding agent เปลี่ยนได้แค่ "passes" field → ลด risk เปลี่ยน spec
- ใช้ JSON แทน Markdown → model แก้ได้น้อยกว่า
- ทุก feature มี test_steps ชัดเจน → E2E validation อัตโนมัติ
- ให้คิดว่านี่เหมือน Jira board แต่เป็น machine-readable

---

## Slide 22: Stripe — One-Shot Minions
**Time:** 2 min

**Notes:**
- Stripe ทำใน large monorepo — scale ใหญ่กว่า OpenAI case study
- **Philosophy:** One-shot — ส่ง task ต้นทาง, รับ PR ปลายทาง
- **Blueprints (Guides):** Structured docs ระดับ service
  - Contracts, architectural rules, interface specs
  - อธิบาย **how** services สร้าง (ไม่ใช่ what)
  - ลด inference burden บน model → agent เลือก architecture ถูกเอง
- **Pre-push Hooks (Sensors):** รันก่อน push → agent self-correct
  - Linters, Formatters, Type checkers, Tests
  - คนเห็นแค่ final result
- **Key difference จาก Anthropic:** Stripe ใช้ single-agent + strong sensors แทน multi-agent
  - ถูกกว่า เร็วกว่า แต่ต้องมี sensors ที่ดีมาก

---

## Slide 23: Section Divider — Guides & Sensors
**Time:** 10 sec (transition)

---

## Slide 24: Guides (Feedforward) vs Sensors (Feedback)
**Time:** 2 min

**Notes:**
- **Guides (Feedforward):** ควบคุม **ก่อน** agent ทำงาน
  - AGENTS.md, CLAUDE.md, Architecture rules, Code templates, Style guides, Blueprints
  - เหมือนกฎจราจร — บอกก่อนว่าทำได้/ทำไม่ได้
- **Sensors (Feedback):** สังเกต **หลัง** agent ทำงาน
  - Tests, Linters, Type checkers, AI code review, Pre-push hooks
  - เหมือนกล้องวงจรปิด — จับผิดภายหลัง
- **ต้องมีทั้งคู่:**
  - เฉพาะ Guides → Rules ไม่ถูก validated → feedback loop ขาด
  - เฉพาะ Sensors → Agent ทำผิดซ้ำเดิม → no prevention
- analogy: มีป้ายจราจรแต่ไม่มีตำรวจ = ใครก็ขับผ่านได้ / มีตำรวจแต่ไม่มีป้าย = ใครก็โดนจับ

---

## Slide 25: Computational vs Inferential Controls
**Time:** 1.5 min

**Notes:**
- **Computational:** Tests, Linters, Type checkers
  - เร็ว (ms–seconds), ถูก, deterministic
  - ควรใช้ให้มากที่สุด
- **Inferential:** AI review, Semantic analysis
  - ช้า (seconds–minutes), แพง, non-deterministic
  - ใช้เฉพาะที่ semantic judgment จำเป็นจริงๆ
- **Rule:** ใช้ Computational ก่อน (coverage, reliability) → Inferential เฉพาะที่จำเป็น
- ให้คิดว่า linter จับ semicolon หาย ใช้เวลา < 100ms และถูกต้องเสมอ → ทำไมต้องใช้ AI review?

---

## Slide 26: 3 Harness Domains
**Time:** 2 min

**Notes:**
3 domains ของ harness — แต่ละอันอยู่คนละระดับความสมบูรณ์:

1. **Maintainability (Most Mature):** Internal code quality
   - Linters, Coverage analysis, Code review agents, Mutation testing
   - เครื่องมือมีเยอะ ทำได้ดีแล้ว

2. **Architecture Fitness (Growing):** Structural rules, performance
   - Dependency rules, Fitness functions, Module boundaries
   - เริ่มมีเครื่องมือแต่ยังไม่ common

3. **Behaviour (Critical Gap):** Functional correctness
   - AI-generated tests, E2E validation
   - **ยังไม่น่าเชื่อถือพอ** ⚡ — นี่คือจุดที่ต้องลงทุนต่อ
- ให้คิดว่าทีมตัวเองอยู่ domain ไหน — ส่วนใหญ่อยู่แค่ Maintainability

---

## Slide 27: Harnessability — ก่อนจะลงทุน Harness
**Time:** 2 min

**Notes:**
- ก่อนจะสร้าง harness ต้องเช็คก่อนว่า codebase "รับ" harness ได้ดีไหม
- 4 properties สำคัญ:
  - Strongly-typed languages → type checker จับ error computational
  - Clear module boundaries → structural linting ทำได้
  - Defined service topologies → ย่อ output space ลง
  - Established frameworks → tooling มีให้ใช้
- **Ashby's Law:** Regulator ต้องมี variety เพียงพอ → ถ้า codebase สละสลวย ไม่มี boundary → output space ใหญ่เกิน → harness ครอบคลุมไม่ถึง
- **Practical tip:** ประเมิน harnessability ก่อน — refactor ให้ boundary + types ดีขึ้น อาจมี leverage สูงกว่าสร้าง harness ซับซ้อนบน codebase ที่สละสลวย

---

## Slide 28: The Human Implicit Harness
**Time:** 1.5 min

**Notes:**
- สไลด์สำคัญที่สุดสำหรับ perspective check
- Quote: "Higher-impact problems — misdiagnosis, overengineering — remain hard to automate"
- Human developers carry **implicit harnesses** ที่ agent ยังทำได้ไม่ได้:
  - **Experience:** รู้ว่า pattern ไหน work ใน context ไหน
  - **Accountability:** รับผิดชอบผลลัพธ์ — agent ไม่มี career risk
  - **Org Awareness:** เข้าใจ politics, priorities, constraints ของ org
- ให้คิดว่า dev อาจไม่เขียนโค้ดเองแล้ว แต่คุณค่าอยู่ที่การตัดสินใจ + context → นั่นแหละที่ AI ทำแทนไม่ได้

---

## Slide 29: Section Divider — Trae/ByteDance R.E.S.T.
**Time:** 10 sec (transition)

---

## Slide 30: R.E.S.T. Framework — 4 Core Objectives
**Time:** 2.5 min

**Notes:**
- Trae/ByteDance สรุป harness objectives เป็น 4 มิติ:

- **R — Reliability:** ระบบต้อง reliable
  - Fault Recovery: Auto-resume จาก checkpoints
  - Idempotency: Retry ปลอดภัย ไม่ corrupt state
  - Consistency: Behavior คงเส้นทางเดิม

- **E — Efficiency:** ใช้ resource อย่างคุ้มค่า
  - Resource Control: Token, API call, compute budgets
  - Low Latency: Quick feedback
  - Throughput: Tasks per unit time

- **S — Security:** ปลอดภัย
  - Least Privilege: Minimum permissions per sub-task
  - Sandboxing: Strict isolation
  - I/O Filtering: Prompt injection defense

- **T — Traceability:** ตามรอยได้
  - E2E Tracing: Full call chain
  - Explainable Decisions: Attribution
  - Auditable State: Query ย้อนได้
- ให้คิดว่า harness ที่ดีต้อง cover ทั้ง 4 มิติ — ถ้าขาดอันไหน จะมีช่องโหว่

---

## Slide 31: PPAF Cognitive Loop
**Time:** 2 min

**Notes:**
- Trae มอง agent เป็น cognitive loop 4 ขั้น:
  - **Perception:** อ่าน world + memory
  - **Planning:** generate plans
  - **Action:** execute tools
  - **Feedback:** observe results, replan
- **Agent Maturity Matrix:** 2 แกน
  - Cognitive Loop: Reactive → Proactive
  - Context Efficiency: Manual → Automated
- **REPL Container:** Deterministic shell wrapping non-deterministic LLM
  - เหมือน REPL (Read, Eval, Print, Loop) แต่สำหรับ AI agent
  - ควบคุม non-deterministic model ด้วย deterministic interface
- ให้คิดว่า agent ของทีมตัวเองอยู่จุดไหนใน maturity matrix

---

## Slide 32: 6 Design Principles + Core Philosophy
**Time:** 2 min

**Notes:**
6 principles อย่างรวดเร็ว:
1. Design for Failure — คิดว่าจะพัง ออกแบบให้ recover ได้
2. Contract-First — ตกลง interface ก่อน implement
3. Secure by Default — ปลอดภัยเป็น default
4. Separation of Concerns — แยก responsibility ชัดเจน
5. Everything Measurable — ทุกอย่างต้องวัดได้
6. Data-Driven Evolution — พัฒนาตามข้อมูล

**Core Philosophy:**
- "When a model hits a wall, implement an engineered mechanism so the same class of failure never happens again"
- **Harness is a living system:** พอ model ดีขึ้น → บาง practices เลิกใช้ → scenarios ใหม่ birth innovations ใหม่
- **From Executor to Architect:** "Soft constraints" (prompts) ไม่พอ → ต้องมี "Hard constraints" (engineering framework)

---

## Slide 33: Meta: AI Second Brain — 60K+ Users
**Time:** 2 min

**Notes:**
- Meta มี use case ที่ interesting — internal tool 63K+ installs, 10K DAU
- **PARA Workspace:** Projects, Areas, Resources, Archives
  - Root CLAUDE.md always loaded, per-project on demand
- **MCP Infrastructure:** Authenticated, scoped access to internal tools
  - Meetings, tasks, wikis, docs
- **Skills as Markdown:** Reusable workflows
  - No compilation, no deployment
  - 3,000+ skills ใน 3 เดือน
- **Progressive Disclosure:** Lean root context + project depth on demand
  - Loading everything degrades quality
- **Key Lesson:** Infrastructure (harness) must come before agent workflows
  - Agent only as useful as systems it can reach

---

## Slide 34: Section Divider — Trade-offs ที่ต้องรู้
**Time:** 10 sec (transition)

---

## Slide 35: Trade-off #1: แพงเกิน
**Time:** 1.5 min

**Notes:**
- **ตัวเลขจริง:** Single agent = $9/งาน, Multi-agent (Anthropic) = $200/งาน
- **Agent ตีกันเอง:** Planner สั่ง → Generator เขียนผิด → Evaluator ตำหนิ → แก้ → ตำหนิอีก → วน loop เผา Token
- มองเห็น pattern: Agent ไม่ได้便宜ทำให้เสร็จเร็วขึ้นเสมอ — บางครั้งแพงกว่าคนทำเอง
- ท้ายสุด Dev ก็ต้องมาเขียน orchestration code ควบคุม agent queue เอง
- ให้คิด ROI: ถ้า task เล็ก → single agent พอ, task ใหญ่ → multi-agent ถึงคุ้ม

---

## Slide 36: Trade-off #2: Test-Passing Illusion
**Time:** 1.5 min

**Notes:**
- **CI/CD บอก:** Test ผ่านทุกอัน ✓ → Code ไม่พัง, syntax ถูก, type ผ่าน
- **ความจริง:** Architecture พัง ✗ → Maintain ต่อไม่ได้, Rule ทับซ้อน, เพิ่ม Debt แทนลด
- **Greenfield Trap:** Project ที่ยังไม่มี Architecture ตั้ง Rule = "นั่งเทียนเขียน" — rules อาจกลายเป็น debt เอง
- ตัวอย่าง: สร้าง lint rule ใหม่ 10 ข้อ แต่ไม่มี architecture → rules ขัดแย้งกันเอง → agent สับสน
- Key insight: Test ผ่าน ≠ Code ดี — ต้องมี architecture fitness functions ร่วมด้วย

---

## Slide 37: Trade-off #3: Harness Decay ⚡
**Time:** 2 min

**Notes:**
- นี่คือ **warning ที่สำคัญที่สุด** ของทั้ง presentation
- "สิ่งที่สร้างมาคุม AI วันนี้ → กลายเป็นหนี้ทางเทคนิคในอีก 6 เดือน"
- **Evidence จริง:**
  - Anthropic: Opus 4.5→4.6 ลบ task-split (เปลือง Cost 40%), Opus 4.7 Self-eval harness สูบ Token ฟรี
  - Manus: รื้อระบบใหม่ 5 รอบใน 6 เดือน
  - LangChain: รื้อระบบใหม่ 3 รอบใน 1 ปี
- **Vercel case study น่าสนใจ:** ลบ AI Tools 80% ทิ้ง → AI ทำงานแม่นขึ้น
  - พอ AI ฉลาดแล้ว → ยัด Rule เยอะไปทำให้สับสน
- **Quote:** "Every component in a harness encodes an assumption about what the model can't do — and those assumptions are worth stress testing"
- ให้คิดว่า harness ที่สร้างวันนี้ จะต้อง review ทุก 3-6 เดือน

---

## Slide 38: The Harness Sandwich Pattern
**Time:** 1.5 min

**Notes:**
- Over-engineered harness = ปัญหาซ้อน 3 ชั้น:
  - **Constraint ซ้อน:** Rule เยอะเกิน → AI สับสน
  - **Cost ซ้อน:** Inferential control แพง → ใช้เยอะเกิน
  - **Debt ซ้อน:** Harness เก่า → รื้อไม่ทัน Model ใหม่
- **Vercel lesson ซ้ำ:** ลบ Tools 80% → AI ทำงานแม่นขึ้น
  - "over-constrained model underperforms unconstrained model"
- ให้คิดว่า "minimal viable harness" คืออะไร — ไม่ต้องครอบคลุมทุกอย่าง แต่ต้อง cover สิ่งที่สำคัญจริงๆ

---

## Slide 39: Timing Strategy — ตอนไหนควบคุม?
**Time:** 1.5 min

**Notes:**
- 4 timing stages สำหรับ controls:
  - **Pre-commit:** Fast linters, basic review — เร็ว, ถูก, ทุกครั้ง
  - **Pre-integration:** Quick sensors, type checks — ก่อน merge
  - **Post-integration:** Mutation testing, comprehensive review — หลัง merge
  - **Continuous:** Drift detection, runtime feedback — ตลอดเวลา
- **Harness Templates:** Pre-packaged guide+sensor bundles
  - สำหรับ common service topologies
  - Encode institutional best practices
  - Reduce per-project setup
- ให้คิดว่าทีมตัวเองมี controls ที่ stage ไหนบ้าง — ส่วนใหญ่มีแค่ pre-commit

---

## Slide 40: Closing — ก่อนจะวิ่งให้เร็ว 10x
**Time:** 1 min

**Notes:**
- สรุปทั้ง presentation ด้วยข้อความเดียว:
  "ก่อนจะวิ่งให้เร็ว 10x ต้องมั่นใจก่อนว่า ทิศทางและรากฐานแข็งแรงพอ"
- Harness Engineering ไม่ใช่เรื่องของ AI อย่างเดียว — เป็นเรื่องของ **ระบบรอบ AI**
- ถ้าอยากเริ่ม: เริ่มจาก AGENTS.md ที่ดี, linters ที่ชัด, architecture ที่ simple
- อย่า over-engineer — start small, measure, iterate
- Q&A
