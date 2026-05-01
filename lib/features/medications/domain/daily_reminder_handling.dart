import 'reminder_schedule.dart';

class DailyReminderHandling {
  const DailyReminderHandling({
    required this.id,
    required this.localDate,
    required this.scheduleId,
    required this.medicationId,
    required this.reminderTime,
    required this.handledAt,
    this.source = DailyReminderHandlingSource.todayDashboard,
  });

  final String id;
  final DateTime localDate;
  final String scheduleId;
  final String medicationId;
  final ReminderTime reminderTime;
  final DateTime handledAt;
  final DailyReminderHandlingSource source;

  static String buildId({
    required DateTime localDate,
    required String scheduleId,
    required String medicationId,
    required ReminderTime reminderTime,
  }) {
    final date = _dateOnly(localDate).toIso8601String().split('T').first;
    return '$date|$scheduleId|$medicationId|${reminderTime.hour}:${reminderTime.minute}';
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'localDate': _dateOnly(localDate).toIso8601String(),
      'scheduleId': scheduleId,
      'medicationId': medicationId,
      'reminderTime': reminderTime.toJson(),
      'handledAt': handledAt.toIso8601String(),
      'source': source.name,
    };
  }

  factory DailyReminderHandling.fromJson(Map<String, Object?> json) {
    final rawTime = json['reminderTime'];
    final reminderTime = rawTime is Map<String, Object?>
        ? ReminderTime.fromJson(rawTime)
        : const ReminderTime(hour: 0, minute: 0);
    final localDate =
        DateTime.tryParse(json['localDate'] as String? ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);
    final scheduleId = json['scheduleId'] as String? ?? '';
    final medicationId = json['medicationId'] as String? ?? '';
    return DailyReminderHandling(
      id:
          json['id'] as String? ??
          buildId(
            localDate: localDate,
            scheduleId: scheduleId,
            medicationId: medicationId,
            reminderTime: reminderTime,
          ),
      localDate: _dateOnly(localDate),
      scheduleId: scheduleId,
      medicationId: medicationId,
      reminderTime: reminderTime,
      handledAt:
          DateTime.tryParse(json['handledAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      source: DailyReminderHandlingSource.fromStorage(
        json['source'] as String?,
      ),
    );
  }

  static DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}

enum DailyReminderHandlingSource {
  todayDashboard;

  static DailyReminderHandlingSource fromStorage(String? value) {
    return switch (value) {
      'todayDashboard' => DailyReminderHandlingSource.todayDashboard,
      _ => DailyReminderHandlingSource.todayDashboard,
    };
  }
}
