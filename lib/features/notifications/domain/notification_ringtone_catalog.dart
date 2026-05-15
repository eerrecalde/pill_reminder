import 'notification_ringtone.dart';

const defaultRingtoneId = 'default';

const bundledNotificationRingtones = <RingtoneOption>[
  RingtoneOption(
    id: defaultRingtoneId,
    displayNameKey: 'notificationRingtoneDefault',
    isDefault: true,
  ),
  RingtoneOption(
    id: 'gentle_chime',
    displayNameKey: 'notificationRingtoneGentleChime',
    previewAssetPath: 'assets/audio/notifications/gentle_chime.wav',
    androidRawResourceName: 'gentle_chime',
    iosSoundFileName: 'gentle_chime.wav',
    isDefault: false,
  ),
  RingtoneOption(
    id: 'bright_bell',
    displayNameKey: 'notificationRingtoneBrightBell',
    previewAssetPath: 'assets/audio/notifications/bright_bell.wav',
    androidRawResourceName: 'bright_bell',
    iosSoundFileName: 'bright_bell.wav',
    isDefault: false,
  ),
  RingtoneOption(
    id: 'soft_pulse',
    displayNameKey: 'notificationRingtoneSoftPulse',
    previewAssetPath: 'assets/audio/notifications/soft_pulse.wav',
    androidRawResourceName: 'soft_pulse',
    iosSoundFileName: 'soft_pulse.wav',
    isDefault: false,
  ),
  RingtoneOption(
    id: 'pills_in_box',
    displayNameKey: 'notificationRingtonePillsInBox',
    previewAssetPath: 'assets/audio/notifications/pills_in_box.wav',
    androidRawResourceName: 'pills_in_box',
    iosSoundFileName: 'pills_in_box.wav',
    isDefault: false,
  ),
];

RingtoneOption defaultNotificationRingtone([
  List<RingtoneOption> options = bundledNotificationRingtones,
]) {
  return options.singleWhere((option) => option.isDefault);
}

RingtoneOption? notificationRingtoneById(
  String id, [
  List<RingtoneOption> options = bundledNotificationRingtones,
]) {
  for (final option in options) {
    if (option.id == id) return option;
  }
  return null;
}

List<String> validateNotificationRingtoneCatalog([
  List<RingtoneOption> options = bundledNotificationRingtones,
]) {
  final errors = <String>[];
  final ids = <String>{};
  final idPattern = RegExp(r'^[a-z0-9_]+$');
  var defaultCount = 0;

  for (final option in options) {
    if (!ids.add(option.id)) {
      errors.add('Duplicate ringtone id: ${option.id}');
    }
    if (!idPattern.hasMatch(option.id)) {
      errors.add('Invalid ringtone id: ${option.id}');
    }
    if (option.isDefault) {
      defaultCount += 1;
    } else if (!option.hasCustomSoundAssets) {
      errors.add('Custom ringtone ${option.id} is missing sound assets.');
    }
    if (!option.isAvailable && option.isDefault) {
      errors.add('Default ringtone must be available.');
    }
  }

  if (defaultCount != 1) {
    errors.add('Catalog must contain exactly one default ringtone.');
  }

  return errors;
}
