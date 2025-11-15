# 🏠 Home Assistant Smart Home Project (Docker + ESPHome + MQTT)

This repository contains my **final-year smart home project** built with  
**Home Assistant**, **Docker Compose**, **ESPHome**, **MQTT (Mosquitto)**, **MariaDB**, and **phpMyAdmin**,  
running on my local network with ESP32-based sensor nodes.

> 🇹🇭 โปรเจคนี้เป็นระบบ Smart Home สำหรับฝึกใช้งาน Home Assistant + ESPHome + Docker + Sensor หลายตัว  
> ใช้ในรายวิชา / โปรเจควิศวกรรมคอมพิวเตอร์ มหาวิทยาลัยแม่ฟ้าหลวง (MFU)

---

## 📚 Table of Contents

1. [Project Overview](#-project-overview)
2. [Key Features](#-key-features)
3. [System Architecture](#-system-architecture)
4. [Tech Stack](#-tech-stack)
5. [Hardware Used](#-hardware-used)
6. [Repository Structure](#-repository-structure)
7. [Prerequisites](#-prerequisites)
8. [Installation & Setup](#-installation--setup)
9. [Docker Compose Stack](#-docker-compose-stack)
10. [Home Assistant Configuration](#-home-assistant-configuration)
11. [ESPHome Nodes & YAML](#-esphome-nodes--yaml)
12. [Automations](#-automations)
13. [Dashboards](#-dashboards)
14. [Troubleshooting](#-troubleshooting)
15. [Future Improvements](#-future-improvements)
16. [Credits](#-credits)

---

## 🧾 Project Overview

This project simulates a **real home automation environment** where multiple sensors and actuators  
are connected to **ESP32** boards and integrated into **Home Assistant** through **ESPHome** & **MQTT**.

Main objectives:

- Monitor **temperature, humidity, gas, smoke, light intensity, and motion**
- Control **fan (PWM)** and **LED** based on sensor values and automations
- Store historical data in **MariaDB**
- Visualize data and controls on **Home Assistant Dashboards**
- Practice real DevOps-style deployment using **Docker Compose**

> 🇹🇭 เป้าหมายคือสร้างระบบ Smart Home ที่ใช้งานได้จริง + เหมาะกับการอธิบายให้กรรมการ/อาจารย์ดูว่า  
> เราเข้าใจ IoT, Docker, Database, Automation, และระบบ Home Assistant แบบ End-to-End

---

## ✨ Key Features

- 🌡 **Environmental Monitoring**
  - Temperature & humidity (DHT11)
  - Gas & smoke (MQ-2)
  - Light level (LDR)
  - Motion detection (PIR)

- 💡 **Actuators & Controls**
  - Fan with **PWM speed control**
  - LED indicator / room light

- 🤖 **Smart Automations**
  - Auto fan ON/OFF when temperature crosses a threshold
  - Gas alarm (buzzer/notification) when MQ-2 detects high gas
  - Auto LED ON when room is dark + motion detected
  - Notifications to Home Assistant app / mobile

- 🐳 **Containerized Stack**
  - One `docker-compose.yaml` to start the whole system
  - MariaDB as a dedicated Recorder backend
  - phpMyAdmin for DB inspection
  - Mosquitto MQTT broker
  - ESPHome dashboard for managing ESP32 nodes

---

## 🏗 System Architecture

**Logical architecture:**

```text
        +---------------------+
        |   ESP32 Node #1     |
        |  - DHT11            |
        |  - Fan (PWM)        |
        +----------+----------+
                   |
        +----------v----------+
        |   ESP32 Node #2     |
        |  - MQ-2 (Gas)       |
        |  - Buzzer / LED     |
        +----------+----------+
                   |
        +----------v----------+
        |   ESP32 Node #3     |
        |  - LDR (Light)      |
        |  - PIR (Motion)     |
        +----------+----------+
                   |
             (Wi-Fi / MQTT)
                   |
         +---------v----------+
         |   Mosquitto MQTT   |
         +---------+----------+
                   |
       +-----------v---------------------------+
       |            Home Assistant             |
       | - Integrations / ESPHome / MQTT       |
       | - Automations & Scripts               |
       | - Dashboards                          |
       +-----------+---------------------------+
                   |
         +---------v----------+
         |      MariaDB       |
         | (History / Logs)   |
         +---------+----------+
                   |
         +---------v----------+
         |     phpMyAdmin     |
         +--------------------+