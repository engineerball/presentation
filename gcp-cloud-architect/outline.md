# Cloud Architect — GCP Best Practices & Real-World Experience

> **Session Duration:** 2 hours (120 min)
> **Format:** Presentation + Workshop
> **Workshop Material:** Google Skills GSP290 — ETL Processing on Google Cloud Using Dataflow and BigQuery (Python)

---

## 1. Quick Recap: Cloud in 5 Minutes (10 min)

### Slide 1.1 — Title Slide
**Title:** Cloud Architect: GCP Best Practices & Real-World Experience
- Speaker name
- Agenda overview

---

### Slide 1.2 — Why Cloud?
**Key points:**
- Scale on demand — no more capacity planning guesswork
- Global infrastructure — deploy close to users in minutes
- Pay for what you use — shift from owning hardware to consuming services
- Innovation velocity — 200+ products, new features weekly
- Managed services reduce operational burden (patching, scaling, DR)

**Speaker notes:**
เน้นว่า cloud ไม่ใช่แค่ "เอาเครื่องไปวางไว้ที่อื่น" แต่เป็น platform ที่ให้บริการ capability มากมาย ที่เราเคยต้องสร้างเองทั้งหมด ตอนนี้เป็น API call เดียว

---

### Slide 1.3 — IaaS / PaaS / SaaS — Choose the Right Level
**Key points:**
- **IaaS** (Infrastructure as a Service): VMs, storage, networking — full control, full responsibility (GCE, VPC, Persistent Disk)
- **PaaS** (Platform as a Service): Managed platforms — focus on code, not infrastructure (Cloud Run, GKE, Cloud SQL, App Engine)
- **SaaS** (Software as a Service): Ready-to-use applications (Google Workspace, Looker, Firebase)

**Diagram suggestion:** Layered triangle — bottom: IaaS (most control), middle: PaaS (balanced), top: SaaS (least control)

**Speaker notes:**
คำถามสำคัญคือ "team ของคุณมี expertise แค่ไหน" ถ้าไม่มีใคร manage Kubernetes อย่างเลือก GKE ให้ ให้ไป Cloud Run ดีกว่า การเลือกผิด level คือการเลือกปัญหาเข้ามาเอง

---

## 2. GCP Overview (10 min)

### Slide 2.1 — GCP Global Infrastructure
**Key points:**
- **Regions** (40+): Independent geographic areas (us-central1, asia-southeast1)
- **Zones** (130+): Isolated locations within a region — deploy across zones for HA
- **Edge locations**: 150+ PoPs for CDN/Cloud Armor

**Diagram suggestion:** World map with GCP regions highlighted, zoom into a region showing 3+ zones

**Speaker notes:**
เลือก region ให้ใกล้ผู้ใช้ (latency) และเข้าใจ compliance requirement (GDPR → EU regions) อย่าลืมว่า zone แต่ละอัน isolated — ถ้า zone หนึ่งล่ม app ยังต้องทำงานได้

---

### Slide 2.2 — GCP Architecture Big Picture
**Key points:**
- GCP organizes resources hierarchically: **Organization → Folders → Projects → Resources**
- Projects are the billing and isolation boundary
- Shared VPC enables network sharing across projects
- Cloud Identity / IAM manages access across the hierarchy

**Diagram suggestion:** Org tree diagram: Org → Folder (Production, Staging, Dev) → Projects → Services

**Speaker notes:**
การออกแบบ org structure ตั้งแต่แรกสำคัญมาก ถ้า design ผิดตอนหลังจะย้ายยาก แนะนำให้ใช้ Folder แยก environment และ team ให้ชัดเจน

---

### Slide 2.3 — Pricing Basics
**Key points:**
- **On-Demand:** Pay per use, no commitment — good for dev/test/spiky workloads
- **Committed Use Discounts (CUDs):** 1-3 year commitment → up to 57% off compute
- **Sustained Use Discounts (SUDs):** Automatic — run a VM for >25% of the month → get discount automatically
- **Preemptible/Spot VMs:** Up to 91% off, can be reclaimed anytime — batch jobs, fault-tolerant workloads
- **Free Tier:** Always Free + 12-month free trial ($300 credit)

**Speaker notes:**
SUDs คือสิ่งที่หลายคนไม่รู้ — ไม่ต้องทำอะไร รันไปเรื่อยๆ discount มันเข้ามาเอง ส่วน CUDs ให้ใช้กับ workload ที่มี steady baseline ชัดเจน อย่าซื้อกับ workload ที่ยังไม่ stable

---

### Slide 2.4 — Infrastructure as Code on GCP
**Key points:**
- **Terraform** (recommended): Declarative, provider ecosystem, state management
- **Google Cloud Deployment Manager:** GCP-native, less community adoption
- **Cloud Build:** CI/CD pipeline — automates terraform apply on merge
- **Config Connector:** Manage GCP resources via Kubernetes manifests (if using GKE)
- **Key benefits:** Reproducible, auditable, version-controlled, no click-ops

**Best practice:** Store state in GCS with versioning enabled. Use separate state files per environment. Lock state to prevent concurrent modifications.

**Speaker notes:**
"Click-ops" คือศัตรูของ production environment ทุกอย่างที่ทำได้ผ่าน UI ควรทำได้ผ่าน code เพื่อ reproducibility และ audit trail

---

## 3. GCP Core Services (15 min)

### Slide 3.1 — Compute Options at a Glance
**Key points:**

| Service | Best For | Scaling | Management |
|---|---|---|---|
| **GCE** | Full control, custom OS, migration | Manual / MIG | You manage everything |
| **Cloud Run** | Containers, HTTP workloads | Automatic (0→N) | Serverless, pay per request |
| **GKE** | Container orchestration, microservices | Automatic (cluster autoscaler) | You manage cluster |
| **App Engine** | Web apps, simple deploy | Automatic | Fully managed platform |
| **Cloud Functions** | Event-driven, short-lived tasks | Automatic (0→N) | Serverless, pay per invocation |

**Diagram suggestion:** Decision tree — "Do you need containers?" → Yes → "Do you need Kubernetes?" → GKE vs Cloud Run. No → App Engine / Cloud Functions.

**Speaker notes:**
เริ่มจาก Cloud Run ก่อนเสมอถ้าได้ — ง่ายสุด, deploy container ได้ทันที, scale to zero, pay per request ถ้าอยากลอง Kubernetes ให้ใช้ GKE Autopilot ที่ Google ดูแล control plane ให้ GCE ให้ใช้ตอนที่ต้องการ control เต็มรูปแบบจริงๆ เท่านั้น

---

### Slide 3.2 — Storage Options
**Key points:**

| Service | Type | Use Case |
|---|---|---|
| **GCS** | Object storage | Files, images, backups, data lake |
| **Cloud SQL** | Managed relational DB | MySQL, PostgreSQL, SQL Server |
| **Spanner** | Globally distributed SQL | Multi-region ACID transactions |
| **Firestore** | NoSQL document DB | Mobile/web apps, real-time sync |
| **Memorystore** | Managed Redis/Memcached | Caching, session store |

**Diagram suggestion:** Decision matrix — Structured vs Unstructured × Small scale vs Global scale

**Speaker notes:**
GCS คือ storage พื้นฐานที่ทุกอย่างใช้ — data lake, backup, static assets, logs archive Cloud SQL เลือกถ้าต้องการ relational DB แบบ classic Spanner แพงแต่ powerful มาก — ถ้าไม่จำเป็นต้อง global ACID อย่าเลือก Firestore ดีสำหรับ mobile app แต่ใช้แทน relational DB ไม่ได้

---

### Slide 3.3 — Networking
**Key points:**
- **VPC:** Software-defined network — private IP space, subnets, firewall rules, routing
- **Cloud Load Balancing:** Global anycast LB — HTTP(S), TCP, SSL, internal/external
- **Cloud CDN:** Content delivery at 150+ edge locations
- **Cloud Armor:** DDoS protection + WAF at the edge
- **Cloud NAT:** Outbound internet for private instances (no public IP needed)

**Best practices:**
- Use private Google Access — access GCP APIs without public IPs
- Private Service Connect — keep traffic on Google's network
- VPC Flow Logs — audit all network traffic

**Speaker notes:**
Networking คือ foundation ที่หลายคนมองข้าม ออกแบบผิดตอนหลังแก้ยากมาก ให้ private services ทุกอย่างที่ได้ ใช้ Cloud NAT สำหรับ outbound traffic only Cloud Armor ต่ออยู่กับ Load Balancer อยู่แล้ว เปิดใช้เลย ฟรี tier มี DDoS protection พื้นฐาน

---

### Slide 3.4 — Serverless & Event-Driven
**Key points:**
- **Cloud Functions:** Event-triggered code (HTTP, Pub/Sub, Cloud Storage events)
- **Eventarc:** Event routing — connect sources to destinations decoupled
- **Workflows:** Orchestrate services (APIs, Cloud Functions, BigQuery jobs) as step-by-step workflows
- **Cloud Tasks:** Asynchronous task queues with retry logic

**Pattern: Event-driven architecture on GCP**
1. Event source (Pub/Sub, Storage, Scheduler)
2. Event router (Eventarc)
3. Handler (Cloud Functions, Cloud Run, Workflows)
4. Downstream (BigQuery, Cloud Storage, external API)

**Speaker notes:**
Workflows คือ Swiss Army Knife ของ GCP — orchestrate อะไรก็ได้เป็น step-by-step ไม่ต้องเขียน code เยอะ เหมาะสำหรับ ETL pipeline, approval flows, multi-service coordination Cloud Functions Gen 2 ใช้ Eventarc อยู่แล้ว ให้ใช้ Gen 2 เป็น default

---

## 4. Data Engineering & Big Data Platform on GCP (15 min)

### Slide 4.1 — Modern Data Platform on GCP — Big Picture
**Key points:**
- **Ingest → Process → Store → Analyze → Serve** pipeline
- GCP provides managed services for every stage
- Separation of storage and compute (BigQuery + GCS)
- Unified batch + streaming (Dataflow / Apache Beam)

**Diagram suggestion:** End-to-end data platform architecture:
- Sources (apps, databases, APIs, IoT)
- → Ingestion layer (Pub/Sub, Dataflow, Data Fusion)
- → Storage layer (GCS as data lake, BigQuery as warehouse)
- → Processing layer (Dataflow, Dataproc, BigQuery)
- → Analytics layer (Looker, Data Studio, Vertex AI)
- → Serving layer (APIs, dashboards, ML models)

**Speaker notes:**
GCP มีข้อได้เปรียบชัดเจนใน data platform — BigQuery เป็น serverless data warehouse ที่ดีมาก, Dataflow คือ managed Apache Beam, และทั้งหมด integrat กันด้วย BigLake แนวคิดสำคัญคือ "decoupled storage and compute" — จัดเก็บข้อมูลที่ GCS (ถูก), process ด้วย BigQuery/Dataflow (เร็ว)

---

### Slide 4.2 — Data Ingestion
**Key points:**

| Service | Type | Best For |
|---|---|---|
| **Cloud Pub/Sub** | Real-time messaging | Event streaming, real-time pipelines |
| **Dataflow** | Batch + Streaming | ETL/ELT, complex transformations |
| **Cloud Data Fusion** | Visual ETL | No-code/low-code data pipelines |
| **Transfer Service** | Bulk data transfer | Migrating data into GCP |
| **Datastream** | CDC | Replicating database changes in real-time |

**Real-time vs Batch decision:**
- **Real-time:** Need data within seconds/minutes (fraud detection, live dashboards)
- **Batch:** Can wait minutes/hours (daily reports, data warehousing)
- **Lambda architecture:** Use both — real-time for immediate insights, batch for corrections and deep analysis

**Speaker notes:**
Pub/Sub คือ backbone ของ real-time architecture ทุก event-driven system ควรผ่าน Pub/Sub Dataflow เป็น Apache Beam ที่ Google manage ให้ — ไม่ต้องจัดการ cluster เองเหมือน Spark บน Dataproc ถ้า team ไม่มี Spark expertise ให้ใช้ Dataflow + SQL ใน BigQuery แทน

---

### Slide 4.3 — Data Lake & Warehouse
**Key points:**
- **GCS as Data Lake:** Store raw data in open formats (Parquet, Avro, ORC)
  - Lifecycle policies: auto-transition to Nearline/Coldline/Archive
  - Bucket-level IAM, Object-level ACLs
- **BigQuery as Data Warehouse:** Serverless, columnar, petabyte-scale
  - Pay per data processed (not per cluster)
  - BigLake: query data in GCS directly (Parquet, ORC, Iceberg, Delta Lake)
  - BI Engine: in-memory caching for repeated queries
- **BigLake Unified:** One engine queries both warehouse (BigQuery native) and lake (GCS) data

**Best practice:** Use BigQuery for analytics, GCS for raw data + archive. Don't copy data unnecessarily — use BigLake to query in place.

**Speaker notes:**
BigQuery คือตัวเปลี่ยนเกม — ไม่ต้องจัดการ cluster ไม่ต้อง tune ไม่ต้อง scale แค่เขียน SQL แล้วมันทำงาน ค่าใช้จ่ายคือ data scanned ดังนั้นให้ partition table และ cluster data ให้ดีเพื่อลด cost

---

### Slide 4.4 — Orchestration
**Key points:**
- **Cloud Composer:** Managed Apache Airflow — industry standard for workflow orchestration
  - DAGs (Directed Acyclic Graphs) define task dependencies
  - Schedule, retry, alert built-in
  - Good for: complex ETL with many dependencies
- **Workflows:** Serverless orchestration for simpler chains
  - YAML-based step definitions
  - No infrastructure to manage
  - Good for: API orchestration, conditional logic, simple pipelines
- **Cloud Scheduler:** Cron-like scheduling for HTTP targets, Pub/Sub, App Engine

**Speaker notes:**
ถ้า pipeline ซับซ้อน มี dependency หลายชั้น → Composer (Airflow) ถ้าแค่เรียก API 2-3 ตัวเรียงกัน → Workflows อย่าเลือก Composer ถ้าไม่จำเป็น เพราะต้องดูแล cluster (แม้ Google จะ managed แล้วก็ตาม)

---

### Slide 4.5 — Analytics & ML
**Key points:**
- **Looker:** BI platform — semantic layer, embedded analytics, data applications
- **Vertex AI:** ML platform — AutoML, custom training, model deployment, feature store
- **Data Studio (Looker Studio):** Free dashboards — quick visualization
- **BigQuery ML:** Train ML models directly in BigQuery using SQL

**Best practice:** Start with BigQuery SQL for analytics and simple ML (BQML). Graduate to Vertex AI for complex models.

**Speaker notes:**
BQML คือ feature ที่หลายคนไม่รู้ — train model ใน BigQuery ได้โดยใช้ SQL เลย ไม่ต้อง export data ไปที่อื่น เหมาะสำหรับเริ่มต้น พอ model ซับซ้อนขึ้นค่อยย้ายไป Vertex AI

---

## 5. GCP Networking & Security (15 min)

### Slide 5.1 — VPC Design Best Practices
**Key points:**
- **Private-first approach:** No public IPs on workloads when possible
- **Shared VPC:** Central networking team manages VPC, projects attach to it
  - Service projects attach to a host project's VPC
  - Centralized firewall and routing control
- **VPC Peering:** Connect VPCs privately (not transitive)
- **VPC Service Controls:** Create security perimeters around GCP APIs (BigQuery, Cloud Storage)
  - Prevent data exfiltration even if credentials are compromised
- **Private Service Connect:** Access Google APIs via private endpoints (private.googleapis.com)

**Common mistake:** Using default VPC for production → no segmentation, no isolation, hard to add later.

**Speaker notes:**
VPC ออกแบบตั้งแรกให้ดีกว่าแก้ทีหลัง ใช้ shared VPC ใน org ที่มีหลาย team — network team ดูแล centrally, dev team ใช้ service project VPC Service Controls คือ layer ความปลอดภัยที่หลายองค์กรข้ามไป มันสร้าง perimeter รอบ API data ถ้า credential รั่ว ก็ยังไม่สามารถดึง data ออกไปได้

---

### Slide 5.2 — IAM Best Practices
**Key points:**
- **Principle of Least Privilege:** Grant minimum permissions needed
- **Service Accounts:** Identity for services/apps (not users)
  - One service account per workload — don't share
  - Disable/default service account keys — use Workload Identity instead
- **Workload Identity:** GKE pods authenticate as GCP service accounts (no key files!)
- **IAM Roles:** Prefer predefined roles over basic/owner/editor
  - Example: `roles/storage.objectViewer` not `roles/editor`
- **Custom Roles:** For fine-grained permissions that predefined roles don't cover

**Common mistakes:**
1. Using `roles/owner` or `roles/editor` for everything
2. Storing service account key files in code/containers
3. One service account for all workloads
4. Not rotating credentials

**Speaker notes:**
IAM คือสิ่งที่ผิดพลาดที่สุดใน GCP ที่เจอ — คนใช้ editor/owner เพราะง่าย แต่นั่นคือการให้ permission เกินความจำเป็น ใช้ Workload Identity แทน service account key เสมอ ถ้ายังมี key file อยู่ใน repo → เป็นช่องโหว่หมด

---

### Slide 5.3 — Cloud Armor & BeyondCorp
**Key points:**
- **Cloud Armor:** DDoS protection + WAF policies
  - Preconfigured WAF rules (SQL injection, XSS, LFI, RFI)
  - Rate limiting, geo-blocking, IP allowlist/denylist
  - Adaptive Protection: ML-based threat detection
  - Attached to Load Balancer (External HTTP(S) LB)
- **BeyondCorp Enterprise:** Zero-trust access
  - Context-aware access policies (user identity, device posture, location)
  - Replace VPN with identity-based access
  - Identity-Aware Proxy (IAP): Protect internal apps without VPN
  - Access Context Manager: Define org-level access policies

**Speaker notes:**
Cloud Armor คือ layer แรกของ defense — เปิด preconfigured WAF rules เลย ฟรี ไม่มีเหตุผลไม่เปิด BeyondCorp/IAP คือทางเลือกที่ดีกว่า VPN ในหลายกรณี — ให้ access ตาม identity + device posture แทนที่จะให้ทุกคนที่มี VPN เข้ามาได้หมด

---

### Slide 5.4 — Real-World Security Horror Stories
**Key points:**
- 🔴 **Misconfigured storage bucket → public data exposure** (happens constantly)
  - Fix: Enable uniform bucket-level access, set IAM not ACLs, use Organization Policy Constraints
- 🔴 **Service account key in GitHub repo → full project compromised**
  - Fix: Workload Identity, git-secrets scanning, no keys
- 🔴 **Open firewall rule 0.0.0.0/0 on SSH/RDP port → crypto mining**
  - Fix: Use IAP for SSH, restrict firewall to bastion/IAP ranges, disable public IP
- 🟡 **No audit logging → can't investigate incidents**
  - Fix: Enable Cloud Audit Logs at organization level, export to BigQuery

**Speaker notes:**
ทั้ง 4 เรื่องนี้เจอจริงๆ ใน production ที่คนทำ และทั้งหมดป้องกันได้ง่ายๆ ถ้าตั้งค่าถูกตั้งแรก ให้ enable Organization Policy Constraints ตั้งแต่วันแรก — เช่น disable public IP โดย default, restrict service account key creation

---

## 6. Well-Architected Framework — GCP Version (5 min)

### Slide 6.1 — GCP Well-Architected Framework
**Key points:**
Google's framework based on 4 pillars:

| Pillar | Key Questions |
|---|---|
| **Reliability** | Can the system recover from failures? Are there automated backups and failover? |
| **Security** | Is data encrypted? Are permissions least-privilege? Is there incident response? |
| **Cost Optimization** | Are you using the right pricing model? Are there idle resources? |
| **Operational Excellence** | Can you monitor, detect, and respond to issues? Is there CI/CD? |

**GCP tools per pillar:**
- Reliability: Cloud Monitoring, Cloud Logging, Error Reporting, SLO monitoring
- Security: Security Command Center, Cloud Armor, VPC Service Controls, IAM Recommender
- Cost: Active Assist Recommenders, Budget Alerts, Cost Management
- Operations: Cloud Build, Cloud Deploy, Operations Suite

**Speaker notes:**
นี่คือ checklist ก่อน deploy production ให้ทุก project run ผ่าน framework นี้อย่างน้อย 1 ครั้ง ใช้ GCP Cloud Assessment tool ที่ Google ให้ฟรีเพื่อวัด maturity score

---

### Slide 6.2 — Production Checklist
**Key points:**
- [ ] IAM: No owner/editor roles on service accounts, Workload Identity enabled
- [ ] Networking: Private IPs only, Cloud NAT for outbound, Cloud Armor enabled
- [ ] Monitoring: Alerting policies for SLO violations, uptime checks enabled
- [ ] Logging: Cloud Audit Logs enabled, log-based metrics for errors
- [ ] Cost: Budget alerts set, no unused resources (check Recommender)
- [ ] Data: Encrypted at rest + in transit, backup configured, retention policy set
- [ ] CI/CD: All infrastructure changes through code review (not click-ops)
- [ ] DR: Documented failover plan, tested at least once

**Speaker notes:**
ส่ง checklist นี้ให้ team ทุกคน ก่อนที่จะ ship อะไรขึ้น production checklist ไม่ได้ซับซ้อนแต่มักถูกข้ามเพราะรีบ อย่ารีบ รีบจะแพงกว่า

---

## 7. Workshop: ETL Pipeline with Dataflow + BigQuery (40 min)

### Slide 7.1 — Workshop Overview
**Key points:**
- **What we'll build:** End-to-end ETL pipeline
  - Ingest CSV data from Cloud Storage → BigQuery
  - Transform data with Apache Beam (Dataflow)
  - Enrich and query with BigQuery SQL
- **Tools:** Cloud Shell, Apache Beam (Python), Dataflow, BigQuery, Cloud Storage
- **Learning outcomes:**
  - Understand ETL pipeline architecture on GCP
  - Write and run Apache Beam pipelines
  - Use BigQuery for data transformation and analysis
  - Monitor Dataflow jobs

**Speaker notes:**
Lab นี้ตามมาจาก Google Cloud Skills (GSP290) เราจะทำกันทีละ step ให้เข้าใจทุกส่วน ไม่ใช่แค่ copy-paste ถ้ามี error ให้ raise hand เราแก้ด้วยกัน — เห็น error คือเห็นประโยชน์จริงๆ

---

### Slide 7.2 — Pre-Lab Setup (5 min)
**Key points:**
**If using Qwiklabs / Google Skills:**
- Start lab, open Cloud Console, activate Cloud Shell
- Project is pre-configured with required APIs

**If setting up manually:**
```bash
# Enable required APIs
gcloud services enable dataflow.googleapis.com compute.googleapis.com \
  storage.googleapis.com bigquery.googleapis.com \
  cloudaicompanion.googleapis.com

# Verify project
gcloud config list project
```

**Download starter code:**
```bash
gcloud storage cp -r gs://spls/gsp290/dataflow-python-examples .
```

**Speaker notes:**
สำหรับ workshop นี้ ถ้าใช้ Google Skills lab จะ setup ให้แล้ว แต่อยากให้รู้ว่าต้อง enable API อะไรบ้าง เพราะตอนทำจริงต้องทำเอง

---

### Slide 7.3 — Architecture: What We're Building
**Diagram suggestion:** Pipeline flow diagram:

```
Cloud Storage (CSV) 
  → Dataflow (Apache Beam Python)
    → BigQuery (lake dataset)
      → SQL Transform (BigQuery)
        → BigQuery (enriched table)
```

**Key points:**
- **Data Ingestion Pipeline:** GCS → filter header → parse CSV → write to BigQuery table
- **Data Transformation Pipeline:** GCS → parse → transform year format → write to BigQuery table
- **Data Enrichment:** BigQuery SQL JOIN → aggregated result table

**Speaker notes:**
อธิบาย architecture ก่อนเขียน code — ให้เห็นภาพรวมก่อนว่า data จะไหลยังไง จาก CSV ใน GCS เข้า Dataflow process แล้วเข้า BigQuery จากนั้นใช้ SQL transform เพิ่ม

---

### Slide 7.4 — Step 1: Create Resources (5 min)
**Key points:**
```bash
# Create Cloud Storage bucket
gcloud storage buckets create gs://$PROJECT_ID/ --location=$REGION

# Copy data files
gcloud storage cp gs://spls/gsp290/data_files/usa_names.csv gs://$PROJECT_ID/data_files/
gcloud storage cp gs://spls/gsp290/data_files/head_usa_names.csv gs://$PROJECT_ID/data_files/

# Create BigQuery dataset
bq mk lake
```

**Speaker notes:**
bucket ชื่อตาม project ID เพื่อความ unique ข้อมูลคือ CSV ของ baby names ใน US — เรียบง่ายแต่เพียงพอสำหรับเรียนรู้ pipeline

---

### Slide 7.5 — Step 2: Data Ingestion Pipeline (15 min)
**Key points:**

**Review the code** (`data_ingestion.py`):
```python
# Pipeline steps:
# 1. Read CSV from GCS (TextIO)
# 2. Filter out header row
# 3. Parse lines → dictionaries
# 4. Write to BigQuery (BigQueryIO)
```

**Setup Docker container:**
```bash
cd ~
docker run -it -e PROJECT=$PROJECT_ID \
  -v $(pwd)/dataflow-python-examples:/dataflow python:3.8 /bin/bash

pip install apache-beam[gcp]==2.59.0
cd /dataflow
```

**Run the pipeline:**
```bash
python dataflow_python_examples/data_ingestion.py \
  --project=$PROJECT_ID \
  --region=$REGION \
  --runner=DataflowRunner \
  --machine_type=e2-standard-2 \
  --staging_location=gs://$PROJECT_ID/test \
  --temp_location=gs://$PROJECT_ID/test \
  --input=gs://$PROJECT_ID/data_files/head_usa_names.csv \
  --save_main_session
```

**Verify in BigQuery:**
```sql
SELECT * FROM lake.usa_names LIMIT 10;
```

**Speaker notes:**
สิ่งสำคัญ: อธิบายว่า pipeline ทำอะไรบ้างก่อน run ให้เปิดไฟล์ data_ingestion.py แล้วอ่าน comment ดู คำว่า "runner=DataflowRunner" หมายคือ run บน GCP Dataflow service (distributed) ถ้าเปลี่ยนเป็น "DirectRunner" จะ run local ได้เลยสำหรับ dev รอให้ job status เป็น Succeeded แล้วค่อยไป BigQuery ดูผล

---

### Slide 7.6 — Step 3: Data Transformation Pipeline (10 min)
**Key points:**

**Review the code** (`data_transformation.py`):
- Similar to ingestion but adds **data transformation**
- Converts year field to BigQuery DATE format
- Demonstrates the "Transform" step in ETL

**Run the transformation pipeline:**
```bash
python dataflow_python_examples/data_transformation.py \
  --project=$PROJECT_ID \
  --region=$REGION \
  --runner=DataflowRunner \
  --machine_type=e2-standard-2 \
  --staging_location=gs://$PROJECT_ID/test \
  --temp_location=gs://$PROJECT_ID/test \
  --input=gs://$PROJECT_ID/data_files/head_usa_names.csv \
  --save_main_session
```

**Speaker notes:**
ต่างจาก ingestion pipeline ตรงที่มี transform step เพิ่มเข้ามา — แปลง format ของข้อมูลให้ BigQuery เข้าใจ นี่คือ "T" ใน ETL ในโลกจริง transform step จะซับซ้อนกว่านี้มาก (data cleansing, dedup, enrichment)

---

### Slide 7.7 — Step 4: Data Enrichment with BigQuery SQL (5 min)
**Key points:**

```sql
-- Join and enrich data
SELECT 
  t.state,
  t.gender,
  COUNT(*) as name_count,
  AVG(t.year) as avg_year
FROM lake.usa_names t
WHERE t.year > 2000
GROUP BY t.state, t.gender
ORDER BY name_count DESC
LIMIT 20;
```

**Key concepts:**
- BigQuery SQL for ad-hoc analysis
- Partitioning for cost optimization (WHERE clause filters partitions)
- BigQuery processes terabytes in seconds — serverless power

**Speaker notes:**
ตอนนี้ข้อมูลอยู่ใน BigQuery แล้ว ใช้ SQL query ได้ทันที ลอง query ต่างๆ ดู เปลี่ยน WHERE, GROUP BY, ลอง JOIN กับ table อื่น BigQuery จะ optimize ให้เอง — ทำให้สิ่งที่เคยต้องใช้ Spark hours ทำเสร็จใน SQL query เดียว

---

### Slide 7.8 — Workshop Recap
**Key points:**
- **Ingest:** GCS → Dataflow (Apache Beam) → BigQuery
- **Transform:** Dataflow pipeline with data processing logic
- **Analyze:** BigQuery SQL for insights
- **Key takeaway:** GCP provides managed services for the entire data lifecycle — you write the logic, Google manages the infrastructure

**Speaker notes:**
สรุปให้เห็นภาพรวมอีกครั้ง — เราทำ ETL pipeline แบบ end-to-end ได้ภายใน 40 นาที โดยที่ไม่ต้องจัดการ server เลย นี่คือจุดแข็งของ GCP สำหรับ data engineering

---

## 8. Lessons Learned / War Stories (5 min)

### Slide 8.1 — Things We Learned the Hard Way
**Key points:**

🔥 **Over-provisioning**
- Deployed GCE with 16 vCPU for app that uses 2 → wasted $3,000/month
- **Fix:** Use Cloud Monitoring to understand actual usage → rightsized to e2-standard-2

🔥 **BigQuery Cost Surprise**
- `SELECT *` on unpartitioned 5TB table → $25 in one query
- **Fix:** Always partition + cluster tables. Use `SELECT` specific columns.

🔥 **VPC Misconfiguration**
- Accidentally opened 0.0.0.0/0 on port 22 for "temporary debugging" → forgot to close → crypto miner
- **Fix:** Use IAP for SSH, never open SSH to the internet

🔥 **Service Account Chaos**
- 1 service account with owner role used by 15 different services → couldn't audit or rotate
- **Fix:** One service account per workload, least-privilege roles

🔥 **Data Pipeline Without Monitoring**
- Dataflow job failed silently for 3 days → downstream reports were stale
- **Fix:** Cloud Monitoring alerts on pipeline failures + data freshness checks

**Speaker notes:**
ทั้งหมดเจอจริงๆ ไม่ใช่เรื่องแต่ง ประสบการณ์เหล่านี้คือสิ่งที่ไม่เคยสอนใน course แต่ต้องเจอเองถึงจะเข้าใจ ให้เอาไปเป็น lesson เผื่อไม่ต้องเจอซ้ำ

---

### Slide 8.2 — Tips & Tricks
**Key points:**
1. **Always set budget alerts** — first thing after project creation, before any deployment
2. **Use labels consistently** — enable billing breakdown by team/project/environment
3. **Enable all audit logs at org level** — you'll need them when something goes wrong
4. **Use terraform for everything** — click-ops in production will bite you
5. **Test in a separate project** — never experiment in production
6. **Read the Recommender** — GCP's Active Assist finds idle resources, security issues, and optimization opportunities
7. **Start simple, iterate** — Cloud Run before GKE, Managed Instance Group before custom autoscaling

**Speaker notes:**
7 ข้อนี้คือ golden rules ที่อยากบอกตัวเองตอนเริ่มใช้ GCP ถ้าทำตั้งแต่แรกจะชีวิตง่ายขึ้นเยอะ

---

## 9. Q&A (5 min)

### Slide 9.1 — Thank You & Q&A
**Title:** Questions?
- Contact info / resources
- Links to lab material: https://www.skills.google/focuses/3460
- GCP Documentation: https://cloud.google.com/docs
- GCP Architecture Framework: https://cloud.google.com/architecture/framework
- GCP Skills Boost: https://www.cloudskillsboost.google/

**Speaker notes:**
เปิดรับคำถาม ถ้ามีเวลาเหลือให้ลองดู Dataflow job ที่ run ไว้ หรือ query BigQuery เพิ่มเติม แจก presentation slides หลังเลิก

---

## Appendix: Reference

### A. Useful gcloud Commands Quick Reference
```bash
# Project management
gcloud config set project PROJECT_ID
gcloud projects describe PROJECT_ID

# API management
gcloud services enable SERVICE_API
gcloud services list --enabled

# Storage
gcloud storage ls gs://BUCKET_NAME/
gcloud storage cp LOCAL_FILE gs://BUCKET_NAME/

# BigQuery
bq mk DATASET_NAME
bq query "SELECT * FROM dataset.table LIMIT 10"
bq show --schema dataset.table

# Compute
gcloud compute instances list
gcloud compute ssh INSTANCE_NAME

# IAM
gcloud iam service-accounts list
gcloud projects get-iam-policy PROJECT_ID

# Dataflow
gcloud dataflow jobs list
gcloud dataflow jobs describe JOB_ID
```

### B. Architecture Diagram Legend
- Blue boxes: GCP managed services
- Green arrows: Data flow
- Orange dashed: Security boundaries (VPC, Service Controls)
- Gray: External systems

### C. Recommended Reading
- Google Cloud Architecture Center: https://cloud.google.com/architecture
- GCP Well-Architected Framework: https://cloud.google.com/architecture/framework
- Google Cloud Skills: https://www.skills.google
- BigQuery Best Practices: https://cloud.google.com/bigquery/docs/best-practices
- Dataflow Documentation: https://cloud.google.com/dataflow/docs
