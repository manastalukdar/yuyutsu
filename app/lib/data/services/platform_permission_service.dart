import 'package:flutter/foundation.dart';

// Conditional imports
import 'platform_permission_service_io.dart' if (dart.library.html) 'platform_permission_service_web.dart';

enum PermissionType {
  storage,
  camera,
  microphone,
  location,
}

enum PermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  restricted,
  notApplicable,
}

abstract class PlatformPermissionServiceBase {
  Future<PermissionStatus> checkPermission(PermissionType permission);
  Future<PermissionStatus> requestPermission(PermissionType permission);
  Future<Map<PermissionType, PermissionStatus>> requestMultiplePermissions(List<PermissionType> permissions);
  Future<bool> openAppSettings();
}

// Factory method to get the appropriate implementation
PlatformPermissionServiceBase getPlatformPermissionService() => createPlatformPermissionService();