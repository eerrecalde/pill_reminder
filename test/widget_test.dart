import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/setup/domain/setup_language.dart';
import 'package:pill_reminder/features/setup/domain/setup_state.dart';
import 'package:pill_reminder/features/setup/domain/notification_permission_status.dart';
import 'package:pill_reminder/main.dart';

import 'features/medications/fakes/fake_medication_history_repository.dart';
import 'features/setup/fakes/fake_notification_permission_service.dart';
import 'features/setup/fakes/fake_setup_preferences_repository.dart';

void main() {
  testWidgets('app opens first-run setup on fresh install', (tester) async {
    await tester.pumpWidget(
      PillReminderApp(
        setupPreferencesRepository: FakeSetupPreferencesRepository(),
        notificationPermissionService: FakeNotificationPermissionService(
          requestResult: SetupNotificationPermissionStatus.granted,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Choose your language'), findsOneWidget);
  });

  testWidgets('main app opens medication history from the app bar', (
    tester,
  ) async {
    await tester.pumpWidget(
      PillReminderApp(
        setupPreferencesRepository: FakeSetupPreferencesRepository(
          SetupState(
            language: SetupLanguage.english,
            currentStep: SetupStep.complete,
            privacyAcknowledged: true,
            notificationStatus: SetupNotificationPermissionStatus.granted,
            isComplete: true,
          ),
        ),
        notificationPermissionService: FakeNotificationPermissionService(),
        medicationHistoryRepository: FakeMedicationHistoryRepository(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Medication history'));
    await tester.pumpAndSettle();

    expect(find.text('Medication history'), findsOneWidget);
    expect(find.text('No history yet'), findsOneWidget);
  });
}
