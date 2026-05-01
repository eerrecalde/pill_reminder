import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/today_dashboard.dart';
import 'today_reminder_card.dart';

class TodaySection extends StatelessWidget {
  const TodaySection({
    required this.section,
    required this.onMarkHandled,
    super.key,
  });

  final TodayDashboardSection section;
  final ValueChanged<TodayReminderItem> onMarkHandled;

  @override
  Widget build(BuildContext context) {
    final title = _titleFor(AppLocalizations.of(context), section.type);
    return Semantics(
      header: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          for (final item in section.items)
            TodayReminderCard(item: item, onMarkHandled: onMarkHandled),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  String _titleFor(AppLocalizations l10n, TodayDashboardSectionType type) {
    return switch (type) {
      TodayDashboardSectionType.dueNow => l10n.todayDueNowTitle,
      TodayDashboardSectionType.upcoming => l10n.todayUpcomingTitle,
      TodayDashboardSectionType.missed => l10n.todayMissedTitle,
      TodayDashboardSectionType.handled => l10n.todayHandledTitle,
      TodayDashboardSectionType.clearForToday => l10n.todayClearTitle,
      TodayDashboardSectionType.noMedications => l10n.todayNoMedicationsTitle,
      TodayDashboardSectionType.noActiveMedications =>
        l10n.todayNoActiveMedicationsTitle,
      TodayDashboardSectionType.noSchedules => l10n.todayNoSchedulesTitle,
    };
  }
}
