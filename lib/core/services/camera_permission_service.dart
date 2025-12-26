import 'package:permission_handler/permission_handler.dart' as permission_handler;

class CameraPermissionService {
  /// Check if camera permission is granted
  Future<bool> isCameraPermissionGranted() async {
    final status = await permission_handler.Permission.camera.status;
    return status.isGranted;
  }

  /// Returns true if granted, false if denied
  Future<bool> requestCameraPermission() async {
    final status = await permission_handler.Permission.camera.request();
    return status.isGranted;
  }

  /// Check if camera permission is permanently denied
  Future<bool> isCameraPermissionPermanentlyDenied() async {
    final status = await permission_handler.Permission.camera.status;
    return status.isPermanentlyDenied;
  }

  /// Open app settings to allow user to grant permission manually
  Future<bool> openAppSettings() async {
    return await permission_handler.openAppSettings();
  }

  /// Get permission status
  Future<permission_handler.PermissionStatus> getCameraPermissionStatus() async {
    return await permission_handler.Permission.camera.status;
  }
}

