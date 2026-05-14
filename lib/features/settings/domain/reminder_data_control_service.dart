import 'deletion_recovery_window.dart';
import 'local_reminder_data_snapshot.dart';

abstract interface class ReminderDataControlService {
  DeletionRecoveryWindow? get recoveryWindow;

  Future<bool> hasLocalReminderData();

  Future<LocalReminderDataSnapshot> snapshot();

  Future<DeletionRecoveryWindow> deleteLocalReminderData();

  Future<DeletionRecoveryWindow> restoreLocalReminderData();

  DeletionRecoveryWindow? expireRecoveryWindow({DateTime? now});
}
