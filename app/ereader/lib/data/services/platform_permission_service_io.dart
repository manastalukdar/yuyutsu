import 'dart:io';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'platform_permission_service.dart';

class PlatformPermissionServiceIO extends PlatformPermissionServiceBase {
  
  @override
  Future<PermissionStatus> checkPermission(PermissionType permission) async {
    if (Platform.isIOS || Platform.isAndroid) {
      final status = await _getPermissionHandler(permission).status;
      return _convertStatus(status);
    }
    // For desktop platforms, most permissions are not applicable
    return PermissionStatus.notApplicable;
  }

  @override
  Future<PermissionStatus> requestPermission(PermissionType permission) async {
    if (Platform.isIOS || Platform.isAndroid) {
      final status = await _getPermissionHandler(permission).request();
      return _convertStatus(status);
    }
    // For desktop platforms, most permissions are not applicable
    return PermissionStatus.notApplicable;
  }

  @override
  Future<Map<PermissionType, PermissionStatus>> requestMultiplePermissions(List<PermissionType> permissions) async {
    final Map<PermissionType, PermissionStatus> results = {};
    
    if (Platform.isIOS || Platform.isAndroid) {
      final Map<ph.Permission, ph.PermissionStatus> statuses = 
          await permissions.map(_getPermissionHandler).toList().request();
      
      for (int i = 0; i < permissions.length; i++) {
        final permission = permissions[i];
        final handler = _getPermissionHandler(permission);
        final status = statuses[handler];
        results[permission] = _convertStatus(status ?? ph.PermissionStatus.denied);
      }
    } else {
      // For desktop platforms, mark as not applicable
      for (final permission in permissions) {
        results[permission] = PermissionStatus.notApplicable;
      }
    }
    
    return results;
  }

  @override
  Future<bool> openAppSettings() async {
    if (Platform.isIOS || Platform.isAndroid) {
      return await ph.openAppSettings();
    }
    return false;
  }

  ph.Permission _getPermissionHandler(PermissionType permission) {
    switch (permission) {
      case PermissionType.storage:
        return ph.Permission.storage;
      case PermissionType.camera:
        return ph.Permission.camera;
      case PermissionType.microphone:
        return ph.Permission.microphone;
      case PermissionType.location:
        return ph.Permission.location;
    }
  }

  PermissionStatus _convertStatus(ph.PermissionStatus status) {
    switch (status) {
      case ph.PermissionStatus.granted:
        return PermissionStatus.granted;
      case ph.PermissionStatus.denied:
        return PermissionStatus.denied;
      case ph.PermissionStatus.permanentlyDenied:
        return PermissionStatus.permanentlyDenied;
      case ph.PermissionStatus.restricted:
        return PermissionStatus.restricted;
      case ph.PermissionStatus.limited:
        return PermissionStatus.granted; // Treat limited as granted
      case ph.PermissionStatus.provisional:
        return PermissionStatus.granted; // Treat provisional as granted
    }
  }
}

PlatformPermissionServiceBase createPlatformPermissionService() => PlatformPermissionServiceIO();