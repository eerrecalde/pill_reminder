import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/notifications/domain/notification_ringtone.dart';
import 'package:pill_reminder/features/notifications/domain/notification_ringtone_catalog.dart';
import 'package:pill_reminder/features/settings/presentation/notification_ringtone_picker_screen.dart';
import 'package:pill_reminder/l10n/app_localizations.dart';
import 'package:pill_reminder/theme/app_theme.dart';

import '../notifications/fakes/fake_notification_ringtone_repository.dart';
import '../notifications/fakes/fake_ringtone_preview_player.dart';

void main() {
  testWidgets('selects and saves a bundled ringtone', (tester) async {
    await _setLargeSurface(tester);
    final repository = FakeNotificationRingtoneRepository();
    await tester.pumpWidget(_Harness(repository: repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Gentle chime'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.widgetWithText(FilledButton, 'Save sound'),
      200,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Save sound'));
    await tester.pumpAndSettle();

    expect(repository.selectedRingtoneId, 'gentle_chime');
  });

  testWidgets(
    'previews without changing saved selection and stops on dismiss',
    (tester) async {
      await _setLargeSurface(tester);
      final repository = FakeNotificationRingtoneRepository();
      final previewPlayer = FakeRingtonePreviewPlayer();
      await tester.pumpWidget(
        _Harness(repository: repository, previewPlayer: previewPlayer),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Preview Gentle chime'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Preview Bright bell'));
      await tester.pumpAndSettle();

      expect(previewPlayer.previewedRingtoneIds, [
        'gentle_chime',
        'bright_bell',
      ]);
      expect(repository.selectedRingtoneId, isNull);

      await tester.tap(find.widgetWithText(OutlinedButton, 'Cancel'));
      await tester.pumpAndSettle();

      expect(previewPlayer.stopCount, greaterThanOrEqualTo(1));
      expect(previewPlayer.disposed, isTrue);
    },
  );

  testWidgets('shows unavailable warning and keeps unavailable option disabled', (
    tester,
  ) async {
    await _setLargeSurface(tester);
    const unavailableOption = RingtoneOption(
      id: 'old_chime',
      displayNameKey: 'notificationRingtoneGentleChime',
      previewAssetPath: 'assets/audio/notifications/gentle_chime.wav',
      androidRawResourceName: 'gentle_chime',
      iosSoundFileName: 'gentle_chime.wav',
      isDefault: false,
      isAvailable: false,
    );
    final repository = FakeNotificationRingtoneRepository(
      options: [...bundledNotificationRingtones, unavailableOption],
      selectedRingtoneId: 'old_chime',
    );

    await tester.pumpWidget(_Harness(repository: repository));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Your previous sound is unavailable. Choose another sound to clear this warning.',
      ),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(find.text('Unavailable'), 200);
    expect(find.text('Unavailable'), findsOneWidget);
    expect(find.byTooltip('Preview Gentle chime'), findsWidgets);
  });

  testWidgets('keeps selected state available to semantics and large text', (
    tester,
  ) async {
    await _setLargeSurface(tester);
    final repository = FakeNotificationRingtoneRepository(
      selectedRingtoneId: 'bright_bell',
    );

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.8)),
        child: _Harness(repository: repository),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bright bell'), findsOneWidget);
    expect(find.text('Selected'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _setLargeSurface(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(900, 1200));
  tester.view.devicePixelRatio = 1;
  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
    tester.view.resetDevicePixelRatio();
  });
}

class _Harness extends StatelessWidget {
  const _Harness({required this.repository, this.previewPlayer});

  final FakeNotificationRingtoneRepository repository;
  final FakeRingtonePreviewPlayer? previewPlayer;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: FutureBuilder(
        future: repository.loadPreference(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(body: CircularProgressIndicator());
          }
          return NotificationRingtonePickerScreen(
            repository: repository,
            initialPreference: snapshot.data!,
            previewPlayer: previewPlayer,
          );
        },
      ),
    );
  }
}
