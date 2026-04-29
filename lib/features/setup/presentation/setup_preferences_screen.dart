import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../services/notification_permission_service.dart';
import '../data/setup_preferences_repository.dart';
import '../domain/notification_permission_status.dart';
import '../domain/setup_language.dart';
import '../domain/setup_state.dart';
import 'reminder_status_banner.dart';

class SetupPreferencesScreen extends StatefulWidget {
  const SetupPreferencesScreen({
    required this.repository,
    required this.notificationPermissionService,
    required this.initialState,
    required this.onLocaleChanged,
    required this.onStateChanged,
    super.key,
  });

  final SetupPreferencesRepository repository;
  final NotificationPermissionService notificationPermissionService;
  final SetupState initialState;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<SetupState> onStateChanged;

  @override
  State<SetupPreferencesScreen> createState() => _SetupPreferencesScreenState();
}

class _SetupPreferencesScreenState extends State<SetupPreferencesScreen> {
  late SetupState _state = widget.initialState;

  Future<void> _changeLanguage(SetupLanguage? language) async {
    if (language == null) return;
    await widget.repository.saveLanguage(language);
    await widget.repository.markComplete();
    final state = await widget.repository.load();
    if (!mounted) return;
    widget.onLocaleChanged(language.locale);
    widget.onStateChanged(state);
    setState(() => _state = state);
  }

  Future<void> _updateNotificationStatus(
    SetupNotificationPermissionStatus status,
  ) async {
    await widget.repository.saveNotificationStatus(status);
    final state = await widget.repository.load();
    if (!mounted) return;
    widget.onStateChanged(state);
    setState(() => _state = state);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.setupPreferences)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  l10n.languageSettingTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.changeLanguageHelp,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                SegmentedButton<SetupLanguage>(
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
                  onSelectionChanged: (selection) {
                    _changeLanguage(selection.first);
                  },
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.notificationSettingTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ReminderStatusBanner(
                  status: _state.notificationStatus,
                  notificationPermissionService:
                      widget.notificationPermissionService,
                  onStatusChanged: _updateNotificationStatus,
                ),
                if (!_state.notificationStatus.needsMainAppStatus)
                  Text(
                    l10n.notificationSettingGranted,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
