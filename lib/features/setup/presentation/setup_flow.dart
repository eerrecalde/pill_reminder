import 'package:flutter/material.dart';

import '../../../services/notification_permission_service.dart';
import '../data/setup_preferences_repository.dart';
import '../domain/notification_permission_status.dart';
import '../domain/setup_language.dart';
import '../domain/setup_state.dart';
import 'language_selection_screen.dart';
import 'notification_permission_screen.dart';
import 'privacy_explanation_screen.dart';

class SetupFlow extends StatefulWidget {
  const SetupFlow({
    required this.repository,
    required this.notificationPermissionService,
    required this.onLocaleChanged,
    required this.onComplete,
    super.key,
  });

  final SetupPreferencesRepository repository;
  final NotificationPermissionService notificationPermissionService;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<SetupState> onComplete;

  @override
  State<SetupFlow> createState() => _SetupFlowState();
}

class _SetupFlowState extends State<SetupFlow> {
  SetupState? _state;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final state = await widget.repository.load();
    if (!mounted) return;
    widget.onLocaleChanged(state.language.locale);
    setState(() => _state = state);
  }

  Future<void> _selectLanguage(SetupLanguage language) async {
    await widget.repository.saveLanguage(language);
    widget.onLocaleChanged(language.locale);
    await _load();
  }

  Future<void> _acknowledgePrivacy() async {
    await widget.repository.savePrivacyAcknowledged();
    await _load();
  }

  Future<void> _finishWithStatus(
    SetupNotificationPermissionStatus status,
  ) async {
    await widget.repository.saveNotificationStatus(status);
    await widget.repository.markComplete();
    final state = await widget.repository.load();
    if (!mounted) return;
    widget.onComplete(state);
  }

  Future<void> _requestNotifications() async {
    final status = await widget.notificationPermissionService
        .requestPermission();
    await _finishWithStatus(status);
  }

  Future<void> _skipNotifications() async {
    await _finishWithStatus(SetupNotificationPermissionStatus.skipped);
  }

  void _goBackToLanguage() {
    setState(() {
      _state = (_state ?? SetupState.initial()).copyWith(
        currentStep: SetupStep.language,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = _state;
    if (state == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return switch (state.currentStep) {
      SetupStep.language => LanguageSelectionScreen(
        selectedLanguage: state.language,
        onLanguageSelected: _selectLanguage,
      ),
      SetupStep.privacy => PrivacyExplanationScreen(
        onBack: _goBackToLanguage,
        onContinue: _acknowledgePrivacy,
      ),
      SetupStep.notifications ||
      SetupStep.complete => NotificationPermissionScreen(
        onBack: _goBackToLanguage,
        onEnable: _requestNotifications,
        onSkip: _skipNotifications,
      ),
    };
  }
}
