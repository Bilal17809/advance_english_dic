import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

import '../core/constant/constant.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  static Database? _wordsDb;
  static Database? _phrasesDb;
  static Database? _wordGameDb;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    throw ('*****ERROR : Use DatabaseHelper.getInstance()*****');
  }

  static Future<DatabaseHelper> getInstance() async {
    await _instance.ensureInitialize();
    return _instance;
  }

  Future<Database> get grammarDatabase async {
    if (_wordsDb != null) return _wordsDb!;
    _wordsDb = await _initializeDatabase(
      dbFileName: 'wordsnew_db.db',
      assetPath: wordDBPth,
    );
    return _wordsDb!;
  }

  Future<Database> get phrasesDatabase async {
    if (_phrasesDb != null) return _phrasesDb!;
    _phrasesDb = await _initializeDatabase(
      dbFileName: 'dictionary.db',
      assetPath:dictionaryDBPth,
    );
    return _phrasesDb!;
  }

  Future<Database> get wordGameDatabase async {
    if (_wordGameDb != null) return _wordGameDb!;
    _wordGameDb = await _initializeDatabase(
      dbFileName: 'db_prahse.db',
      assetPath:phraseDBPth,
    );
    return _wordGameDb!;
  }


  Future<Database> _initializeDatabase({
    required String dbFileName,
    required String assetPath,
  }) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbFileName);
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    await File(path).writeAsBytes(bytes, flush: true);
    return await openDatabase(path);
  }

  Future<void> ensureInitialize() async {
    try {
      await Future.wait([wordGameDatabase, grammarDatabase, phrasesDatabase]);
      debugPrint('***** SUCCESS: Databases initialize*****');
    } catch (e) {
      debugPrint('***** ERROR: Databases initialize*****');
    }
  }
}
