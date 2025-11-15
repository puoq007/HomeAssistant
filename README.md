# 🏠 Home Assistant Smart Home Project (Docker Environment)

[![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Core-41BDF5?logo=homeassistant&logoColor=white)](https://www.home-assistant.io/)
[![ESPHome](https://img.shields.io/badge/ESPHome-Devices-000000?logo=esphome&logoColor=white)](https://esphome.io/)
[![MQTT](https://img.shields.io/badge/MQTT-Mosquitto-6001D2?logo=eclipsemosquitto&logoColor=white)](https://mosquitto.org/)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![MariaDB](https://img.shields.io/badge/MariaDB-Database-003545?logo=mariadb&logoColor=white)](https://mariadb.org/)
[![phpMyAdmin](https://img.shields.io/badge/phpMyAdmin-DB%20UI-6C78AF?logo=phpmyadmin&logoColor=white)](https://www.phpmyadmin.net/)

This repository focuses on building a reproducible, modular, and scalable **Docker-based environment** for running Home Assistant and related services.  
It is part of a larger initiative to create educational materials and a practical smart-home system that beginners — even those with **zero hardware knowledge** — can use to start learning IoT, sensors, automation, and real-world smart-home deployment.

---

## 📘 Project Purpose / วัตถุประสงค์ของโปรเจค

This project was created as part of my learning and final-year work to explore real-world smart-home development using **Home Assistant**, **Docker**, **MQTT**, and **ESPHome**.

🇹🇭 **เหตุผลในการสร้างโปรเจคนี้:**

- เพื่อทำ **สื่อการเรียนการสอน** สำหรับ *ผู้เริ่มต้น (Beginner)* ที่ “ไม่มีพื้นฐานฮาร์ดแวร์เลย” และอยากเริ่มต้นจากศูนย์  
- เพื่อให้เข้าใจการทำงานของระบบ **IoT และ Smart Home** ตั้งแต่ระดับเซ็นเซอร์ → การส่งข้อมูล → ระบบอัตโนมัติ  
- เพื่อใช้เป็นตัวอย่างสำหรับผู้ที่สนใจสร้าง **โปรเจคที่ใหญ่ขึ้น** เช่น การควบคุมไฟบ้าน, ระบบแจ้งเตือน, ระบบตรวจวัดสภาพแวดล้อม  
- เพื่อเป็นพื้นฐานให้ผู้เรียนสามารถนำไป **พัฒนาอุปกรณ์จริง** และติดตั้งในบ้านของตัวเองได้  
- เพื่อเป็นส่วนหนึ่งของการจัดทำโปรเจคของมหาวิทยาลัย และส่งมอบให้กับ **อาจารย์ที่ปรึกษาโปรเจค**  
- เพื่อพัฒนาระบบ Smart Home ที่สามารถนำไปใช้งานในบ้านจริงได้ในอนาคต  

This README documents **only the Docker environment** that powers the system.

---

## 📚 Table of Contents

1. [Docker Compose Overview / ภาพรวมระบบ Docker](#-docker-compose-overview--ภาพรวมระบบ-docker)  
2. [System Diagram / แผนภาพระบบ](#-system-diagram--แผนภาพระบบ-docker-architecture)  
3. [File Structure / โครงสร้างไฟล์](#-file-structure--โครงสร้างไฟล์-docker-only)  
4. [Run Order / ลำดับการรันระบบ](#-run-order-แนะนำลำดับการรันระบบ)  
5. [Debug Commands / คำสั่ง Debug](#-debug-commands--คำสั่ง-debug-สำคัญ)  
6. [Service URLs / จุดเข้าใช้งานระบบ](#-service-urls--จุดเข้าใช้งานระบบ)  
7. [Cleanup / การลบ Container และ Volume](#-cleanup--การลบ-container--volume)

---

## 🐳 Docker Compose Overview / ภาพรวมระบบ Docker

This system uses a multi-container Docker stack to run the complete smart-home environment:

- **Home Assistant** – core automation platform (ระบบหลักสำหรับ Automation และ Dashboard)  
- **MariaDB** – database for Recorder/History (เก็บประวัติและ Log ระยะยาว)  
- **Mosquitto MQTT Broker** – message broker สำหรับรับ/ส่งข้อมูลจาก ESP32 ผ่าน MQTT  
- **ESPHome Dashboard** – สำหรับจัดการ ESP32, ดูสถานะ และ OTA firmware  
- **phpMyAdmin** – UI for database management (จัดการฐานข้อมูลผ่านเว็บเบราว์เซอร์)  

🇹🇭 ส่วน Docker นี้ทำหน้าที่เป็น “โครงสร้างพื้นฐาน (Infrastructure)” ให้กับระบบ Smart Home ทั้งหมด  
โดยออกแบบให้ **รันซ้ำได้ง่าย (reproducible)**, **ขยายได้ (scalable)** และ **ย้ายเครื่องได้สะดวก** ด้วย Docker Compose เพียงไฟล์เดียว

---

## 🧭 System Diagram / แผนภาพระบบ (Docker Architecture)

```text
                +----------------------+
                |      ESP32 Nodes     |
                |  (MQTT Publishers)   |
                +----------+-----------+
                           |
                           | Wi-Fi / TCP
                           v
                 +---------+---------+
                 |    Mosquitto     |
                 |   MQTT Broker    |
                 +---------+---------+
                           |
        +------------------+-------------------+
        |                                      |
        v                                      v
+---------------+                +---------------------------+
| Home Assistant| <----API-----> |         ESPHome           |
|  Core System  |                |  Dashboard & OTA Manager  |
+-------+-------+                +-------------+-------------+
        |                                      |
        | Recorder / History                   |
        v                                      v
 +------+---------------+         +---------------------------+
 |        MariaDB       |         |        phpMyAdmin         |
 |  Long-term Storage   |         |   DB Web Management UI    |
 +----------------------+         +---------------------------+

```

แผนภาพนี้แสดงลำดับการไหลของข้อมูลจาก ESP32 → MQTT → Home Assistant → ฐานข้อมูลโดย Docker จะเป็นตัวจัดการทุก Service ให้ทำงานอยู่บนเครื่องเดียวกัน (หรือเครื่องในเครือข่ายเดียวกัน)

## 📁 File Structure / โครงสร้างไฟล์ (Docker Only)
```text
homeassistant/
├─ docker-compose.yaml      # ไฟล์หลักสำหรับรันทุก Container
├─ config/                  # ถูกแม็ปเป็น /config ของ Home Assistant
│  ├─ configuration.yaml
│  ├─ secrets.yaml
│  ├─ automations.yaml
│  ├─ scripts.yaml
│  ├─ scenes.yaml
│  └─ esphome/              # ถ้าใช้ร่วมกับ ESPHome Dashboard
├─ mariadb/                 # Volume สำหรับเก็บข้อมูล MariaDB
├─ mqtt/                    # Config / data ของ Mosquitto
└─ phpmyadmin/              # (ถ้ามี) config เพิ่มเติมของ phpMyAdmin

```

จุดสำคัญคือโฟลเดอร์ config/ ซึ่งจะใช้เก็บไฟล์ config ของ Home Assistant ทั้งหมด การแยกโฟลเดอร์แบบนี้ทำให้ Backup/Restore และ ย้ายเครื่อง ทำได้ง่ายมาก

## 🚀 Run Order (แนะนำลำดับการรันระบบ)

เพื่อให้ทุก Service ทำงานได้อย่างถูกต้อง แนะนำให้รันตามลำดับด้านล่างนี้:

1️⃣ Start database first (MariaDB)
```bash
docker compose up -d mariadb
```
รอประมาณ 5–10 วินาที เพื่อให้ MariaDB initial และพร้อมรับการเชื่อมต่อ

2️⃣ Start MQTT broker (Mosquitto)
```bash
docker compose up -d mosquitto
```
MQTT จะเป็นตัวกลางให้ ESP32 ส่งข้อมูลเข้า Home Assistant

3️⃣ Start Home Assistant
```bash
docker compose up -d homeassistant
```
Home Assistant จะเชื่อมต่อกับ MariaDB และ MQTT ตามที่กำหนดไว้ใน configuration.yaml

4️⃣ Start ESPHome Dashboard
```bash
docker compose up -d esphome
```
สำหรับจัดการ firmware, logs, และสถานะของ ESP32

5️⃣ Start phpMyAdmin (optional)
```bash
docker compose up -d phpmyadmin
```
ใช้เมื่อจำเป็นต้องดู / แก้ไขข้อมูลในฐานข้อมูลผ่าน UI

## ⭐ Start everything at once
หากต้องการความสะดวก สามารถรันทั้งหมดในคำสั่งเดียวได้:
```bash
docker compose up -d
```
ถ้าเจอปัญหา Home Assistant ต่อฐานข้อมูลไม่ได้ อาจเกิดจาก DB ยังไม่พร้อม สามารถแก้ด้วยการปิดทุกอย่าง แล้วรันตามลำดับด้านบนแทน

## 🛠 Debug Commands / คำสั่ง Debug สำคัญ

ชุดคำสั่งด้านล่างนี้ใช้เวลาระบบมีปัญหา เช่น Container ไม่ขึ้น, ต่อฐานข้อมูลไม่ได้, MQTT ไม่ตอบสนอง ฯลฯ

🔍 1. Check all container status / ดูสถานะ Container ทั้งหมด
```bash
docker compose ps
```
ใช้เช็คว่า Service ไหน Up, Exited, หรือมีสถานะผิดปกติ

🔍 2. View logs (live) / ดู log แบบ Real-time
```bash
docker compose logs -f homeassistant
```
คำสั่งสำหรับ Service อื่น ๆ:
```bash
docker compose logs -f mariadb
docker compose logs -f mosquitto
docker compose logs -f esphome
docker compose logs -f phpmyadmin
```
Log คือแหล่งข้อมูลหลักในการดูว่าเกิด Error อะไร เช่น
– ฐานข้อมูล connect ไม่ได้
– MQTT auth ผิด
– Config YAML ผิด syntax

🔧 3. Restart specific service / Restart เฉพาะ Service
```bash
docker compose restart homeassistant
```
ใช้กรณีแก้ config แล้วอยากให้ Home Assistant โหลดใหม่ หรือ Service ค้าง

🔧 4. Enter container shell / เข้าไปข้างใน Container
```bash
docker exec -it homeassistant bash
```
หรือสำหรับ MariaDB:
```bash
docker exec -it mariadb bash
```
เหมาะสำหรับ Advanced Debug เช่น ตรวจ log เพิ่ม, ทดสอบคำสั่งภายใน Container

🔧 5. Test MQTT broker manually (optional)
ถ้ามี mosquitto_pub / mosquitto_sub ติดตั้งบนเครื่อง:
```bash
mosquitto_sub -h localhost -t "test" -v
```
แล้วลองส่งข้อความ:
```text
mosquitto_pub -h localhost -t "test" -m "hello"
```
ถ้า subscribe ฝั่งแรกเห็นข้อความ test hello แสดงว่า MQTT broker ทำงานปกติ

🔧 6. Check MariaDB connection inside container
```bash
docker exec -it mariadb mysql -u homeassistant -p
```
ใช้ทดสอบว่า user/password ถูกต้อง และ DB พร้อมใช้งาน

🔧 7. Check ESPHome status / ตรวจสถานะ ESPHome
```bash
docker compose logs -f esphome
```
ดูว่า ESP32 เชื่อมต่อได้ไหม, มี error เรื่อง Wi-Fi/MQTT หรือไม่

## 🌐 Service URLs / จุดเข้าใช้งานระบบ

| Service          | URL / Port              | Description (TH/ENG)                      |
|------------------|--------------------------|-------------------------------------------|
| **Home Assistant** | http://localhost:8123   | Dashboard / Automations                   |
| **ESPHome**        | http://localhost:6052   | จัดการ ESP32 + OTA Firmware               |
| **phpMyAdmin**     | http://localhost:8080   | จัดการฐานข้อมูล MariaDB ผ่าน UI          |
| **Mosquitto MQTT** | localhost:1883          | MQTT Broker สำหรับ ESP32                  |


ถ้าเข้าจากเครื่องอื่นใน LAN ให้เปลี่ยน localhost เป็น IP ของเครื่อง Host เช่น:
```text
http://192.168.1.129:8123
http://192.168.1.129:6052
http://192.168.1.129:8080
```
## 🧹 Cleanup / การลบ Container & Volume
⚠️ คำเตือน: คำสั่งนี้จะลบทั้ง Container และ Volume (รวมถึงข้อมูล DB)
```bash
docker compose down -v
```
ใช้เมื่อ:
	•	ต้องการเริ่มระบบใหม่ทั้งหมดแบบ clean
	•	หรือมีปัญหากับฐานข้อมูลที่แก้ไม่ออก และยอมลบข้อมูลทั้งหมด

ลบ container แต่คง volume (ข้อมูลไม่หาย):
```bash
docker compose down
```
ลบเฉพาะ service ใด service หนึ่ง:
```bash
docker compose rm -f homeassistant
```
---

## 🏁 Project Footer / ข้อความปิดท้ายโปรเจค

### 📘 About This Project  
This Docker-based Home Assistant environment represents a modular, scalable, and production-ready foundation for building real smart-home systems.  
It is designed not only for learning, but also for practical deployment and further expansion into more advanced IoT solutions.

🇹🇭 **เกี่ยวกับโปรเจค (ภาษาไทย):**  
โปรเจคนี้ถูกสร้างขึ้นเพื่อเป็นพื้นฐานในการเรียนรู้ระบบ Smart Home ตั้งแต่ระดับเริ่มต้น   โดยเน้นให้ผู้ที่ไม่มีพื้นฐานฮาร์ดแวร์หรือ IoT มาก่อน สามารถทำตามและพัฒนาต่อยอดได้จริง   รวมถึงสามารถนำไปประยุกต์ใช้ในบ้านของตนเอง หรือใช้เป็นต้นแบบสำหรับโปรเจคที่ใหญ่ขึ้นได้

---

### 🌱 Vision & Learning Impact  
**EN:**  
The aim of this project is to encourage beginners to explore IoT, Docker, automation frameworks, and real hardware integration, allowing them to confidently move toward more complex systems in the future.

**TH:**  
เป้าหมายคือให้ผู้เริ่มต้นได้สัมผัสเทคโนโลยี IoT และระบบอัตโนมัติแบบจริงจัง   สร้างความเข้าใจในโครงสร้างพื้นฐานของระบบ และพร้อมต่อยอดสู่โปรเจคระดับสูงขึ้นในอนาคต

---

### 🤝 Acknowledgement  
Special thanks to my project advisor and everyone who supported this learning journey.  
This system is part of my academic development and aims to contribute to future students and makers.

🇹🇭 **ขอขอบคุณอาจารย์ที่ปรึกษา และผู้ที่มีส่วนช่วยในการพัฒนาโปรเจคนี้**  
หวังว่าโปรเจคนี้จะเป็นประโยชน์ทั้งต่อผู้เรียนและผู้ที่ต้องการเริ่มต้นเส้นทางด้าน Smart Home / IoT

---

### 🧩 Open for Improvement  
This environment can be extended with:  
- Hardware integrations (sensors/actuators)  
- Advanced Home Assistant automation  
- ESPHome nodes  
- Custom dashboards  
- Cloud integrations  
- AI-driven automations  

โปรเจคนี้ยังเปิดโอกาสให้เพิ่มเติมระบบต่าง ๆ ได้อีกมาก และถูกออกแบบไว้เพื่อรองรับอนาคตโดยตรง

---

## 🏁 Final Inspiration / ข้อความสร้างแรงบันดาลใจ

**EN:**  
May this project serve as inspiration for anyone beginning their journey into IoT and Smart Home technologies.  
I hope it encourages you to explore, build, experiment, and enjoy the process of creating something meaningful.  
May this be one of the steps that leads you toward even greater projects in the future.

**TH:**  
สุดท้ายนี้ ขอให้โปรเจคนี้เป็นแรงบันดาลใจให้ผู้ที่เริ่มต้นเส้นทางด้าน IoT และ Smart Home   ได้ค้นพบความสนุกในการสร้าง ทดลอง และพัฒนาสิ่งใหม่ ๆ  
และหวังว่าจะเป็นหนึ่งในก้าวที่พาคุณไปสู่โปรเจคที่ยิ่งใหญ่กว่าในอนาคต

---