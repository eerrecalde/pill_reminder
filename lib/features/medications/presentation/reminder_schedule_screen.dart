import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import '../../../l10n/app_localizations.dart';
import '../../../services/notification_permission_service.dart';
import '../../../services/reminder_notification_scheduler.dart';
import '../../setup/domain/notification_permission_status.dart';
import '../data/reminder_schedule_repository.dart';
import '../domain/medication.dart';
import '../domain/reminder_schedule.dart';
import '../domain/reminder_schedule_draft.dart';
import '../domain/reminder_schedule_validation.dart';
import 'reminder_schedule_review.dart';
import 'reminder_time_selector.dart';

class ReminderScheduleScreen extends StatefulWidget {
  const ReminderScheduleScreen({
    required this.medication,
    required this.repository,
    required this.notificationPermissionService,
    required this.notificationScheduler,
    super.key,
  });

  final Medication medication;
  final ReminderScheduleRepository repository;
  final NotificationPermissionService notificationPermissionService;
  final ReminderNotificationScheduler notificationScheduler;

  @override
  State<ReminderScheduleScreen> createState() => _ReminderScheduleScreenState();
}

class _ReminderScheduleScreenState extends State<ReminderScheduleScreen> {
  List<ReminderTime> _times = const [];
  DateTime? _endDate;
  SetupNotificationPermissionStatus _permissionStatus =
      SetupNotificationPermissionStatus.unavailable;
  ReminderScheduleValidationResult _validation =
      const ReminderScheduleValidationResult.valid();
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    final existing = await widget.repository.loadScheduleForMedication(
      widget.medication.id,
    );
    final permission = await widget.notificationPermissionService.checkStatus();
    if (!mounted) return;
    setState(() {
      _times = existing?.sortedReminderTimes ?? const [];
      _endDate = existing?.endDate;
      _permissionStatus = permission;
      _loading = false;
    });
  }

  ReminderScheduleDraft _draft() {
    return ReminderScheduleDraft(
      medication: widget.medication,
      selectedTimes: _times,
      endDate: _endDate,
      notificationPermissionStatus: _permissionStatus,
      validationState: _validation,
    );
  }

  Future<void> _addTime() async {
    if (_times.length >= ReminderScheduleValidation.maxDailyTimes) {
      _setValidation(
        const ReminderScheduleValidationResult.invalid([
          ReminderScheduleValidationError(
            ReminderScheduleValidationIssue.tooManyTimes,
          ),
        ]),
      );
      return;
    }
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked == null) return;
    _upsertTime(ReminderTime(hour: picked.hour, minute: picked.minute));
  }

  Future<void> _editTime(ReminderTime original) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: original.hour, minute: original.minute),
    );
    if (picked == null) return;
    setState(() {
      _times = _times.where((time) => time != original).followedBy([
        ReminderTime(hour: picked.hour, minute: picked.minute),
      ]).toList()..sort();
      _validation = const ReminderScheduleValidationResult.valid();
    });
  }

  void _upsertTime(ReminderTime time) {
    setState(() {
      _times = [..._times, time]..sort();
      _validation = ReminderScheduleValidation.validate(_draft());
    });
  }

  void _removeTime(ReminderTime time) {
    setState(() {
      _times = _times.where((item) => item != time).toList();
      _validation = const ReminderScheduleValidationResult.valid();
    });
  }

  Future<void> _pickEndDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5),
    );
    if (picked == null) return;
    setState(() {
      _endDate = picked;
      _validation = const ReminderScheduleValidationResult.valid();
    });
  }

  Future<void> _save() async {
    final validation = ReminderScheduleValidation.validate(_draft());
    _setValidation(validation);
    if (!validation.isValid) return;

    final l10n = AppLocalizations.of(context);
    final view = View.of(context);
    final textDirection = Directionality.of(context);
    setState(() => _saving = true);
    final initialSchedule = await widget.repository.saveSchedule(
      medicationId: widget.medication.id,
      reminderTimes: _times,
      endDate: _endDate,
      notificationDeliveryState: _deliveryStateForPermission(),
    );
    final result = await widget.notificationScheduler.schedule(
      initialSchedule,
      title: l10n.appTitle,
      body: l10n.notificationBody,
      permissionStatus: _permissionStatus,
    );
    final saved = await widget.repository.saveSchedule(
      medicationId: widget.medication.id,
      reminderTimes: initialSchedule.reminderTimes,
      endDate: initialSchedule.endDate,
      notificationDeliveryState: result.deliveryState,
    );
    if (!mounted) return;
    SemanticsService.sendAnnouncement(
      view,
      l10n.scheduleSavedSemantics,
      textDirection,
    );
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop(saved);
    } else {
      setState(() => _saving = false);
    }
  }

  void _setValidation(ReminderScheduleValidationResult validation) {
    setState(() => _validation = validation);
    final message = _validationMessage(validation.firstError);
    if (message != null) {
      SemanticsService.sendAnnouncement(
        View.of(context),
        message,
        Directionality.of(context),
      );
    }
  }

  ReminderNotificationDeliveryState _deliveryStateForPermission() {
    return switch (_permissionStatus) {
      SetupNotificationPermissionStatus.granted =>
        ReminderNotificationDeliveryState.deliverable,
      SetupNotificationPermissionStatus.unknown ||
      SetupNotificationPermissionStatus.skipped ||
      SetupNotificationPermissionStatus.denied =>
        ReminderNotificationDeliveryState.permissionNeeded,
      SetupNotificationPermissionStatus.blocked =>
        ReminderNotificationDeliveryState.blocked,
      SetupNotificationPermissionStatus.unavailable =>
        ReminderNotificationDeliveryState.unavailable,
    };
  }

  void _cancel() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.scheduleReminderTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.scheduleReminderTitle)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  l10n.scheduleMedicationSummary(widget.medication.name),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                if (!widget.medication.isActive) _InactiveMedicationMessage(),
                ReminderTimeSelector(
                  times: _times,
                  onAdd: widget.medication.isActive ? _addTime : () {},
                  onEdit: widget.medication.isActive ? _editTime : (_) {},
                  onRemove: widget.medication.isActive ? _removeTime : (_) {},
                  errorText: _validationMessage(_validation.firstError),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  key: const Key('pick-schedule-end-date-button'),
                  onPressed: widget.medication.isActive ? _pickEndDate : null,
                  icon: const Icon(Icons.event),
                  label: Text(
                    _endDate == null
                        ? l10n.addOptionalEndDate
                        : l10n.scheduleStopsOn(
                            formatReminderDate(context, _endDate!),
                          ),
                  ),
                ),
                if (_endDate != null)
                  TextButton.icon(
                    key: const Key('clear-schedule-end-date-button'),
                    onPressed: () => setState(() => _endDate = null),
                    icon: const Icon(Icons.close),
                    label: Text(l10n.clearEndDate),
                  ),
                const SizedBox(height: 20),
                ReminderScheduleReview(
                  medication: widget.medication,
                  times: _times,
                  endDate: _endDate,
                  notificationMessage: _notificationMessage(),
                  errorText:
                      _validation.hasIssue(
                        ReminderScheduleValidationIssue.invalidEndDate,
                      )
                      ? _validationMessage(_validation.firstError)
                      : null,
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  key: const Key('save-reminder-schedule-button'),
                  onPressed: _saving || !widget.medication.isActive
                      ? null
                      : _save,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(l10n.saveSchedule),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  key: const Key('cancel-reminder-schedule-button'),
                  onPressed: _saving ? null : _cancel,
                  icon: const Icon(Icons.close),
                  label: Text(l10n.cancel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _notificationMessage() {
    final l10n = AppLocalizations.of(context);
    return switch (_permissionStatus) {
      SetupNotificationPermissionStatus.granted =>
        l10n.scheduleNotificationsDeliverable,
      SetupNotificationPermissionStatus.unknown ||
      SetupNotificationPermissionStatus.skipped ||
      SetupNotificationPermissionStatus.denied =>
        l10n.scheduleNotificationsNeedPermission,
      SetupNotificationPermissionStatus.blocked =>
        l10n.scheduleNotificationsBlocked,
      SetupNotificationPermissionStatus.unavailable =>
        l10n.scheduleNotificationsUnavailable,
    };
  }

  String? _validationMessage(ReminderScheduleValidationError? error) {
    if (error == null) return null;
    final l10n = AppLocalizations.of(context);
    return switch (error.issue) {
      ReminderScheduleValidationIssue.inactiveMedication =>
        l10n.scheduleInactiveMedicationError,
      ReminderScheduleValidationIssue.missingTime =>
        l10n.scheduleMissingTimeError,
      ReminderScheduleValidationIssue.duplicateTime =>
        l10n.scheduleDuplicateTimeError,
      ReminderScheduleValidationIssue.tooManyTimes =>
        l10n.scheduleTooManyTimesError,
      ReminderScheduleValidationIssue.invalidEndDate =>
        l10n.scheduleInvalidEndDateError,
    };
  }
}

class _InactiveMedicationMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(l10n.scheduleInactiveMedicationError),
        ),
      ),
    );
  }
}
