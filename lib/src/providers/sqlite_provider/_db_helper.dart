import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../../helpers/logger.dart';

class DbHelper {
  static String get dbName => kReleaseMode ? 'data.sqlite' : 'data.test.sqlite';

  // /data/user/0/com.example.gymlab/app_flutter/data.sqlite
  static Future<void> setupDbFile() async {
    final dbPath = await getDbPath();

    L.debug('init database');

    if (!kReleaseMode) {
      try {
        L.warning('detele database');
        await File(dbPath).delete();
      } catch (e) {
        L.error(e);
      }
    }

    // move the database file from assets/ folder to app document directory
    // so sqflite can access it
    if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
      final data = await rootBundle.load('assets/data/$dbName');
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);
    }
  }

  /// Get the path to the local database stored on the device
  static Future<String> getDbPath() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath = join(documentsDirectory.path, dbName);

    return dbPath;
  }
}
