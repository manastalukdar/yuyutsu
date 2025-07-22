import 'dart:typed_data';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import '../models/file_source.dart';
import 'file_service.dart';

class GoogleDriveService implements FileService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveReadonlyScope],
  );

  drive.DriveApi? _driveApi;
  GoogleSignInAccount? _currentUser;

  @override
  Future<bool> hasPermission() async {
    return _googleSignIn.isSignedIn();
  }

  @override
  Future<bool> requestPermission() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        _currentUser = account;
        final authHeaders = await account.authHeaders;
        final authenticateClient = GoogleAuthClient(authHeaders);
        _driveApi = drive.DriveApi(authenticateClient);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<FileLocation>> browseFiles() async {
    if (_driveApi == null) {
      throw Exception('Google Drive not authenticated');
    }

    try {
      final fileList = await _driveApi!.files.list(
        q: "mimeType contains 'pdf' or mimeType contains 'epub' or mimeType contains 'text'",
        spaces: 'drive',
        $fields: 'files(id,name,size,modifiedTime,mimeType)',
      );

      return fileList.files?.map((file) {
        return FileLocation(
          name: file.name ?? 'Unknown',
          path: file.id ?? '',
          source: FileSource.googleDrive,
          size: file.size != null ? int.tryParse(file.size!) : null,
          lastModified: file.modifiedTime,
          metadata: {
            'mimeType': file.mimeType,
            'driveFileId': file.id,
          },
        );
      }).toList() ?? [];
    } catch (e) {
      throw Exception('Failed to browse Google Drive files: $e');
    }
  }

  @override
  Future<Uint8List?> loadFile(FileLocation location) async {
    if (_driveApi == null) {
      throw Exception('Google Drive not authenticated');
    }

    try {
      final fileId = location.metadata?['driveFileId'] ?? location.path;
      final media = await _driveApi!.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final bytes = <int>[];
      await for (var chunk in media.stream) {
        bytes.addAll(chunk);
      }
      
      return Uint8List.fromList(bytes);
    } catch (e) {
      throw Exception('Failed to download file from Google Drive: $e');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _driveApi = null;
    _currentUser = null;
  }

  GoogleSignInAccount? get currentUser => _currentUser;
  bool get isSignedIn => _currentUser != null;
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }

  @override
  void close() {
    _client.close();
  }
}