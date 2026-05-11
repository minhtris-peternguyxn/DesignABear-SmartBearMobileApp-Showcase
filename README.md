<div align="center">

# 📱 SmartBear — Mobile Companion App

### Flutter Mobile App for SmartBear IoT Teddy Bear

[![Flutter](https://img.shields.io/badge/Flutter-3.9-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.9-0175C2?logo=dart&logoColor=white)](https://dart.dev/)
[![Android](https://img.shields.io/badge/Android-Ready-3DDC84?logo=android&logoColor=white)](https://developer.android.com/)
[![SignalR](https://img.shields.io/badge/SignalR-WebSocket-512BD4?logo=dotnet&logoColor=white)](https://learn.microsoft.com/aspnet/signalr)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

[English](#-english) · [Tiếng Việt](#-tiếng-việt)

</div>

---

## 📌 About This Repository / Về Repository Này

> **🔒 Note:** This is a **public showcase** of the SmartBear Mobile App, originally developed in a **private repository** during the Spring 2026 Capstone Project at FPT University HCM. As the original repo is private, **commit history is not available** — we kindly ask readers to understand. All secrets and API keys are loaded from `.env` (not included).
>
> **🔒 Lưu ý:** Đây là phiên bản **showcase công khai** của ứng dụng SmartBear Mobile, được phát triển trong **repository riêng tư** thuộc Đồ án Tốt nghiệp kỳ Spring 2026 tại Đại học FPT TP.HCM. Do repo gốc là private nên **không có lịch sử commit** — mong quý độc giả thông cảm. Toàn bộ secrets được load từ `.env` (không bao gồm trong repo).

---

## 🔗 Related Repositories / Các Repo Liên Quan

| Repository | Description / Mô tả | Link |
|:-----------|:---------------------|:-----|
| 📱 **Mobile App** | This repository / Repo hiện tại | You are here ✨ |
| 🧸 **E-commerce Backend** | Custom toy e-commerce platform | [DesignABear-Ecommerce-Showcase](https://github.com/minhtris-peternguyxn/DesignABear-Ecommerce-Showcase) |
| 🤖 **SmartBear IoT Server** | AI-powered smart toy backend | [DesignABear-SmartBearServer-Showcase](https://github.com/minhtris-peternguyxn/DesignABear-SmartBearServer-Showcase) |

## 📄 Documentation & Demo / Tài Liệu & Demo

| Resource | Link |
|:---------|:-----|
| 📑 **Project Report / Báo Cáo** | [Google Drive — Coming Soon](#) |
| 🎬 **Video Demo** | [Google Drive — Coming Soon](#) |
| 🖼️ **Screenshots** | [Google Drive — Coming Soon](#) |

---

# 🇬🇧 English

## Overview

**SmartBear Mobile App** is a Flutter-based companion application for the SmartBear IoT teddy bear system. Parents use this app to manage their child's smart bear — pairing devices, customizing AI personality, managing subscriptions, setting smart alarms, monitoring conversation history, and configuring safety controls.

The app communicates with the [SmartBear IoT Server](https://github.com/minhtris-peternguyxn/DesignABear-SmartBearServer-Showcase) via REST API and SignalR WebSocket for real-time voice streaming.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────┐
│              Flutter Mobile App              │
├─────────────────────────────────────────────┤
│  Screens (11 modules)                        │
│  ├── Auth (Login / Google OAuth)             │
│  ├── Home (Device Dashboard)                 │
│  ├── Device (Pairing / WiFi Setup)           │
│  ├── Profile (Child Profile Management)      │
│  ├── Alarm (Smart Alarm CRUD)                │
│  ├── Voice (TTS Voice Selection)             │
│  ├── Safety (Content Filter Settings)        │
│  ├── History (Conversation Logs)             │
│  ├── Premium (Subscription Plans)            │
│  ├── Settings (App Configuration)            │
│  └── Intro (Onboarding)                      │
├─────────────────────────────────────────────┤
│  Services                                    │
│  ├── AuthService (JWT + Google Sign-In)      │
│  └── ThemeService (Dark/Light Mode)          │
├─────────────────────────────────────────────┤
│  Core / Network                              │
│  ├── BaseApiClient (HTTP + Auth Headers)     │
│  └── ApiConfigManager (Runtime URL Config)   │
├─────────────────────────────────────────────┤
│  Data Layer                                  │
│  ├── API Clients (REST endpoints)            │
│  └── Models (Response/Request DTOs)          │
├─────────────────────────────────────────────┤
│  Config                                      │
│  └── AppConfig (dotenv-based secrets)        │
└─────────────────────────────────────────────┘
         │ REST API + SignalR WebSocket
         ▼
┌─────────────────────────────────────────────┐
│         SmartBear IoT Server (.NET 8)        │
└─────────────────────────────────────────────┘
```

## 🛠️ Tech Stack

| Category | Technology |
|:---------|:-----------|
| **Framework** | Flutter 3.9 / Dart 3.9 |
| **State Management** | StatefulWidget + Service pattern |
| **Networking** | `http` package + custom `BaseApiClient` |
| **Real-time** | SignalR WebSocket (voice streaming to bear) |
| **Auth** | Google Sign-In + JWT token management |
| **Config** | `flutter_dotenv` for environment-based secrets |
| **UI/UX** | Google Fonts, `flutter_animate`, Material 3 |
| **Audio** | `audioplayers` for voice preview playback |
| **Storage** | `shared_preferences` for local persistence |
| **IoT** | `wifi_scan` + `webview_flutter` for device pairing |
| **Platform** | Android (primary target) |

## ✨ Key Features

- 🔐 **Authentication** — Google OAuth + email/password with JWT
- 🧸 **Device Pairing** — WiFi scanning + OTP-based ESP32 registration
- 👶 **Child Profiles** — Multi-child support per device with age/personality config
- 🎭 **Bear Personality** — Configure AI behavior mode (Friendly, Educational, Storyteller...)
- ⏰ **Smart Alarms** — Schedule bear wake-up messages with custom voice
- 🎙️ **Voice Selection** — Preview and set TTS voices (ElevenLabs / Google TTS)
- 🛡️ **Safety Controls** — Manage banned words and content filter sensitivity
- 📜 **Conversation History** — View past bear-child interactions with timestamps
- 💳 **Premium Subscriptions** — In-app subscription management via PayOS
- 🌗 **Dark/Light Theme** — Full theme support with system preference detection
- 🎨 **Modern UI** — Material 3 design with smooth animations

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK 3.9+](https://docs.flutter.dev/get-started/install)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)
- Android device/emulator (API 24+)
- Running [SmartBear IoT Server](https://github.com/minhtris-peternguyxn/DesignABear-SmartBearServer-Showcase)

### Setup

```bash
# 1. Clone
git clone https://github.com/minhtris-peternguyxn/DesignABear-SmartBearMobileApp-Showcase.git
cd DesignABear-SmartBearMobileApp-Showcase

# 2. Configure environment
cp .env.example .env
# Edit .env with your server URL and Google OAuth client IDs

# 3. Install dependencies
flutter pub get

# 4. Run on device/emulator
flutter run
```

### Build APK

```bash
flutter build apk --release
```

## 📁 Project Structure

```
lib/
├── config/
│   └── app_config.dart              # Environment-based configuration
├── core/
│   └── network/
│       ├── base_api_client.dart      # HTTP client with auth headers
│       └── api_config_manager.dart   # Runtime API URL management
├── data/
│   ├── api/                          # REST API client classes
│   └── models/                       # Data models & DTOs
│       ├── request/                  # Request payloads
│       └── response/                 # Response models
├── screens/
│   ├── alarm/                        # Smart alarm management
│   ├── auth/                         # Login & registration
│   ├── device/                       # Device pairing & WiFi setup
│   ├── history/                      # Conversation history viewer
│   ├── home/                         # Main dashboard
│   ├── intro/                        # Onboarding screens
│   ├── premium/                      # Subscription plans
│   ├── profile/                      # Child profile management
│   ├── safety/                       # Content safety settings
│   ├── settings/                     # App settings
│   └── voice/                        # TTS voice selection
├── services/
│   ├── auth_service.dart             # Authentication logic
│   └── theme_service.dart            # Theme management
├── widgets/                          # Reusable UI components
└── main.dart                         # App entry point
```

---

# 🇻🇳 Tiếng Việt

## Tổng Quan

**SmartBear Mobile App** là ứng dụng Flutter đồng hành cho hệ thống gấu bông IoT thông minh SmartBear. Phụ huynh sử dụng app để quản lý gấu thông minh của con — ghép nối thiết bị, tùy chỉnh tính cách AI, quản lý gói subscription, đặt báo thức thông minh, xem lịch sử trò chuyện và cấu hình an toàn nội dung.

## ✨ Tính Năng Nổi Bật

- 🔐 **Đăng nhập** — Google OAuth + email/mật khẩu với JWT
- 🧸 **Ghép nối thiết bị** — Quét WiFi + đăng ký ESP32 qua OTP
- 👶 **Hồ sơ trẻ** — Hỗ trợ nhiều trẻ trên mỗi thiết bị, cấu hình tuổi & tính cách
- 🎭 **Tính cách gấu** — Cấu hình chế độ AI (Thân thiện, Giáo dục, Kể chuyện...)
- ⏰ **Báo thức thông minh** — Hẹn giờ gấu nói với giọng tuỳ chỉnh
- 🎙️ **Chọn giọng nói** — Nghe thử và chọn giọng TTS
- 🛡️ **Kiểm soát an toàn** — Quản lý từ cấm và bộ lọc nội dung
- 📜 **Lịch sử trò chuyện** — Xem các cuộc hội thoại gấu-trẻ
- 💳 **Gói Premium** — Quản lý subscription qua PayOS
- 🌗 **Giao diện sáng/tối** — Hỗ trợ theme theo hệ thống

## 🚀 Cài Đặt

```bash
# 1. Clone
git clone https://github.com/minhtris-peternguyxn/DesignABear-SmartBearMobileApp-Showcase.git
cd DesignABear-SmartBearMobileApp-Showcase

# 2. Cấu hình môi trường
cp .env.example .env
# Chỉnh .env với URL server và Google OAuth client IDs

# 3. Cài dependencies
flutter pub get

# 4. Chạy trên thiết bị/giả lập
flutter run
```

---

<div align="center">

## 👥 Team

**FPT University HCM — Capstone Project Spring 2026**

Made with ❤️ by the DesignABear Team

---

⭐ If you found this project useful, please consider giving it a star!

⭐ Nếu bạn thấy dự án này hữu ích, hãy cho chúng tôi một ngôi sao nhé!

</div>
