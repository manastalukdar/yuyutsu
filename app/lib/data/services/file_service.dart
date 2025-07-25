import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../models/file_source.dart';

abstract class FileService {
  Future<List<FileLocation>> browseFiles();
  Future<Uint8List?> loadFile(FileLocation location);
  Future<bool> hasPermission();
  Future<bool> requestPermission();
}

class LocalFileService implements FileService {
  @override
  Future<bool> hasPermission() async {
    if (Platform.isAndroid) {
      return await Permission.storage.isGranted;
    }
    return true;
  }

  @override
  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true;
  }

  @override
  Future<List<FileLocation>> browseFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'epub', 'txt', 'mobi', 'azw', 'azw3'],
        allowMultiple: true,
      );

      if (result != null) {
        return result.files.map((file) {
          return FileLocation(
            name: file.name,
            path: file.path ?? '',
            source: FileSource.local,
            size: file.size,
            lastModified: DateTime.now(),
          );
        }).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to browse local files: $e');
    }
  }

  @override
  Future<Uint8List?> loadFile(FileLocation location) async {
    try {
      if (location.path.isEmpty) return null;
      
      final file = File(location.path);
      if (!await file.exists()) {
        throw Exception('File not found: ${location.path}');
      }
      
      return await file.readAsBytes();
    } catch (e) {
      throw Exception('Failed to load file: $e');
    }
  }

  Future<List<FileLocation>> getRecentFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final recentDir = Directory('${directory.path}/recent');
      
      if (!await recentDir.exists()) {
        return [];
      }
      
      final files = await recentDir.list().toList();
      return files
          .where((file) => file is File)
          .cast<File>()
          .map((file) {
        final stat = file.statSync();
        return FileLocation(
          name: file.path.split('/').last,
          path: file.path,
          source: FileSource.local,
          size: stat.size,
          lastModified: stat.modified,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }
}

class UrlFileService implements FileService {
  @override
  Future<bool> hasPermission() async => true;

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<List<FileLocation>> browseFiles() async {
    return [];
  }

  @override
  Future<Uint8List?> loadFile(FileLocation location) async {
    try {
      final response = await http.get(Uri.parse(location.path));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      throw Exception('Failed to download file: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to load URL file: $e');
    }
  }

  Future<FileLocation?> loadFromUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      final response = await http.head(uri);
      
      if (response.statusCode == 200) {
        final fileName = uri.pathSegments.isNotEmpty 
            ? uri.pathSegments.last 
            : 'downloaded_file';
        
        final contentLength = response.headers['content-length'];
        final size = contentLength != null ? int.tryParse(contentLength) : null;
        
        return FileLocation(
          name: fileName,
          path: url,
          source: FileSource.url,
          size: size,
          lastModified: DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load URL: $e');
    }
  }
}

class FileServiceManager {
  final LocalFileService _localService = LocalFileService();
  final UrlFileService _urlService = UrlFileService();

  FileService getService(FileSource source) {
    switch (source) {
      case FileSource.local:
        return _localService;
      case FileSource.url:
        return _urlService;
      default:
        throw UnsupportedError('File source $source not yet implemented');
    }
  }

  Future<Uint8List?> loadFile(FileLocation location) async {
    final service = getService(location.source);
    return await service.loadFile(location);
  }

  Future<List<FileLocation>> browseLocalFiles() async {
    return await _localService.browseFiles();
  }

  Future<List<FileLocation>> getRecentFiles() async {
    return await _localService.getRecentFiles();
  }

  Future<FileLocation?> loadFromUrl(String url) async {
    return await _urlService.loadFromUrl(url);
  }

  Future<bool> requestPermissions() async {
    return await _localService.requestPermission();
  }
}