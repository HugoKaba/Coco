/// Échelle d'espacement de l'app (base 4pt), nommée en t-shirt sizes.
///
/// À utiliser pour tous les gaps, paddings et marges au lieu de valeurs en dur :
/// `SizedBox(height: AppSpacing.lg)`, `EdgeInsets.all(AppSpacing.md)`…
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
}
