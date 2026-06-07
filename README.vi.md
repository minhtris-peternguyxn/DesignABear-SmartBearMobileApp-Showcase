<div align="center">

# 📱 SmartBear — Mobile Companion App

### Ứng dụng di động Flutter đồng hành cùng Gấu bông thông minh SmartBear IoT

[![Flutter](https://img.shields.io/badge/Flutter-3.9-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.9-0175C2?logo=dart&logoColor=white)](https://dart.dev/)
[![Android](https://img.shields.io/badge/Android-Ready-3DDC84?logo=android&logoColor=white)](https://developer.android.com/)
[![SignalR](https://img.shields.io/badge/SignalR-WebSocket-512BD4?logo=dotnet&logoColor=white)](https://learn.microsoft.com/aspnet/signalr)

<br>

[![English Version](https://img.shields.io/badge/Language-English-blue?style=for-the-badge&logo=translate)](./README.md)

---

</div>

## 📌 Lưu ý Showcase & Trạng thái phát triển

> **🔒 Lưu ý Showcase:** 
> Đây là phiên bản **showcase công khai** của ứng dụng SmartBear Mobile, được phát triển ban đầu trong một **repository riêng tư** thuộc Đồ án Tốt nghiệp kỳ Spring 2026 tại Đại học FPT TP.HCM. Do repo gốc là private nên không có lịch sử commit tại đây. Dự án hiện đang được hoàn thiện, phát triển và duy trì duy nhất bởi **Tri Nguyen Minh** (@minhtris-peternguyxn) phục vụ cho hồ sơ năng lực xin việc cá nhân.

---

## 🔗 Tài liệu & Các Repo liên quan

| Tài nguyên | Liên kết |
|:-----------|:---------|
| 🌐 **Website Demo trực tuyến** | [designabear.shop](https://designabear.shop) (Mật khẩu: `minhtri10504`) |
| 📑 **Tài liệu dự án (Báo cáo, Demo, Ảnh)** | [Google Drive Folder](https://drive.google.com/drive/folders/1HyvJ_ja7P2BdN88A7oy6Hs2fxi4oRyQE?usp=sharing) |
| 📱 **Mobile App** | Repo này (Bản Tiếng Việt) |
| 🧸 **E-commerce Backend** | [DesignABear-Ecommerce-Showcase](https://github.com/minhtris-peternguyxn/DesignABear-Ecommerce-Showcase) |
| 🤖 **SmartBear IoT Server** | [DesignABear-SmartBearServer-Showcase](https://github.com/minhtris-peternguyxn/DesignABear-SmartBearServer-Showcase) |

---

## 📖 Tổng Quan

**SmartBear Mobile App** là ứng dụng di động viết bằng Flutter đồng hành cùng hệ thống gấu bông thông minh SmartBear IoT. Phụ huynh sử dụng ứng dụng này để quản lý và cấu hình gấu bông của trẻ — bao gồm ghép nối thiết bị qua WiFi, tùy chỉnh chế độ/tính cách AI, đăng ký và quản lý các gói cước thành viên (subscriptions), đặt báo thức thông minh, giám sát lịch sử trò chuyện và thiết lập các bộ lọc từ cấm an toàn cho con.

Ứng dụng kết nối trực tiếp đến [SmartBear IoT Server](https://github.com/minhtris-peternguyxn/DesignABear-SmartBearServer-Showcase) qua các REST API và SignalR WebSocket hỗ trợ truyền luồng giọng nói real-time.

---

## 🏗️ Kiến Trúc Ứng Dụng

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

## 🛠️ Công Nghệ Sử Dụng

| Danh mục | Công nghệ sử dụng |
|:---------|:------------------|
| **Framework** | Flutter 3.9 / Dart 3.9 |
| **Quản lý trạng thái** | Sử dụng cấu trúc StatefulWidget kết hợp mô hình Service pattern |
| **Kết nối mạng** | Thư viện `http` kế thừa bởi lớp tự tùy chỉnh `BaseApiClient` |
| **Real-time** | SignalR WebSocket (hỗ trợ phát thử/truyền giọng nói từ thiết bị) |
| **Xác thực** | Tích hợp Google Sign-In & Quản lý vòng đời mã token JWT |
| **Cấu hình** | Thư viện `flutter_dotenv` để nạp các tham số môi trường và secrets |
| **Giao diện UI/UX** | Sử dụng Google Fonts, thư viện `flutter_animate`, Material 3 |
| **Âm thanh** | Thư viện `audioplayers` để phát thử các mẫu giọng nói TTS |
| **Lưu trữ cục bộ** | Thư viện `shared_preferences` lưu cấu hình người dùng |
| **IoT / Kết nối** | Thư viện `wifi_scan` và `webview_flutter` hỗ trợ quy trình ghép cặp thiết bị |
| **Nền tảng đích** | Android (nền tảng mục tiêu chính) |

---

## ✨ Tính Năng Nổi Bật

- 🔐 **Xác Thực Người Dùng** — Đăng nhập bằng Google OAuth hoặc Email/Mật khẩu truyền thống sử dụng cơ chế bảo mật JWT.
- 🧸 **Ghép Nối Thiết Bị** — Quét các mạng WiFi xung quanh gấu bông và kích hoạt đăng ký thiết bị ESP32 thông qua mã OTP bảo mật.
- 👶 **Hồ Sơ Trẻ Em** — Cho phép quản lý nhiều hồ sơ trẻ em khác nhau trên cùng một thiết bị với các cấu hình về độ tuổi và tính cách gấu khác nhau.
- 🎭 **Điều Chỉnh Tính Cách Gấu** — Cấu hình chế độ hoạt động của AI (Thân thiện, Giáo dục, Kể chuyện, Học toán...).
- ⏰ **Báo Thức Thông Minh** — Thiết lập lịch báo thức cho gấu với nội dung báo thức bằng giọng nói được cá nhân hoá bởi AI.
- 🎙️ **Xem Trước Giọng Nói** — Nghe thử các mẫu giọng khác nhau của ElevenLabs/Google TTS và áp dụng cho gấu bông.
- 🛡️ **Kiểm Soát An Toàn** — Phụ huynh quản lý danh sách các từ cấm và thay đổi mức độ nhạy cảm của bộ lọc AI.
- 📜 **Lịch Sử Trò Chuyện** — Xem và theo dõi lại toàn bộ cuộc đối thoại của trẻ với gấu bông kèm mốc thời gian chi tiết.
- 💳 **Gói Thành Viên Cao Cấp** — Đăng ký nâng cấp tài khoản và thanh toán trực tiếp qua cổng ngân hàng PayOS.
- 🌗 **Giao Diện Sáng/Tối** — Hỗ trợ đầy đủ Light/Dark mode, tự động nhận diện thiết lập của hệ điều hành.

---

## 🚀 Hướng Dẫn Cài Đặt

### Yêu cầu hệ thống
- [Flutter SDK 3.9+](https://docs.flutter.dev/get-started/install)
- [Android Studio](https://developer.android.com/studio) hoặc [VS Code](https://code.visualstudio.com/)
- Thiết bị chạy Android hoặc máy ảo giả lập (Android API 24+)
- Máy chủ [SmartBear IoT Server](https://github.com/minhtris-peternguyxn/DesignABear-SmartBearServer-Showcase) đang hoạt động

### Các bước thiết lập
```bash
# 1. Clone repository này về máy local
git clone https://github.com/minhtris-peternguyxn/DesignABear-SmartBearMobileApp-Showcase.git
cd DesignABear-SmartBearMobileApp-Showcase

# 2. Tạo file cấu hình môi trường từ mẫu
cp .env.example .env
# Chỉnh sửa file .env để điền URL của server và Google OAuth client IDs phù hợp

# 3. Tải và cài đặt các dependencies của Flutter
flutter pub get

# 4. Khởi chạy ứng dụng trên thiết bị / máy ảo
flutter run
```

### Build APK phát hành
```bash
flutter build apk --release
```

---

## 📁 Cấu Trúc Thư Mục

```
lib/
├── config/
│   └── app_config.dart              # Đọc cấu hình từ tệp biến môi trường .env
├── core/
│   └── network/
│       ├── base_api_client.dart      # HTTP Client tùy chỉnh đính kèm token xác thực
│       └── api_config_manager.dart   # Quản lý thay đổi cấu hình API URL lúc runtime
├── data/
│   ├── api/                          # Lớp triển khai gọi REST API
│   └── models/                       # Các Data models & DTOs
│       ├── request/                  # Cấu trúc dữ liệu yêu cầu gửi đi (payloads)
│       └── response/                 # Cấu trúc dữ liệu phản hồi nhận về
├── screens/
│   ├── alarm/                        # Màn hình quản lý báo thức thông minh
│   ├── auth/                         # Màn hình đăng nhập & đăng ký tài khoản
│   ├── device/                       # Quy trình ghép cặp gấu bông & cấu hình WiFi
│   ├── history/                      # Trình xem lịch sử hội thoại trẻ - gấu
│   ├── home/                         # Màn hình Dashboard quản lý chính
│   ├── intro/                        # Các màn hình Onboarding hướng dẫn sử dụng
│   ├── premium/                      # Màn hình nâng cấp các gói tài khoản cao cấp
│   ├── profile/                      # Quản lý thông tin hồ sơ của trẻ em
│   ├── safety/                       # Thiết lập bảo mật & an toàn cho trẻ
│   ├── settings/                     # Các cài đặt ứng dụng
│   └── voice/                        # Trình nghe thử và cấu hình giọng nói AI
├── services/
│   ├── auth_service.dart             # Xử lý các nghiệp vụ đăng nhập, đăng xuất
│   └── theme_service.dart            # Quản lý giao diện Sáng/Tối của ứng dụng
├── widgets/                          # Các thành phần UI có thể tái sử dụng
└── main.dart                         # Điểm bắt đầu (entry point) khởi chạy ứng dụng
```

---

<div align="center">

## 👥 Đội ngũ phát triển

**Đại học FPT TP.HCM — Capstone Project Spring 2026**

Được phát triển với ❤️ bởi đội ngũ DesignABear

---

⭐ Nếu bạn thấy dự án này hữu ích, hãy để lại một ngôi sao (star) ủng hộ nhé!

</div>
