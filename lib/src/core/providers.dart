import 'package:flutter/widgets.dart';
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

final isDarkModeProvider = StateProvider<bool>((ref) => false);

final localeProvider = StateProvider<String>((ref) => 'en');

const _kPrefIsDark = 'pref_is_dark';
const _kPrefLocale = 'pref_locale';

class SettingsRepository {
  final SharedPreferences _prefs;
  SettingsRepository(this._prefs);

  bool get isDark => _prefs.getBool(_kPrefIsDark) ?? false;
  String get locale => _prefs.getString(_kPrefLocale) ?? 'en';

  Future<void> setIsDark(bool v) async => _prefs.setBool(_kPrefIsDark, v);
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
  ref.read(isDarkModeProvider.notifier).state = repo.isDark;
  ref.read(localeProvider.notifier).state = repo.locale;
});

class _SettingsPersistenceNotifier {
  final Ref ref;
  _SettingsPersistenceNotifier(this.ref) {
    ref.listen<bool>(isDarkModeProvider, (prev, next) {
      _saveWithRetry<bool>(() async {
        final repo = await ref.read(settingsRepositoryProvider.future);
        await repo.setIsDark(next);
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
