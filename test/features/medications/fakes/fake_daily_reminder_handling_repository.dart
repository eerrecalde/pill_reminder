import 'package:pill_reminder/features/medications/data/daily_reminder_handling_repository.dart';
import 'package:pill_reminder/features/medications/domain/daily_reminder_handling.dart';
import 'package:pill_reminder/features/medications/domain/reminder_schedule.dart';

class FakeDailyReminderHandlingRepository
    implements DailyReminderHandlingRepository {
  FakeDailyReminderHandlingRepository([List<DailyReminderHandling>? records])
    : _records = [...?records];

  final List<DailyReminderHandling> _records;

  int markHandledCount = 0;

  @override
  Future<List<DailyReminderHandling>> loadForDate(DateTime localDate) async {
    return _records
        .where((record) => _isSameDate(record.localDate, localDate))
        .toList(growable: false);
  }

  @override
  Future<DailyReminderHandling> markHandled({
    required DateTime localDate,
    required String scheduleId,
    required String medicationId,
    required ReminderTime reminderTime,
    required DateTime handledAt,
  }) async {
    markHandledCount += 1;
    final record = DailyReminderHandling(
      id: DailyReminderHandling.buildId(
        localDate: localDate,
        scheduleId: scheduleId,
        medicationId: medicationId,
        reminderTime: reminderTime,
      ),
      localDate: DateTime(localDate.year, localDate.month, localDate.day),
      scheduleId: scheduleId,
      medicationId: medicationId,
      reminderTime: reminderTime,
      handledAt: handledAt,
    );
    _records.removeWhere((existing) => existing.id == record.id);
    _records.add(record);
    return record;
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
