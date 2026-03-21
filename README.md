# ProfileForge AI

Flutter mobile app for AI-powered LinkedIn profile optimization.

## Features

- **Profile Analyzer** — Paste your LinkedIn profile, get an AI score (0-100) with section breakdown and recommendations
- **Headline Generator** — Generate 10 optimized headlines for your target role
- **Summary Writer** — Get 3 tone variations (Professional, Creative, Executive)
- **Favorites** — Save and manage your best results
- **Onboarding** — Guided 3-page intro for first-time users
- **Settings** — Custom endpoint, model selection, dark/light theme

## Stack

- Flutter 3 + Dart
- Material 3 with indigo seed color
- Provider for state management
- HTTP for AI API calls
- SharedPreferences for local storage

## AI Backend

Calls `https://sai.sharedllm.com/v1/chat/completions` with model `gpt-oss:120b`. No API key required.

## Run

```bash
flutter run
flutter build apk
flutter build ios
flutter build web
```
