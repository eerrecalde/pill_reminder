import 'package:pill_reminder/features/setup/data/setup_preferences_repository.dart';
import 'package:pill_reminder/features/setup/domain/notification_permission_status.dart';
import 'package:pill_reminder/features/setup/domain/setup_language.dart';
import 'package:pill_reminder/features/setup/domain/setup_state.dart';

class FakeSetupPreferencesRepository implements SetupPreferencesRepository {
  FakeSetupPreferencesRepository([SetupState? initialState])
    : _state = initialState ?? SetupState.initial();

  SetupState _state;

  @override
  Future<SetupState> load() async => _state;

  @override
  Future<void> saveLanguage(SetupLanguage language) async {
    _state = _state.copyWith(
      language: language,
      currentStep: SetupStep.privacy,
      createdAt: _state.createdAt ?? DateTime(2026, 4, 29),
      updatedAt: DateTime(2026, 4, 29),
    );
  }

  @override
  Future<void> savePrivacyAcknowledged() async {
    _state = _state.copyWith(
      privacyAcknowledged: true,
      currentStep: SetupStep.notifications,
      updatedAt: DateTime(2026, 4, 29),
    );
  }

  @override
  Future<void> saveNotificationStatus(
    SetupNotificationPermissionStatus status,
  ) async {
    _state = _state.copyWith(
      notificationStatus: status,
      updatedAt: DateTime(2026, 4, 29),
    );
  }

  @override
  Future<void> markComplete() async {
    _state = _state.copyWith(
      isComplete: true,
      currentStep: SetupStep.complete,
      updatedAt: DateTime(2026, 4, 29),
    );
  }

  @override
  Future<void> reset() async {
    _state = SetupState.initial();
  }
}
