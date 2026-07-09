import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../../core/config/stripe_config.dart';

/// Levée quand le paiement échoue (hors annulation volontaire de l'utilisateur).
class PaymentException implements Exception {
  PaymentException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Orchestre un paiement Stripe pour la réservation d'un créneau payant.
///
/// Flux :
///   1. demande un `client_secret` au backend (Cloud Function `createPaymentIntent`) ;
///   2. ouvre la PaymentSheet Stripe (carte, Apple/Google Pay) ;
///   3. renvoie `true` si payé, `false` si l'utilisateur annule.
/// Toute autre erreur lève une [PaymentException].
class StripePaymentService {
  StripePaymentService({FirebaseFunctions? functions})
    : _functions =
          functions ??
          // Doit correspondre à la région déclarée dans functions/index.js.
          FirebaseFunctions.instanceFor(region: 'europe-west1');

  final FirebaseFunctions _functions;

  Future<bool> payForSlot({required String slotId}) async {
    // 1. Récupère le client_secret auprès du backend.
    final String clientSecret;
    try {
      final callable = _functions.httpsCallable('createPaymentIntent');
      final result = await callable.call(<String, dynamic>{'slotId': slotId});
      final data = Map<String, dynamic>.from(result.data as Map);
      clientSecret = data['clientSecret'] as String;
    } on FirebaseFunctionsException catch (e) {
      throw PaymentException(
        e.message ?? 'Impossible de préparer le paiement.',
      );
    }

    // 2. Prépare puis présente la PaymentSheet.
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: StripeConfig.merchantDisplayName,
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      return true; // Paiement confirmé.
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        return false; // L'utilisateur a fermé la feuille de paiement.
      }
      throw PaymentException(e.error.localizedMessage ?? 'Paiement refusé.');
    }
  }
}
