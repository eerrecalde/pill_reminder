import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../data/medication_history_repository.dart';
import '../domain/medication_history.dart';
import '../domain/medication_history_service.dart';
import 'medication_history_day_section.dart';

class MedicationHistoryScreen extends StatefulWidget {
  const MedicationHistoryScreen({
    required this.repository,
    this.clock,
    super.key,
  });

  final MedicationHistoryRepository repository;
  final MedicationHistoryClock? clock;

  @override
  State<MedicationHistoryScreen> createState() =>
      _MedicationHistoryScreenState();
}

class _MedicationHistoryScreenState extends State<MedicationHistoryScreen> {
  late Future<List<MedicationHistoryDayGroup>> _groupsFuture;

  @override
  void initState() {
    super.initState();
    _groupsFuture = _loadGroups();
  }

  Future<List<MedicationHistoryDayGroup>> _loadGroups() {
    return MedicationHistoryService(
      repository: widget.repository,
      clock: widget.clock,
    ).loadDayGroups();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.medicationHistoryTitle)),
      body: SafeArea(
        child: FutureBuilder<List<MedicationHistoryDayGroup>>(
          future: _groupsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final groups = snapshot.data ?? const [];
            if (groups.isEmpty) {
              return _HistoryEmptyState(
                title: l10n.medicationHistoryEmptyTitle,
                body: l10n.medicationHistoryEmptyBody,
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                final groups = await _loadGroups();
                if (!mounted) return;
                setState(() => _groupsFuture = Future.value(groups));
              },
              child: ListView(
                key: const Key('medication-history-list'),
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    l10n.medicationHistoryIntro,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  for (final group in groups)
                    MedicationHistoryDaySection(group: group),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HistoryEmptyState extends StatelessWidget {
  const _HistoryEmptyState({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              body,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
