import 'dart:typed_data';
import 'dart:html' as html;
import 'dart:convert';
import 'platform_file_service.dart';

class PlatformFileServiceWeb extends PlatformFileServiceBase {
  static const String _storagePrefix = 'ereader_files_';
  
  @override
  Future<String> getApplicationDocumentsPath() async {
    // For web, we'll use a virtual path since there's no real file system
    return '/documents';
  }

  @override
  Future<String> getTemporaryPath() async {
    // For web, we'll use a virtual path
    return '/temp';
  }

  @override
  Future<bool> writeFile(String path, Uint8List data) async {
    try {
      final key = _storagePrefix + path;
      final base64Data = base64Encode(data);
      html.window.localStorage[key] = base64Data;
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Uint8List?> readFile(String path) async {
    try {
      final key = _storagePrefix + path;
      final base64Data = html.window.localStorage[key];
      if (base64Data != null) {
        return base64Decode(base64Data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> deleteFile(String path) async {
    try {
      final key = _storagePrefix + path;
      html.window.localStorage.remove(key);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> fileExists(String path) async {
    try {
      final key = _storagePrefix + path;
      return html.window.localStorage.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<String>> listFiles(String directory) async {
    try {
      final keys = html.window.localStorage.keys
          .where((key) => key.startsWith(_storagePrefix))
          .map((key) => key.substring(_storagePrefix.length))
          .where((path) => path.startsWith(directory))
          .toList();
      return keys;
    } catch (e) {
      return [];
    }
  }
}

PlatformFileServiceBase createPlatformFileService() => PlatformFileServiceWeb();