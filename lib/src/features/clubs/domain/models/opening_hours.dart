import 'package:flutter/material.dart';

class OpeningHours {
  final bool isOpen;
  final TimeOfDay? openTime;
  final TimeOfDay? closeTime;

  const OpeningHours({required this.isOpen, this.openTime, this.closeTime});

  OpeningHours copyWith({
    bool? isOpen,
    TimeOfDay? openTime,
    TimeOfDay? closeTime,
  }) {
    return OpeningHours(
      isOpen: isOpen ?? this.isOpen,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
    );
  }

  factory OpeningHours.fromMap(Map<String, dynamic> data) {
    TimeOfDay? parseTime(dynamic val) {
      if (val is Map) {
        final hour = (val['hour'] as num?)?.toInt() ?? 0;
        final minute = (val['minute'] as num?)?.toInt() ?? 0;
        return TimeOfDay(hour: hour, minute: minute);
      }
      return null;
    }

    return OpeningHours(
      isOpen: data['isOpen'] as bool? ?? false,
      openTime: parseTime(data['openTime']),
      closeTime: parseTime(data['closeTime']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isOpen': isOpen,
      if (openTime != null)
        'openTime': {'hour': openTime!.hour, 'minute': openTime!.minute},
      if (closeTime != null)
        'closeTime': {'hour': closeTime!.hour, 'minute': closeTime!.minute},
    };
  }

  static OpeningHours closed() {
    return const OpeningHours(isOpen: false);
  }

  static OpeningHours standard() {
    return const OpeningHours(
      isOpen: true,
      openTime: TimeOfDay(hour: 9, minute: 0),
      closeTime: TimeOfDay(hour: 21, minute: 0),
    );
  }
}
