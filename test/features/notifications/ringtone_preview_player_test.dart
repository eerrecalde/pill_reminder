import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/notifications/domain/notification_ringtone_catalog.dart';

import 'fakes/fake_ringtone_preview_player.dart';

void main() {
  test('fake preview player records play, stop, and dispose calls', () async {
    final player = FakeRingtonePreviewPlayer();
    final option = notificationRingtoneById('gentle_chime')!;

    await player.preview(option);
    await player.stop();
    await player.dispose();

    expect(player.previewedRingtoneIds, ['gentle_chime']);
    expect(player.stopCount, 1);
    expect(player.disposed, isTrue);
  });
}
