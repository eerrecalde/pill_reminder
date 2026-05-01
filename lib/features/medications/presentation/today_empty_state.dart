import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/today_dashboard.dart';

class TodayEmptyState extends StatelessWidget {
  const TodayEmptyState({
    required this.section,
    required this.onAddMedication,
    required this.onScheduleReminder,
    required this.onManageMedications,
    super.key,
  });

  final TodayDashboardSection section;
  final VoidCallback onAddMedication;
  final VoidCallback onScheduleReminder;
  final VoidCallback onManageMedications;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = _titleFor(l10n, section.type);
    final body = _bodyFor(l10n, section.type);
    final action = section.primaryAction;

    return Semantics(
      label: '$title. $body',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(body, style: Theme.of(context).textTheme.bodyLarge),
              if (action != null) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    key: _keyFor(section.type),
                    onPressed: _callbackFor(action),
                    icon: Icon(_iconFor(action)),
                    label: Text(_labelFor(l10n, action)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  VoidCallback _callbackFor(TodayDashboardAction action) {
    return switch (action) {
      TodayDashboardAction.addMedication => onAddMedication,
      TodayDashboardAction.scheduleReminder => onScheduleReminder,
      TodayDashboardAction.manageMedications => onManageMedications,
    };
  }

  IconData _iconFor(TodayDashboardAction action) {
    return switch (action) {
      TodayDashboardAction.addMedication => Icons.add,
      TodayDashboardAction.scheduleReminder => Icons.schedule,
      TodayDashboardAction.manageMedications => Icons.list_alt_outlined,
    };
  }

  String _labelFor(AppLocalizations l10n, TodayDashboardAction action) {
    return switch (action) {
      TodayDashboardAction.addMedication => l10n.addMedicationTitle,
      TodayDashboardAction.scheduleReminder => l10n.scheduleReminderTitle,
      TodayDashboardAction.manageMedications => l10n.todayManageMedications,
    };
  }

  Key _keyFor(TodayDashboardSectionType type) {
    if (type == TodayDashboardSectionType.noMedications) {
      return const Key('open-add-medication-button');
    }
    return Key('today-empty-action-${type.name}');
  }

  String _titleFor(AppLocalizations l10n, TodayDashboardSectionType type) {
    return switch (type) {
      TodayDashboardSectionType.clearForToday => l10n.todayClearTitle,
      TodayDashboardSectionType.noMedications => l10n.todayNoMedicationsTitle,
      TodayDashboardSectionType.noActiveMedications =>
        l10n.todayNoActiveMedicationsTitle,
      TodayDashboardSectionType.noSchedules => l10n.todayNoSchedulesTitle,
      _ => l10n.todayClearTitle,
    };
  }

  String _bodyFor(AppLocalizations l10n, TodayDashboardSectionType type) {
    return switch (type) {
      TodayDashboardSectionType.clearForToday => l10n.todayClearBody,
      TodayDashboardSectionType.noMedications => l10n.todayNoMedicationsBody,
      TodayDashboardSectionType.noActiveMedications =>
        l10n.todayNoActiveMedicationsBody,
      TodayDashboardSectionType.noSchedules => l10n.todayNoSchedulesBody,
      _ => l10n.todayClearBody,
    };
  }
}
