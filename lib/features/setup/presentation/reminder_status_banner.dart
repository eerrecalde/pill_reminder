import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../services/notification_permission_service.dart';
import '../../../theme/app_theme.dart';
import '../domain/notification_permission_status.dart';

class ReminderStatusBanner extends StatelessWidget {
  const ReminderStatusBanner({
    required this.status,
    required this.notificationPermissionService,
    required this.onStatusChanged,
    super.key,
  });

  final SetupNotificationPermissionStatus status;
  final NotificationPermissionService notificationPermissionService;
  final ValueChanged<SetupNotificationPermissionStatus> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    if (!status.needsMainAppStatus) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context);
    return Semantics(
      container: true,
      label:
          '${l10n.remindersUnavailableTitle}. ${l10n.remindersUnavailableBody}',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.setupAccent.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.setupSecondary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications_off_outlined),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.remindersUnavailableTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.remindersUnavailableBody,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                await notificationPermissionService.openNotificationSettings();
                final latest = await notificationPermissionService
                    .checkStatus();
                onStatusChanged(latest);
              },
              icon: const Icon(Icons.settings_outlined),
              label: Text(l10n.openSettings),
            ),
          ],
        ),
      ),
    );
  }
}
