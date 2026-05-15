class RingtoneOption {
  const RingtoneOption({
    required this.id,
    required this.displayNameKey,
    this.previewAssetPath,
    this.androidRawResourceName,
    this.iosSoundFileName,
    required this.isDefault,
    this.isAvailable = true,
  });

  final String id;
  final String displayNameKey;
  final String? previewAssetPath;
  final String? androidRawResourceName;
  final String? iosSoundFileName;
  final bool isDefault;
  final bool isAvailable;

  bool get usesPlatformDefaultSound => isDefault;

  bool get hasCustomSoundAssets {
    return previewAssetPath != null &&
        androidRawResourceName != null &&
        iosSoundFileName != null;
  }
}

class NotificationRingtonePreference {
  const NotificationRingtonePreference({
    required this.selectedRingtoneId,
    required this.resolvedRingtoneId,
    required this.resolvedOption,
    this.unavailableSavedRingtoneId,
    this.updatedAt,
  });

  final String? selectedRingtoneId;
  final String resolvedRingtoneId;
  final RingtoneOption resolvedOption;
  final String? unavailableSavedRingtoneId;
  final DateTime? updatedAt;

  bool get hasUnavailableSavedRingtone => unavailableSavedRingtoneId != null;
}

class NotificationRingtoneValidationException implements Exception {
  const NotificationRingtoneValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}
