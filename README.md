# Streak App

Streak App is a Flutter productivity application focused on habit consistency. It combines streak tracking, reminders, freeze mechanics, achievements, and a lightweight to-do workflow in one mobile experience.


## Project Highlights

- Create and manage streaks with frequency options: daily, weekly, and custom weekdays.
- Reminder support with multiple times per streak and local notification syncing.
- Completion tracking with streak progression, freeze usage, and longest streak metrics.
- Achievement system with progress evaluation and unlock timeline.
- To-do module with optional reminders.
- User settings for theme mode, notifications, and haptics.
- Drift (SQLite) local persistence with schema migration support.
- Riverpod-driven state and GoRouter navigation.

## Why This Project Exists

The goal is to model a realistic personal productivity app while keeping a clean, evolvable codebase. It is built to show:

- Feature-oriented Flutter architecture
- Repository abstractions over storage
- Local-first mobile app behavior
- Product-oriented UX flows and validation

## Tech Stack

- Flutter, Dart
- Riverpod for state and dependency access
- GoRouter for navigation
- Drift + SQLite for local database storage
- flutter_local_notifications and timezone packages for reminders
- shared_preferences for lightweight preference persistence
- build_runner and drift_dev for code generation

See dependencies in [pubspec.yaml](pubspec.yaml).

## Architecture Overview

The codebase follows a feature-first layout with app-level infrastructure and modular feature folders.

Primary app entry points:

- [lib/main.dart](lib/main.dart)
- [lib/app/router/app_router.dart](lib/app/router/app_router.dart)
- [lib/app/database/drift_database.dart](lib/app/database/drift_database.dart)

Core feature modules:

- Dashboard overview: [lib/features/dashboard/presentation/pages/dashboard_page.dart](lib/features/dashboard/presentation/pages/dashboard_page.dart)
- Streak creation: [lib/features/streaks/presentation/pages/create_streak_page.dart](lib/features/streaks/presentation/pages/create_streak_page.dart)
- Streak detail and completion flow: [lib/features/streaks/presentation/pages/streak_detail_page.dart](lib/features/streaks/presentation/pages/streak_detail_page.dart)
- Streak repository layer: [lib/features/streaks/data/repositories/streak_repository.dart](lib/features/streaks/data/repositories/streak_repository.dart)
- Achievements: [lib/features/achievements/presentation/pages/achievements_page.dart](lib/features/achievements/presentation/pages/achievements_page.dart)
- To-do management: [lib/features/todos/presentation/pages/todo_page.dart](lib/features/todos/presentation/pages/todo_page.dart)
- Settings and theming: [lib/features/settings/presentation/pages/settings_page.dart](lib/features/settings/presentation/pages/settings_page.dart)

## Data Model Snapshot

Drift schema currently includes tables for:

- Streaks
- Completions
- App settings
- Achievements
- To-dos

Database definition and migrations are in [lib/app/database/drift_database.dart](lib/app/database/drift_database.dart).

## Running the App

Prerequisites:

- Flutter SDK (stable)
- Android Studio or VS Code with Flutter tooling
- Android SDK configured for device or emulator testing

Setup:

1. Clone the repository.
2. Install dependencies with: flutter pub get
3. Generate Drift code with: dart run build_runner build --delete-conflicting-outputs
4. Run the app with: flutter run

## Development Commands

- Static analysis: flutter analyze
- Widget tests: flutter test
- Refresh generated files: dart run build_runner build --delete-conflicting-outputs

## Android Build Note

This project uses notification dependencies that require core library desugaring on Android. The app module build configuration already includes this setup in [android/app/build.gradle.kts](android/app/build.gradle.kts).

## Current Status

- Core streak flow is implemented end-to-end.
- Dashboard now surfaces active streaks and high-value summary metrics.
- Persistence layer is Drift-based and migrated away from Isar.
- Some modules are still evolving and intended for iterative expansion.

## What Employers Can Evaluate Here

- Ability to design and ship complete feature flows, not just UI screens.
- Pragmatic architecture choices for maintainability in Flutter.
- Database-backed domain logic and schema migration handling.
- State-driven UI updates with Riverpod and reactive streams.
- Attention to product details such as validation, reminders, and progression mechanics.

## Next Improvements

- Expand history analytics and charting.
- Improve automated test coverage for feature modules.
- Add release-ready CI checks and quality gates.
- Add screenshots and short demo capture for portfolio presentation.

## License

No license file is currently included in this repository.
