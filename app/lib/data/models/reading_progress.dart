import 'package:equatable/equatable.dart';

class ReadingProgress extends Equatable {
  final String bookId;
  final int currentPage;
  final double progress; // 0.0 to 1.0
  final String? currentChapter;
  final int? currentParagraph;
  final DateTime lastUpdated;
  final int totalReadingTimeMinutes;

  const ReadingProgress({
    required this.bookId,
    required this.currentPage,
    required this.progress,
    this.currentChapter,
    this.currentParagraph,
    required this.lastUpdated,
    this.totalReadingTimeMinutes = 0,
  });

  ReadingProgress copyWith({
    String? bookId,
    int? currentPage,
    double? progress,
    String? currentChapter,
    int? currentParagraph,
    DateTime? lastUpdated,
    int? totalReadingTimeMinutes,
  }) {
    return ReadingProgress(
      bookId: bookId ?? this.bookId,
      currentPage: currentPage ?? this.currentPage,
      progress: progress ?? this.progress,
      currentChapter: currentChapter ?? this.currentChapter,
      currentParagraph: currentParagraph ?? this.currentParagraph,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      totalReadingTimeMinutes: totalReadingTimeMinutes ?? this.totalReadingTimeMinutes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'currentPage': currentPage,
      'progress': progress,
      'currentChapter': currentChapter,
      'currentParagraph': currentParagraph,
      'lastUpdated': lastUpdated.toIso8601String(),
      'totalReadingTimeMinutes': totalReadingTimeMinutes,
    };
  }

  factory ReadingProgress.fromJson(Map<String, dynamic> json) {
    return ReadingProgress(
      bookId: json['bookId'],
      currentPage: json['currentPage'],
      progress: json['progress'].toDouble(),
      currentChapter: json['currentChapter'],
      currentParagraph: json['currentParagraph'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
      totalReadingTimeMinutes: json['totalReadingTimeMinutes'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        bookId,
        currentPage,
        progress,
        currentChapter,
        currentParagraph,
        lastUpdated,
        totalReadingTimeMinutes,
      ];
}