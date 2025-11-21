import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../adds/rewarded_intertitial.dart';
import '../../../core/animation/animation_games.dart';
import '../../remove_ads_contrl/remove_ads_contrl.dart';

final String mistralApiKey = 'TDMyRjLKPOL83jlG17EnUBdUDN1nxwlR';
final String mistralApiUrl = 'https://api.mistral.ai/v1/chat/completions';
final String mistralModel = 'open-mistral-7b';

class AiCenterController extends GetxController {

  late stt.SpeechToText speech;
  var recognizedText = ''.obs;
  var inputText = ''.obs;
  var isLoading = false.obs;
  var responseText = ''.obs;
  RxBool isPostAdAllowed = false.obs;
  final RemoveAds removeAds = Get.put(RemoveAds());
  final splashAd = Get.find<RewardAdController>();

  final RxString hintText = ''.obs;
  final Rx<Color> hintTextColor = Colors.black.obs;
  final List<String> hintMessages = [
    'Write a professional job application for a marketing position.Create a detailed proposal for launching a new product.',
    'Draft a formal email to request a client meeting.Write a respectful resignation letter to your manager.',
    'Generate a personalized cover letter specifically tailored for a developer position, highlighting relevant skills',
  ];

  final List<Color> hintColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  RxInt interactionCount = 0.obs;
  final int maxFreeInteractions = 2;

  @override
  void onInit() {
    super.onInit();
    speech = stt.SpeechToText();
    loadInteractionCount();
    splashAd.loadAd();
  }


  Future<void> loadInteractionCount() async {
    final prefs = await SharedPreferences.getInstance();
    interactionCount.value = prefs.getInt('interactionCount') ?? 0;
  }

  Future<void> incrementInteractionCount() async {
    final prefs = await SharedPreferences.getInstance();
    interactionCount.value++;
    await prefs.setInt('interactionCount', interactionCount.value);
  }

  Future<void> resetInteractionCount() async {
    final prefs = await SharedPreferences.getInstance();
    interactionCount.value = 0;
    await prefs.setInt('interactionCount', 0);
  }

  void startSpeechToText(BuildContext context) async {
      bool available = await speech.initialize(
        onStatus: (status) => print('Speech status: $status'),
        onError: (error) => print('Speech error: $error'),
      );

      if (available) {
        speech.listen(
          onResult: (result) {
            recognizedText.value = result.recognizedWords;
          },
        );
      } else {
        recognizedText.value = 'Speech recognition unavailable';
      }
  }

  void stopListening() {
    speech.stop();
  }

  void processRecognizedText(TextEditingController controller) {
    if (recognizedText.value.isNotEmpty) {
      controller.text = recognizedText.value;
      inputText.value = recognizedText.value;
    }
  }

  Future<void> generateResponse(BuildContext context) async {
    if (!Get.find<RemoveAds>().isSubscribedGet.value) {
      if (interactionCount.value >= maxFreeInteractions &&
          !isPostAdAllowed.value)
      {
        showCustomDialog(
          context: context,
          imagePath: "assets/limited.png",
          title: "Limit Reached",
          message: "You’ve used your 2 free messages.Please watch an ad to continue or go Premium.",
          leftButtonText: "Cancel",
          rightButtonText: "Watch Ads",
            onRightTap: () async {
              Navigator.of(context).pop();
              if (!splashAd.isAdLoaded.value) {
                showAdNotReadyDialog(context);
                return;
              }
              if (splashAd.isAdLoaded.value) {
                 splashAd.showAd(onAdComplete: () async {
                  await resetInteractionCount();
                  isPostAdAllowed.value = true;
                  if (inputText.value.isNotEmpty) {
                    await generateResponse(context);
                  }
                });
              }

              else {
                showAdNotReadyDialog(context);
              }
            }
        );
        return;
      } else if (isPostAdAllowed.value) {
        isPostAdAllowed.value = false;
      } else {
        await incrementInteractionCount();
      }
    }

    if (inputText.value.isEmpty) return;

    isLoading.value = true;
    responseText.value = '';

    try {
      final userInput = 'Please respond briefly: ${inputText.value.trim()}';

      final messages = [
        {"role": "user", "content": userInput}
      ];

      final response = await http.post(
        Uri.parse(mistralApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $mistralApiKey',
        },
        body: jsonEncode({
          'model': mistralModel,
          'messages': messages,
          'temperature': 0.3,
          'max_tokens': 100,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final content = responseData['choices'][0]['message']['content'];
        responseText.value = content ?? 'No response from Mistral.';
      } else {
        responseText.value = 'Error ${response.statusCode}: ${response.body}';
      }
    } catch (e) {
      responseText.value = 'Mistral error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
