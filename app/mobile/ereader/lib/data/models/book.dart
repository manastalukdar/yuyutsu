import 'package:equatable/equatable.dart';

enum BookFormat { epub, pdf, txt, mobi }

class Book extends Equatable {
  final String id;
  final String title;
  final String author;
  final String? description;
  final String filePath;
  final BookFormat format;
  final String? coverPath;
  final DateTime dateAdded;
  final DateTime? lastOpened;
  final int totalPages;
  final int currentPage;
  final double readingProgress; // 0.0 to 1.0
  final Map<String, dynamic>? metadata;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    this.description,
    required this.filePath,
    required this.format,
    this.coverPath,
    required this.dateAdded,
    this.lastOpened,
    this.totalPages = 0,
    this.currentPage = 0,
    this.readingProgress = 0.0,
    this.metadata,
  });

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? filePath,
    BookFormat? format,
    String? coverPath,
    DateTime? dateAdded,
    DateTime? lastOpened,
    int? totalPages,
    int? currentPage,
    double? readingProgress,
    Map<String, dynamic>? metadata,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      filePath: filePath ?? this.filePath,
      format: format ?? this.format,
      coverPath: coverPath ?? this.coverPath,
      dateAdded: dateAdded ?? this.dateAdded,
      lastOpened: lastOpened ?? this.lastOpened,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      readingProgress: readingProgress ?? this.readingProgress,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'filePath': filePath,
      'format': format.name,
      'coverPath': coverPath,
      'dateAdded': dateAdded.toIso8601String(),
      'lastOpened': lastOpened?.toIso8601String(),
      'totalPages': totalPages,
      'currentPage': currentPage,
      'readingProgress': readingProgress,
      'metadata': metadata,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      filePath: json['filePath'],
      format: BookFormat.values.byName(json['format']),
      coverPath: json['coverPath'],
      dateAdded: DateTime.parse(json['dateAdded']),
      lastOpened: json['lastOpened'] != null 
          ? DateTime.parse(json['lastOpened']) 
          : null,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      readingProgress: json['readingProgress']?.toDouble() ?? 0.0,
      metadata: json['metadata'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        author,
        description,
        filePath,
        format,
        coverPath,
        dateAdded,
        lastOpened,
        totalPages,
        currentPage,
        readingProgress,
        metadata,
      ];

  @override
  String toString() {
    return 'Book{id: $id, title: $title, author: $author, format: $format}';
  }
}