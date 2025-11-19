import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../data/hepler/dictionary_helper.dart';
import '../../../data/models/dictionary_model.dart';

class WordsDetailContrl extends GetxController {
  final DictionaryHelper _helper = DictionaryHelper();
  final stt.SpeechToText _speech = stt.SpeechToText();

  var isListening = false.obs;
  var spokenText = ''.obs;
  var searchText = ''.obs;
  var wordDetails = Rxn<DictionaryDes>();
  var relatedWords = <DictionaryKey>[].obs;
  var recognizedText = ''.obs;
  var showNoResultMessage = false.obs;
  var hasSearched = false.obs;

  final textController = TextEditingController();
  late Debouncer debouncer;

  /// 👇 AI-generated data
  var generatedExamples = <String>[].obs;
  var oppositeWords = <String>[].obs;

  final String mistralApiKey = 'TDMyRjLKPOL83jlG17EnUBdUDN1nxwlR';
  final String mistralApiUrl = 'https://api.mistral.ai/v1/chat/completions';
  final String mistralModel = 'open-mistral-7b';

  @override
  void onInit() {
    super.onInit();
    debouncer = Debouncer(milliseconds: 400);
    ever(searchText, (_) {
      showNoResultMessage.value = false;
    });
    initDB();
  }

  Future<void> initDB() async {
    await _helper.initDatabase();
  }

  Future<void> startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      isListening.value = true;
      _speech.listen(onResult: (result) {
        recognizedText.value = result.recognizedWords;
      });
    }
  }

  void stopListening() {
    _speech.stop();
    isListening.value = false;
  }

  void processRecognizedText(BuildContext context) {
    final text = recognizedText.value.trim();
    if (text.isNotEmpty) {
      searchWord(text);
      searchText.value = text;
    }
  }

  /// 🔍 Search for word details from DB and fetch examples + opposites
  Future<void> searchWord(String wordInput) async {
    final trimmedWord = wordInput.trim();
    showNoResultMessage.value = false;

    if (trimmedWord.isEmpty) {
      searchText.value = '';
      relatedWords.clear();
      wordDetails.value = null;
      hasSearched.value = false;
      generatedExamples.clear();
      oppositeWords.clear();
      return;
    }

    if (searchText.value != trimmedWord) {
      searchText.value = trimmedWord;
    }

    hasSearched.value = true;

    final db = _helper.database;
    final keys = await db.query(
      'Keys',
      where: 'LOWER(word) LIKE ?',
      whereArgs: ['${trimmedWord.toLowerCase()}%'],
      limit: 20,
    );

    relatedWords.value = keys.map((k) => DictionaryKey.fromMap(k)).toList();

    if (keys.isEmpty) {
      wordDetails.value = null;
      generatedExamples.clear();
      oppositeWords.clear();
      showNoResultMessage.value = true;
      return;
    }

    final idRef = keys.first['_idref'];
    final desc = await db.query('description', where: '_id = ?', whereArgs: [idRef]);

    if (desc.isNotEmpty) {
      wordDetails.value = DictionaryDes.fromMap(desc.first);
      await generateExampleAndOpposites(trimmedWord);
    } else {
      wordDetails.value = null;
      generatedExamples.clear();
      oppositeWords.clear();
    }
  }

  Future<void> generateExampleAndOpposites(String word) async {
    generatedExamples.clear();
    oppositeWords.clear();

    try {
      final prompt = '''
Give 5 simple example sentences, ensuring each sentence includes the word "$word".
Then give 5 opposite words of "$word", labeled as:
Examples:
1. ...
2. ...
Opposites: word1, word2, word3, word4, word5
''';
      final messages = [
        {"role": "user", "content": prompt}
      ];

      final response = await http.post(
        Uri.parse(mistralApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $mistralApiKey',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'model': mistralModel,
          'messages': messages,
          'temperature': 0.5,
          'max_tokens': 100,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['choices'][0]['message']['content'] ?? '';

        final lines = text.split('\n').map((e) => e.trim()).toList();

        for (int i = 0; i < lines.length; i++) {
          final line = lines[i];

          if (line.startsWith(RegExp(r'^\d+\.\s*'))) {
            final cleaned = line.replaceFirst(RegExp(r'^\d+\.\s*'), '');
            if (cleaned.isNotEmpty) {
              generatedExamples.add(cleaned);
            }
          } else if (line.toLowerCase().contains('opposite') || line.toLowerCase().contains('antonym')) {
            String raw = '';

            if (line.contains(':')) {
              raw = line.split(':').last;
            } else if (i + 1 < lines.length) {
              raw = lines[i + 1]; // Take next line if no colon
            }

            oppositeWords.assignAll(
              raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty),
            );
          }
        }


        if (generatedExamples.length > 5) {
          generatedExamples.value = generatedExamples.take(5).toList();
        }
      } else {
        print('Mistral API error: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('Mistral Error: $e');
    }
  }


  Future<void> loadWordDetails(int idRef) async {
    final db = _helper.database;
    final desc = await db.query('description', where: '_id = ?', whereArgs: [idRef]);
    if (desc.isNotEmpty) {
      wordDetails.value = DictionaryDes.fromMap(desc.first);
    } else {
      wordDetails.value = null;
    }
  }
}

/// ⏱️ Utility to debounce text input
class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}


