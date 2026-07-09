/// Configuration Stripe centralisée.
///
/// La *publishable key* (`pk_test_...`) est PUBLIQUE par conception : elle ne
/// permet que d'identifier le compte Stripe côté client, jamais de débiter.
/// Il est donc sans danger de l'embarquer dans l'app.
///
/// La *secret key* (`sk_test_...`) ne doit JAMAIS apparaître ici ni dans aucun
/// fichier de l'app : elle vit uniquement côté backend (Cloud Function).
class StripeConfig {
  StripeConfig._();

  /// Clé publishable (test mode).
  ///
  /// Peut être surchargée au build via :
  ///   flutter run --dart-define=STRIPE_PUBLISHABLE_KEY=pk_live_...
  static const String publishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue:
        'pk_test_51Tk3QD1P45wd7gobht35FCLigK4JVo8SZa0yHVhKcy7jTpBvMhGCpAQimVRsG8mPQ7tWRWtTDfN7KBqJlopLhPjF00apHUQhYP',
  );

  /// Nom affiché par Stripe dans la feuille de paiement.
  static const String merchantDisplayName = 'SportLinker';
}
