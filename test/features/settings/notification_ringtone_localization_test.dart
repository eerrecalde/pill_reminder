import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/l10n/app_localizations_en.dart';
import 'package:pill_reminder/l10n/app_localizations_es.dart';

void main() {
  test('English and Spanish ringtone localization keys are present', () {
    final en = AppLocalizationsEn();
    final es = AppLocalizationsEs();

    expect(en.notificationRingtonePickerTitle, isNotEmpty);
    expect(en.notificationRingtoneGentleChime, isNotEmpty);
    expect(en.notificationRingtonePillsInBox, 'Pills in a box');
    expect(
      en.notificationRingtonePreviewNamed('Gentle chime'),
      contains('Gentle'),
    );
    expect(
      en.settingsNotificationSoundDeviceLimits,
      contains('do-not-disturb'),
    );

    expect(es.notificationRingtonePickerTitle, isNotEmpty);
    expect(es.notificationRingtoneGentleChime, isNotEmpty);
    expect(es.notificationRingtonePillsInBox, 'Pastillas en una caja');
    expect(
      es.notificationRingtonePreviewNamed('Campana suave'),
      contains('Campana'),
    );
    expect(es.settingsNotificationSoundDeviceLimits, contains('no molestar'));
  });
}
