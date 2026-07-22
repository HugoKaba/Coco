import 'package:easy_localization/easy_localization.dart';

String? clubCreationStepError({
  required int step,
  required String email,
  required String password,
  required String clubName,
  required List<String> activities,
  required String description,
  required String city,
  required String address,
}) {
  if (step == 0) {
    if (email.isEmpty || password.length < 6) {
      return 'clubs.create.error_credentials'.tr();
    }
  }

  if (step == 1) {
    if (clubName.isEmpty ||
        activities.isEmpty ||
        description.isEmpty ||
        city.isEmpty ||
        address.isEmpty) {
      return 'clubs.create.error_required_fields'.tr();
    }
  }

  return null;
}
