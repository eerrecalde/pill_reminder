import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';

class NotificationPermissionScreen extends StatelessWidget {
  const NotificationPermissionScreen({
    required this.onBack,
    required this.onEnable,
    required this.onSkip,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onEnable;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      tooltip: l10n.back,
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const SizedBox(height: 48),
                  const Icon(
                    Icons.notifications_active_outlined,
                    size: 120,
                    color: AppTheme.setupSecondary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.getReminderAlerts,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.notificationBody,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.setupMutedText,
                    ),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: onEnable,
                    child: Text(l10n.turnOnReminders),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(onPressed: onSkip, child: Text(l10n.notNow)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
