import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';
import '../core/common_widgets/country_flag.dart';
import '../presentations/ai_translator/controller/speak_dialog_contrl.dart';
import '../presentations/ai_translator/controller/speak_text_contrl.dart';

class ConversationController extends GetxController {
  final GoogleTranslator translator = GoogleTranslator();
  final SpeakText speakText=Get.put(SpeakText());
  final selectedLanguageC1 = 'English'.obs;
  final selectedLanguageC2 = 'German'.obs;
  final transcribedText = ''.obs;
  final translatedText = ''.obs;
  final isListening = false.obs;
  final loading = false.obs;
  final stt.SpeechToText _speech = stt.SpeechToText();
  Timer? _speechTimer;
  var recognizedText = ''.obs;
  List<String> myList=[];
  final RxList<Map<String, dynamic>> conversationList = <Map<String, dynamic>>[].obs;
  final List<String> rtlLanguages = ['Arabic', 'Hebrew', 'Persian', 'Urdu'];
  bool isRtlLanguage(String language) => rtlLanguages.contains(language);
  final TextEditingController inputTextController=TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadConversationList();
    loadSelectedCountries();
  }

  Future<void> translateWrittenText(BuildContext context) async {
    final text = inputTextController.text.trim();
    if (text.isEmpty) return;

    final fromLang = selectedLanguageC1.value;
    final toLang = selectedLanguageC2.value;

    try {
      var connectivityResults = await Connectivity().checkConnectivity();
      ConnectivityResult connectivityResult = connectivityResults.isNotEmpty
          ? connectivityResults.first
          : ConnectivityResult.none;

      if (connectivityResult == ConnectivityResult.none) {
        showNoInternetDialog(context);
        return;
      }

      loading.value = true;

      final fromCode = languageCodesC[fromLang] ?? 'en';
      final toCode = languageCodesC[toLang] ?? 'en';

      final translation = await translator.translate(
        text,
        from: fromCode,
        to: toCode,
      );

      translatedText.value = translation.text;

      final conversation = {
        'originalText': text,
        'translatedText': translatedText.value,
        'originalLanguage': fromLang,
        'translatedLanguage': toLang,
        'originalLabel': fromLang,
        'translatedLabel': toLang,
        'originalFlag': getFlagEmojiForLanguage(fromLang),
        'translatedFlag': getFlagEmojiForLanguage(toLang),
        'timestamp': DateTime.now().toIso8601String(),
        'isFavorite': false,
      };

      conversationList.insert(0, conversation);
      await saveConversationList();
      await speakText.playText(context, translatedText.value, toCode);
    } catch (e) {
      print("❌ Translation error (written text): $e");
    } finally {
      loading.value = false;
    }
  }


  void toggleFavorite(int index) async {
    final updated = List<Map<String, dynamic>>.from(conversationList);
    updated[index]['isFavorite'] = !(updated[index]['isFavorite'] ?? false);
    conversationList
      ..clear()
      ..addAll(updated);
    await saveConversationList();
  }



  void swapLanguages() {
    final temp = selectedLanguageC1.value;
    selectedLanguageC1.value = selectedLanguageC2.value;
    selectedLanguageC2.value = temp;
  }

  void setSelectedLanguages(String language1, String language2) {
    selectedLanguageC1.value = language1;
    selectedLanguageC2.value = language2;
  }


  Future<void> startSpeechToText(
      BuildContext context, String languageName, bool isRightMic)
  async {
    try {
      String languageCode = languageCodesC[languageName] ?? 'en';
      print("Starting speech recognition for language: $languageCode");

      isListening.value = true;
      recognizedText.value = '';

      bool available = await _speech.initialize(
        onStatus: (status) => print('Status: $status'),
        onError: (error) => print('Error: $error'),
      );

      if (available) {
        _speech.listen(
          onResult: (result) async {
            if (result.recognizedWords.isNotEmpty) {
              recognizedText.value = result.recognizedWords;
              print("Recognized text: ${recognizedText.value}");
            }
          },
          localeId: languageCode,
        );
      } else {
        print("Speech recognition not available");
      }
    } catch (e) {
      print("Error in Speech-to-Text: $e");
    }
  }

  Future<void> stopListening() async {
    await _speech.stop();
    isListening.value = false;
    if (_speechTimer != null && _speechTimer!.isActive) {
      _speechTimer!.cancel();
    }
  }

  void processRecognizedText(bool isRightMic,BuildContext context) {
    transcribedText.value = recognizedText.value;

    if (transcribedText.value.isNotEmpty) {
      if (isRightMic) {
        translateText(context,
          transcribedText.value,
          selectedLanguageC1.value,
          selectedLanguageC2.value,
          isRightMic,
        );
      } else {
        translateText(context,
          transcribedText.value,
          selectedLanguageC2.value,
          selectedLanguageC1.value,
          isRightMic,
        );
      }
    }
  }

  String countryCodeToEmoji(String countryCode) {
    return countryCode.toUpperCase().replaceAllMapped(
      RegExp(r'[A-Z]'),
          (match) =>
          String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
    );
  }
  String getFlagEmojiForLanguage(String languageName) {
    final countryCode = languageFlags[languageName];
    if (countryCode == null) return '🏳️';
    return countryCodeToEmoji(countryCode);
  }


  Future<void> translateText(
      BuildContext context,
      String text,
      String targetLanguage,
      String sourceLanguage,
      bool isRightMic,
      ) async {
    print("Translating text: $text");

    try {
      var connectivityResults = await Connectivity().checkConnectivity();
      ConnectivityResult connectivityResult = connectivityResults.isNotEmpty
          ? connectivityResults.first
          : ConnectivityResult.none;

      if (connectivityResult == ConnectivityResult.none) {
        showNoInternetDialog(context);
        return;
      }

      loading.value = true;

      final sourceLanguageCode = languageCodesC[sourceLanguage] ?? 'en';
      final targetLanguageCode = languageCodesC[targetLanguage] ?? 'en';

      final translation = await translator.translate(
        text,
        from: sourceLanguageCode,
        to: targetLanguageCode,
      );
      translatedText.value = translation.text;

      final originalLang = isRightMic ? selectedLanguageC2.value : selectedLanguageC1.value;
      final translatedLang = isRightMic ? selectedLanguageC1.value : selectedLanguageC2.value;

      final conversation = {
        'originalText': text,
        'translatedText': translatedText.value,
        'originalLanguage': originalLang,
        'translatedLanguage': translatedLang,
        'originalLabel': originalLang,
        'translatedLabel': translatedLang,
        'originalFlag': getFlagEmojiForLanguage(originalLang),
        'translatedFlag': getFlagEmojiForLanguage(translatedLang),
        'timestamp': DateTime.now().toIso8601String(),
        'isFavorite': false,
      };
      conversationList.insert(0, conversation);
      await saveConversationList();
      await speakText.playText(context, translatedText.value, targetLanguageCode);
    } catch (e) {
      print("Translation error: $e");
    } finally {
      loading.value = false;
    }
  }


  Future<void> saveConversationList() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('conversationList', jsonEncode(conversationList));
  }

  Future<List<Map<String, dynamic>>> loadConversationList() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('conversationList');
    if (savedData != null) {
      final List<dynamic> jsonData = jsonDecode(savedData);
      final loadedData = jsonData.cast<Map<String, dynamic>>();
      conversationList.assignAll(loadedData);
      cleanOldConversations();
      return conversationList;
    }
    return [];
  }

  Future<void> cleanOldConversations() async {
    final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
    conversationList.removeWhere((conversation) {
      final timestamp = DateTime.parse(conversation['Timestamp']);
      return timestamp.isBefore(threeDaysAgo);
    });
    saveConversationList();
  }

  Future<void> saveSelectedCountry(String key, String country) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, country);
  }
  Future<void> loadSelectedCountries() async {
    final prefs = await SharedPreferences.getInstance();
    selectedLanguageC1.value = prefs.getString('selectedCountry1') ?? selectedLanguageC1.value;
    selectedLanguageC2.value = prefs.getString('selectedCountry2') ?? selectedLanguageC2.value;
  }
}
