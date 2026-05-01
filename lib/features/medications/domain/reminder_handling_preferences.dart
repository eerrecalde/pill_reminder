class ReminderHandlingPreferences {
  const ReminderHandlingPreferences({
    this.remindAgainLaterIntervalMinutes =
        defaultRemindAgainLaterIntervalMinutes,
    this.updatedAt,
  });

  static const defaultRemindAgainLaterIntervalMinutes = 10;

  final int remindAgainLaterIntervalMinutes;
  final DateTime? updatedAt;

  ReminderHandlingPreferences copyWith({
    int? remindAgainLaterIntervalMinutes,
    DateTime? updatedAt,
  }) {
    return ReminderHandlingPreferences(
      remindAgainLaterIntervalMinutes:
          remindAgainLaterIntervalMinutes ??
          this.remindAgainLaterIntervalMinutes,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'remindAgainLaterIntervalMinutes': remindAgainLaterIntervalMinutes,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory ReminderHandlingPreferences.fromJson(Map<String, Object?> json) {
    return ReminderHandlingPreferences(
      remindAgainLaterIntervalMinutes:
          json['remindAgainLaterIntervalMinutes'] as int? ??
          defaultRemindAgainLaterIntervalMinutes,
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
    );
  }
}
