import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../adds/binner_adds.dart';
import '../../../adds/instertial_adds.dart';
import '../../../adds/open_screen.dart';
import '../../../core/common_widgets/bg_circular.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../../../core/common_widgets/round_image.dart';
import '../../../core/common_widgets/textform_field.dart';
import '../../../core/constant/constant.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../ai_translator/controller/speak_dialog_contrl.dart';
import '../../remove_ads_contrl/remove_ads_contrl.dart';
import '../controller/ai_dictionary_controlerl.dart';

class AiDictionaryPage extends StatefulWidget {
  const AiDictionaryPage({super.key});

  @override
  State<AiDictionaryPage> createState() => _AiDictionaryPageState();
}
class _AiDictionaryPageState extends State<AiDictionaryPage> {
  final DictionaryController controller = Get.put(DictionaryController());
  final RemoveAds removeAds = Get.put(RemoveAds());
  final AppOpenAdController appOpenAdController=Get.put(AppOpenAdController());
  final InterstitialAdController interstitialAdController=Get.put(InterstitialAdController());

  @override
  void initState() {
    super.initState();
    controller.clearData();
    if (!removeAds.isSubscribedGet.value) {
      interstitialAdController.checkAndShowAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundCircles(),
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: BackIconButton(),
                  ),
                  Center(
                    child: Text(
                      "AI Dictionary",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding:  EdgeInsets.only(top:80, left: kBodyHp, right: kBodyHp),
              child: Container(
                decoration: roundedDecoration,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: roundedDecoration,
                      padding: const EdgeInsets.all(10),
                      child: CustomTextFormField(
                        hintText: 'Search Word',
                        hintTextColor: Colors.grey,
                        style: TextStyle(fontSize:15),
                        controller: controller.textController,
                        textAlign: TextAlign.start,
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RoundedButton(
                              backgroundColor: dividerColor,
                              child: const Icon(Icons.keyboard_voice, color: kBlue),
                              onTap: () async {
                                final connectivityResult = await Connectivity().checkConnectivity();
                                if (!connectivityResult.contains(ConnectivityResult.mobile) &&
                                    !connectivityResult.contains(ConnectivityResult.wifi)) {
                                  if (!context.mounted) return;
                                  await showNoInternetDialog(context);
                                }
                                else{
                                  await showSpeakDialog(context, controller);
                                }
                              },
                            ),
                            const SizedBox(width: 10),
                            RoundedButton(
                              backgroundColor: dividerColor,
                              child: const Icon(Icons.send, color: kBlue),
                              onTap: () async{
                                final connectivityResult = await Connectivity().checkConnectivity();
                                if (!connectivityResult.contains(ConnectivityResult.mobile) &&
                                    !connectivityResult.contains(ConnectivityResult.wifi)) {
                                  if (!context.mounted) return;
                                  await showNoInternetDialog(context);
                                }
                                else{
                                  controller.fetchWordDetails(controller.textController.text);
                                }
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Obx(() {
                        if (controller.wordDefinition.isEmpty) {
                          return  Center(child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/search11.png',
                              height: 55,width: 55,color:kBlue,),
                              SizedBox(height:8,),
                              Text("Enter a word to get details.",
                              style:context.textTheme.labelMedium,),
                            ],
                          ));
                        }
                        return ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            ...controller.wordDefinition.entries.map((entry) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.key,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ...entry.value.map(
                                        (def) => Padding(
                                      padding: const EdgeInsets.only(left: 12, bottom: 6),
                                      child: Text(
                                        "• $def",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            }),
                            if (controller.synonyms.isNotEmpty) ...[
                              const Text(
                                "Synonyms",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: controller.synonyms
                                    .map((syn) => Chip(
                                  label: Text(syn),
                                  backgroundColor: Colors.grey.shade200,
                                ))
                                    .toList(),
                              ),
                              const SizedBox(height: 16),

                            ]
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        final interstitial = Get.find<InterstitialAdController>();
        return interstitial.isAdReady.value
            ? const SizedBox()
            :  BannerAdWidget();
      }),
    );
  }
}

Future<void> showSpeakDialog(
    BuildContext context,
    DictionaryController controller,
    ) async {
  if (Platform.isAndroid) {
    const MethodChannel _androidSpeechChannel =
    MethodChannel('com.example.ad_english_dictionary/speech_Text');
    try {
      final result = await _androidSpeechChannel.invokeMethod(
        'getTextFromSpeech',
        {'languageISO': 'en'},
      );
      if (result != null && result.toString().isNotEmpty) {
        final spoken = result.toString().trim();
        final wordCount = spoken.split(' ').where((w) => w.isNotEmpty).length;

        if (spoken.isEmpty) {
          Get.snackbar("Error", "No speech detected.");
        } else if (wordCount > 1) {
          Get.snackbar("Error", "Please speak only one word.");
        } else {
          controller.recognizedText.value = spoken;
          controller.textController.text = spoken;
        }
      } else {
        Get.snackbar("Try Again", "No speech recognized.");
      }
    } on PlatformException catch (e) {
      Get.snackbar("Speech Error", e.message ?? "Unknown error");
    }
    return;
  }

  // iOS or fallback: custom dialog logic
  controller.recognizedText.value = '';
  final RxBool timedOut = false.obs;
  controller.startSpeechToText(context);

  Future.delayed(const Duration(milliseconds: 5600), () {
    if (controller.recognizedText.value.isEmpty) {
      controller.stopListening();
      timedOut.value = true;
    }
  });

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Microphone Icon
                Obx(() {
                  return AnimatedRoundedButton(
                    backgroundColor: skyBorderColor.withOpacity(0.4),
                    child: Icon(
                      Icons.keyboard_voice,
                      color: timedOut.value ? Colors.red : kBlue,
                      size: 55,
                    ),
                    onTap: () {},
                  );
                }),

                const SizedBox(height: 20),

                /// Recognized Text or Status
                Obx(() {
                  return Center(
                    child: Text(
                      controller.recognizedText.value.isEmpty
                          ? (timedOut.value ? "No speech detected" : "Listening...")
                          : controller.recognizedText.value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }),

                const SizedBox(height: 20),

                /// Buttons
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey.shade600,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            controller.stopListening();
                            Navigator.pop(dialogContext);
                          },
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 12),

                      if (timedOut.value)
                        Flexible(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              controller.recognizedText.value = '';
                              timedOut.value = false;
                              controller.startSpeechToText(context);
                            },
                            child: const Text("Try Again"),
                          ),
                        )
                      else
                        Flexible(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              controller.stopListening();
                              controller.processRecognizedText(context);
                              Navigator.pop(dialogContext);
                            },
                            child: const Text("OK"),
                          ),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      );
    },
  );
}






