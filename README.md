<div align="center">

# D/MOTIVATION

### **The War Room**

**"The Motivation to Quit Quitting."**

</div>

D/MOTIVATION is an **offline-first strategic accountability tool** built with Flutter.  
Unlike typical motivation apps that push random quotes, this application acts as a **high-performance coach**. It forces users to **deconstruct their excuses**, define a **specific mission**, and uses AI to deliver **strategic directives** tailored to the user’s weaknesses and deadlines.

---

## ⚡ Tech Stack

| Category      | Technology                  | Description                                       |
| ------------- | --------------------------- | ------------------------------------------------- |
| Frontend      | Flutter                     | Cross-platform mobile UI framework.               |
| Database      | Hive                        | Fast, offline-first local key-value storage.      |
| Backend       | Supabase                    | Auth, backup, and Edge Functions.                 |
| AI Engine     | Google Gemini               | Generates strategic pathways via Edge Functions.  |
| Notifications | flutter_local_notifications | Local scheduling engine for strategic injections. |

---

## 🚀 Getting Started

### **Prerequisites**

- Flutter SDK (Latest Stable)
- Supabase project with Edge Functions enabled
- Google Gemini API Key

### **📂 Project Structure**

The project follows a clean architecture approach tailored for Flutter.

```
lib/
├── core/                      # Global services & utilities
│   ├── api/                   # API integration layer (Dio, interceptors, clients)
│   ├── network/               # Internet connectivity checker
│   ├── exceptions/            # Global exception & failure handling
│   ├── utils/                 # Global helpers, extensions, formatters
│   └── config/                # App-wide config (env, constants)
│
├── routes/                    # App routing and navigation setup
│   └── app_router.dart
│
├── themes/                    # Light/Dark themes, typography, colors
│   ├── app_theme.dart
│   └── colors.dart
│
├── features/                  # Modular feature-based structure
│   └── feature_name/          # Example feature
│       ├── bloc/              # Bloc / Cubit state management
│       │   ├── feature_bloc.dart
│       │   └── feature_state.dart
│       │
│       ├── repo/              # Repository + data source abstraction
│       │   ├── feature_repo.dart
│       │   └── feature_local_ds.dart / feature_remote_ds.dart
│       │
│       └── view/              # UI screens for the feature
│           ├── feature_screen.dart
│           └── widgets/
│               └── feature_widget.dart
│
└── main.dart                  # Application entry point
```
