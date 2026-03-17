# 🧭 FutureNext

[![Flutter](https://img.shields.io/badge/Flutter-v3.22+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-v3.0+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Feature--First%20BLoC-6C63FF)](#project-structure)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

**FutureNext** is a premium, AI-powered career counseling application designed to help students and professionals discover their ideal career paths through scientific assessment and expert AI guidance.

---

## ✨ Key Features

- 🧠 **AI Career Counselor**: Real-time chat with a Google Gemini-powered career expert for personalized guidance.
- 📋 **Scientific Career Quiz**: A comprehensive assessment with logic based on interest scoring and career categorization.
- 📚 **Career Library**: Exploration of 40+ career paths with detailed roadmaps, salary insights, and top colleges.
- 🎨 **Premium UI/UX**: Modern glassmorphic design system with fluid animations and responsive layouts.
- 🔒 **Secure Auth**: Production-ready authentication flow with Firebase integration support.

---

## 🛠️ Tech Stack

### Frontend
- **Framework**: [Flutter](https://flutter.dev/) (SDK 3.22+)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc) (Event-based architecture)
- **Navigation**: [go_router](https://pub.dev/packages/go_router) (Declarative routing)
- **Animations**: [flutter_animate](https://pub.dev/packages/flutter_animate) (High-performance UI effects)

### Data & Services
- **Database**: [Hive](https://pub.dev/packages/hive) (Lightweight, fast NoSQL local storage)
- **AI Integration**: [Google Generative AI](https://pub.dev/packages/google_generative_ai) (Gemini Pro)
- **Fonts**: [Google Fonts](https://pub.dev/packages/google_fonts) (Poppins & Nunito)

---

## 🏗️ Project Structure

The project follows a **Feature-First + Layered Architecture**, ensuring high scalability and modularity.

```text
lib/
├── core/               # App-wide shared configurations
│   ├── constants/      # App strings, API keys, dimensions
│   ├── theme/          # Central AppTheme (Light/Dark)
│   ├── utils/          # Global helpers (IconMapper, Formatters)
│   └── router/         # GoRouter definitions
│
├── data/               # Data access layer
│   ├── local/          # Static/Local data sources (Career & Quiz data)
│   ├── models/         # Domain Data Models (Career, Quiz, User)
│   └── repositories/   # Data abstraction layer for BLOCs
│
├── domain/             # Business logic service layer
│   └── services/       # AI, Storage, and Persistence services
│
├── features/           # Modularized feature folders
│   ├── auth/           # Login, Signup, and Profile logic
│   ├── careers/        # Career exploration and details
│   ├── chat/           # AI Counselor Chat interface
│   ├── dashboard/      # Main navigation and overview
│   ├── onboard/        # First-time user onboarding
│   └── quiz/           # Assessment logic and scoring
│
└── widgets/            # Globally shared UI components
    └── common/         # Custom Buttons, Inputs, Cards
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.22 or higher)
- Android Studio / VS Code
- A Gemini API Key (for the AI features)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Aditya-Naikwadi/FutureNext.git
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup Environment**
   Update your Gemini API key in `lib/core/constants/app_strings.dart`.

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 🤝 Contributing
Feel free to open issues or pull requests to improve the **FutureNext** experience.

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
