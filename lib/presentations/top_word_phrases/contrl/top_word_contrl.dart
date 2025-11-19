import 'package:get/get.dart';

import '../../../data/hepler/top_phrases.dart';
import '../../../data/models/mostWord_model.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TopicController extends GetxController {
  var topicList = <TopicPhrases>[].obs;
  var phrasesList = <TopicPhrasesSentence>[].obs;
  final dbHelper = DatabaseDServices();
  final FlutterTts flutterTts = FlutterTts();

  var searchText = ''.obs;

  List<TopicPhrases> get filteredTopics {
    if (searchText.isEmpty) return topicList;
    return topicList
        .where((topic) =>
    topic.title?.toLowerCase().contains(searchText.value.toLowerCase()) ??
        false)
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadTopics();
    _initTts();
  }

  void _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }
  void speakText(String text) async {
    if (text.trim().isEmpty) return;

    await flutterTts.stop();
    await flutterTts.speak(text.trim());
  }

  void loadTopics() async {
    try {
      final topics = await dbHelper.fetchTopics();
      topicList.assignAll(topics);
    } catch (e) {
      print("Error loading topics: $e");
    }
  }

  void loadPhrases(int ids) async {
    try {
      final topics = await dbHelper.fetchPhraseByTopic(ids);
      phrasesList.assignAll(topics);
    } catch (e) {
      print("Error loading phrases: $e");
    }
  }
}

