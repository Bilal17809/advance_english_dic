import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
class SpeakText extends GetxController {
  final pitch = 1.0.obs;
  final speed = 1.0.obs;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playText(BuildContext context,String text, String languageCode) async {
    try {
      final targetLangCode = languageCode;
      final encodedText = Uri.encodeComponent(text);

      // گوگل TTS API میں اسپیکنگ ریٹ اور پچ ایڈجسٹ کرنا
      final url = 'https://translate.google.com/translate_tts?ie=UTF-8'
          '&client=tw-ob'
          '&q=$encodedText'
          '&tl=$targetLangCode'
          '&ttsspeed=${speed.value}' // 🎚️ اسپیکنگ اسپیڈ شامل کریں
          '&pitch=${pitch.value}'; // 🎚️ پچ شامل کریں

      await _audioPlayer.stop();
      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url)));
      await _audioPlayer.setSpeed(speed.value);

      await _audioPlayer.play();
    } catch (e) {
      print('Error playing TTS audio: $e');
    }
  }

  void stopAudio() async {
    try {
      await _audioPlayer.stop();
      print("Audio stopped.");
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }
}