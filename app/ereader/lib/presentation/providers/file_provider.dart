import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/file_source.dart';
import '../../data/services/file_service.dart';

class FileState {
  final List<FileLocation> files;
  final List<FileLocation> recentFiles;
  final bool isLoading;
  final String? error;

  const FileState({
    this.files = const [],
    this.recentFiles = const [],
    this.isLoading = false,
    this.error,
  });

  FileState copyWith({
    List<FileLocation>? files,
    List<FileLocation>? recentFiles,
    bool? isLoading,
    String? error,
  }) {
    return FileState(
      files: files ?? this.files,
      recentFiles: recentFiles ?? this.recentFiles,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FileNotifier extends StateNotifier<FileState> {
  FileNotifier() : super(const FileState());
  
  final FileServiceManager _fileManager = FileServiceManager();

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void setFiles(List<FileLocation> files) {
    state = state.copyWith(files: files, error: null);
  }

  void addFile(FileLocation file) {
    final updatedFiles = [...state.files, file];
    state = state.copyWith(files: updatedFiles);
  }

  void removeFile(FileLocation file) {
    final updatedFiles = state.files.where((f) => f.path != file.path).toList();
    state = state.copyWith(files: updatedFiles);
  }

  Future<void> loadRecentFiles() async {
    try {
      setLoading(true);
      final recentFiles = await _fileManager.getRecentFiles();
      state = state.copyWith(
        recentFiles: recentFiles,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearFiles() {
    state = state.copyWith(files: []);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final fileProvider = StateNotifierProvider<FileNotifier, FileState>((ref) {
  return FileNotifier();
});