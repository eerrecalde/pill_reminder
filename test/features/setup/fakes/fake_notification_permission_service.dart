import 'package:pill_reminder/features/setup/domain/notification_permission_status.dart';
import 'package:pill_reminder/services/notification_permission_service.dart';

class FakeNotificationPermissionService
    implements NotificationPermissionService {
  FakeNotificationPermissionService({
    this.requestResult = SetupNotificationPermissionStatus.granted,
    this.currentStatus = SetupNotificationPermissionStatus.granted,
  });

  SetupNotificationPermissionStatus requestResult;
  SetupNotificationPermissionStatus currentStatus;
  bool openedSettings = false;

  @override
  Future<SetupNotificationPermissionStatus> checkStatus() async {
    return currentStatus;
  }

  @override
  Future<bool> openNotificationSettings() async {
    openedSettings = true;
    return true;
  }

  @override
  Future<SetupNotificationPermissionStatus> requestPermission() async {
    currentStatus = requestResult;
    return requestResult;
  }
}
