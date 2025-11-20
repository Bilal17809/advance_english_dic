import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class DictionaryController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final isListening = false.obs;
  final recognizedText = ''.obs;
  late stt.SpeechToText speech;
  final wordDefinition = <String, List<String>>{}.obs;
  final synonyms = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    speech = stt.SpeechToText();
    clearData();
  }

  void clearData() {
    wordDefinition.clear();
    synonyms.clear();
    textController.clear();
  }

  Future<void> fetchWordDetails(String word) async {
    wordDefinition.clear();
    synonyms.clear();

    try {
      final url = "https://api.dictionaryapi.dev/api/v2/entries/en/$word";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final meanings = data[0]['meanings'];

        for (var meaning in meanings) {
          String partOfSpeech = meaning['partOfSpeech'];
          List<String> definitions = [];

          for (var def in meaning['definitions']) {
            if (def['definition'] != null) {
              definitions.add(def['definition']);
            }
            if (def['synonyms'] != null && def['synonyms'].isNotEmpty) {
              synonyms.addAll(List<String>.from(def['synonyms']));
            }
          }

          if (definitions.isNotEmpty) {
            wordDefinition[partOfSpeech] = definitions;
          }
        }

        synonyms.value = synonyms.toSet().toList(); // Remove duplicates
      } else {
        wordDefinition['Error'] = ['Word not found.'];
      }
    } catch (e) {
      wordDefinition['Error'] = ['Failed to fetch data: ${e.toString()}'];
    }
  }

  Future<void> startSpeechToText(BuildContext context) async {
    final available = await speech.initialize();
    if (available) {
      isListening.value = true;
      speech.listen(
        onResult: (result) {
          recognizedText.value = result.recognizedWords;
        },
      );
    }
  }

  void stopListening() {
    if (speech.isListening) {
      speech.stop();
    }
    isListening.value = false;
  }

  void processRecognizedText(BuildContext context) {
    if (recognizedText.isNotEmpty) {
      textController.text = recognizedText.value;
      fetchWordDetails(recognizedText.value);
    }
  }
}
