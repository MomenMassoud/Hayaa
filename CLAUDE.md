# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get          # install dependencies
flutter run              # run on connected device/emulator
flutter build apk        # build Android APK
flutter analyze          # static analysis (uses analysis_options.yaml)
flutter test             # run tests
flutter test test/widget_test.dart  # run a single test file
```

## Architecture

Feature-based folder structure under `lib/features/`. Each feature contains:
- `views/` — full screen widgets (one per route)
- `widgets/` — sub-widgets and body components for that screen
- `models/` — feature-local data models (shared models live in `lib/models/`)

Shared utilities live in `lib/core/Utils/`:
- `app_routes.dart` — central route map; every navigable screen registers here
- `app_colors.dart` — `AppColors` abstract class with all colour constants
- `app_images.dart` — `AppImages` abstract class with all asset path constants
- `supabase_helper.dart` — static helper for Supabase Storage uploads/deletes

## Routing

Routes are named strings. Each view declares `static const String id = '...'` and registers itself in `appRoutes` in `lib/core/Utils/app_routes.dart`. Navigate with `Navigator.pushNamed(context, SomeView.id)`.

## Backend

**Firebase** is the primary backend:
- **Firestore** — user data, rooms, messages, posts, stories, families, gifts, friend lists
- **Firebase Auth** — email/password, phone, Google Sign-In
- **Firebase Storage** — media files (some older uploads)
- **Firebase Messaging** — push notifications

**Supabase Storage** (`lib/core/Utils/supabase_helper.dart`) is used for new image uploads (profile photos, post images). The helper exposes `SupabaseHelper.uploadImage(File)` and `SupabaseHelper.deleteImage(String url)`.

**ZEGOCLOUD** (`zego_uikit_prebuilt_live_audio_room`) powers the live audio rooms feature. Room sessions are joined via `ZegoUIKitPrebuiltLiveAudioRoom` widget. Room metadata (wallpaper, seat state, users) is stored in Firestore under the `room` collection.

## Key Data Collections (Firestore)

- `user/{uid}` — `UserModel` fields including `seen` (online status or server timestamp), `vip`, `level`, `exp`, `coin`, `daimond`, `type`
- `room/{roomId}/user/{uid}` — per-room user presence
- `messages/{chatId}/message` — one-to-one chat messages
- `family/{familyId}` — group/family data

## User Presence

`MyApp` implements `WidgetsBindingObserver`. On app pause/inactive it writes `seen: FieldValue.serverTimestamp()` to `user/{uid}`; on resume it writes `seen: "online"`.

## Localization

`easy_localization` with two locales: `en-US` and `ar-DZ`. Translation files are at `lib/core/Utils/assets/lang/`. Use `'key'.tr()` for translated strings.

## Custom Fonts

Three font families are registered in `pubspec.yaml`: `Hayah`, `Questv1`, `aldhabi`. Reference them by family name in `TextStyle(fontFamily: 'Hayah')`.

## Virtual Economy

Users hold three currencies stored on `UserModel`: `coin` (gold), `daimond`, and silver coin equivalents. The Store feature (`lib/features/store/`) sells cosmetic items (cars/GIF ride animations, frames, head accessories, wallpapers). VIP tiers (1–4) unlock additional perks tracked in `user.vip`.

## Naming Conventions

- Screen files: `*_view.dart` / class `*View`
- Body/sub-widget files: `*_body.dart` or descriptive widget name
- Model files: `*_model.dart`
- State classes: `_ClassName` (private, same file as the StatefulWidget)
