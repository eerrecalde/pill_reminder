enum SetupNotificationPermissionStatus {
  unknown,
  granted,
  skipped,
  denied,
  blocked,
  unavailable;

  bool get remindersCanBeDelivered => this == granted;

  bool get needsMainAppStatus {
    return this == skipped ||
        this == denied ||
        this == blocked ||
        this == unavailable;
  }

  static SetupNotificationPermissionStatus fromName(String? value) {
    return SetupNotificationPermissionStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => SetupNotificationPermissionStatus.unknown,
    );
  }
}
