import 'package:equatable/equatable.dart';

class Bookmark extends Equatable {
  final String id;
  final String bookId;
  final String title;
  final String? note;
  final int pageNumber;
  final String? chapterTitle;
  final String? selectedText;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Bookmark({
    required this.id,
    required this.bookId,
    required this.title,
    this.note,
    required this.pageNumber,
    this.chapterTitle,
    this.selectedText,
    required this.createdAt,
    this.updatedAt,
  });

  Bookmark copyWith({
    String? id,
    String? bookId,
    String? title,
    String? note,
    int? pageNumber,
    String? chapterTitle,
    String? selectedText,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Bookmark(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      title: title ?? this.title,
      note: note ?? this.note,
      pageNumber: pageNumber ?? this.pageNumber,
      chapterTitle: chapterTitle ?? this.chapterTitle,
      selectedText: selectedText ?? this.selectedText,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'title': title,
      'note': note,
      'pageNumber': pageNumber,
      'chapterTitle': chapterTitle,
      'selectedText': selectedText,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'],
      bookId: json['bookId'],
      title: json['title'],
      note: json['note'],
      pageNumber: json['pageNumber'],
      chapterTitle: json['chapterTitle'],
      selectedText: json['selectedText'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        bookId,
        title,
        note,
        pageNumber,
        chapterTitle,
        selectedText,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'Bookmark{id: $id, bookId: $bookId, title: $title, page: $pageNumber}';
  }
}