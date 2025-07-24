import 'platform_permission_service.dart';

class PlatformPermissionServiceWeb extends PlatformPermissionServiceBase {
  
  @override
  Future<PermissionStatus> checkPermission(PermissionType permission) async {
    // On web, most permissions are handled by the browser
    // File access permissions are typically handled through file picker dialogs
    switch (permission) {
      case PermissionType.storage:
        // Web storage is always available via localStorage/IndexedDB
        return PermissionStatus.granted;
      case PermissionType.camera:
      case PermissionType.microphone:
        // These would require specific web APIs and user interaction
        return PermissionStatus.notApplicable;
      case PermissionType.location:
        // Web location API is available but requires user consent
        return PermissionStatus.notApplicable;
    }
  }

  @override
  Future<PermissionStatus> requestPermission(PermissionType permission) async {
    // On web, permissions are typically requested through browser APIs
    // which are handled automatically when needed
    switch (permission) {
      case PermissionType.storage:
        return PermissionStatus.granted;
      case PermissionType.camera:
      case PermissionType.microphone:
      case PermissionType.location:
        return PermissionStatus.notApplicable;
    }
  }

  @override
  Future<Map<PermissionType, PermissionStatus>> requestMultiplePermissions(List<PermissionType> permissions) async {
    final Map<PermissionType, PermissionStatus> results = {};
    
    for (final permission in permissions) {
      results[permission] = await requestPermission(permission);
    }
    
    return results;
  }

  @override
  Future<bool> openAppSettings() async {
    // No app settings on web - permissions are managed by browser
    return false;
  }
}

PlatformPermissionServiceBase createPlatformPermissionService() => PlatformPermissionServiceWeb();