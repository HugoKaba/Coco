import 'package:flutter/material.dart';

/// Échelle typographique de l'app, nommée en t-shirt sizes.
///
/// Chaque style porte une taille + un poids par défaut, mais PAS de couleur :
/// la couleur est héritée du thème (`onSurface`…), ce qui garde le dark mode
/// cohérent. Pour un cas particulier : `AppTextStyles.md.copyWith(...)`.
class AppTextStyles {
  AppTextStyles._();

  /// 12 · légendes, métadonnées
  static const TextStyle xs = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  /// 14 · texte secondaire
  static const TextStyle sm = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  /// 16 · corps de texte par défaut
  static const TextStyle md = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  /// 18 · sous-titres
  static const TextStyle lg = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  /// 20 · titres de section
  static const TextStyle xl = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  /// 24 · titres d'écran
  static const TextStyle xxl = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  /// 28 · gros titres
  static const TextStyle xxxl = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  /// 32 · display / hero
  static const TextStyle display = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );
}
