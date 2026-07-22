import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

enum SubscriptionType {
  monthly,
  annual;

  String get displayName {
    switch (this) {
      case SubscriptionType.monthly:
        return 'clubs.subscription.monthly'.tr();
      case SubscriptionType.annual:
        return 'clubs.subscription.annual'.tr();
    }
  }
}

class SubscriptionTier {
  final SubscriptionType type;
  final double price;
  final int durationDays;
  final Map<String, bool> features;
  final DateTime? startDate;
  final DateTime? expiresAt;

  const SubscriptionTier({
    required this.type,
    required this.price,
    required this.durationDays,
    required this.features,
    this.startDate,
    this.expiresAt,
  });

  bool get isActive {
    if (expiresAt == null) return false;
    return DateTime.now().isBefore(expiresAt!);
  }

  bool get isExpired => !isActive;

  int get daysRemaining {
    if (expiresAt == null) return 0;
    final diff = expiresAt!.difference(DateTime.now());
    return diff.inDays.clamp(0, double.infinity).toInt();
  }

  SubscriptionTier copyWith({
    SubscriptionType? type,
    double? price,
    int? durationDays,
    Map<String, bool>? features,
    DateTime? startDate,
    DateTime? expiresAt,
  }) {
    return SubscriptionTier(
      type: type ?? this.type,
      price: price ?? this.price,
      durationDays: durationDays ?? this.durationDays,
      features: features ?? this.features,
      startDate: startDate ?? this.startDate,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  factory SubscriptionTier.fromFirestore(Map<String, dynamic> data) {
    DateTime? parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val);
      return null;
    }

    return SubscriptionTier(
      type: SubscriptionType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => SubscriptionType.monthly,
      ),
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      durationDays: (data['durationDays'] as num?)?.toInt() ?? 30,
      features: Map<String, bool>.from(data['features'] ?? {}),
      startDate: parseDate(data['startDate']),
      expiresAt: parseDate(data['expiresAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'type': type.name,
      'price': price,
      'durationDays': durationDays,
      'features': features,
      if (startDate != null) 'startDate': Timestamp.fromDate(startDate!),
      if (expiresAt != null) 'expiresAt': Timestamp.fromDate(expiresAt!),
    };
  }

  static SubscriptionTier createMonthly({DateTime? startDate}) {
    final start = startDate ?? DateTime.now();
    return SubscriptionTier(
      type: SubscriptionType.monthly,
      price: 29.99,
      durationDays: 30,
      features: {
        'unlimited_slots': true,
        'chat_access': true,
        'analytics': true,
        'custom_branding': false,
      },
      startDate: start,
      expiresAt: start.add(const Duration(days: 30)),
    );
  }

  static SubscriptionTier createAnnual({DateTime? startDate}) {
    final start = startDate ?? DateTime.now();
    return SubscriptionTier(
      type: SubscriptionType.annual,
      price: 299.99,
      durationDays: 365,
      features: {
        'unlimited_slots': true,
        'chat_access': true,
        'analytics': true,
        'custom_branding': true,
      },
      startDate: start,
      expiresAt: start.add(const Duration(days: 365)),
    );
  }
}
