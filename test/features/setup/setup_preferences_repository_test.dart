import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/setup/data/local_setup_preferences_repository.dart';
import 'package:pill_reminder/features/setup/domain/notification_permission_status.dart';
import 'package:pill_reminder/features/setup/domain/setup_language.dart';
import 'package:pill_reminder/features/setup/domain/setup_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalSetupPreferencesRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    repository = LocalSetupPreferencesRepository(preferences);
  });

  test(
    'persists setup completion, current step, and selected language',
    () async {
      await repository.saveLanguage(SetupLanguage.spanishLatinAmerica);
      await repository.savePrivacyAcknowledged();
      await repository.saveNotificationStatus(
        SetupNotificationPermissionStatus.skipped,
      );
      await repository.markComplete();

      final state = await repository.load();

      expect(state.isComplete, isTrue);
      expect(state.currentStep, SetupStep.complete);
      expect(state.language, SetupLanguage.spanishLatinAmerica);
      expect(state.privacyAcknowledged, isTrue);
      expect(
        state.notificationStatus,
        SetupNotificationPermissionStatus.skipped,
      );
    },
  );

  test('persists privacy acknowledgement before setup completion', () async {
    await repository.saveLanguage(SetupLanguage.english);
    await repository.savePrivacyAcknowledged();

    final state = await repository.load();

    expect(state.privacyAcknowledged, isTrue);
    expect(state.currentStep, SetupStep.notifications);
  });

  test('does not mark setup complete before privacy acknowledgement', () async {
    await repository.saveLanguage(SetupLanguage.english);

    expect(repository.markComplete, throwsStateError);
  });

  test(
    'persists notification status and derived main app status behavior',
    () async {
      await repository.saveNotificationStatus(
        SetupNotificationPermissionStatus.denied,
      );

      final state = await repository.load();

      expect(
        state.notificationStatus,
        SetupNotificationPermissionStatus.denied,
      );
      expect(state.notificationStatus.needsMainAppStatus, isTrue);
      expect(
        SetupNotificationPermissionStatus.granted.needsMainAppStatus,
        isFalse,
      );
    },
  );
}
