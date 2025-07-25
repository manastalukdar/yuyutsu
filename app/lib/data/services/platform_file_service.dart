import 'dart:typed_data';
import 'package:flutter/foundation.dart';

// Conditional imports
import 'platform_file_service_io.dart' if (dart.library.html) 'platform_file_service_web.dart';

abstract class PlatformFileServiceBase {
  Future<String> getApplicationDocumentsPath();
  Future<String> getTemporaryPath();
  Future<bool> writeFile(String path, Uint8List data);
  Future<Uint8List?> readFile(String path);
  Future<bool> deleteFile(String path);
  Future<bool> fileExists(String path);
  Future<List<String>> listFiles(String directory);
}

// Factory method to get the appropriate implementation
PlatformFileServiceBase getPlatformFileService() => createPlatformFileService();