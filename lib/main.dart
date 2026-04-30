import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/medications/data/local_medication_repository.dart';
import 'features/medications/data/medication_repository.dart';
import 'features/medications/domain/medication.dart';
import 'features/medications/presentation/add_medication_screen.dart';
import 'features/medications/presentation/medication_list_section.dart';
import 'features/setup/data/local_setup_preferences_repository.dart';
import 'features/setup/data/setup_preferences_repository.dart';
import 'features/setup/domain/notification_permission_status.dart';
import 'features/setup/domain/setup_state.dart';
import 'features/setup/presentation/reminder_status_banner.dart';
import 'features/setup/presentation/setup_flow.dart';
import 'features/setup/presentation/setup_preferences_screen.dart';
import 'l10n/app_localizations.dart';
import 'services/notification_permission_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  runApp(
    PillReminderApp(
      setupPreferencesRepository: LocalSetupPreferencesRepository(preferences),
      medicationRepository: LocalMedicationRepository(preferences),
      notificationPermissionService:
          PermissionHandlerNotificationPermissionService(),
    ),
  );
}

class PillReminderApp extends StatefulWidget {
  const PillReminderApp({
    required this.setupPreferencesRepository,
    required this.notificationPermissionService,
    this.medicationRepository,
    super.key,
  });

  final SetupPreferencesRepository setupPreferencesRepository;
  final NotificationPermissionService notificationPermissionService;
  final MedicationRepository? medicationRepository;

  @override
  State<PillReminderApp> createState() => _PillReminderAppState();
}

class _PillReminderAppState extends State<PillReminderApp> {
  Locale _locale = const Locale('en');
  SetupState? _setupState;
  bool _loading = true;
  late final MedicationRepository _fallbackMedicationRepository =
      _InMemoryMedicationRepository();

  @override
  void initState() {
    super.initState();
    _loadSetup();
  }

  Future<void> _loadSetup() async {
    final state = await widget.setupPreferencesRepository.load();
    if (!mounted) return;
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
    required this.onLocaleChanged,
    required this.onSetupStateChanged,
    required this.onNotificationStatusChanged,
  });

  final SetupState setupState;
  final SetupPreferencesRepository repository;
  final MedicationRepository medicationRepository;
  final NotificationPermissionService notificationPermissionService;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<SetupState> onSetupStateChanged;
  final ValueChanged<SetupNotificationPermissionStatus>
  onNotificationStatusChanged;

  @override
  State<_MainAppHome> createState() => _MainAppHomeState();
}

class _MainAppHomeState extends State<_MainAppHome> {
  List<Medication> _medications = const [];
  bool _loadingMedications = true;

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  Future<void> _loadMedications() async {
    final medications = await widget.medicationRepository.loadMedications();
    if (!mounted) return;
    setState(() {
      _medications = medications;
      _loadingMedications = false;
    });
  }

  Future<void> _openAddMedication(BuildContext context) async {
    final medication = await Navigator.of(context).push<Medication>(
      MaterialPageRoute(
        builder: (_) =>
            AddMedicationScreen(repository: widget.medicationRepository),
      ),
    );
    if (medication != null) {
      await _loadMedications();
    }
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
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                ReminderStatusBanner(
                  status: widget.setupState.notificationStatus,
                  notificationPermissionService:
                      widget.notificationPermissionService,
                  onStatusChanged: widget.onNotificationStatusChanged,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  key: const Key('open-add-medication-button'),
                  onPressed: () => _openAddMedication(context),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.addMedicationTitle),
                ),
                const SizedBox(height: 24),
                if (_loadingMedications)
                  const Center(child: CircularProgressIndicator())
                else
                  MedicationListSection(medications: _medications),
              ],
            ),
          ),
        ),
      ),
    );
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
