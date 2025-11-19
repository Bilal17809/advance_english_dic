import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/conversation_model.dart';
import '../models/mostWord_model.dart';

class DatabaseDServices {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'db_prahse.db');
    print("################## ${path}");

    if (await databaseExists(path)) {
      return await openDatabase(path);
    } else {
      ByteData data = await rootBundle.load('assets/db/db_prahse.db');
      print("################## ${data}");
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
      return await openDatabase(path);
    }
  }

  Future<List<TopicPhrases>> fetchTopics() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Topics');
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return TopicPhrases.fromMap(maps[i]);
      });
    }
    else {
      return [];
    }
  }


  Future<List<TopicPhrasesSentence>> fetchPhraseByTopic(int? id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .query(
      'TopicPhrases',
      where: 'TopicId = ?',
      whereArgs: [
        id
      ],
    );
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return TopicPhrasesSentence.fromMap(maps[i]);
      }); //   }
    } else { // }
      return [];
    }
  }

  Future<List<TopicPhrases>> fetchWord() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Voca5000Words');
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return TopicPhrases.fromMap(maps[i]);
      });
    }
    else {
      return [];
    }
  }

  Future<List<ConversationModel>> fetchConversations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tbl_conversation');
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return ConversationModel.fromMap(maps[i]);
      });
    }
    else {
      return [];
    }
  }

}