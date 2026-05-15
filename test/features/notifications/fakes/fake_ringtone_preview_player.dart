import 'package:pill_reminder/features/notifications/domain/notification_ringtone.dart';
import 'package:pill_reminder/features/notifications/services/ringtone_preview_player.dart';

class FakeRingtonePreviewPlayer implements RingtonePreviewPlayer {
  final List<String> previewedRingtoneIds = [];
  int stopCount = 0;
  bool disposed = false;

  @override
  Future<void> preview(RingtoneOption option) async {
    previewedRingtoneIds.add(option.id);
  }

  @override
  Future<void> stop() async {
    stopCount += 1;
  }

  @override
  Future<void> dispose() async {
    disposed = true;
  }
}
