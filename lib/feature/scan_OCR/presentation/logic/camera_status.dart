enum CameraStatus { 
  closed, 
  initializing, 
  ready, 
  error,
  permissionDenied // جديد
}

extension CameraStatusExtension on CameraStatus {
  String get displayText {
    switch (this) {
      case CameraStatus.closed:
        return 'Camera Closed';
      case CameraStatus.initializing:
        return 'Initializing Camera...';
      case CameraStatus.ready:
        return 'Ready to Capture';
      case CameraStatus.error:
        return 'Camera Error';
      case CameraStatus.permissionDenied:
        return 'Camera Permission Denied';
    }
  }

  bool get isReady => this == CameraStatus.ready;
  bool get hasError => this == CameraStatus.error;
  bool get isPermissionDenied => this == CameraStatus.permissionDenied;
}