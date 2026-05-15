import 'package:audioplayers/audioplayers.dart';

import '../domain/notification_ringtone.dart';

abstract class RingtonePreviewPlayer {
  Future<void> preview(RingtoneOption option);

  Future<void> stop();

  Future<void> dispose();
}

class AssetRingtonePreviewPlayer implements RingtonePreviewPlayer {
  AssetRingtonePreviewPlayer({AudioPlayer? audioPlayer})
    : _audioPlayer = audioPlayer ?? AudioPlayer();

  final AudioPlayer _audioPlayer;

  @override
  Future<void> preview(RingtoneOption option) async {
    await stop();
    final assetPath = option.previewAssetPath;
    if (assetPath == null || !option.isAvailable) return;

    const prefix = 'assets/';
    final playerAssetPath = assetPath.startsWith(prefix)
        ? assetPath.substring(prefix.length)
        : assetPath;
    await _audioPlayer.play(AssetSource(playerAssetPath));
  }

  @override
  Future<void> stop() {
    return _audioPlayer.stop();
  }

  @override
  Future<void> dispose() {
    return _audioPlayer.dispose();
  }
}

class SilentRingtonePreviewPlayer implements RingtonePreviewPlayer {
  const SilentRingtonePreviewPlayer();

  @override
  Future<void> preview(RingtoneOption option) async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {}
}
