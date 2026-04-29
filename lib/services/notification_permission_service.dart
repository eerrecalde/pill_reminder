import 'package:permission_handler/permission_handler.dart';

import '../features/setup/domain/notification_permission_status.dart';

abstract class NotificationPermissionService {
  Future<SetupNotificationPermissionStatus> checkStatus();

  Future<SetupNotificationPermissionStatus> requestPermission();

  Future<bool> openNotificationSettings();
}

class PermissionHandlerNotificationPermissionService
    implements NotificationPermissionService {
  @override
  Future<SetupNotificationPermissionStatus> checkStatus() async {
    return _mapPermissionStatus(await Permission.notification.status);
  }

  @override
  Future<SetupNotificationPermissionStatus> requestPermission() async {
    return _mapPermissionStatus(await Permission.notification.request());
  }

  @override
  Future<bool> openNotificationSettings() {
    return openAppSettings();
  }

  SetupNotificationPermissionStatus _mapPermissionStatus(
    PermissionStatus status,
  ) {
    if (status.isGranted || status.isLimited) {
      return SetupNotificationPermissionStatus.granted;
    }
    if (status.isPermanentlyDenied || status.isRestricted) {
      return SetupNotificationPermissionStatus.blocked;
    }
    if (status.isDenied) {
      return SetupNotificationPermissionStatus.denied;
    }
    return SetupNotificationPermissionStatus.unavailable;
  }
}
