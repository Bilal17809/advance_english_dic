import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/dictionary_model.dart';
import '../models/models.dart';

class DictionaryHelper {
  late Database _db;

  Future<void> initDatabase() async {
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, "dictionary.db");

    var exists = await databaseExists(path);

    if (!exists) {
      print("Creating a new copy from assets");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load("assets/db/dictionary.db");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    _db = await openDatabase(path);
  }

  Future<List<DictionaryKey>> fetchKey() async {
    final List<Map<String, dynamic>> maps = await _db.query('Keys');
    return List.generate(maps.length, (i) {
      return DictionaryKey.fromMap(maps[i]);
    });
  }

  Database get database => _db;
  Future<void> dispose() async {
    await _db.close();
  }

  Future<List<DictionaryDes>> fetchDescription() async {
    final List<Map<String, dynamic>> maps = await _db.query('description');
    return List.generate(maps.length, (i) {
      return DictionaryDes.fromMap(maps[i]);
    });
  }


}