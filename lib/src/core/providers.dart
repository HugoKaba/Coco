import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coco/src/features/auth/auth_service.dart';
import 'package:coco/src/features/chats/data/repositories/conversations_repository_impl.dart';
import 'package:coco/src/features/chats/data/repositories/messages_repository_impl.dart';
import 'package:coco/src/features/chats/domain/repositories/conversations_repository.dart';
import 'package:coco/src/features/chats/domain/repositories/messages_repository.dart';
import 'package:coco/src/features/chats/application/messaging_service.dart';
import 'package:coco/src/features/chats/application/notification_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(authServiceProvider);
  return auth.authStateChanges();
});

class AuthChangeNotifier extends ChangeNotifier {
  AuthChangeNotifier(Ref ref) {
    notifyListeners();
    _remove = ref
        .listen<AsyncValue<User?>>(
          authStateChangesProvider,
          (previous, next) => notifyListeners(),
          fireImmediately: false,
        )
        .close;
  }

  late final void Function() _remove;

  @override
  void dispose() {
    _remove();
    super.dispose();
  }
}

/// Mode de thème de l'app. Par défaut [ThemeMode.system] : l'app suit le
/// réglage clair/sombre de l'appareil tant que l'utilisateur n'a pas choisi
/// explicitement.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

final localeProvider = StateProvider<String>((ref) => 'en');

const _kPrefThemeMode = 'pref_theme_mode';
const _kPrefLocale = 'pref_locale';

class SettingsRepository {
  final SharedPreferences _prefs;
  SettingsRepository(this._prefs);

  ThemeMode get themeMode {
    switch (_prefs.getString(_kPrefThemeMode)) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String get locale => _prefs.getString(_kPrefLocale) ?? 'en';

  Future<void> setThemeMode(ThemeMode m) async =>
      _prefs.setString(_kPrefThemeMode, m.name);
  Future<void> setLocale(String code) async =>
      _prefs.setString(_kPrefLocale, code);
}

final settingsRepositoryProvider = FutureProvider<SettingsRepository>((
  ref,
) async {
  final prefs = await SharedPreferences.getInstance();
  return SettingsRepository(prefs);
});

final settingsInitProvider = FutureProvider<void>((ref) async {
  final repo = await ref.watch(settingsRepositoryProvider.future);
  ref.read(themeModeProvider.notifier).state = repo.themeMode;
  ref.read(localeProvider.notifier).state = repo.locale;
});

class _SettingsPersistenceNotifier {
  final Ref ref;
  _SettingsPersistenceNotifier(this.ref) {
    ref.listen<ThemeMode>(themeModeProvider, (prev, next) {
      _saveWithRetry<ThemeMode>(() async {
        final repo = await ref.read(settingsRepositoryProvider.future);
        await repo.setThemeMode(next);
      });
    });
    ref.listen<String>(localeProvider, (prev, next) {
      _saveWithRetry<String>(() async {
        final repo = await ref.read(settingsRepositoryProvider.future);
        await repo.setLocale(next);
      });
    });
  }

  void _saveWithRetry<T>(Future<void> Function() writeFn, {int retries = 0}) {
    writeFn().catchError((err) {
      if (retries >= 3) return;
      Future.delayed(Duration(milliseconds: 200 * (1 << retries)), () {
        _saveWithRetry(writeFn, retries: retries + 1);
      });
    });
  }
}

final settingsPersistenceProvider = Provider.autoDispose((ref) {
  return _SettingsPersistenceNotifier(ref);
});

final conversationsRepositoryProvider = Provider<ConversationsRepository>((
  ref,
) {
  return ConversationsRepositoryImpl();
});

final messagesRepositoryProvider = Provider<MessagesRepository>((ref) {
  return MessagesRepositoryImpl();
});

final messagingServiceProvider = Provider<MessagingService>((ref) {
  final conversationsRepo = ref.watch(conversationsRepositoryProvider);
  final messagesRepo = ref.watch(messagesRepositoryProvider);
  return MessagingService(conversationsRepo, messagesRepo);
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
