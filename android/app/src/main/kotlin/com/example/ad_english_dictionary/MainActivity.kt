package com.example.ad_english_dictionary

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity()



//package com.example.ad_english_dictionary
//
//import android.speech.tts.TextToSpeech
//import android.speech.tts.TextToSpeech.OnInitListener
//import android.os.Bundle
//import android.content.Intent
//import android.speech.RecognizerIntent
//import android.app.Activity
//import androidx.annotation.NonNull
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodChannel
//import java.util.Locale
//
//class MainActivity : FlutterActivity() {
//    private val CHANNEL = "com.example.ad_english_dictionary/speech_Text"
//    private val SPEECH_REQUEST_CODE = 1001
//    private var pendingResult: MethodChannel.Result? = null
//    private lateinit var tts: TextToSpeech
//
//    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
//                .setMethodCallHandler { call, result ->
//                    when (call.method) {
//                        "getTextFromSpeech" -> {
//                            val languageISO: String = call.argument("languageISO") ?: "en-US"
//                            startSpeechRecognition(languageISO, result)
//                        }
//                        "translateText" -> {
//                            val text: String = call.argument("text") ?: ""
//                            val sourceLanguage: String = call.argument("sourceLanguage") ?: ""
//                            val targetLanguage: String = call.argument("targetLanguage") ?: ""
//
//                            // Simulate translation (replace this with actual API integration)
//                            val translatedText = "$text [Translated to $targetLanguage]"
//                            result.success(translatedText)
//                        }
//                        else -> result.notImplemented()
//                    }
//                }
//    }
//
//    private fun startSpeechRecognition(languageISO: String, result: MethodChannel.Result) {
//        pendingResult = result
//        val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
//            putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
//            putExtra(RecognizerIntent.EXTRA_LANGUAGE, languageISO)
//            putExtra(RecognizerIntent.EXTRA_PROMPT, "Speak now...")
//        }
//
//        try {
//            startActivityForResult(intent, SPEECH_REQUEST_CODE)
//        } catch (e: Exception) {
//            pendingResult?.error("SpeechError", "Google Speech API not available on this device", null)
//            pendingResult = null
//        }
//    }
//
//    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
//        super.onActivityResult(requestCode, resultCode, data)
//        if (requestCode == SPEECH_REQUEST_CODE) {
//            if (resultCode == Activity.RESULT_OK && data != null) {
//                val results = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS)
//                if (results != null && results.isNotEmpty()) {
//                    pendingResult?.success(results[0]) // Return recognized text to Flutter
//                } else {
//                    pendingResult?.error("SpeechError", "No speech recognized", null)
//                }
//            } else {
//                pendingResult?.error("SpeechError", "Speech recognition failed or was cancelled", null)
//            }
//            pendingResult = null // Prevent memory leaks
//        }
//    }
//}
