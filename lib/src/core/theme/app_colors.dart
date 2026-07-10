import 'package:flutter/material.dart';

/// Source de vérité unique des couleurs de l'app.
///
/// Aucune couleur ne doit être codée en dur ailleurs dans le code : on
/// référence toujours une constante d'[AppColors]. Ainsi, changer une couleur
/// (ex. la marque) se fait ici, en un seul endroit, et se propage partout.
class AppColors {
  AppColors._();

  // --- Marque ---
  /// Orange principal de l'app (accent, boutons, onglet actif…).
  static const Color brand = Color(0xFFCD8232);

  /// Variantes de la marque, utilisées surtout dans les dégradés.
  static const Color brandLight = Color(0xFFF2A33A);
  static const Color brandDark = Color(0xFFA05E15);

  // --- Fonds ---
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF0D0D0D);

  /// Surfaces sombres (cartes, conteneurs) : plus claires que le fond, mais
  /// jamais noir pur — plus confortable et moins de halation.
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceHigh = Color(0xFF2A2A2A);

  // --- Sémantiques : niveaux de pratique ---
  static const Color levelBeginner = Color(0xFF4CAF50); // vert
  static const Color levelIntermediate = Color(0xFF2196F3); // bleu
  static const Color levelAdvanced = Color(0xFFFF9800); // orange
  static const Color levelExpert = Color(0xFFF44336); // rouge

  // --- Sémantiques : états ---
  /// Succès / confirmation (ex. bouton "déjà membre").
  static const Color success = Color(0xFF4CAF50);

  /// Pastille de notification.
  static const Color badge = Color(0xFFE53935);
}
