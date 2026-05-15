import 'dart:async';

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../services/notification_permission_service.dart';
import '../../notifications/data/local_notification_ringtone_repository.dart';
import '../../notifications/data/notification_ringtone_repository.dart';
import '../../notifications/domain/notification_ringtone.dart';
import '../../notifications/services/ringtone_preview_player.dart';
import '../../setup/data/setup_preferences_repository.dart';
import '../../setup/domain/notification_permission_status.dart';
import '../../setup/domain/setup_language.dart';
import '../../setup/domain/setup_state.dart';
import '../domain/deletion_recovery_window.dart';
import '../domain/reminder_data_control_service.dart';
import 'data_deletion_confirmation_dialog.dart';
import 'notification_ringtone_picker_screen.dart';
import 'settings_section.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    required this.repository,
    required this.notificationPermissionService,
    required this.dataControlService,
    required this.initialState,
    required this.onLocaleChanged,
    required this.onStateChanged,
    this.ringtoneRepository = const DefaultNotificationRingtoneRepository(),
    this.ringtonePreviewPlayer,
    super.key,
  });

  final SetupPreferencesRepository repository;
  final NotificationPermissionService notificationPermissionService;
  final ReminderDataControlService dataControlService;
  final SetupState initialState;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<SetupState> onStateChanged;
  final NotificationRingtoneRepository ringtoneRepository;
  final RingtonePreviewPlayer? ringtonePreviewPlayer;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SetupState _state = widget.initialState;
  bool _checkingNotifications = false;
  bool _hasLocalData = false;
  bool _loadingLocalData = true;
  bool _busyWithLocalData = false;
  DeletionRecoveryWindow? _recoveryWindow;
  Timer? _recoveryTimer;
  NotificationRingtonePreference? _ringtonePreference;
  bool _loadingRingtonePreference = true;

  @override
  void initState() {
    super.initState();
    _refreshNotificationStatus();
    _refreshLocalDataState();
    _loadRingtonePreference();
  }

  @override
  void dispose() {
    _recoveryTimer?.cancel();
    super.dispose();
  }

  Future<void> _changeLanguage(SetupLanguage? language) async {
    if (language == null || language == _state.language) return;
    await widget.repository.saveLanguage(language);
    await widget.repository.markComplete();
    final state = await widget.repository.load();
    if (!mounted) return;
    widget.onLocaleChanged(language.locale);
    widget.onStateChanged(state);
    setState(() => _state = state);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).settingsLanguageSaved),
      ),
    );
  }

  Future<void> _refreshNotificationStatus() async {
    setState(() => _checkingNotifications = true);
    final status = await widget.notificationPermissionService.checkStatus();
    await widget.repository.saveNotificationStatus(status);
    final state = await widget.repository.load();
    if (!mounted) return;
    widget.onStateChanged(state);
    setState(() {
      _state = state;
      _checkingNotifications = false;
    });
  }

  Future<void> _openNotificationSettings() async {
    await widget.notificationPermissionService.openNotificationSettings();
  }

  Future<void> _loadRingtonePreference() async {
    final preference = await widget.ringtoneRepository.loadPreference();
    if (!mounted) return;
    setState(() {
      _ringtonePreference = preference;
      _loadingRingtonePreference = false;
    });
  }

  Future<void> _openRingtonePicker() async {
    final preference =
        _ringtonePreference ?? await widget.ringtoneRepository.loadPreference();
    if (!mounted) return;
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => NotificationRingtonePickerScreen(
          repository: widget.ringtoneRepository,
          initialPreference: preference,
          previewPlayer: widget.ringtonePreviewPlayer,
        ),
      ),
    );
    await _loadRingtonePreference();
    if (!mounted || saved != true) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).notificationRingtoneSaved),
      ),
    );
  }

  Future<void> _refreshLocalDataState() async {
    final hasData = await widget.dataControlService.hasLocalReminderData();
    if (!mounted) return;
    setState(() {
      _hasLocalData = hasData;
      _loadingLocalData = false;
      _recoveryWindow = widget.dataControlService.expireRecoveryWindow();
    });
  }

  Future<void> _confirmDeleteLocalData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const DataDeletionConfirmationDialog(),
    );
    if (confirmed != true) return;
    await _deleteLocalData();
  }

  Future<void> _deleteLocalData() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busyWithLocalData = true);
    try {
      final window = await widget.dataControlService.deleteLocalReminderData();
      if (!mounted) return;
      setState(() {
        _recoveryWindow = window;
        _hasLocalData = false;
      });
      _scheduleRecoveryExpiry(window);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.settingsDataDeleted),
          action: window.state == DeletionRecoveryWindowState.active
              ? SnackBarAction(
                  label: l10n.settingsUndoDeleteAction,
                  onPressed: _restoreLocalData,
                )
              : null,
        ),
      );
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.settingsDeleteFailed)));
    } finally {
      if (mounted) {
        setState(() => _busyWithLocalData = false);
        await _refreshLocalDataState();
      }
    }
  }

  Future<void> _restoreLocalData() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busyWithLocalData = true);
    try {
      final window = await widget.dataControlService.restoreLocalReminderData();
      if (!mounted) return;
      setState(() {
        _recoveryWindow = window;
        _hasLocalData = true;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.settingsDataRestored)));
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.settingsRestoreFailed)));
    } finally {
      if (mounted) setState(() => _busyWithLocalData = false);
    }
  }

  void _scheduleRecoveryExpiry(DeletionRecoveryWindow window) {
    _recoveryTimer?.cancel();
    if (window.state != DeletionRecoveryWindowState.active) return;
    final delay = window.expiresAt.difference(DateTime.now());
    _recoveryTimer = Timer(delay.isNegative ? Duration.zero : delay, () {
      if (!mounted) return;
      final expired = widget.dataControlService.expireRecoveryWindow();
      setState(() => _recoveryWindow = expired);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                SettingsSection(
                  title: l10n.settingsLanguageTitle,
                  subtitle: l10n.settingsLanguageDescription,
                  icon: Icons.language_outlined,
                  children: [_buildLanguageControl(l10n)],
                ),
                SettingsSection(
                  title: l10n.settingsAccessibilityTitle,
                  subtitle: l10n.settingsAccessibilityDescription,
                  icon: Icons.accessibility_new_outlined,
                  children: [Text(l10n.settingsAccessibilityDeviceSupport)],
                ),
                SettingsSection(
                  title: l10n.settingsNotificationsTitle,
                  subtitle: l10n.settingsNotificationsDescription,
                  icon: Icons.notifications_none_outlined,
                  children: [
                    _buildNotificationStatus(l10n),
                    const SizedBox(height: 16),
                    _buildNotificationSound(l10n),
                  ],
                ),
                SettingsSection(
                  title: l10n.settingsPrivacyTitle,
                  subtitle: l10n.settingsPrivacyDescription,
                  icon: Icons.privacy_tip_outlined,
                  children: [
                    Text(l10n.settingsPrivacyLocalOnly),
                    const SizedBox(height: 8),
                    Text(l10n.settingsPrivacyNoAccounts),
                  ],
                ),
                SettingsSection(
                  title: l10n.settingsLocalDataTitle,
                  subtitle: l10n.settingsLocalDataDescription,
                  icon: Icons.delete_outline,
                  children: [_buildLocalDataControls(l10n)],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageControl(AppLocalizations l10n) {
    return Semantics(
      label: l10n.settingsLanguageSemantics,
      child: SegmentedButton<SetupLanguage>(
        segments: [
          ButtonSegment(
            value: SetupLanguage.english,
            label: Text(l10n.english),
          ),
          ButtonSegment(
            value: SetupLanguage.spanishLatinAmerica,
            label: Text(l10n.spanishLatinAmerica),
          ),
        ],
        selected: {_state.language},
        onSelectionChanged: (selection) => _changeLanguage(selection.first),
      ),
    );
  }

  Widget _buildNotificationStatus(AppLocalizations l10n) {
    final statusText = switch (_state.notificationStatus) {
      SetupNotificationPermissionStatus.granted =>
        l10n.settingsNotificationAllowed,
      SetupNotificationPermissionStatus.blocked =>
        l10n.settingsNotificationBlocked,
      SetupNotificationPermissionStatus.unavailable =>
        l10n.settingsNotificationUnavailable,
      SetupNotificationPermissionStatus.unknown ||
      SetupNotificationPermissionStatus.skipped ||
      SetupNotificationPermissionStatus.denied =>
        l10n.settingsNotificationDenied,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          liveRegion: true,
          child: Text(statusText, style: Theme.of(context).textTheme.bodyLarge),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            OutlinedButton.icon(
              onPressed: _checkingNotifications
                  ? null
                  : _refreshNotificationStatus,
              icon: _checkingNotifications
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh_outlined),
              label: Text(l10n.settingsNotificationRefresh),
            ),
            if (_state.notificationStatus !=
                SetupNotificationPermissionStatus.granted)
              TextButton.icon(
                onPressed: _openNotificationSettings,
                icon: const Icon(Icons.settings_outlined),
                label: Text(l10n.settingsNotificationOpenDeviceSettings),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationSound(AppLocalizations l10n) {
    if (_loadingRingtonePreference) {
      return const LinearProgressIndicator(minHeight: 2);
    }

    final preference = _ringtonePreference;
    final soundName = preference == null
        ? localizedRingtoneName(l10n, widget.ringtoneRepository.defaultOption)
        : localizedRingtoneName(l10n, preference.resolvedOption);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settingsNotificationSoundTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(l10n.settingsNotificationSoundDescription),
        const SizedBox(height: 8),
        Text(l10n.settingsNotificationSoundCurrent(soundName)),
        const SizedBox(height: 8),
        Text(l10n.settingsNotificationSoundDeviceLimits),
        if (preference?.hasUnavailableSavedRingtone ?? false) ...[
          const SizedBox(height: 12),
          Semantics(
            liveRegion: true,
            child: Text(
              l10n.settingsNotificationSoundUnavailable,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _openRingtonePicker,
          icon: const Icon(Icons.music_note_outlined),
          label: Text(l10n.settingsNotificationSoundChoose),
        ),
      ],
    );
  }

  Widget _buildLocalDataControls(AppLocalizations l10n) {
    if (_loadingLocalData) {
      return const LinearProgressIndicator(minHeight: 2);
    }

    final recoveryWindow = _recoveryWindow;
    final recoveryMessage = switch (recoveryWindow?.state) {
      DeletionRecoveryWindowState.active => l10n.settingsRecoveryAvailable,
      DeletionRecoveryWindowState.expired => l10n.settingsRecoveryExpired,
      DeletionRecoveryWindowState.restored => l10n.settingsDataRestored,
      DeletionRecoveryWindowState.failed => l10n.settingsRestoreFailed,
      null => null,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _hasLocalData
              ? l10n.settingsLocalDataFound
              : l10n.settingsNoLocalData,
        ),
        if (recoveryMessage != null) ...[
          const SizedBox(height: 12),
          Semantics(liveRegion: true, child: Text(recoveryMessage)),
        ],
        const SizedBox(height: 16),
        if (_hasLocalData)
          FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
            ),
            onPressed: _busyWithLocalData ? null : _confirmDeleteLocalData,
            icon: const Icon(Icons.delete_outline),
            label: Text(l10n.settingsDeleteLocalDataAction),
          )
        else if (recoveryWindow?.state == DeletionRecoveryWindowState.active)
          OutlinedButton.icon(
            onPressed: _busyWithLocalData ? null : _restoreLocalData,
            icon: const Icon(Icons.undo_outlined),
            label: Text(l10n.settingsUndoDeleteAction),
          ),
      ],
    );
  }
}
