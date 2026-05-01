import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/medications/domain/medication.dart';
import 'package:pill_reminder/features/medications/domain/reminder_schedule.dart';
import 'package:pill_reminder/features/medications/domain/today_dashboard.dart';
import 'package:pill_reminder/features/medications/domain/today_dashboard_service.dart';

import 'fakes/fake_daily_reminder_handling_repository.dart';
import 'fakes/fake_medication_repository.dart';
import 'fakes/fake_reminder_schedule_repository.dart';
import 'reminder_schedule_test_fixtures.dart';
import 'today_dashboard_test_fixtures.dart';

void main() {
  test('derives grouped statuses and stable ordering for today', () async {
    final now = todayDashboardNow(hour: 9, minute: 30);
    final service = TodayDashboardService(
      medicationRepository: FakeMedicationRepository([
        todayMedicationFixture(id: 'med-1', name: 'Beta'),
        todayMedicationFixture(id: 'med-2', name: 'Alpha'),
        todayMedicationFixture(id: 'med-3', name: 'Gamma'),
      ]),
      reminderScheduleRepository: FakeReminderScheduleRepository([
        todayScheduleFixture(
          id: 'schedule-1',
          medicationId: 'med-1',
          reminderTimes: [
            reminderTimeFixture(hour: 8),
            reminderTimeFixture(hour: 9),
            reminderTimeFixture(hour: 12),
          ],
        ),
        todayScheduleFixture(
          id: 'schedule-2',
          medicationId: 'med-2',
          reminderTimes: [reminderTimeFixture(hour: 9)],
        ),
        todayScheduleFixture(
          id: 'schedule-3',
          medicationId: 'med-3',
          reminderTimes: [reminderTimeFixture(hour: 7)],
        ),
      ]),
      handlingRepository: FakeDailyReminderHandlingRepository([
        todayHandlingFixture(
          scheduleId: 'schedule-1',
          medicationId: 'med-1',
          reminderTime: reminderTimeFixture(hour: 8),
        ),
      ]),
      clock: () => now,
    );

    final snapshot = await service.loadSnapshot();

    expect(snapshot.sections.map((section) => section.type), [
      TodayDashboardSectionType.dueNow,
      TodayDashboardSectionType.upcoming,
      TodayDashboardSectionType.missed,
      TodayDashboardSectionType.handled,
    ]);
    expect(
      snapshot.sections
          .firstWhere(
            (section) => section.type == TodayDashboardSectionType.dueNow,
          )
          .items
          .map((item) => item.medicationName),
      ['Alpha', 'Beta'],
    );
    expect(
      snapshot.sections
          .firstWhere(
            (section) => section.type == TodayDashboardSectionType.upcoming,
          )
          .items
          .single
          .scheduledDateTime,
      DateTime(2026, 5, 1, 12),
    );
    expect(
      snapshot.sections
          .firstWhere(
            (section) => section.type == TodayDashboardSectionType.missed,
          )
          .items
          .single
          .medicationName,
      'Gamma',
    );
    expect(
      snapshot.sections
          .firstWhere(
            (section) => section.type == TodayDashboardSectionType.handled,
          )
          .items
          .single
          .status,
      TodayReminderStatus.handled,
    );
    expect(snapshot.nextRefreshAt, DateTime(2026, 5, 1, 10, 1));
  });

  test(
    'filters inactive medications and schedules ended before today',
    () async {
      final service = TodayDashboardService(
        medicationRepository: FakeMedicationRepository([
          todayMedicationFixture(id: 'med-1'),
          todayMedicationFixture(
            id: 'med-2',
            status: MedicationStatus.inactive,
          ),
        ]),
        reminderScheduleRepository: FakeReminderScheduleRepository([
          todayScheduleFixture(
            medicationId: 'med-1',
            endDate: DateTime(2026, 4, 30),
          ),
          todayScheduleFixture(medicationId: 'med-2'),
        ]),
        handlingRepository: FakeDailyReminderHandlingRepository(),
        clock: () => todayDashboardNow(),
      );

      final snapshot = await service.loadSnapshot();

      expect(
        snapshot.sections.single.type,
        TodayDashboardSectionType.noSchedules,
      );
    },
  );

  test('selects empty and clear-day sections', () async {
    Future<TodayDashboardSectionType> sectionFor({
      required List<Medication> medications,
      List<ReminderSchedule> schedules = const [],
      List<Object> handled = const [],
    }) async {
      final handlingRecords = handled
          .whereType<ReminderTime>()
          .map(
            (time) => todayHandlingFixture(
              reminderTime: time,
              handledAt: DateTime(2026, 5, 1, time.hour, time.minute + 1),
            ),
          )
          .toList(growable: false);
      final service = TodayDashboardService(
        medicationRepository: FakeMedicationRepository(medications),
        reminderScheduleRepository: FakeReminderScheduleRepository(schedules),
        handlingRepository: FakeDailyReminderHandlingRepository(
          handlingRecords,
        ),
        clock: () => todayDashboardNow(hour: 14),
      );
      final snapshot = await service.loadSnapshot();
      return snapshot.sections.first.type;
    }

    expect(
      await sectionFor(medications: const []),
      TodayDashboardSectionType.noMedications,
    );
    expect(
      await sectionFor(
        medications: [
          todayMedicationFixture(status: MedicationStatus.inactive),
        ],
      ),
      TodayDashboardSectionType.noActiveMedications,
    );
    expect(
      await sectionFor(medications: [todayMedicationFixture()]),
      TodayDashboardSectionType.noSchedules,
    );
    expect(
      await sectionFor(
        medications: [todayMedicationFixture()],
        schedules: [
          todayScheduleFixture(reminderTimes: [reminderTimeFixture(hour: 8)]),
        ],
        handled: [reminderTimeFixture(hour: 8)],
      ),
      TodayDashboardSectionType.clearForToday,
    );
  });
}
