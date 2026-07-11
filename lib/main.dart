import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/shared/widgets/app_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'firebase_options.dart';
import 'package:coco/src/router.dart';
import 'package:coco/src/core/providers.dart';
import 'package:coco/src/core/config/stripe_config.dart';
import 'package:coco/src/core/config/dev_config.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialise le SDK Stripe avec la clé publishable (publique).
  Stripe.publishableKey = StripeConfig.publishableKey;
  await Stripe.instance.applySettings();

  // En développement local, on branche l'app sur les émulateurs Firebase
  // (Functions/Firestore/Auth) qui tournent sur la machine. Aucun login requis.
  if (kUseFirebaseEmulators) {
    FirebaseFirestore.instance.useFirestoreEmulator(kEmulatorHost, 8080);
    await FirebaseAuth.instance.useAuthEmulator(kEmulatorHost, 9099);
    FirebaseFunctions.instanceFor(
      region: 'europe-west1',
    ).useFunctionsEmulator(kEmulatorHost, 5001);
  }
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
        ref.read(notificationServiceProvider).initialize();
      });
    }
    ref.listen<String>(localeProvider, (previous, next) {
      try {
        context.setLocale(Locale(next));
      } catch (_) {}
    });

    final themeMode = ref.watch(themeModeProvider);
    final localeCode = ref.watch(localeProvider);

    final lightScheme = ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      brightness: Brightness.light,
      surfaceTint: Colors.transparent,
    );
    final darkScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.brand,
          brightness: Brightness.dark,
          surfaceTint: Colors.transparent,
        ).copyWith(
          // Surfaces sombres mais pas noir pur (plus confortable, évite la
          // halation typique du blanc pur sur noir pur).
          surface: AppColors.darkBackground,
          surfaceContainer: AppColors.darkSurface,
          surfaceContainerHighest: AppColors.darkSurfaceHigh,
        );

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
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: lightScheme,
        scaffoldBackgroundColor: AppColors.lightBackground,
        cardColor: AppColors.lightBackground,
        inputDecorationTheme: appInputDecorationTheme(lightScheme),
        // AppBar aligné sur le corps (pas de teinte crème M3), titre "bold".
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.lightBackground,
          foregroundColor: Colors.black,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: AppTextStyles.xxl.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
            color: Colors.black,
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: darkScheme,
        scaffoldBackgroundColor: AppColors.darkBackground,
        cardColor: AppColors.darkSurface,
        inputDecorationTheme: appInputDecorationTheme(darkScheme),
        dialogTheme: const DialogThemeData(
          backgroundColor: AppColors.darkSurface,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.darkBackground,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: AppTextStyles.xxl.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
            color: Colors.white,
          ),
        ),
      ),
      themeMode: themeMode,
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
