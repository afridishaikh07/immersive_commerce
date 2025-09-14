# 🛍️ Immersive Commerce

A modern Flutter e-commerce application built with **Clean Architecture**, **Riverpod state management**, and **Material 3 design**.  
Implements product listing, detail view, authentication, favorites and native iOS/Android integration.

---

## 📹 Demo Video
[▶ Watch the Demo](./video.mp4)

*(GitHub does not autoplay `.mp4` — click the link above to view the video.)*

---

## ✨ Features

### 🔐 Authentication
- Sign up / login with email and password  
- Session persistence using **SharedPreferences**  
- Auto-navigation based on login state  
- Logout option in profile  

### 🛍️ Product Management
- Product list fetched from [Fake Store API](https://api.escuelajs.co/api/v1/products/)  
- Displays product name, price, and image  
- Product details with description and price  
- Responsive UI & smooth scrolling  

### ❤️ Favorites
- Add/remove favorites with a heart icon  
- Managed using **Riverpod**  
- Persisted across sessions  

### 👤 Profile
- View and update name & email  
- Display device info from **Swift (iOS)** and **Kotlin (Android)** using **MethodChannel**  
- Logout functionality  

---

## 🏗️ Tech Stack

- **Flutter 3.x** (cross-platform UI)  
- **Riverpod 2.x** (state management)  
- **Material 3** (modern design system)  
- **Clean Architecture** (separation of concerns)  
- **SharedPreferences** (local storage)  
- **HTTP** (API requests)  
- **MethodChannel** (native integration)  

## 💡 Design Choices & Challenges

- **Authentication:** Chose `SharedPreferences` for lightweight local session management instead of Firebase/Auth0 since no specific backend requirement was mentioned.  
- **State Management:** Used **Riverpod** for simplicity, scalability, and testability.  
- **Clean Architecture:** Ensures clear separation of concerns and easier maintainability.  
- **Native Integration:** Implemented `MethodChannel` in both **Swift (iOS)** and **Kotlin (Android)** to fetch device-specific info.  
- **Challenges Faced:**
  - Handling session persistence consistently across Android and iOS (initial issue on iOS simulator).  
  - Deciding between mock JSON vs API → finally integrated **Fake Store API** for realism.  
  - Ensuring consistent UI across iOS and Android while using Material 3.  

### Dependencies
```yaml
dependencies:
  flutter_riverpod: ^2.4.9
  http: ^1.1.0
  shared_preferences: ^2.2.2
  
---

## 📂 Project Structure

lib/
├── core/                  # Constants, utils, theming
├── features/
│   ├── auth/              # Authentication (login, signup, session)
│   │   ├── data/          # Data sources & repositories
│   │   ├── domain/        # Entities & use cases
│   │   └── presentation/  # UI screens & providers
│   │
│   ├── products/          # Product listing & details
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── profile/           # User profile & device info
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── shared/
    ├── services/          # API, persistence, method channel
    └── widgets/           # Reusable UI components
