<div align="center">

# 📱 SmartBear — Mobile Companion App

### Flutter Mobile App for SmartBear IoT Teddy Bear

[![Flutter](https://img.shields.io/badge/Flutter-3.9-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.9-0175C2?logo=dart&logoColor=white)](https://dart.dev/)
[![Android](https://img.shields.io/badge/Android-Ready-3DDC84?logo=android&logoColor=white)](https://developer.android.com/)
[![SignalR](https://img.shields.io/badge/SignalR-WebSocket-512BD4?logo=dotnet&logoColor=white)](https://learn.microsoft.com/aspnet/signalr)

<br>

[![Tiếng Việt Version](https://img.shields.io/badge/Language-Tiếng_Việt-red?style=for-the-badge&logo=translate)](./README.vi.md)

---

</div>

## 📌 Showcase Notice & Development Status

> **🔒 Showcase Notice:** 
> This is a **public showcase** version of the SmartBear Mobile App, originally developed in a **private repository** during the Spring 2026 Capstone Project at FPT University HCM. As the original repo is private, commit history is not available here. This repository is maintained as a personal job application portfolio demo. Following the graduation thesis defense, this project is being solely maintained, completed, and developed by **Tri Nguyen Minh** (@minhtris-peternguyxn).

---

## 🔗 Related Repositories & Docs

| Resource | Link |
|:---------|:-----|
| 🌐 **Live Demo Website** | [designabear.shop](https://designabear.shop) (Password: `minhtri10504`) |
| 📑 **Project Assets (Report, Demo, Images)** | [Google Drive Folder](https://drive.google.com/drive/folders/1HyvJ_ja7P2BdN88A7oy6Hs2fxi4oRyQE?usp=sharing) |
| 📱 **Mobile App** | This repository (English Version) |
| 🧸 **E-commerce Backend** | [DesignABear-Ecommerce-Showcase](https://github.com/minhtris-peternguyxn/DesignABear-Ecommerce-Showcase) |
| 🤖 **SmartBear IoT Server** | [DesignABear-SmartBearServer-Showcase](https://github.com/minhtris-peternguyxn/DesignABear-SmartBearServer-Showcase) |

---

## 📖 Overview

**SmartBear Mobile App** is a Flutter-based companion application for the SmartBear IoT teddy bear system. Parents use this app to manage their child's smart bear — pairing devices, customizing AI personality, managing subscriptions, setting smart alarms, monitoring conversation history, and configuring safety controls.

The app communicates with the [SmartBear IoT Server](https://github.com/minhtris-peternguyxn/DesignABear-SmartBearServer-Showcase) via REST API and SignalR WebSocket for real-time voice streaming.

---

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

---

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

---

## ✨ Key Features

- 🔐 **Authentication** — Google OAuth + email/password with JWT.
- 🧸 **Device Pairing** — WiFi scanning + OTP-based ESP32 registration.
- 👶 **Child Profiles** — Multi-child support per device with age/personality config.
- 🎭 **Bear Personality** — Configure AI behavior mode (Friendly, Educational, Storyteller...).
- ⏰ **Smart Alarms** — Schedule bear wake-up messages with custom voice.
- 🎙️ **Voice Selection** — Preview and set TTS voices (ElevenLabs / Google TTS).
- 🛡️ **Safety Controls** — Manage banned words and content filter sensitivity.
- 📜 **Conversation History** — View past bear-child interactions with timestamps.
- 💳 **Premium Subscriptions** — In-app subscription management via PayOS.
- 🌗 **Dark/Light Theme** — Full theme support with system preference detection.
- 🎨 **Modern UI** — Material 3 design with smooth animations.

---

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

---

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

<div align="center">

## 👥 Team

**FPT University HCM — Capstone Project Spring 2026**

Made with ❤️ by the DesignABear Team

---

⭐ If you found this project useful, please consider giving it a star!

</div>
