import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/models.dart';

class QuizDatabaseService {
  late Database _db;

  Future<void> initDatabase() async {
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, "wordsnew_db.db");

    var exists = await databaseExists(path);

    if (!exists) {
      print("Creating a new copy from assets");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load("assets/db/wordsnew_db.db");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    _db = await openDatabase(path);
  }

  Future<List<PartOfSpeech>> fetchMenuData() async {
    final List<Map<String, dynamic>> maps = await _db.query('tbl_new_words');
    return List.generate(maps.length, (i) {
      return PartOfSpeech.fromJson(maps[i]);
    });
  }

  Future<void> dispose() async {
    await _db.close();
  }
}