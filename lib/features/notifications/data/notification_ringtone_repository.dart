import '../domain/notification_ringtone.dart';

const notificationRingtonePreferenceKey = 'notification_ringtone_id';

abstract class NotificationRingtoneRepository {
  List<RingtoneOption> get options;

  RingtoneOption get defaultOption;

  RingtoneOption? optionById(String id);

  Future<NotificationRingtonePreference> loadPreference();

  Future<void> saveRingtone(RingtoneOption option);

  Future<void> clearPreference();
}
