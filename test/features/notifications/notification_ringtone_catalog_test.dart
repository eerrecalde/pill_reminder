import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/notifications/domain/notification_ringtone_catalog.dart';

void main() {
  test('catalog has one valid default and stable custom sound metadata', () {
    expect(validateNotificationRingtoneCatalog(), isEmpty);
    expect(defaultNotificationRingtone().id, defaultRingtoneId);

    final ids = bundledNotificationRingtones.map((option) => option.id);
    expect(ids, containsAll(['default', 'gentle_chime', 'bright_bell']));
    expect(ids.every((id) => RegExp(r'^[a-z0-9_]+$').hasMatch(id)), isTrue);

    for (final option in bundledNotificationRingtones.where(
      (option) => !option.isDefault,
    )) {
      expect(
        option.previewAssetPath,
        startsWith('assets/audio/notifications/'),
      );
      expect(option.androidRawResourceName, isNotEmpty);
      expect(option.iosSoundFileName, endsWith('.wav'));
    }
  });
}
