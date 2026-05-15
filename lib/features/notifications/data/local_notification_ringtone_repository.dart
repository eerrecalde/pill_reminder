import 'package:shared_preferences/shared_preferences.dart';

import '../domain/notification_ringtone.dart';
import '../domain/notification_ringtone_catalog.dart';
import 'notification_ringtone_repository.dart';

class LocalNotificationRingtoneRepository
    implements NotificationRingtoneRepository {
  LocalNotificationRingtoneRepository(
    this._preferences, {
    List<RingtoneOption> options = bundledNotificationRingtones,
    DateTime Function()? now,
  }) : _options = List.unmodifiable(options),
       _now = now ?? DateTime.now;

  final SharedPreferences _preferences;
  final List<RingtoneOption> _options;
  final DateTime Function() _now;

  @override
  List<RingtoneOption> get options => _options;

  @override
  RingtoneOption get defaultOption => defaultNotificationRingtone(_options);

  @override
  RingtoneOption? optionById(String id) =>
      notificationRingtoneById(id, _options);

  @override
  Future<NotificationRingtonePreference> loadPreference() async {
    final savedId = _preferences.getString(notificationRingtonePreferenceKey);
    final savedOption = savedId == null ? null : optionById(savedId);
    final resolvedOption = savedOption?.isAvailable == true
        ? savedOption!
        : defaultOption;

    return NotificationRingtonePreference(
      selectedRingtoneId: savedId,
      resolvedRingtoneId: resolvedOption.id,
      resolvedOption: resolvedOption,
      unavailableSavedRingtoneId:
          savedId != null && savedOption?.isAvailable != true ? savedId : null,
    );
  }

  @override
  Future<void> saveRingtone(RingtoneOption option) async {
    final catalogOption = optionById(option.id);
    if (catalogOption == null || !catalogOption.isAvailable) {
      throw NotificationRingtoneValidationException(
        'Only available bundled ringtone options can be saved.',
      );
    }

    if (catalogOption.isDefault) {
      await clearPreference();
      return;
    }

    await _preferences.setString(notificationRingtonePreferenceKey, option.id);
    _now();
  }

  @override
  Future<void> clearPreference() async {
    await _preferences.remove(notificationRingtonePreferenceKey);
    _now();
  }
}

class DefaultNotificationRingtoneRepository
    implements NotificationRingtoneRepository {
  const DefaultNotificationRingtoneRepository({
    List<RingtoneOption> options = bundledNotificationRingtones,
  }) : _options = options;

  final List<RingtoneOption> _options;

  @override
  List<RingtoneOption> get options => _options;

  @override
  RingtoneOption get defaultOption => defaultNotificationRingtone(_options);

  @override
  RingtoneOption? optionById(String id) =>
      notificationRingtoneById(id, _options);

  @override
  Future<NotificationRingtonePreference> loadPreference() async {
    final option = defaultOption;
    return NotificationRingtonePreference(
      selectedRingtoneId: null,
      resolvedRingtoneId: option.id,
      resolvedOption: option,
    );
  }

  @override
  Future<void> saveRingtone(RingtoneOption option) async {
    throw UnsupportedError('Default ringtone repository is read-only.');
  }

  @override
  Future<void> clearPreference() async {}
}
