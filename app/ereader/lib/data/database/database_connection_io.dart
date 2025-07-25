import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    // Make sqlite3 available for desktop platforms
    if (Platform.isLinux || Platform.isWindows) {
      sqlite3.tempDirectory = (await getTemporaryDirectory()).path;
    }

    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'yuyutsu_ereader.db'));
    
    return NativeDatabase.createInBackground(file);
  });
}