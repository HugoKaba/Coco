import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:sportlinker/src/router.dart';
import 'package:sportlinker/src/core/providers.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.setLoggingEnabled(true);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
    sslEnabled: true,
  );
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('fr')],
      path: 'assets/langs',
      fallbackLocale: const Locale('en'),
      child: const ProviderScope(child: AppRoot()),
    ),
  );
}

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});
  static bool _settingsInitScheduled = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    if (!_settingsInitScheduled) {
      _settingsInitScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(settingsInitProvider.future).catchError((_) {});
        ref.read(settingsPersistenceProvider);
      });
    }
    ref.listen<String>(localeProvider, (previous, next) {
      try {
        context.setLocale(Locale(next));
      } catch (_) {}
    });

    final isDark = ref.watch(isDarkModeProvider);
    final localeCode = ref.watch(localeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => tr('app.title'),
      supportedLocales: context.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        final appLocale = Locale(localeCode);
        if (supportedLocales.contains(appLocale)) return appLocale;
        return locale ?? supportedLocales.first;
      },
      localizationsDelegates: context.localizationDelegates,
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      locale: context.locale,
      routerConfig: router,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const ProviderScope(child: AppRoot());
}
