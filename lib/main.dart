import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/medications/data/daily_reminder_handling_repository.dart';
import 'features/medications/data/local_daily_reminder_handling_repository.dart';
import 'features/medications/data/local_medication_repository.dart';
import 'features/medications/data/local_reminder_schedule_repository.dart';
import 'features/medications/data/medication_repository.dart';
import 'features/medications/data/reminder_schedule_repository.dart';
import 'features/medications/domain/daily_reminder_handling.dart';
import 'features/medications/domain/medication.dart';
import 'features/medications/domain/reminder_schedule.dart';
import 'features/medications/presentation/add_medication_screen.dart';
import 'features/medications/presentation/reminder_schedule_screen.dart';
import 'features/medications/presentation/today_dashboard_screen.dart';
import 'features/setup/data/local_setup_preferences_repository.dart';
import 'features/setup/data/setup_preferences_repository.dart';
import 'features/setup/domain/notification_permission_status.dart';
import 'features/setup/domain/setup_state.dart';
import 'features/setup/presentation/setup_flow.dart';
import 'features/setup/presentation/setup_preferences_screen.dart';
import 'l10n/app_localizations.dart';
import 'services/notification_permission_service.dart';
import 'services/reminder_notification_scheduler.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  runApp(
    PillReminderApp(
      setupPreferencesRepository: LocalSetupPreferencesRepository(preferences),
      medicationRepository: LocalMedicationRepository(preferences),
      reminderScheduleRepository: LocalReminderScheduleRepository(preferences),
      dailyReminderHandlingRepository: LocalDailyReminderHandlingRepository(
        preferences,
      ),
      reminderNotificationScheduler: LocalReminderNotificationScheduler(),
      notificationPermissionService:
          PermissionHandlerNotificationPermissionService(),
    ),
  );
}

class PillReminderApp extends StatefulWidget {
  const PillReminderApp({
    required this.setupPreferencesRepository,
    required this.notificationPermissionService,
    this.dailyReminderHandlingRepository,
    this.reminderScheduleRepository,
    this.reminderNotificationScheduler,
    this.medicationRepository,
    super.key,
  });

  final SetupPreferencesRepository setupPreferencesRepository;
  final NotificationPermissionService notificationPermissionService;
  final MedicationRepository? medicationRepository;
  final DailyReminderHandlingRepository? dailyReminderHandlingRepository;
  final ReminderScheduleRepository? reminderScheduleRepository;
  final ReminderNotificationScheduler? reminderNotificationScheduler;

  @override
  State<PillReminderApp> createState() => _PillReminderAppState();
}

class _PillReminderAppState extends State<PillReminderApp> {
  Locale _locale = const Locale('en');
  SetupState? _setupState;
  bool _loading = true;
  late final MedicationRepository _fallbackMedicationRepository =
      _InMemoryMedicationRepository();
  late final ReminderScheduleRepository _fallbackReminderScheduleRepository =
      _InMemoryReminderScheduleRepository();
  late final DailyReminderHandlingRepository _fallbackHandlingRepository =
      _InMemoryDailyReminderHandlingRepository();
  late final ReminderNotificationScheduler _fallbackReminderScheduler =
      _InMemoryReminderNotificationScheduler();

  @override
  void initState() {
    super.initState();
    _loadSetup();
  }

  Future<void> _loadSetup() async {
    final state = await widget.setupPreferencesRepository.load();
    if (!context.mounted) return;
    setState(() {
      _setupState = state;
      _locale = state.language.locale;
      _loading = false;
    });
  }

  void _setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  void _setSetupState(SetupState state) {
    setState(() {
      _setupState = state;
      _locale = state.language.locale;
    });
  }

  Future<void> _updateNotificationStatus(
    SetupNotificationPermissionStatus status,
  ) async {
    await widget.setupPreferencesRepository.saveNotificationStatus(status);
    final state = await widget.setupPreferencesRepository.load();
    if (!mounted) return;
    _setSetupState(state);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pill Reminder',
      theme: AppTheme.light,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: _buildHome(),
    );
  }

  Widget _buildHome() {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final state = _setupState ?? SetupState.initial();
    if (!state.isComplete) {
      return SetupFlow(
        repository: widget.setupPreferencesRepository,
        notificationPermissionService: widget.notificationPermissionService,
        onLocaleChanged: _setLocale,
        onComplete: _setSetupState,
      );
    }

    return _MainAppHome(
      setupState: state,
      repository: widget.setupPreferencesRepository,
      medicationRepository:
          widget.medicationRepository ?? _fallbackMedicationRepository,
      notificationPermissionService: widget.notificationPermissionService,
      reminderScheduleRepository:
          widget.reminderScheduleRepository ??
          _fallbackReminderScheduleRepository,
      dailyReminderHandlingRepository:
          widget.dailyReminderHandlingRepository ?? _fallbackHandlingRepository,
      reminderNotificationScheduler:
          widget.reminderNotificationScheduler ?? _fallbackReminderScheduler,
      onLocaleChanged: _setLocale,
      onSetupStateChanged: _setSetupState,
      onNotificationStatusChanged: _updateNotificationStatus,
    );
  }
}

class _MainAppHome extends StatefulWidget {
  const _MainAppHome({
    required this.setupState,
    required this.repository,
    required this.medicationRepository,
    required this.notificationPermissionService,
    required this.reminderScheduleRepository,
    required this.dailyReminderHandlingRepository,
    required this.reminderNotificationScheduler,
    required this.onLocaleChanged,
    required this.onSetupStateChanged,
    required this.onNotificationStatusChanged,
  });

  final SetupState setupState;
  final SetupPreferencesRepository repository;
  final MedicationRepository medicationRepository;
  final NotificationPermissionService notificationPermissionService;
  final ReminderScheduleRepository reminderScheduleRepository;
  final DailyReminderHandlingRepository dailyReminderHandlingRepository;
  final ReminderNotificationScheduler reminderNotificationScheduler;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<SetupState> onSetupStateChanged;
  final ValueChanged<SetupNotificationPermissionStatus>
  onNotificationStatusChanged;

  @override
  State<_MainAppHome> createState() => _MainAppHomeState();
}

class _MainAppHomeState extends State<_MainAppHome> {
  Future<void> _openAddMedication(BuildContext context) async {
    final medication = await Navigator.of(context).push<Medication>(
      MaterialPageRoute(
        builder: (_) =>
            AddMedicationScreen(repository: widget.medicationRepository),
      ),
    );
    if (medication != null && mounted) setState(() {});
  }

  Future<void> _openReminderSchedule(Medication medication) async {
    if (!mounted) return;
    await Navigator.of(context).push<ReminderSchedule>(
      MaterialPageRoute(
        builder: (_) => ReminderScheduleScreen(
          medication: medication,
          repository: widget.reminderScheduleRepository,
          notificationPermissionService: widget.notificationPermissionService,
          notificationScheduler: widget.reminderNotificationScheduler,
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _openScheduleFromDashboard(
    BuildContext context,
    String? medicationId,
  ) async {
    final medications = await widget.medicationRepository.loadMedications();
    final schedules = await widget.reminderScheduleRepository.loadSchedules();
    Medication? selected;

    if (medicationId != null) {
      for (final medication in medications) {
        if (medication.id == medicationId) {
          selected = medication;
          break;
        }
      }
    }

    selected ??= medications.where((medication) {
      final hasSchedule = schedules.any(
        (schedule) => schedule.medicationId == medication.id,
      );
      return medication.isActive && !hasSchedule;
    }).firstOrNull;

    if (selected == null && medications.isNotEmpty) {
      selected = medications.firstWhere(
        (medication) => medication.isActive,
        orElse: () => medications.first,
      );
    }

    if (!mounted) return;
    if (selected != null && selected.isActive) {
      await _openReminderSchedule(selected);
    }
  }

  Future<void> _openManageMedications(BuildContext context) async {
    await _openAddMedication(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mainTitle),
        actions: [
          IconButton(
            tooltip: l10n.setupPreferences,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SetupPreferencesScreen(
                    repository: widget.repository,
                    notificationPermissionService:
                        widget.notificationPermissionService,
                    initialState: widget.setupState,
                    onLocaleChanged: widget.onLocaleChanged,
                    onStateChanged: widget.onSetupStateChanged,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: TodayDashboardScreen(
              medicationRepository: widget.medicationRepository,
              reminderScheduleRepository: widget.reminderScheduleRepository,
              dailyReminderHandlingRepository:
                  widget.dailyReminderHandlingRepository,
              reminderNotificationScheduler:
                  widget.reminderNotificationScheduler,
              notificationPermissionService:
                  widget.notificationPermissionService,
              notificationStatus: widget.setupState.notificationStatus,
              onNotificationStatusChanged: widget.onNotificationStatusChanged,
              onAddMedication: () => _openAddMedication(context),
              onScheduleReminder: (medicationId) =>
                  _openScheduleFromDashboard(context, medicationId),
              onManageMedications: () => _openManageMedications(context),
            ),
          ),
        ),
      ),
    );
  }
}

class _InMemoryReminderScheduleRepository
    implements ReminderScheduleRepository {
  final List<ReminderSchedule> _schedules = [];

  @override
  Future<List<ReminderSchedule>> loadSchedules() async {
    return List.unmodifiable(_schedules);
  }

  @override
  Future<ReminderSchedule?> loadScheduleForMedication(
    String medicationId,
  ) async {
    for (final schedule in _schedules) {
      if (schedule.medicationId == medicationId) return schedule;
    }
    return null;
  }

  @override
  Future<ReminderSchedule> saveSchedule({
    required String medicationId,
    required List<ReminderTime> reminderTimes,
    DateTime? endDate,
    ReminderNotificationDeliveryState notificationDeliveryState =
        ReminderNotificationDeliveryState.permissionNeeded,
  }) async {
    final now = DateTime.now();
    final existing = await loadScheduleForMedication(medicationId);
    final schedule = ReminderSchedule(
      id: existing?.id ?? 'memory-schedule-${now.microsecondsSinceEpoch}',
      medicationId: medicationId,
      reminderTimes: [...reminderTimes]..sort(),
      endDate: endDate,
      notificationDeliveryState: notificationDeliveryState,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );
    _schedules.removeWhere((item) => item.medicationId == medicationId);
    _schedules.add(schedule);
    return schedule;
  }

  @override
  Future<void> deleteSchedule(String medicationId) async {
    _schedules.removeWhere((item) => item.medicationId == medicationId);
  }
}

class _InMemoryReminderNotificationScheduler
    implements ReminderNotificationScheduler {
  @override
  Future<void> initialize() async {}

  @override
  Future<void> cancelForSchedule(ReminderSchedule schedule) async {}

  @override
  Future<ReminderNotificationScheduleResult> schedule(
    ReminderSchedule schedule, {
    required String title,
    required String body,
    required SetupNotificationPermissionStatus permissionStatus,
  }) async {
    final status = switch (permissionStatus) {
      SetupNotificationPermissionStatus.granted =>
        ReminderNotificationScheduleStatus.scheduled,
      SetupNotificationPermissionStatus.unknown ||
      SetupNotificationPermissionStatus.skipped ||
      SetupNotificationPermissionStatus.denied =>
        ReminderNotificationScheduleStatus.deferredForPermission,
      SetupNotificationPermissionStatus.blocked =>
        ReminderNotificationScheduleStatus.blocked,
      SetupNotificationPermissionStatus.unavailable =>
        ReminderNotificationScheduleStatus.unavailable,
    };
    return ReminderNotificationScheduleResult(status);
  }

  @override
  Future<void> suppressTodayForTime(
    ReminderSchedule schedule,
    ReminderTime reminderTime, {
    required String title,
    required String body,
    required SetupNotificationPermissionStatus permissionStatus,
  }) async {}
}

class _InMemoryDailyReminderHandlingRepository
    implements DailyReminderHandlingRepository {
  final List<DailyReminderHandling> _records = [];

  @override
  Future<List<DailyReminderHandling>> loadForDate(DateTime localDate) async {
    return _records
        .where((record) => _isSameDate(record.localDate, localDate))
        .toList(growable: false);
  }

  @override
  Future<DailyReminderHandling> markHandled({
    required DateTime localDate,
    required String scheduleId,
    required String medicationId,
    required ReminderTime reminderTime,
    required DateTime handledAt,
  }) async {
    final record = DailyReminderHandling(
      id: DailyReminderHandling.buildId(
        localDate: localDate,
        scheduleId: scheduleId,
        medicationId: medicationId,
        reminderTime: reminderTime,
      ),
      localDate: DateTime(localDate.year, localDate.month, localDate.day),
      scheduleId: scheduleId,
      medicationId: medicationId,
      reminderTime: reminderTime,
      handledAt: handledAt,
    );
    _records.removeWhere((item) => item.id == record.id);
    _records.add(record);
    return record;
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _InMemoryMedicationRepository implements MedicationRepository {
  final List<Medication> _medications = [];

  @override
  Future<List<Medication>> loadMedications() async {
    return List.unmodifiable(_medications);
  }

  @override
  Future<Medication> addMedication({
    required String name,
    String dosageLabel = '',
    String notes = '',
    MedicationStatus status = MedicationStatus.active,
  }) async {
    final now = DateTime.now();
    final medication = Medication(
      id: 'memory-${now.microsecondsSinceEpoch}',
      name: name.trim(),
      dosageLabel: dosageLabel.trim(),
      notes: notes.trim(),
      status: status,
      createdAt: now,
      updatedAt: now,
    );
    _medications.add(medication);
    return medication;
  }
}
