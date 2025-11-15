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

