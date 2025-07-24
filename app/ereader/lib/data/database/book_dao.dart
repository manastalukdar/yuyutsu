import 'package:drift/drift.dart';
import '../models/book.dart' as model;
import 'database.dart';
import 'dart:convert';

part 'book_dao.g.dart';

@DriftAccessor(tables: [Books])
class BookDao extends DatabaseAccessor<AppDatabase> with _$BookDaoMixin {
  BookDao(AppDatabase db) : super(db);

  Future<List<model.Book>> getAllBooks() async {
    final books = await select(this.books).get();
    return books.map(_bookFromRow).toList();
  }

  Future<model.Book?> getBookById(String id) async {
    final book = await (select(this.books)..where((b) => b.id.equals(id))).getSingleOrNull();
    return book != null ? _bookFromRow(book) : null;
  }

  Future<void> insertBook(model.Book book) async {
    await into(books).insert(_bookToCompanion(book));
  }

  Future<void> updateBook(model.Book book) async {
    await (update(books)..where((b) => b.id.equals(book.id))).write(_bookToCompanion(book));
  }

  Future<void> deleteBook(String id) async {
    await (delete(books)..where((b) => b.id.equals(id))).go();
  }

  Future<List<model.Book>> getRecentBooks({int limit = 10}) async {
    final books = await (select(this.books)
          ..where((b) => b.lastOpened.isNotNull())
          ..orderBy([(b) => OrderingTerm.desc(b.lastOpened)])
          ..limit(limit))
        .get();
    return books.map(_bookFromRow).toList();
  }

  Future<List<model.Book>> searchBooks(String query) async {
    final books = await (select(this.books)
          ..where((b) => 
              b.title.contains(query) | 
              b.author.contains(query) |
              (b.description.isNotNull() & b.description.contains(query))))
        .get();
    return books.map(_bookFromRow).toList();
  }

  model.Book _bookFromRow(BooksData row) {
    return model.Book(
      id: row.id,
      title: row.title,
      author: row.author,
      description: row.description,
      filePath: row.filePath,
      format: model.BookFormat.values.byName(row.format),
      coverPath: row.coverPath,
      dateAdded: row.dateAdded,
      lastOpened: row.lastOpened,
      totalPages: row.totalPages,
      currentPage: row.currentPage,
      readingProgress: row.readingProgress,
      metadata: row.metadata != null ? jsonDecode(row.metadata!) : null,
    );
  }

  BooksCompanion _bookToCompanion(model.Book book) {
    return BooksCompanion(
      id: Value(book.id),
      title: Value(book.title),
      author: Value(book.author),
      description: Value(book.description),
      filePath: Value(book.filePath),
      format: Value(book.format.name),
      coverPath: Value(book.coverPath),
      dateAdded: Value(book.dateAdded),
      lastOpened: Value(book.lastOpened),
      totalPages: Value(book.totalPages),
      currentPage: Value(book.currentPage),
      readingProgress: Value(book.readingProgress),
      metadata: Value(book.metadata != null ? jsonEncode(book.metadata) : null),
    );
  }
}