<div align="center">

***Inspired from Solo Levling***

# ARISE

### **The Hunter System**

**"Player has met the conditions for awakening."**

</div>

**ARISE** is an **offline-first strategic accountability system** built with Flutter, heavily inspired by the *Solo Leveling* aesthetic and progression mechanics. 
Instead of a typical passive motivation app, ARISE acts as a **system interface / high-performance coach**. It forces users to **deconstruct their excuses**, take on **daily quests**, and track their stats to level up their real-life potential.

---

## ⚡ Tech Stack

| Category      | Technology                  | Description                                       |
| ------------- | --------------------------- | ------------------------------------------------- |
| Frontend      | Flutter (Material 3)        | Cross-platform mobile UI framework.               |
| Database      | Hive / Isar                 | Fast, offline-first local key-value storage.      |
| Backend       | Supabase                    | Auth, backup, and Edge Functions.                 |
| AI Engine     | Google Gemini               | Generates strategic directives via Edge Functions.|
| Notifications | flutter_local_notifications | Local scheduling engine for system alerts.        |

---

## 🎨 Design System (ARISE Edition)

* **The Vibe:** Dark-mode "Shadow Monarch" interface featuring absolute void blacks (`#07050B`), deep slate panels (`#13101B`), monarch purple accents (`#9D4EDD`), and mana cyan highlights (`#00F5D4`). Fully supports a clean system-light mode as well.
* **Typography:** 
  * **Orbitron:** Used for system titles, headers, and rank-up notifications.
  * **Rajdhani:** Used for crisp, readable body text, quest logs, and stat attributes.

---

## 🚀 Getting Started

### **Prerequisites**

- Flutter SDK (Latest Stable)
- Supabase project with Edge Functions enabled
- Google Gemini API Key

### **📂 Project Structure**

The project follows a clean, modular feature-based architecture tailored for Flutter.

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
