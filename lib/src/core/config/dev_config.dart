/// Configuration de développement local.
///
/// Quand [kUseFirebaseEmulators] est `true`, l'app se connecte aux émulateurs
/// Firebase qui tournent sur ta machine (Functions, Firestore, Auth) au lieu du
/// cloud. Ça permet de tester le paiement Stripe SANS `firebase login` ni plan
/// Blaze.
///
/// `false` = l'app appelle le **vrai backend** déployé sur Firebase (la Cloud
/// Function `createPaymentIntent` en europe-west1). Déployée le 2026-07-09.
const bool kUseFirebaseEmulators = false;

/// Hôte des émulateurs.
/// - `localhost` fonctionne sur le **simulateur iOS** (réseau partagé avec le Mac).
/// - Sur un **émulateur Android**, il faudrait `10.0.2.2`.
const String kEmulatorHost = 'localhost';
