/**
 * Cloud Functions SportLinker — paiements Stripe.
 *
 * Fonction `createPaymentIntent` : appelée par l'app Flutter quand un user
 * veut réserver un cours payant. Elle crée un PaymentIntent Stripe côté
 * serveur (la secret key ne quitte jamais le serveur) et renvoie le
 * `client_secret` que l'app utilisera pour ouvrir la PaymentSheet.
 */

const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const admin = require("firebase-admin");
const Stripe = require("stripe");

admin.initializeApp();

// La secret key Stripe est stockée dans Google Secret Manager, jamais en clair
// dans le code. On la définira via :  firebase functions:secrets:set STRIPE_SECRET_KEY
const stripeSecretKey = defineSecret("STRIPE_SECRET_KEY");

exports.createPaymentIntent = onCall(
  { secrets: [stripeSecretKey], region: "europe-west1" },
  async (request) => {
    // 1. L'appelant doit être authentifié (auth Firebase, gérée automatiquement).
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Vous devez être connecté.");
    }

    const slotId = request.data && request.data.slotId;
    if (!slotId || typeof slotId !== "string") {
      throw new HttpsError("invalid-argument", "slotId manquant ou invalide.");
    }

    // 2. On lit le VRAI prix dans Firestore — jamais celui envoyé par le client
    //    (sinon l'utilisateur pourrait forcer un montant de 0,01 €).
    const slotSnap = await admin
      .firestore()
      .collection("slots")
      .doc(slotId)
      .get();

    if (!slotSnap.exists) {
      throw new HttpsError("not-found", "Créneau introuvable.");
    }

    const price = slotSnap.data().price;
    if (typeof price !== "number" || price <= 0) {
      throw new HttpsError(
        "failed-precondition",
        "Ce créneau n'est pas payant."
      );
    }

    // 3. Création du PaymentIntent. Stripe travaille en centimes → on x100.
    const stripe = new Stripe(stripeSecretKey.value());
    const amount = Math.round(price * 100);

    const paymentIntent = await stripe.paymentIntents.create({
      amount,
      currency: "eur",
      automatic_payment_methods: { enabled: true },
      metadata: {
        slotId,
        userId: request.auth.uid,
      },
    });

    // 4. On ne renvoie QUE le client_secret (jamais la secret key).
    return {
      clientSecret: paymentIntent.client_secret,
      amount,
      currency: "eur",
    };
  }
);
