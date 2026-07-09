# Sportlinker

Sportlinker (package `coco`) is a Flutter mobile app for connecting people around sport: profile matching (swipe), events, group chats, and sport clubs with map-based discovery. It uses Firebase (Auth, Firestore, Storage, Messaging, Cloud Functions), Riverpod state management, GoRouter navigation, and Stripe for paid club course bookings.

This README covers how to set up, run and extend the project.

## Features

- **Auth** — Google Sign-In + Email/Password (Firebase Auth)
- **Swipe & matching** — profile discovery with geolocation-based filters
- **Events** — create and join sport events
- **Chats** — 1:1 (matches) and group (events) messaging
- **Clubs** — discovery on an interactive **map** (flutter_map / OpenStreetMap), club pages, bookable slots/courses
- **Payments** — pay for club course slots with **Stripe** (PaymentSheet + Cloud Function)
- **Theme** — System / Light / Dark, follows the device by default
- **i18n** — English / French (easy_localization), preferences persisted (SharedPreferences)

## Quick start

Prerequisites

- Flutter SDK (stable) installed and on PATH
- Android Studio / Xcode for device simulators
- A Firebase project configured for iOS and Android (`GoogleService-Info.plist` and `google-services.json`)

Install deps and run:

```bash
flutter pub get
flutter run
```

If you change native iOS files (Info.plist, pods) do a full rebuild:

```bash
flutter clean && flutter run
```

## Maps & Geolocation

- Club discovery renders an interactive map with **`flutter_map`** and free **OpenStreetMap** tiles (no Google Maps API key required).
- Device location via **`geolocator`**; nearby queries are helped by **`geoflutterfire_plus`**, address lookups by **`geocoding`**.
- A **"locate me"** button on the map recenters on the user's position ("around me" mode). Location calls use an 8s timeout so the UI never hangs when location is off/denied/unavailable.
- iOS needs `NSLocationWhenInUseUsageDescription` in `ios/Runner/Info.plist` (already set). On the iOS **simulator**, set a location first (Features → Location, or `xcrun simctl location <device> set <lat>,<lng>`) or `getCurrentPosition` returns nothing.

## Payments (Stripe)

Paid club course slots are charged via Stripe using a server-side PaymentIntent (the secret key never reaches the app):

- **Client**: `flutter_stripe` PaymentSheet, wired in `lib/src/features/clubs/application/stripe_payment_service.dart`. Publishable key in `lib/src/core/config/stripe_config.dart`.
- **Backend**: Cloud Function `createPaymentIntent` (`functions/index.js`, region `europe-west1`) reads the slot price from Firestore and creates the PaymentIntent. The Stripe **secret key** lives in Google Secret Manager (`STRIPE_SECRET_KEY`).
- **Local vs deployed**: toggle `kUseFirebaseEmulators` in `lib/src/core/config/dev_config.dart`.
  - `true` → Firebase emulators: `firebase emulators:start --only auth,firestore,functions` (secret read from `functions/.secret.local`, which is gitignored).
  - `false` → the deployed backend.
- Deploy: `firebase deploy --only functions`. Test card: `4242 4242 4242 4242`, any future expiry / CVC.

## Firebase / Google Sign-In notes

- iOS: `ios/Runner/GoogleService-Info.plist` must contain correct CLIENT_ID and REVERSED_CLIENT_ID. The plugin also requires `CFBundleURLTypes` and `GIDClientID` entries in `ios/Runner/Info.plist` (already added in this repo). If you update `GoogleService-Info.plist`, re-open Xcode or rebuild.
- Android: add your app SHA-1 fingerprint in the Firebase Console (Project Settings → Your Apps → Add fingerprint). Then download `google-services.json` and place it at `android/app/google-services.json`.

## Authentication

- Google Sign-In handled by `google_sign_in` and `firebase_auth`.
- Email/password sign-in is implemented in `lib/src/features/auth/auth_service.dart`.

## Localization

- This project uses `easy_localization` with JSON translation files under `assets/langs/`.
- Files: `assets/langs/en.json` and `assets/langs/fr.json`.
- Keys are grouped by page/feature, e.g. `sign_in.title`, `settings.theme`, `clubs.map.locate_me`.
- Use `tr('sign_in.title')` in widgets to translate strings. Example: `Text(tr('sign_in.title'))`.
- To add a translation, add the key under **each** language file in `assets/langs/`.

EasyLocalization is initialized in `lib/main.dart` and the app sets the locale from persisted preferences on startup.

## Theme & Preferences

- Theme mode (**System / Light / Dark**) and language are stored with SharedPreferences and persisted across restarts. The default follows the device (`ThemeMode.system`).
- Providers are in `lib/src/core/providers.dart` (see `themeModeProvider`, `localeProvider`). The mode is chosen in Settings via a segmented control.

## Routes

- `GoRouter` configuration is in `lib/src/router.dart`.
- The `/settings` route is protected and requires the user to be authenticated.

## Git hooks

- There's a script to install pre-commit checks in `scripts/install_hooks.sh`. Hooks (if installed) run tools like the file length checker.

## Development notes

- Add translations and avoid hard-coded UI strings.
- If you see errors about missing localization delegates (Material/Cupertino), run `flutter pub get` to ensure `flutter_localizations` is available.

## Troubleshooting

- **Xcode build fails "out of space" / `CreateUniversalBinary` errors**: free disk by clearing `~/Library/Developer/Xcode/DerivedData`, then `flutter clean && flutter run`.
- **Stripe/Swift "malformed precompiled module" after an interrupted build**: `flutter clean`, clear DerivedData, `cd ios && pod install`, rebuild.
- **CocoaPods "Firebase/Auth" version conflict** after pulling: `rm ios/Podfile.lock && cd ios && pod install --repo-update`.
- **Google Sign-In URL scheme error on iOS**: ensure `REVERSED_CLIENT_ID` is present in `ios/Runner/Info.plist` inside `CFBundleURLTypes`.
- **PlatformException from SharedPreferences at app start**: do a full restart; the app delays settings init until after the first frame to reduce this.

## Contact

If you need additional features or help wiring a backend, say what you'd like next and I can implement it.
