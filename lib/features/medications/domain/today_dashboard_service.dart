import '../data/daily_reminder_handling_repository.dart';
import '../data/medication_repository.dart';
import '../data/reminder_schedule_repository.dart';
import 'daily_reminder_handling.dart';
import 'medication.dart';
import 'reminder_schedule.dart';
import 'today_dashboard.dart';

typedef DashboardClock = DateTime Function();

class TodayDashboardService {
  TodayDashboardService({
    required MedicationRepository medicationRepository,
    required ReminderScheduleRepository reminderScheduleRepository,
    required DailyReminderHandlingRepository handlingRepository,
    DashboardClock? clock,
  }) : _medicationRepository = medicationRepository,
       _reminderScheduleRepository = reminderScheduleRepository,
       _handlingRepository = handlingRepository,
       _clock = clock ?? DateTime.now;

  final MedicationRepository _medicationRepository;
  final ReminderScheduleRepository _reminderScheduleRepository;
  final DailyReminderHandlingRepository _handlingRepository;
  final DashboardClock _clock;

  Future<TodayDashboardSnapshot> loadSnapshot() async {
    final now = _clock();
    final localDate = _dateOnly(now);
    final medications = await _medicationRepository.loadMedications();
    final schedules = await _reminderScheduleRepository.loadSchedules();
    final handlingRecords = await _handlingRepository.loadForDate(localDate);

    final sections = _buildSections(
      now: now,
      localDate: localDate,
      medications: medications,
      schedules: schedules,
      handlingRecords: handlingRecords,
    );

    return TodayDashboardSnapshot(
      generatedAt: now,
      localDate: localDate,
      sections: sections,
      nextRefreshAt: _nextRefreshAt(now, sections),
    );
  }

  List<TodayDashboardSection> _buildSections({
    required DateTime now,
    required DateTime localDate,
    required List<Medication> medications,
    required List<ReminderSchedule> schedules,
    required List<DailyReminderHandling> handlingRecords,
  }) {
    if (medications.isEmpty) {
      return const [
        TodayDashboardSection(
          type: TodayDashboardSectionType.noMedications,
          primaryAction: TodayDashboardAction.addMedication,
        ),
      ];
    }

    final activeMedications = medications
        .where((medication) => medication.isActive)
        .toList(growable: false);
    if (activeMedications.isEmpty) {
      return const [
        TodayDashboardSection(
          type: TodayDashboardSectionType.noActiveMedications,
          primaryAction: TodayDashboardAction.manageMedications,
        ),
      ];
    }

    final schedulesByMedicationId = {
      for (final schedule in schedules) schedule.medicationId: schedule,
    };
    final items = <TodayReminderItem>[];
    String? firstUnscheduledMedicationId;

    for (final medication in activeMedications) {
      final schedule = schedulesByMedicationId[medication.id];
      if (schedule == null) {
        firstUnscheduledMedicationId ??= medication.id;
        continue;
      }
      if (!_scheduleAppliesOn(schedule, localDate)) continue;

      for (final reminderTime in schedule.sortedReminderTimes) {
        final handling = _findHandling(
          handlingRecords,
          localDate: localDate,
          schedule: schedule,
          medication: medication,
          reminderTime: reminderTime,
        );
        final scheduledDateTime = DateTime(
          localDate.year,
          localDate.month,
          localDate.day,
          reminderTime.hour,
          reminderTime.minute,
        );
        final status = _statusFor(
          now: now,
          scheduledDateTime: scheduledDateTime,
          handling: handling,
        );
        final id = DailyReminderHandling.buildId(
          localDate: localDate,
          scheduleId: schedule.id,
          medicationId: medication.id,
          reminderTime: reminderTime,
        );
        items.add(
          TodayReminderItem(
            id: id,
            localDate: localDate,
            medicationId: medication.id,
            medicationName: medication.name,
            dosageLabel: medication.dosageLabel,
            scheduleId: schedule.id,
            reminderTime: reminderTime,
            scheduledDateTime: scheduledDateTime,
            status: status,
            handledAt: handling?.handledAt,
            notificationDeliveryState: schedule.notificationDeliveryState,
          ),
        );
      }
    }

    if (items.isEmpty) {
      return [
        TodayDashboardSection(
          type: TodayDashboardSectionType.noSchedules,
          primaryAction: TodayDashboardAction.scheduleReminder,
          actionMedicationId: firstUnscheduledMedicationId,
        ),
      ];
    }

    final sections = <TodayDashboardSection>[
      _sectionFor(TodayDashboardSectionType.dueNow, items),
      _sectionFor(TodayDashboardSectionType.upcoming, items),
      _sectionFor(TodayDashboardSectionType.missed, items),
      _sectionFor(TodayDashboardSectionType.handled, items),
    ].where((section) => section.items.isNotEmpty).toList(growable: false);

    final unhandledCount = items.where((item) {
      return item.status != TodayReminderStatus.handled;
    }).length;
    if (unhandledCount == 0) {
      return [
        const TodayDashboardSection(
          type: TodayDashboardSectionType.clearForToday,
        ),
        ...sections,
      ];
    }

    return sections;
  }

  TodayDashboardSection _sectionFor(
    TodayDashboardSectionType type,
    List<TodayReminderItem> items,
  ) {
    final status = switch (type) {
      TodayDashboardSectionType.dueNow => TodayReminderStatus.dueNow,
      TodayDashboardSectionType.upcoming => TodayReminderStatus.upcoming,
      TodayDashboardSectionType.missed => TodayReminderStatus.missed,
      TodayDashboardSectionType.handled => TodayReminderStatus.handled,
      _ => throw ArgumentError.value(type, 'type'),
    };
    final sectionItems =
        items.where((item) => item.status == status).toList(growable: false)
          ..sort(_compareItems);
    return TodayDashboardSection(type: type, items: sectionItems);
  }

  int _compareItems(TodayReminderItem a, TodayReminderItem b) {
    final timeComparison = a.reminderTime.compareTo(b.reminderTime);
    if (timeComparison != 0) return timeComparison;
    return a.medicationName.compareTo(b.medicationName);
  }

  DailyReminderHandling? _findHandling(
    List<DailyReminderHandling> handlingRecords, {
    required DateTime localDate,
    required ReminderSchedule schedule,
    required Medication medication,
    required ReminderTime reminderTime,
  }) {
    final id = DailyReminderHandling.buildId(
      localDate: localDate,
      scheduleId: schedule.id,
      medicationId: medication.id,
      reminderTime: reminderTime,
    );
    for (final record in handlingRecords) {
      if (record.id == id) return record;
    }
    return null;
  }

  TodayReminderStatus _statusFor({
    required DateTime now,
    required DateTime scheduledDateTime,
    required DailyReminderHandling? handling,
  }) {
    if (handling != null) return TodayReminderStatus.handled;
    if (now.isBefore(scheduledDateTime)) return TodayReminderStatus.upcoming;
    if (!now.isAfter(scheduledDateTime.add(const Duration(minutes: 60)))) {
      return TodayReminderStatus.dueNow;
    }
    return TodayReminderStatus.missed;
  }

  bool _scheduleAppliesOn(ReminderSchedule schedule, DateTime localDate) {
    final endDate = schedule.endDate;
    if (endDate == null) return true;
    return !_dateOnly(endDate).isBefore(localDate);
  }

  DateTime? _nextRefreshAt(DateTime now, List<TodayDashboardSection> sections) {
    final candidates = <DateTime>[DateTime(now.year, now.month, now.day + 1)];
    for (final section in sections) {
      for (final item in section.items) {
        if (item.status == TodayReminderStatus.upcoming) {
          candidates.add(item.scheduledDateTime);
        } else if (item.status == TodayReminderStatus.dueNow) {
          candidates.add(
            item.scheduledDateTime.add(const Duration(minutes: 61)),
          );
        }
      }
    }
    candidates.removeWhere((candidate) => !candidate.isAfter(now));
    candidates.sort();
    return candidates.isEmpty ? null : candidates.first;
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}
