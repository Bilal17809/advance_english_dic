import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/mostWord_model.dart';
import '../models/quiz_model.dart';
class TestQuizDbHelper {
  late Database _db;

  Future<void> initDatabase() async {
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, "db_prahse.db");

    if (!await databaseExists(path)) {
      print("Creating a new copy from assets");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load("assets/db/db_prahse.db");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }

    _db = await openDatabase(path);
  }

  Future<List<QuizModel>> fetchQuizData() async {
    final List<Map<String, dynamic>> maps = await _db.query('ReadTestQuiz');
    return List.generate(maps.length, (i) {
      return QuizModel.fromJson(maps[i]);
    });
  }

  Future<List<QuizModel>> fetchQuizDataBySubLevel(int subLevel) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'ReadTestQuiz',
      where: 'SubLevel = ?',
      whereArgs: [subLevel],
    );
    return List.generate(maps.length, (i) {
      return QuizModel.fromJson(maps[i]);
    });
  }

  Future<void> dispose() async {
    await _db.close();
  }
}