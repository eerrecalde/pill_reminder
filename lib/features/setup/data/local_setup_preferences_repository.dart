import 'package:shared_preferences/shared_preferences.dart';

import '../domain/notification_permission_status.dart';
import '../domain/setup_language.dart';
import '../domain/setup_state.dart';
import 'setup_preferences_repository.dart';

class LocalSetupPreferencesRepository implements SetupPreferencesRepository {
  LocalSetupPreferencesRepository(this._preferences);

  static const _isCompleteKey = 'setup.isComplete';
  static const _currentStepKey = 'setup.currentStep';
  static const _languageKey = 'setup.language';
  static const _privacyAcknowledgedKey = 'setup.privacyAcknowledged';
  static const _notificationStatusKey = 'setup.notificationStatus';
  static const _createdAtKey = 'setup.createdAt';
  static const _updatedAtKey = 'setup.updatedAt';

  final SharedPreferences _preferences;

  @override
  Future<SetupState> load() async {
    final createdAtValue = _preferences.getString(_createdAtKey);
    final updatedAtValue = _preferences.getString(_updatedAtKey);

    return SetupState(
      isComplete: _preferences.getBool(_isCompleteKey) ?? false,
      currentStep: SetupStep.fromName(_preferences.getString(_currentStepKey)),
      language: SetupLanguage.fromLocaleCode(
        _preferences.getString(_languageKey),
      ),
      privacyAcknowledged:
          _preferences.getBool(_privacyAcknowledgedKey) ?? false,
      notificationStatus: SetupNotificationPermissionStatus.fromName(
        _preferences.getString(_notificationStatusKey),
      ),
      createdAt: createdAtValue == null
          ? null
          : DateTime.tryParse(createdAtValue),
      updatedAt: updatedAtValue == null
          ? null
          : DateTime.tryParse(updatedAtValue),
    );
  }

  @override
  Future<void> saveLanguage(SetupLanguage language) async {
    await _ensureCreatedAt();
    await _preferences.setString(_languageKey, language.localeCode);
    await _preferences.setString(_currentStepKey, SetupStep.privacy.name);
    await _touch();
  }

  @override
  Future<void> savePrivacyAcknowledged() async {
    await _ensureCreatedAt();
    await _preferences.setBool(_privacyAcknowledgedKey, true);
    await _preferences.setString(_currentStepKey, SetupStep.notifications.name);
    await _touch();
  }

  @override
  Future<void> saveNotificationStatus(
    SetupNotificationPermissionStatus status,
  ) async {
    await _ensureCreatedAt();
    await _preferences.setString(_notificationStatusKey, status.name);
    await _touch();
  }

  @override
  Future<void> markComplete() async {
    await _ensureCreatedAt();
    final state = await load();
    if (!state.privacyAcknowledged) {
      throw StateError('Privacy must be acknowledged before setup completes.');
    }
    await _preferences.setBool(_isCompleteKey, true);
    await _preferences.setString(_currentStepKey, SetupStep.complete.name);
    await _touch();
  }

  @override
  Future<void> reset() async {
    await Future.wait([
      _preferences.remove(_isCompleteKey),
      _preferences.remove(_currentStepKey),
      _preferences.remove(_languageKey),
      _preferences.remove(_privacyAcknowledgedKey),
      _preferences.remove(_notificationStatusKey),
      _preferences.remove(_createdAtKey),
      _preferences.remove(_updatedAtKey),
    ]);
  }

  Future<void> _ensureCreatedAt() async {
    if (!_preferences.containsKey(_createdAtKey)) {
      await _preferences.setString(
        _createdAtKey,
        DateTime.now().toIso8601String(),
      );
    }
  }

  Future<void> _touch() async {
    await _preferences.setString(
      _updatedAtKey,
      DateTime.now().toIso8601String(),
    );
  }
}
