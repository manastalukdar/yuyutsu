import 'package:drift/drift.dart';
import '../models/bookmark.dart';
import 'database.dart';

part 'bookmark_dao.g.dart';

@DriftAccessor(tables: [Bookmarks])
class BookmarkDao extends DatabaseAccessor<AppDatabase> with _$BookmarkDaoMixin {
  BookmarkDao(AppDatabase db) : super(db);

  Future<List<Bookmark>> getBookmarksForBook(String bookId) async {
    final bookmarks = await (select(this.bookmarks)
          ..where((b) => b.bookId.equals(bookId))
          ..orderBy([(b) => OrderingTerm.desc(b.createdAt)]))
        .get();
    return bookmarks.map(_bookmarkFromRow).toList();
  }

  Future<Bookmark?> getBookmarkById(String id) async {
    final bookmark = await (select(this.bookmarks)..where((b) => b.id.equals(id))).getSingleOrNull();
    return bookmark != null ? _bookmarkFromRow(bookmark) : null;
  }

  Future<void> insertBookmark(Bookmark bookmark) async {
    await into(bookmarks).insert(_bookmarkToCompanion(bookmark));
  }

  Future<void> updateBookmark(Bookmark bookmark) async {
    await (update(bookmarks)..where((b) => b.id.equals(bookmark.id))).write(_bookmarkToCompanion(bookmark));
  }

  Future<void> deleteBookmark(String id) async {
    await (delete(bookmarks)..where((b) => b.id.equals(id))).go();
  }

  Future<List<Bookmark>> getAllBookmarks() async {
    final bookmarks = await (select(this.bookmarks)
          ..orderBy([(b) => OrderingTerm.desc(b.createdAt)]))
        .get();
    return bookmarks.map(_bookmarkFromRow).toList();
  }

  Future<void> deleteBookmarksForBook(String bookId) async {
    await (delete(bookmarks)..where((b) => b.bookId.equals(bookId))).go();
  }

  Bookmark _bookmarkFromRow(BookmarksData row) {
    return Bookmark(
      id: row.id,
      bookId: row.bookId,
      title: row.title,
      note: row.note,
      pageNumber: row.pageNumber,
      chapterTitle: row.chapterTitle,
      selectedText: row.selectedText,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  BookmarksCompanion _bookmarkToCompanion(Bookmark bookmark) {
    return BookmarksCompanion(
      id: Value(bookmark.id),
      bookId: Value(bookmark.bookId),
      title: Value(bookmark.title),
      note: Value(bookmark.note),
      pageNumber: Value(bookmark.pageNumber),
      chapterTitle: Value(bookmark.chapterTitle),
      selectedText: Value(bookmark.selectedText),
      createdAt: Value(bookmark.createdAt),
      updatedAt: Value(bookmark.updatedAt),
    );
  }
}