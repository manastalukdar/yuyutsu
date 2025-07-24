import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/file_source.dart';
import 'file_service.dart';

enum FileFormat {
  pdf,
  epub,
  txt,
  mobi,
  azw,
  azw3,
  unknown,
}

class FileContent {
  final String title;
  final String? author;
  final List<String> chapters;
  final FileFormat format;
  final FileLocation source;
  final Map<String, dynamic>? metadata;

  const FileContent({
    required this.title,
    this.author,
    required this.chapters,
    required this.format,
    required this.source,
    this.metadata,
  });
}

class FileReaderService {
  final FileServiceManager _fileManager = FileServiceManager();

  Future<FileContent?> readFile(FileLocation location) async {
    try {
      final bytes = await _fileManager.loadFile(location);
      if (bytes == null) return null;

      final format = _detectFileFormat(location.name, bytes);
      
      switch (format) {
        case FileFormat.txt:
          return _readTextFile(location, bytes);
        case FileFormat.epub:
          return _readEpubFile(location, bytes);
        case FileFormat.pdf:
          return _readPdfFile(location, bytes);
        default:
          throw UnsupportedError('File format $format not supported yet');
      }
    } catch (e) {
      throw Exception('Failed to read file: $e');
    }
  }

  FileFormat _detectFileFormat(String fileName, Uint8List bytes) {
    final extension = fileName.split('.').last.toLowerCase();
    
    switch (extension) {
      case 'pdf':
        return FileFormat.pdf;
      case 'epub':
        return FileFormat.epub;
      case 'txt':
        return FileFormat.txt;
      case 'mobi':
        return FileFormat.mobi;
      case 'azw':
        return FileFormat.azw;
      case 'azw3':
        return FileFormat.azw3;
      default:
        // Try to detect by content
        return _detectFormatByContent(bytes);
    }
  }

  FileFormat _detectFormatByContent(Uint8List bytes) {
    if (bytes.length < 4) return FileFormat.unknown;
    
    // PDF magic number
    if (bytes[0] == 0x25 && bytes[1] == 0x50 && bytes[2] == 0x44 && bytes[3] == 0x46) {
      return FileFormat.pdf;
    }
    
    // ZIP (EPUB is a ZIP file)
    if (bytes[0] == 0x50 && bytes[1] == 0x4B) {
      return FileFormat.epub;
    }
    
    // Try to decode as text
    try {
      utf8.decode(bytes.take(1000).toList());
      return FileFormat.txt;
    } catch (e) {
      return FileFormat.unknown;
    }
  }

  Future<FileContent> _readTextFile(FileLocation location, Uint8List bytes) async {
    try {
      final content = utf8.decode(bytes);
      final lines = content.split('\n');
      
      // Simple chapter detection for text files
      final chapters = <String>[];
      String currentChapter = '';
      
      for (final line in lines) {
        // Basic chapter detection - lines that start with "Chapter" or are all caps
        if (_isChapterHeader(line) && currentChapter.isNotEmpty) {
          chapters.add(currentChapter.trim());
          currentChapter = line + '\n';
        } else {
          currentChapter += line + '\n';
        }
      }
      
      if (currentChapter.isNotEmpty) {
        chapters.add(currentChapter.trim());
      }
      
      if (chapters.isEmpty) {
        chapters.add(content);
      }
      
      return FileContent(
        title: _extractTitle(location.name),
        author: null,
        chapters: chapters,
        format: FileFormat.txt,
        source: location,
      );
    } catch (e) {
      throw Exception('Failed to read text file: $e');
    }
  }

  Future<FileContent> _readEpubFile(FileLocation location, Uint8List bytes) async {
    // For now, return a placeholder - full EPUB parsing would require additional libraries
    return FileContent(
      title: _extractTitle(location.name),
      author: 'Unknown Author',
      chapters: ['EPUB support coming soon. This is a placeholder for ${location.name}'],
      format: FileFormat.epub,
      source: location,
      metadata: {'note': 'Full EPUB parsing will be implemented using epub_view package'},
    );
  }

  Future<FileContent> _readPdfFile(FileLocation location, Uint8List bytes) async {
    // For now, return a placeholder - full PDF parsing would require additional processing
    return FileContent(
      title: _extractTitle(location.name),
      author: 'Unknown Author',
      chapters: ['PDF support coming soon. This is a placeholder for ${location.name}'],
      format: FileFormat.pdf,
      source: location,
      metadata: {'note': 'Full PDF parsing will be implemented using syncfusion_flutter_pdf package'},
    );
  }

  bool _isChapterHeader(String line) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) return false;
    
    // Check for common chapter patterns
    final chapterPatterns = [
      RegExp(r'^Chapter\s+\d+', caseSensitive: false),
      RegExp(r'^Ch\.\s*\d+', caseSensitive: false),
      RegExp(r'^\d+\.\s*[A-Z]', caseSensitive: false),
      RegExp(r'^[A-Z\s]{3,}$'), // All caps lines (often chapter titles)
    ];
    
    return chapterPatterns.any((pattern) => pattern.hasMatch(trimmed));
  }

  String _extractTitle(String fileName) {
    // Remove file extension and clean up the name
    final nameWithoutExtension = fileName.contains('.') 
        ? fileName.substring(0, fileName.lastIndexOf('.'))
        : fileName;
    
    // Replace underscores and dashes with spaces
    return nameWithoutExtension
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty 
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : word)
        .join(' ')
        .trim();
  }

  List<String> getSupportedExtensions() {
    return ['pdf', 'epub', 'txt', 'mobi', 'azw', 'azw3'];
  }

  bool isFormatSupported(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return getSupportedExtensions().contains(extension);
  }
}