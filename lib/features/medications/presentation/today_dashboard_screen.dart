import 'dart:async';

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../services/notification_permission_service.dart';
import '../../../services/reminder_notification_scheduler.dart';
import '../../setup/domain/notification_permission_status.dart';
import '../../setup/presentation/reminder_status_banner.dart';
import '../data/daily_reminder_handling_repository.dart';
import '../data/due_reminder_repository.dart';
import '../data/medication_repository.dart';
import '../data/reminder_schedule_repository.dart';
import '../domain/medication_reminder_operations.dart';
import '../domain/medication.dart';
import '../domain/today_dashboard.dart';
import '../domain/today_dashboard_service.dart';
import 'add_medication_screen.dart';
import 'medication_delete_confirmation_dialog.dart';
import 'medication_list_section.dart';
import 'today_empty_state.dart';
import 'today_section.dart';

class TodayDashboardScreen extends StatefulWidget {
  const TodayDashboardScreen({
    required this.medicationRepository,
    required this.reminderScheduleRepository,
    required this.dailyReminderHandlingRepository,
    required this.dueReminderRepository,
    required this.reminderNotificationScheduler,
    required this.notificationPermissionService,
    required this.notificationStatus,
    required this.onNotificationStatusChanged,
    required this.onAddMedication,
    required this.onScheduleReminder,
    required this.onManageMedications,
    this.clock,
    super.key,
  });

  final MedicationRepository medicationRepository;
  final ReminderScheduleRepository reminderScheduleRepository;
  final DailyReminderHandlingRepository dailyReminderHandlingRepository;
  final DueReminderRepository dueReminderRepository;
  final ReminderNotificationScheduler reminderNotificationScheduler;
  final NotificationPermissionService notificationPermissionService;
  final SetupNotificationPermissionStatus notificationStatus;
  final ValueChanged<SetupNotificationPermissionStatus>
  onNotificationStatusChanged;
  final Future<void> Function() onAddMedication;
  final Future<void> Function(String? medicationId) onScheduleReminder;
  final Future<void> Function() onManageMedications;
  final DashboardClock? clock;

  @override
  State<TodayDashboardScreen> createState() => _TodayDashboardScreenState();
}

class _TodayDashboardScreenState extends State<TodayDashboardScreen>
    with WidgetsBindingObserver {
  TodayDashboardSnapshot? _snapshot;
  List<Medication> _medications = const [];
  bool _loading = true;
  Timer? _refreshTimer;

  late TodayDashboardService _service;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _service = _createService();
    _loadSnapshot();
  }

  @override
  void didUpdateWidget(TodayDashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.medicationRepository != widget.medicationRepository ||
        oldWidget.reminderScheduleRepository !=
            widget.reminderScheduleRepository ||
        oldWidget.dailyReminderHandlingRepository !=
            widget.dailyReminderHandlingRepository ||
        oldWidget.clock != widget.clock) {
      _service = _createService();
      _loadSnapshot();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadSnapshot();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    super.dispose();
  }

  TodayDashboardService _createService() {
    return TodayDashboardService(
      medicationRepository: widget.medicationRepository,
      reminderScheduleRepository: widget.reminderScheduleRepository,
      handlingRepository: widget.dailyReminderHandlingRepository,
      clock: widget.clock,
    );
  }

  Future<void> _loadSnapshot() async {
    final snapshot = await _service.loadSnapshot();
    final medications = await widget.medicationRepository.loadMedications();
    if (!mounted) return;
    setState(() {
      _snapshot = snapshot;
      _medications = medications;
      _loading = false;
    });
    _scheduleRefresh(snapshot);
  }

  void _scheduleRefresh(TodayDashboardSnapshot snapshot) {
    _refreshTimer?.cancel();
    final nextRefreshAt = snapshot.nextRefreshAt;
    if (nextRefreshAt == null) return;
    final delay = nextRefreshAt.difference(DateTime.now());
    if (delay.isNegative) {
      _refreshTimer = Timer(const Duration(seconds: 1), _loadSnapshot);
      return;
    }
    _refreshTimer = Timer(delay, _loadSnapshot);
  }

  Future<void> _markHandled(TodayReminderItem item) async {
    final now = widget.clock?.call() ?? DateTime.now();
    final l10n = AppLocalizations.of(context);
    await widget.dailyReminderHandlingRepository.markHandled(
      localDate: item.localDate,
      scheduleId: item.scheduleId,
      medicationId: item.medicationId,
      reminderTime: item.reminderTime,
      handledAt: now,
    );

    if (item.isUpcoming) {
      final schedules = await widget.reminderScheduleRepository.loadSchedules();
      for (final schedule in schedules) {
        if (schedule.id == item.scheduleId) {
          await widget.reminderNotificationScheduler.suppressTodayForTime(
            schedule,
            item.reminderTime,
            title: item.medicationName,
            body: l10n.todayMarkHandled,
            permissionStatus: widget.notificationStatus,
          );
          break;
        }
      }
    }

    await _loadSnapshot();
  }

  Future<void> _handleAddMedication() async {
    await widget.onAddMedication();
    await _loadSnapshot();
  }

  Future<void> _handleScheduleReminder(String? medicationId) async {
    await widget.onScheduleReminder(medicationId);
    await _loadSnapshot();
  }

  Future<void> _handleManageMedications() async {
    await widget.onManageMedications();
    await _loadSnapshot();
  }

  MedicationReminderOperations _operations() {
    return MedicationReminderOperations(
      medicationRepository: widget.medicationRepository,
      scheduleRepository: widget.reminderScheduleRepository,
      dueReminderRepository: widget.dueReminderRepository,
      notificationScheduler: widget.reminderNotificationScheduler,
    );
  }

  Future<void> _editMedication(Medication medication) async {
    final updated = await Navigator.of(context).push<Medication>(
      MaterialPageRoute(
        builder: (_) => AddMedicationScreen(
          repository: widget.medicationRepository,
          initialMedication: medication,
        ),
      ),
    );
    if (updated == null) {
      await _loadSnapshot();
      return;
    }
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    await _operations().updateMedicationDetails(
      medication: updated,
      title: l10n.appTitle,
      body: l10n.notificationBody,
      permissionStatus: widget.notificationStatus,
    );
    await _loadSnapshot();
  }

  Future<void> _pauseMedication(Medication medication) async {
    await _operations().pauseMedication(medication);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).remindersPaused)),
    );
    await _loadSnapshot();
  }

  Future<void> _resumeMedication(Medication medication) async {
    await _operations().resumeMedication(
      medication: medication,
      title: AppLocalizations.of(context).appTitle,
      body: AppLocalizations.of(context).notificationBody,
      permissionStatus: widget.notificationStatus,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).remindersResumed)),
    );
    await _loadSnapshot();
  }

  Future<void> _deleteMedication(Medication medication) async {
    final confirmed = await showMedicationDeleteConfirmationDialog(
      context: context,
      medication: medication,
      target: MedicationDeleteConfirmationTarget.medication,
    );
    if (!confirmed) return;
    await _operations().deleteMedication(medication);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).medicationDeleted)),
    );
    await _loadSnapshot();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final snapshot = _snapshot;
    if (snapshot == null) {
      return const SizedBox.shrink();
    }

    return RefreshIndicator(
      onRefresh: _loadSnapshot,
      child: ListView(
        key: const Key('today-dashboard-list'),
        padding: const EdgeInsets.all(24),
        children: [
          ReminderStatusBanner(
            status: widget.notificationStatus,
            notificationPermissionService: widget.notificationPermissionService,
            onStatusChanged: widget.onNotificationStatusChanged,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).todayNotificationGuidance,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          for (final section in snapshot.sections)
            if (section.isReminderSection)
              TodaySection(section: section, onMarkHandled: _markHandled)
            else
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: TodayEmptyState(
                  section: section,
                  onAddMedication: _handleAddMedication,
                  onScheduleReminder: () =>
                      _handleScheduleReminder(section.actionMedicationId),
                  onManageMedications: _handleManageMedications,
                ),
              ),
          if (_medications.isNotEmpty) ...[
            const SizedBox(height: 8),
            MedicationListSection(
              medications: _medications,
              onScheduleMedication: (medication) =>
                  _handleScheduleReminder(medication.id),
              onEditMedication: _editMedication,
              onPauseMedication: _pauseMedication,
              onResumeMedication: _resumeMedication,
              onDeleteMedication: _deleteMedication,
            ),
          ],
        ],
      ),
    );
  }
}
