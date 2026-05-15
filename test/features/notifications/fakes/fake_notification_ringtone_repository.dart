import 'package:pill_reminder/features/notifications/data/notification_ringtone_repository.dart';
import 'package:pill_reminder/features/notifications/domain/notification_ringtone.dart';
import 'package:pill_reminder/features/notifications/domain/notification_ringtone_catalog.dart';

class FakeNotificationRingtoneRepository
    implements NotificationRingtoneRepository {
  FakeNotificationRingtoneRepository({
    List<RingtoneOption> options = bundledNotificationRingtones,
    this.selectedRingtoneId,
  }) : _options = List.unmodifiable(options);

  final List<RingtoneOption> _options;
  String? selectedRingtoneId;

  @override
  List<RingtoneOption> get options => _options;

  @override
  RingtoneOption get defaultOption => defaultNotificationRingtone(_options);

  @override
  RingtoneOption? optionById(String id) =>
      notificationRingtoneById(id, _options);

  @override
  Future<NotificationRingtonePreference> loadPreference() async {
    final savedId = selectedRingtoneId;
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
    selectedRingtoneId = catalogOption.isDefault ? null : catalogOption.id;
  }

  @override
  Future<void> clearPreference() async {
    selectedRingtoneId = null;
  }
}
