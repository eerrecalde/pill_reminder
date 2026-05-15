import 'package:flutter/material.dart';

import '../../../features/notifications/data/notification_ringtone_repository.dart';
import '../../../features/notifications/domain/notification_ringtone.dart';
import '../../../features/notifications/services/ringtone_preview_player.dart';
import '../../../l10n/app_localizations.dart';

class NotificationRingtonePickerScreen extends StatefulWidget {
  const NotificationRingtonePickerScreen({
    required this.repository,
    required this.initialPreference,
    RingtonePreviewPlayer? previewPlayer,
    super.key,
  }) : previewPlayer = previewPlayer ?? const SilentRingtonePreviewPlayer();

  final NotificationRingtoneRepository repository;
  final NotificationRingtonePreference initialPreference;
  final RingtonePreviewPlayer previewPlayer;

  @override
  State<NotificationRingtonePickerScreen> createState() =>
      _NotificationRingtonePickerScreenState();
}

class _NotificationRingtonePickerScreenState
    extends State<NotificationRingtonePickerScreen> {
  late String _selectedRingtoneId = widget.initialPreference.resolvedRingtoneId;
  String? _previewingRingtoneId;
  bool _saving = false;

  @override
  void dispose() {
    widget.previewPlayer.stop();
    widget.previewPlayer.dispose();
    super.dispose();
  }

  Future<void> _preview(RingtoneOption option) async {
    if (!option.isAvailable) return;
    await widget.previewPlayer.preview(option);
    if (!mounted) return;
    setState(() => _previewingRingtoneId = option.id);
  }

  Future<void> _save() async {
    final option = widget.repository.optionById(_selectedRingtoneId);
    if (option == null || !option.isAvailable) return;
    setState(() => _saving = true);
    await widget.previewPlayer.stop();
    await widget.repository.saveRingtone(option);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final options = widget.repository.options;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationRingtonePickerTitle)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                if (widget.initialPreference.hasUnavailableSavedRingtone) ...[
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      l10n.notificationRingtoneUnavailableWarning,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(l10n.notificationRingtoneDeviceLimits),
                const SizedBox(height: 16),
                for (final option in options) _buildOptionTile(l10n, option),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: _saving
                          ? null
                          : () async {
                              await widget.previewPlayer.stop();
                              if (!context.mounted) return;
                              Navigator.of(context).pop(false);
                            },
                      child: Text(l10n.cancel),
                    ),
                    FilledButton.icon(
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check_outlined),
                      label: Text(l10n.notificationRingtoneSave),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(AppLocalizations l10n, RingtoneOption option) {
    final name = localizedRingtoneName(l10n, option);
    final selected = option.id == _selectedRingtoneId;
    final status = option.isAvailable
        ? selected
              ? l10n.notificationRingtoneSelected
              : option.id == widget.initialPreference.resolvedRingtoneId
              ? l10n.notificationRingtoneCurrent
              : ''
        : l10n.notificationRingtoneUnavailable;
    final semanticsStatus = status.isEmpty ? name : status;

    return Semantics(
      selected: selected,
      enabled: option.isAvailable,
      label: l10n.notificationRingtoneRowSemantics(name, semanticsStatus),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          minVerticalPadding: 12,
          leading: Icon(
            selected
                ? Icons.radio_button_checked_outlined
                : Icons.radio_button_unchecked_outlined,
          ),
          title: Text(name),
          subtitle: status.isEmpty ? null : Text(status),
          enabled: option.isAvailable,
          onTap: option.isAvailable
              ? () => setState(() => _selectedRingtoneId = option.id)
              : null,
          trailing: IconButton(
            tooltip: l10n.notificationRingtonePreviewNamed(name),
            onPressed: option.isAvailable ? () => _preview(option) : null,
            icon: Icon(
              _previewingRingtoneId == option.id
                  ? Icons.volume_up_outlined
                  : Icons.play_arrow_outlined,
            ),
          ),
        ),
      ),
    );
  }
}

String localizedRingtoneName(AppLocalizations l10n, RingtoneOption option) {
  return switch (option.displayNameKey) {
    'notificationRingtoneDefault' => l10n.notificationRingtoneDefault,
    'notificationRingtoneGentleChime' => l10n.notificationRingtoneGentleChime,
    'notificationRingtoneBrightBell' => l10n.notificationRingtoneBrightBell,
    'notificationRingtoneSoftPulse' => l10n.notificationRingtoneSoftPulse,
    'notificationRingtonePillsInBox' => l10n.notificationRingtonePillsInBox,
    _ => option.id,
  };
}
