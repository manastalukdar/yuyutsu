import 'package:drift/drift.dart';
import '../models/reading_progress.dart';
import 'database.dart';

part 'reading_progress_dao.g.dart';

@DriftAccessor(tables: [ReadingProgresses])
class ReadingProgressDao extends DatabaseAccessor<AppDatabase> with _$ReadingProgressDaoMixin {
  ReadingProgressDao(AppDatabase db) : super(db);

  Future<ReadingProgress?> getProgressForBook(String bookId) async {
    final progress = await (select(this.readingProgresses)..where((p) => p.bookId.equals(bookId))).getSingleOrNull();
    return progress != null ? _progressFromRow(progress) : null;
  }

  Future<void> upsertProgress(ReadingProgress progress) async {
    await into(readingProgresses).insertOnConflictUpdate(_progressToCompanion(progress));
  }

  Future<void> deleteProgressForBook(String bookId) async {
    await (delete(readingProgresses)..where((p) => p.bookId.equals(bookId))).go();
  }

  Future<List<ReadingProgress>> getAllProgress() async {
    final progresses = await (select(this.readingProgresses)
          ..orderBy([(p) => OrderingTerm.desc(p.lastUpdated)]))
        .get();
    return progresses.map(_progressFromRow).toList();
  }

  Future<List<ReadingProgress>> getRecentlyRead({int limit = 10}) async {
    final progresses = await (select(this.readingProgresses)
          ..orderBy([(p) => OrderingTerm.desc(p.lastUpdated)])
          ..limit(limit))
        .get();
    return progresses.map(_progressFromRow).toList();
  }

  ReadingProgress _progressFromRow(ReadingProgressesData row) {
    return ReadingProgress(
      bookId: row.bookId,
      currentPage: row.currentPage,
      progress: row.progress,
      currentChapter: row.currentChapter,
      currentParagraph: row.currentParagraph,
      lastUpdated: row.lastUpdated,
      totalReadingTimeMinutes: row.totalReadingTimeMinutes,
    );
  }

  ReadingProgressesCompanion _progressToCompanion(ReadingProgress progress) {
    return ReadingProgressesCompanion(
      bookId: Value(progress.bookId),
      currentPage: Value(progress.currentPage),
      progress: Value(progress.progress),
      currentChapter: Value(progress.currentChapter),
      currentParagraph: Value(progress.currentParagraph),
      lastUpdated: Value(progress.lastUpdated),
      totalReadingTimeMinutes: Value(progress.totalReadingTimeMinutes),
    );
  }
}