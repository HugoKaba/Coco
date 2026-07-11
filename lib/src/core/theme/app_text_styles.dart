import 'package:flutter/material.dart';

/// Échelle des tailles de police (t-shirt sizes). Source de vérité unique des
/// `fontSize` : on écrit `fontSize: AppFontSize.md` au lieu de `fontSize: 16`.
class AppFontSize {
  AppFontSize._();

  static const double xs = 12;
  static const double sm = 14;
  static const double md = 16;
  static const double lg = 18;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 28;
  static const double display = 32;
}

/// Échelle typographique de l'app, nommée en t-shirt sizes.
///
/// Chaque style porte une taille + un poids par défaut, mais PAS de couleur :
/// la couleur est héritée du thème (`onSurface`…), ce qui garde le dark mode
/// cohérent. Pour un cas particulier : `AppTextStyles.md.copyWith(...)`.
class AppTextStyles {
  AppTextStyles._();

  /// 12 · légendes, métadonnées
  static const TextStyle xs = TextStyle(
    fontSize: AppFontSize.xs,
    fontWeight: FontWeight.w500,
  );

  /// 14 · texte secondaire
  static const TextStyle sm = TextStyle(
    fontSize: AppFontSize.sm,
    fontWeight: FontWeight.w500,
  );

  /// 16 · corps de texte par défaut
  static const TextStyle md = TextStyle(
    fontSize: AppFontSize.md,
    fontWeight: FontWeight.w500,
  );

  /// 18 · sous-titres
  static const TextStyle lg = TextStyle(
    fontSize: AppFontSize.lg,
    fontWeight: FontWeight.w600,
  );

  /// 20 · titres de section
  static const TextStyle xl = TextStyle(
    fontSize: AppFontSize.xl,
    fontWeight: FontWeight.w600,
  );

  /// 24 · titres d'écran
  static const TextStyle xxl = TextStyle(
    fontSize: AppFontSize.xxl,
    fontWeight: FontWeight.w700,
  );

  /// 28 · gros titres
  static const TextStyle xxxl = TextStyle(
    fontSize: AppFontSize.xxxl,
    fontWeight: FontWeight.w700,
  );

  /// 32 · display / hero
  static const TextStyle display = TextStyle(
    fontSize: AppFontSize.display,
    fontWeight: FontWeight.w700,
  );
}
