import 'package:sqflite/sqflite.dart';
import '../data/models/models.dart';



class PhrasesDBServices {
  final Database _db;
  PhrasesDBServices({required Database db}) : _db = db;

  Future<List<PartOfSpeech>> fetchMenuData() async {
    final List<Map<String, dynamic>> maps = await _db.query('tbl_new_words');
    return maps.map((json) => PartOfSpeech.fromJson(json)).toList();
  }
}