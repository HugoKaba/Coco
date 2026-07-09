/// Configuration de développement local.
///
/// Quand [kUseFirebaseEmulators] est `true`, l'app se connecte aux émulateurs
/// Firebase qui tournent sur ta machine (Functions, Firestore, Auth) au lieu du
/// cloud. Ça permet de tester le paiement Stripe SANS `firebase login` ni plan
/// Blaze. Repasse à `false` le jour où le backend est déployé sur Firebase.
const bool kUseFirebaseEmulators = true;

/// Hôte des émulateurs.
/// - `localhost` fonctionne sur le **simulateur iOS** (réseau partagé avec le Mac).
/// - Sur un **émulateur Android**, il faudrait `10.0.2.2`.
const String kEmulatorHost = 'localhost';
