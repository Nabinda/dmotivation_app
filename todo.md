# D/MOTIVATION - Project Roadmap

## 🟢 Phase 1: Core Architecture & UI (COMPLETED)

- [x] **Project Setup:** Flutter + Supabase + Hive.
- [x] **Theme Engine:** `Terminal`, `Defcon 1`, `Cold Truth` modes.
- [x] **Onboarding Module:**

  - [x] Mission, Protocol, Schedule, Enemy steps.
  - [x] Input validation.
  - [x] Mock AI generation service.

- [x] **Local Database:**

  - [x] Hive persistence for Strategy JSON.
  - [x] Save/Update logic in Repositories.

- [x] **Dashboard (The Command Center):**

  - [x] Dynamic "Day X" calculation.
  - [x] Dynamic Phase Status & Progress Bar.
  - [x] Tactical Checklist with Read/Write persistence.
  - [x] "Mission Accomplished" visual reward state.
  - [x] Date Picker for history navigation.
  - [x] Custom "Warning Triangle" FAB.

- [x] **Panic Mode:**

  - [x] Selection Sheet (Lazy, Anxious, Burnout).
  - [x] **Action Timer:** Aggressive logic + Dynamic "Cold Truths".
  - [x] **Box Breathing:** Visual guidance + Dynamic Stoic quotes.

## 🔵 Phase 2: App Hygiene & Settings (COMPLETED TODAY)

- [x] **Settings Screen:**

  - [x] "Identity Card" (Conscript vs Operator).
  - [x] "Abort Mission" (Hard Reset/Wipe Hive).
  - [x] "Theme Selector" integration.

- [x] **Monetization UI:**

  - [x] `PaywallScreen` (Upgrade Flow).
  - [x] `ManageSubscriptionScreen` (Cancellation Flow).
  - [x] "Pro vs Free" Logic mocks.

- [x] **Analytics UI:**

  - [x] `TacticalAnalyticsScreen` (Dummy UI).
  - [x] `PanicLogsScreen` (Dummy UI).

- [x] **Refactoring & Polish (The "Hidden" Work):**

  - [x] **Widget Extraction:** Split Onboarding and Settings into clean `widgets/` folders.
  - [x] **Theme Repair:** Fixed `MaterialStateProperty` deprecations.
  - [x] **Visibility Fix:** Ensured text is readable in Light Mode (High Contrast logic).
  - [x] **Router:** Updated `go_router` to handle all new paths (`/settings`, `/paywall`, `/analytics`).

## 🔴 Phase 3: The "Voice" (NEXT PRIORITY)

_The app is functional, but silent. It needs to speak._

- [ ] **Notification Service:**

  - [ ] Install `flutter_local_notifications` + `timezone`.
  - [ ] Create `NotificationService` class.
  - [ ] Implement permission request logic (iOS/Android).

- [ ] **Injection Logic:**

  - [ ] Parse `injections` array from Hive Strategy.
  - [ ] Schedule notifications based on User's `wakeTime` / `sleepTime`.
  - [ ] Implement "Refill" logic on app startup.

## 🟣 Phase 4: The Brain (Backend)

_Replacing mock data with real intelligence._

- [ ] **Supabase Edge Functions:**

  - [ ] Create `generate-strategy` function (Deno/TypeScript).
  - [ ] Connect to Google Gemini API.
  - [ ] Secure API Keys.

- [ ] **Client Integration:**

  - [ ] Connect `OnboardingRemoteService` to Supabase instead of Mock.
  - [ ] Handle network errors/timeouts gracefully.

## 🟡 Phase 5: Real Monetization

_Connecting the UI to money._

- [ ] **RevenueCat Setup:**

  - [ ] Configure Store Products in Apple/Google.
  - [ ] Wire up `PaywallScreen` buttons to actual purchase logic.
  - [ ] Sync "Pro Status" with Supabase Auth.
