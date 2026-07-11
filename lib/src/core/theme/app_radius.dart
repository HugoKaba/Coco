import 'package:flutter/widgets.dart';

/// Échelle de rayons d'arrondi, nommée en t-shirt sizes.
///
/// `sm/md/lg/xl/xxl` renvoient les valeurs brutes (pour `BorderRadius.circular`
/// ou `Radius.circular`) ; les getters `*All` renvoient directement un
/// [BorderRadius] prêt à l'emploi.
class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius xxlAll = BorderRadius.all(Radius.circular(xxl));
}
