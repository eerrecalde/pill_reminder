import 'daily_reminder_handling.dart';
import 'reminder_schedule.dart';

enum TodayReminderStatus { dueNow, upcoming, missed, handled }

enum TodayDashboardSectionType {
  dueNow,
  upcoming,
  missed,
  handled,
  noMedications,
  noActiveMedications,
  noSchedules,
  clearForToday,
}

enum TodayDashboardAction { addMedication, scheduleReminder, manageMedications }

class TodayReminderItem {
  const TodayReminderItem({
    required this.id,
    required this.localDate,
    required this.medicationId,
    required this.medicationName,
    required this.dosageLabel,
    required this.scheduleId,
    required this.reminderTime,
    required this.scheduledDateTime,
    required this.status,
    required this.notificationDeliveryState,
    this.handledAt,
  });

  final String id;
  final DateTime localDate;
  final String medicationId;
  final String medicationName;
  final String dosageLabel;
  final String scheduleId;
  final ReminderTime reminderTime;
  final DateTime scheduledDateTime;
  final TodayReminderStatus status;
  final DateTime? handledAt;
  final ReminderNotificationDeliveryState notificationDeliveryState;

  bool get canMarkHandled {
    return status == TodayReminderStatus.dueNow ||
        status == TodayReminderStatus.upcoming;
  }

  bool get isUpcoming => status == TodayReminderStatus.upcoming;

  DailyReminderHandling toHandling({required DateTime handledAt}) {
    return DailyReminderHandling(
      id: id,
      localDate: localDate,
      scheduleId: scheduleId,
      medicationId: medicationId,
      reminderTime: reminderTime,
      handledAt: handledAt,
    );
  }
}

class TodayDashboardSection {
  const TodayDashboardSection({
    required this.type,
    this.items = const [],
    this.primaryAction,
    this.actionMedicationId,
  });

  final TodayDashboardSectionType type;
  final List<TodayReminderItem> items;
  final TodayDashboardAction? primaryAction;
  final String? actionMedicationId;

  bool get isReminderSection {
    return switch (type) {
      TodayDashboardSectionType.dueNow ||
      TodayDashboardSectionType.upcoming ||
      TodayDashboardSectionType.missed ||
      TodayDashboardSectionType.handled => true,
      _ => false,
    };
  }
}

class TodayDashboardSnapshot {
  const TodayDashboardSnapshot({
    required this.generatedAt,
    required this.localDate,
    required this.sections,
    this.nextRefreshAt,
  });

  final DateTime generatedAt;
  final DateTime localDate;
  final List<TodayDashboardSection> sections;
  final DateTime? nextRefreshAt;

  List<TodayReminderItem> get allItems {
    return [
      for (final section in sections)
        for (final item in section.items) item,
    ];
  }
}
