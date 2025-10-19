# Sportlinker

Sportlinker is a Flutter mobile app demo with Firebase Authentication (Google + Email/Password), Riverpod state management and GoRouter navigation. It includes basic localization (English/French), theme switching (dark/light) and preference persistence using SharedPreferences.

This README covers how to setup, run and extend the project.

## Quick start

Prerequisites

- Flutter SDK (stable) installed and on PATH
- Android Studio / Xcode for device simulators
- A Firebase project configured for iOS and Android (GoogleService-Info.plist and google-services.json)

Install deps

```bash
flutter pub get
```

Run on an emulator or device

```bash
flutter run
```

If you change native iOS files (Info.plist, plist keys) do a full rebuild:

```bash
flutter clean
flutter run
```

## Firebase / Google Sign-In notes

- iOS: `ios/Runner/GoogleService-Info.plist` must contain correct CLIENT_ID and REVERSED_CLIENT_ID. The plugin also requires `CFBundleURLTypes` and `GIDClientID` entries in `ios/Runner/Info.plist` (already added in this repo). If you update `GoogleService-Info.plist`, re-open Xcode or rebuild.
- Android: add your app SHA-1 fingerprint in the Firebase Console (Project Settings → Your Apps → Add fingerprint). Then download `google-services.json` and place it at `android/app/google-services.json`.

## Authentication

- Google Sign-In handled by `google_sign_in` and `firebase_auth`.
- Email/password sign-in is implemented in `lib/src/features/auth/auth_service.dart`.

## Localization

- Simple map-based localization lives under `lib/src/l10n/`.
  - `strings_en.dart`, `strings_fr.dart`, and `localization.dart`.
- To add more strings: add keys to both maps and use `AppLocalizations.of(context).t('key')`.

## Theme & Preferences

- Theme (dark/light) and language selection are stored using SharedPreferences and persisted across restarts.
- Providers are in `lib/src/core/providers.dart` (see `isDarkModeProvider`, `localeProvider`).

## Routes

- `GoRouter` configuration is in `lib/src/router.dart`.
- The `/settings` route is protected and requires the user to be authenticated.

## Git hooks

- There's a script to install pre-commit checks in `scripts/install_hooks.sh`. Hooks (if installed) will run tools like the file length checker.

## Development notes

- Add translations and avoid hard-coded UI strings.
- If you see errors about missing localization delegates (Material/Cupertino), run `flutter pub get` to ensure `flutter_localizations` is available.

## Troubleshooting

- PlatformException from SharedPreferences at app start: if you see channel errors, ensure a full restart and that plugins are initialized. The app delays settings initialization until after the first frame to reduce the chance of that error.
- Google Sign-In URL scheme error on iOS: ensure the `REVERSED_CLIENT_ID` is present in `ios/Runner/Info.plist` inside the `CFBundleURLTypes` array.
- Android Google Sign-In errors: verify the SHA-1 fingerprint is added to the Firebase project.

## Contact

If you need additional features or help wiring a backend, say what you'd like next and I can implement it.
