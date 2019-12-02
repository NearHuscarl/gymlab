import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DbHelper {
  /// Get the path to the local database stored on the device
  static Future<String> get dbPath async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath = join(documentsDirectory.path, "data.sqlite");

    if (kDebugMode) {
      try {
        File(dbPath).deleteSync();
      } catch (e) {}
    }

    if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
      final data = await rootBundle.load('assets/data/data.sqlite');
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);
    }

    return dbPath;
  }

  static final String exerciseTable = 'Exercise';
}
