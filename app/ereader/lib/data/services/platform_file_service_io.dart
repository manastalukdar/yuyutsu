import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'platform_file_service.dart';

class PlatformFileServiceIO extends PlatformFileServiceBase {
  @override
  Future<String> getApplicationDocumentsPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Future<String> getTemporaryPath() async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  @override
  Future<bool> writeFile(String path, Uint8List data) async {
    try {
      final file = File(path);
      await file.create(recursive: true);
      await file.writeAsBytes(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Uint8List?> readFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        return await file.readAsBytes();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> deleteFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> fileExists(String path) async {
    try {
      final file = File(path);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<String>> listFiles(String directory) async {
    try {
      final dir = Directory(directory);
      if (await dir.exists()) {
        final files = await dir.list().toList();
        return files.where((f) => f is File).map((f) => f.path).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

PlatformFileServiceBase createPlatformFileService() => PlatformFileServiceIO();