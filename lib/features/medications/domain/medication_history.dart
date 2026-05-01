import 'reminder_schedule.dart';

enum MedicationHistoryStatus {
  taken,
  skipped,
  missed,
  snoozed;

  static MedicationHistoryStatus? fromStorage(String? value) {
    return switch (value) {
      'taken' => MedicationHistoryStatus.taken,
      'skipped' => MedicationHistoryStatus.skipped,
      'missed' => MedicationHistoryStatus.missed,
      'snoozed' => MedicationHistoryStatus.snoozed,
      _ => null,
    };
  }

  bool get isFinal => this != MedicationHistoryStatus.snoozed;
}

enum MedicationHistorySource {
  todayDashboard,
  dueReminder,
  reconciliation;

  static MedicationHistorySource fromStorage(String? value) {
    return switch (value) {
      'todayDashboard' => MedicationHistorySource.todayDashboard,
      'dueReminder' => MedicationHistorySource.dueReminder,
      _ => MedicationHistorySource.reconciliation,
    };
  }
}

class MedicationHistoryEntry {
  const MedicationHistoryEntry({
    required this.id,
    required this.localDate,
    required this.scheduledAt,
    required this.scheduleId,
    required this.medicationId,
    required this.medicationName,
    required this.status,
    required this.statusUpdatedAt,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
    this.dosageLabel = '',
    this.snoozeCount,
    this.lastSnoozedAt,
    this.nextReminderAt,
  });

  final String id;
  final DateTime localDate;
  final DateTime scheduledAt;
  final String scheduleId;
  final String medicationId;
  final String medicationName;
  final String dosageLabel;
  final MedicationHistoryStatus status;
  final DateTime statusUpdatedAt;
  final int? snoozeCount;
  final DateTime? lastSnoozedAt;
  final DateTime? nextReminderAt;
  final MedicationHistorySource source;
  final DateTime createdAt;
  final DateTime updatedAt;

  static String buildOccurrenceId({
    required DateTime localDate,
    required String scheduleId,
    required String medicationId,
    required ReminderTime reminderTime,
  }) {
    final date = dateOnly(localDate).toIso8601String().split('T').first;
    return '$date|$scheduleId|$medicationId|${reminderTime.hour}:${reminderTime.minute}';
  }

  static String buildOccurrenceIdFromDateTime({
    required DateTime scheduledAt,
    required String scheduleId,
    required String medicationId,
  }) {
    return buildOccurrenceId(
      localDate: scheduledAt,
      scheduleId: scheduleId,
      medicationId: medicationId,
      reminderTime: ReminderTime(
        hour: scheduledAt.hour,
        minute: scheduledAt.minute,
      ),
    );
  }

  static DateTime dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  MedicationHistoryEntry copyWith({
    MedicationHistoryStatus? status,
    DateTime? statusUpdatedAt,
    int? snoozeCount,
    DateTime? lastSnoozedAt,
    DateTime? nextReminderAt,
    MedicationHistorySource? source,
    DateTime? updatedAt,
  }) {
    return MedicationHistoryEntry(
      id: id,
      localDate: localDate,
      scheduledAt: scheduledAt,
      scheduleId: scheduleId,
      medicationId: medicationId,
      medicationName: medicationName,
      dosageLabel: dosageLabel,
      status: status ?? this.status,
      statusUpdatedAt: statusUpdatedAt ?? this.statusUpdatedAt,
      snoozeCount: snoozeCount ?? this.snoozeCount,
      lastSnoozedAt: lastSnoozedAt ?? this.lastSnoozedAt,
      nextReminderAt: nextReminderAt ?? this.nextReminderAt,
      source: source ?? this.source,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  MedicationHistoryEntry mergeWith(MedicationHistoryEntry incoming) {
    if (status.isFinal && !incoming.status.isFinal) return this;
    if (!status.isFinal && incoming.status.isFinal) {
      return incoming
          .copyWith(
            snoozeCount: incoming.snoozeCount ?? snoozeCount,
            lastSnoozedAt: incoming.lastSnoozedAt ?? lastSnoozedAt,
            nextReminderAt: incoming.nextReminderAt ?? nextReminderAt,
          )
          ._withCreatedAt(createdAt);
    }
    if (incoming.updatedAt.isBefore(updatedAt)) return this;
    return incoming._withCreatedAt(createdAt);
  }

  MedicationHistoryEntry _withCreatedAt(DateTime value) {
    return MedicationHistoryEntry(
      id: id,
      localDate: localDate,
      scheduledAt: scheduledAt,
      scheduleId: scheduleId,
      medicationId: medicationId,
      medicationName: medicationName,
      dosageLabel: dosageLabel,
      status: status,
      statusUpdatedAt: statusUpdatedAt,
      snoozeCount: snoozeCount,
      lastSnoozedAt: lastSnoozedAt,
      nextReminderAt: nextReminderAt,
      source: source,
      createdAt: value,
      updatedAt: updatedAt,
    );
  }

  bool get isValid {
    return id.isNotEmpty &&
        scheduleId.isNotEmpty &&
        medicationName.trim().isNotEmpty &&
        !localDate.isBefore(DateTime(1900)) &&
        !scheduledAt.isBefore(DateTime(1900));
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'localDate': dateOnly(localDate).toIso8601String(),
      'scheduledAt': scheduledAt.toIso8601String(),
      'scheduleId': scheduleId,
      'medicationId': medicationId,
      'medicationName': medicationName.trim(),
      'dosageLabel': dosageLabel.trim(),
      'status': status.name,
      'statusUpdatedAt': statusUpdatedAt.toIso8601String(),
      'snoozeCount': snoozeCount,
      'lastSnoozedAt': lastSnoozedAt?.toIso8601String(),
      'nextReminderAt': nextReminderAt?.toIso8601String(),
      'source': source.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory MedicationHistoryEntry.fromJson(Map<String, Object?> json) {
    final status = MedicationHistoryStatus.fromStorage(
      json['status'] as String?,
    );
    if (status == null) {
      throw const FormatException('Unknown medication history status');
    }
    return MedicationHistoryEntry(
      id: json['id'] as String? ?? '',
      localDate: dateOnly(
        DateTime.tryParse(json['localDate'] as String? ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0),
      ),
      scheduledAt:
          DateTime.tryParse(json['scheduledAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      scheduleId: json['scheduleId'] as String? ?? '',
      medicationId: json['medicationId'] as String? ?? '',
      medicationName: (json['medicationName'] as String? ?? '').trim(),
      dosageLabel: (json['dosageLabel'] as String? ?? '').trim(),
      status: status,
      statusUpdatedAt:
          DateTime.tryParse(json['statusUpdatedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      snoozeCount: json['snoozeCount'] as int?,
      lastSnoozedAt: DateTime.tryParse(json['lastSnoozedAt'] as String? ?? ''),
      nextReminderAt: DateTime.tryParse(
        json['nextReminderAt'] as String? ?? '',
      ),
      source: MedicationHistorySource.fromStorage(json['source'] as String?),
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}

class MedicationHistoryDayGroup {
  const MedicationHistoryDayGroup({
    required this.localDate,
    required this.entries,
  });

  final DateTime localDate;
  final List<MedicationHistoryEntry> entries;
}
