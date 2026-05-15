import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/notifications/data/local_notification_ringtone_repository.dart';
import 'package:pill_reminder/features/notifications/data/notification_ringtone_repository.dart';
import 'package:pill_reminder/features/notifications/domain/notification_ringtone.dart';
import 'package:pill_reminder/features/notifications/domain/notification_ringtone_catalog.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences preferences;
  late LocalNotificationRingtoneRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
    repository = LocalNotificationRingtoneRepository(preferences);
  });

  test('loads missing preference as default', () async {
    final preference = await repository.loadPreference();

    expect(preference.resolvedRingtoneId, defaultRingtoneId);
    expect(preference.resolvedOption.isDefault, isTrue);
    expect(preference.unavailableSavedRingtoneId, isNull);
  });

  test('saves an available ringtone and persists its stable id', () async {
    final option = repository.optionById('gentle_chime')!;

    await repository.saveRingtone(option);

    expect(preferences.getString(notificationRingtonePreferenceKey), option.id);
    expect((await repository.loadPreference()).resolvedRingtoneId, option.id);
  });

  test('saving default clears the stored preference', () async {
    await repository.saveRingtone(repository.optionById('gentle_chime')!);

    await repository.saveRingtone(repository.defaultOption);

    expect(preferences.getString(notificationRingtonePreferenceKey), isNull);
    expect((await repository.loadPreference()).resolvedRingtoneId, 'default');
  });

  test(
    'resolves unknown saved id to default and exposes unavailable warning',
    () async {
      await preferences.setString(
        notificationRingtonePreferenceKey,
        'removed_sound',
      );

      final preference = await repository.loadPreference();

      expect(preference.resolvedRingtoneId, defaultRingtoneId);
      expect(preference.unavailableSavedRingtoneId, 'removed_sound');
    },
  );

  test(
    'resolves unavailable saved option to default and clears warning after save',
    () async {
      final unavailableOption = const RingtoneOption(
        id: 'old_chime',
        displayNameKey: 'notificationRingtoneGentleChime',
        previewAssetPath: 'assets/audio/notifications/gentle_chime.wav',
        androidRawResourceName: 'gentle_chime',
        iosSoundFileName: 'gentle_chime.wav',
        isDefault: false,
        isAvailable: false,
      );
      repository = LocalNotificationRingtoneRepository(
        preferences,
        options: [...bundledNotificationRingtones, unavailableOption],
      );
      await preferences.setString(
        notificationRingtonePreferenceKey,
        'old_chime',
      );

      final warningPreference = await repository.loadPreference();

      expect(warningPreference.resolvedRingtoneId, defaultRingtoneId);
      expect(warningPreference.unavailableSavedRingtoneId, 'old_chime');

      await repository.saveRingtone(repository.optionById('bright_bell')!);
      final updated = await repository.loadPreference();

      expect(updated.resolvedRingtoneId, 'bright_bell');
      expect(updated.unavailableSavedRingtoneId, isNull);
    },
  );

  test('rejects unavailable save targets', () {
    const unavailableOption = RingtoneOption(
      id: 'old_chime',
      displayNameKey: 'notificationRingtoneGentleChime',
      previewAssetPath: 'assets/audio/notifications/gentle_chime.wav',
      androidRawResourceName: 'gentle_chime',
      iosSoundFileName: 'gentle_chime.wav',
      isDefault: false,
      isAvailable: false,
    );

    expect(
      repository.saveRingtone(unavailableOption),
      throwsA(isA<NotificationRingtoneValidationException>()),
    );
  });
}
