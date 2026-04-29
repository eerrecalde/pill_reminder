import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/setup/domain/notification_permission_status.dart';
import 'package:pill_reminder/main.dart';

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
}
