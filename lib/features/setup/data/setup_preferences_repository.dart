import '../domain/notification_permission_status.dart';
import '../domain/setup_language.dart';
import '../domain/setup_state.dart';

abstract class SetupPreferencesRepository {
  Future<SetupState> load();

  Future<void> saveLanguage(SetupLanguage language);

  Future<void> savePrivacyAcknowledged();

  Future<void> saveNotificationStatus(SetupNotificationPermissionStatus status);

  Future<void> markComplete();

  Future<void> reset();
}
