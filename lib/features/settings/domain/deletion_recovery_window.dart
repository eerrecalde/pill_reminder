import 'local_reminder_data_snapshot.dart';

enum DeletionRecoveryWindowState { active, restored, expired, failed }

class DeletionRecoveryWindow {
  const DeletionRecoveryWindow({
    required this.snapshot,
    required this.startedAt,
    required this.expiresAt,
    this.state = DeletionRecoveryWindowState.active,
  });

  factory DeletionRecoveryWindow.start({
    required LocalReminderDataSnapshot snapshot,
    required DateTime startedAt,
  }) {
    return DeletionRecoveryWindow(
      snapshot: snapshot,
      startedAt: startedAt,
      expiresAt: startedAt.add(recoveryDuration),
    );
  }

  static const recoveryDuration = Duration(seconds: 30);

  final LocalReminderDataSnapshot snapshot;
  final DateTime startedAt;
  final DateTime expiresAt;
  final DeletionRecoveryWindowState state;

  bool isActiveAt(DateTime now) {
    return state == DeletionRecoveryWindowState.active &&
        now.isBefore(expiresAt);
  }

  DeletionRecoveryWindow markRestored() {
    return _copyWith(state: DeletionRecoveryWindowState.restored);
  }

  DeletionRecoveryWindow markExpired() {
    return _copyWith(state: DeletionRecoveryWindowState.expired);
  }

  DeletionRecoveryWindow markFailed() {
    return _copyWith(state: DeletionRecoveryWindowState.failed);
  }

  DeletionRecoveryWindow _copyWith({DeletionRecoveryWindowState? state}) {
    return DeletionRecoveryWindow(
      snapshot: snapshot,
      startedAt: startedAt,
      expiresAt: expiresAt,
      state: state ?? this.state,
    );
  }
}
