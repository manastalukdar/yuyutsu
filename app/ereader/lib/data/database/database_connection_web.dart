import 'package:drift/drift.dart';
import 'package:drift/web.dart';

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    return WebDatabase.withStorage(await DriftWebStorage.indexedDbIfSupported('yuyutsu_ereader_db'));
  });
}