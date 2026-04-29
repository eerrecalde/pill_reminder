import 'notification_permission_status.dart';
import 'setup_language.dart';

enum SetupStep {
  language,
  privacy,
  notifications,
  complete;

  static SetupStep fromName(String? value) {
    return SetupStep.values.firstWhere(
      (step) => step.name == value,
      orElse: () => SetupStep.language,
    );
  }
}

class SetupState {
  const SetupState({
    required this.isComplete,
    required this.currentStep,
    required this.language,
    required this.privacyAcknowledged,
    required this.notificationStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory SetupState.initial() {
    return const SetupState(
      isComplete: false,
      currentStep: SetupStep.language,
      language: SetupLanguage.english,
      privacyAcknowledged: false,
      notificationStatus: SetupNotificationPermissionStatus.unknown,
    );
  }

  final bool isComplete;
  final SetupStep currentStep;
  final SetupLanguage language;
  final bool privacyAcknowledged;
  final SetupNotificationPermissionStatus notificationStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SetupState copyWith({
    bool? isComplete,
    SetupStep? currentStep,
    SetupLanguage? language,
    bool? privacyAcknowledged,
    SetupNotificationPermissionStatus? notificationStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SetupState(
      isComplete: isComplete ?? this.isComplete,
      currentStep: currentStep ?? this.currentStep,
      language: language ?? this.language,
      privacyAcknowledged: privacyAcknowledged ?? this.privacyAcknowledged,
      notificationStatus: notificationStatus ?? this.notificationStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
