import 'package:drift/drift.dart';
import 'package:drift/web.dart';

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    return WebDatabase.withStorage(await DriftWebStorage.indexedDbIfSupported('ereader_db'));
  });
}