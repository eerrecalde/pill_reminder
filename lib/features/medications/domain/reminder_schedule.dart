enum ReminderNotificationDeliveryState {
  deliverable,
  permissionNeeded,
  blocked,
  unavailable;

  static ReminderNotificationDeliveryState fromStorage(String? value) {
    return switch (value) {
      'deliverable' => ReminderNotificationDeliveryState.deliverable,
      'blocked' => ReminderNotificationDeliveryState.blocked,
      'unavailable' => ReminderNotificationDeliveryState.unavailable,
      _ => ReminderNotificationDeliveryState.permissionNeeded,
    };
  }
}

class ReminderTime implements Comparable<ReminderTime> {
  const ReminderTime({required this.hour, required this.minute});

  final int hour;
  final int minute;

  int get minutesSinceMidnight => hour * 60 + minute;

  Map<String, Object?> toJson() {
    return {'hour': hour, 'minute': minute};
  }

  factory ReminderTime.fromJson(Map<String, Object?> json) {
    return ReminderTime(
      hour: json['hour'] as int? ?? 0,
      minute: json['minute'] as int? ?? 0,
    );
  }

  @override
  int compareTo(ReminderTime other) {
    return minutesSinceMidnight.compareTo(other.minutesSinceMidnight);
  }

  @override
  bool operator ==(Object other) {
    return other is ReminderTime &&
        hour == other.hour &&
        minute == other.minute;
  }

  @override
  int get hashCode => Object.hash(hour, minute);
}

class ReminderSchedule {
  const ReminderSchedule({
    required this.id,
    required this.medicationId,
    required this.reminderTimes,
    required this.createdAt,
    required this.updatedAt,
    this.endDate,
    this.notificationDeliveryState =
        ReminderNotificationDeliveryState.permissionNeeded,
  });

  final String id;
  final String medicationId;
  final List<ReminderTime> reminderTimes;
  final DateTime? endDate;
  final ReminderNotificationDeliveryState notificationDeliveryState;
  final DateTime createdAt;
  final DateTime updatedAt;

  List<ReminderTime> get sortedReminderTimes {
    return [...reminderTimes]..sort();
  }

  ReminderSchedule copyWith({
    String? id,
    String? medicationId,
    List<ReminderTime>? reminderTimes,
    DateTime? endDate,
    bool clearEndDate = false,
    ReminderNotificationDeliveryState? notificationDeliveryState,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReminderSchedule(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      reminderTimes: reminderTimes ?? this.reminderTimes,
      endDate: clearEndDate ? null : endDate ?? this.endDate,
      notificationDeliveryState:
          notificationDeliveryState ?? this.notificationDeliveryState,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'medicationId': medicationId,
      'reminderTimes': reminderTimes.map((time) => time.toJson()).toList(),
      'endDate': endDate?.toIso8601String(),
      'notificationDeliveryState': notificationDeliveryState.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ReminderSchedule.fromJson(Map<String, Object?> json) {
    final rawTimes = json['reminderTimes'];
    return ReminderSchedule(
      id: json['id'] as String? ?? '',
      medicationId: json['medicationId'] as String? ?? '',
      reminderTimes: rawTimes is List
          ? rawTimes
                .whereType<Map<String, Object?>>()
                .map(ReminderTime.fromJson)
                .toList(growable: false)
          : const [],
      endDate: DateTime.tryParse(json['endDate'] as String? ?? ''),
      notificationDeliveryState: ReminderNotificationDeliveryState.fromStorage(
        json['notificationDeliveryState'] as String?,
      ),
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
