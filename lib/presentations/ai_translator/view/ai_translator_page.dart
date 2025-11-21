import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../adds/binner_adds.dart';
import '../../../adds/instertial_adds.dart';
import '../../../adds/open_screen.dart';
import '../../../core/common_widgets/bg_circular.dart';
import '../../../core/common_widgets/country_flag.dart';
import '../../../core/common_widgets/drop_down.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../../../core/common_widgets/round_image.dart';
import '../../../core/common_widgets/speak_dialog_box.dart';
import '../../../core/common_widgets/textform_field.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../example/contrl.dart';
import '../../favrt/view/favrt_page.dart';
import '../../remove_ads_contrl/remove_ads_contrl.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../controller/speak_dialog_contrl.dart';
import '../controller/speak_text_contrl.dart';

class AiTranslatorPage extends StatefulWidget {
   AiTranslatorPage({super.key});

  @override
  State<AiTranslatorPage> createState() => _AiTranslatorPageState();
}

class _AiTranslatorPageState extends State<AiTranslatorPage> {
  final ConversationController controller=Get.put(ConversationController());

   final  SpeakDialog speakDialog=Get.put(SpeakDialog());

   final RemoveAds removeAds = Get.put(RemoveAds());

   final AppOpenAdController appOpenAdController=Get.put(AppOpenAdController());

   final InterstitialAdController interstitialAdController=Get.put(InterstitialAdController());

   @override
   void initState() {
     super.initState();
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
                      "AI Translator",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 90, left: 13, right: 13),
              child: Container(
                decoration: roundedDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16,horizontal:5),
                    width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: const BorderRadius.only(
                          topLeft:Radius.circular(10),
                          topRight:Radius.circular(10),
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              AnimatedRoundedButton2(
                                backgroundColor: dividerColor,
                                child: const Icon(Icons.keyboard_voice, color: kBlue,size:27,),
                                onTap: () async {
                                  final connectivityResult = await Connectivity().checkConnectivity();
                                  if (!connectivityResult.contains(ConnectivityResult.mobile) &&
                                      !connectivityResult.contains(ConnectivityResult.wifi)) {
                                    if (!context.mounted) return;
                                    await showNoInternetDialog(context);
                                  }else{
                                    final selectedLanguage = controller.selectedLanguageC1.value;
                                    controller.startSpeechToText(context, selectedLanguage, false);
                                    speakDialog.openMicDialog(context, false);
                                  }
                                },
                              ),
                              const SizedBox(width:5),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => const LanguagesSelection(isFirst: true));
                                  },
                                  child: Obx(() {
                                    final selectedLanguage = controller.selectedLanguageC1.value;
                                    final countryCode = languageFlags[selectedLanguage] ?? 'US';

                                    return Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        // Main container
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                          decoration: roundedDecoration.copyWith(
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(color: kWhiteEF),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    selectedLanguage,
                                                    style: context.textTheme.labelSmall,
                                                    softWrap: false,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8,),
                                              const Icon(Icons.arrow_drop_down, size:20),
                                            ],
                                          ),
                                        ),

                                        // Positioned flag (top-left)
                                        Positioned(
                                          top: -7,
                                          left: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(4),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: CountryFlag.fromCountryCode(
                                              countryCode,
                                              height: 14,
                                              width: 22,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                              const SizedBox(width:5),
                              // swap btn
                              RoundedButton(
                                backgroundColor: dividerColor,
                                child: const Icon(Icons.swap_horiz_rounded, color: kBlue),
                                onTap:controller.swapLanguages,
                              ),

                              const SizedBox(width:5),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => const LanguagesSelection(isFirst: false));
                                  },
                                  child: Obx(() {
                                    final selectedLanguage = controller.selectedLanguageC2.value;
                                    final countryCode = languageFlags[selectedLanguage] ?? 'US';

                                    return Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        // Main container
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                          decoration: roundedDecoration.copyWith(
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(color: kWhiteEF),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    selectedLanguage,
                                                    style: context.textTheme.labelSmall,
                                                    softWrap: false,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8,),
                                              const Icon(Icons.arrow_drop_down, size:20),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: -7,
                                          left: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(4),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: CountryFlag.fromCountryCode(
                                              countryCode,
                                              height: 14,
                                              width: 22,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                              const SizedBox(width:5),
                              AnimatedRoundedButton2(
                                backgroundColor: dividerColor,
                                child: const Icon(Icons.keyboard_voice, color: kBlue,size:27,),
                                onTap: () async {
                                  final connectivityResult = await Connectivity().checkConnectivity();
                                  if (!connectivityResult.contains(ConnectivityResult.mobile) &&
                                      !connectivityResult.contains(ConnectivityResult.wifi)) {
                                    if (!context.mounted) return;
                                    await showNoInternetDialog(context);
                                  }
                                  else{
                                    final selectedLanguage = controller.selectedLanguageC2.value;
                                    controller.startSpeechToText(context, selectedLanguage, true);
                                    speakDialog.openMicDialog(context, true);
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          CustomTextFormField(
                            fillColor: Colors.blue,
                            hintTextColor: Colors.white,
                            cursorColor: Colors.white,
                            textColor: Colors.white,
                            hintText: 'Write Something Here...',
                            textAlign: TextAlign.start,
                            controller: controller.inputTextController,
                          ),
                          const SizedBox(height:60),
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RoundedButton(
                                  backgroundColor: dividerColor,
                                  child: const Icon(Icons.favorite_border, color: kBlue),
                                  onTap: () {
                                    Get.to(FavoriteScreen());
                                  },
                                ),
                                const SizedBox(width: 8),

                                RoundedButton(
                                  backgroundColor: dividerColor,
                                  child: const Icon(Icons.close, color: kBlue),
                                  onTap: () {
                                    controller.inputTextController.clear();
                                    controller.translatedText.value = '';
                                  },
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () async{
                                    final connectivityResult = await Connectivity().checkConnectivity();
                                    if (!connectivityResult.contains(ConnectivityResult.mobile) &&
                                        !connectivityResult.contains(ConnectivityResult.wifi)) {
                                      if (!context.mounted) return;
                                      await showNoInternetDialog(context);
                                    }
                                    else{
                                      controller.translateWrittenText(Get.context!);
                                    }
                                    },
                                  child: const Text(
                                    "Translate",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                        child: const TranslationHistoryWidget()),
                    const SizedBox(height: 16),
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


class TranslationHistoryWidget extends StatefulWidget {
  const TranslationHistoryWidget({super.key});

  @override
  State<TranslationHistoryWidget> createState() => _TranslationHistoryWidgetState();
}
class _TranslationHistoryWidgetState extends State<TranslationHistoryWidget> with WidgetsBindingObserver{
  final ConversationController controller = Get.put(ConversationController());
  final SpeakText speakText = Get.put(SpeakText());
  bool isExpanded = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.resumed) {
      speakText.stopAudio();
    }
  }
  @override
  Widget build(BuildContext context) {

    return Obx(() {
      if (controller.conversationList.isEmpty) {
        return  Padding(
          padding: EdgeInsets.only(top: 20),
          child: Center(child:
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/search11.png',
                  height: 55,width: 55,color:skyTextColor,),
                SizedBox(height:8,),
                Text("No History yet.",
                  style:context.textTheme.labelMedium,),
              ],
            ),
          )),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        itemCount: controller.conversationList.length,
        itemBuilder: (context, index) {
          final record = controller.conversationList[index];

          final originalFlag = record['originalFlag'] ?? '';
          final translatedFlag = record['translatedFlag'] ?? '';
          final originalLabel = record['originalLabel'] ?? '';
          final translatedLabel = record['translatedLabel'] ?? '';
          final originalText = record['originalText'] ?? '';
          final translatedText = record['translatedText'] ?? '';
          final translatedLangCode = record['translatedLabel'] ?? 'en';
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft:Radius.circular(10),
                topRight:Radius.circular(10),
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Original language
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:12),
                  child: Row(
                    children: [
                      Text(originalFlag, style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 6),
                      Text(
                        originalLabel,
                          style:context.textTheme.bodyLarge?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          )
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:12),
                  child: Text(originalText, style: const TextStyle(fontSize: 15)
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(vertical:8,horizontal:12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: isExpanded ? const Radius.circular(40):const Radius.circular(10),
                      bottomRight: isExpanded ? const Radius.circular(40):const Radius.circular(10),
                    ),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(translatedFlag, style: const TextStyle(fontSize: 22)),
                              const SizedBox(width: 6),
                              Text(
                                translatedLabel,
                                style:context.textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                )
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              isExpanded ? Icons.expand_less : Icons.expand_more,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                          ),
                        ],
                      ),
                      Text(translatedText, style:context.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                      )
                      ),

                      if (isExpanded) ...[
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildIconButton(context, Icons.volume_up_rounded, 'Speak', () async {
                              final textToSpeak = record['translatedText'] ?? '';
                              final languageName = record['translatedLanguage'] ?? 'English';
                              final langCode = languageCodesC[languageName] ?? 'en';

                              if (textToSpeak.isEmpty) {
                                showCustomToast(context, 'No text to speak');
                                return;
                              }

                              try {
                                await speakText.playText(context, textToSpeak, langCode);
                              } catch (e) {
                                showCustomToast(context, 'Failed to play audio: $e');
                              }
                            }),
                            _buildIconButton(context, Icons.copy, 'Copy', () {
                              Clipboard.setData(ClipboardData(text: translatedText));
                              showCustomToast(context, 'Text copied to clipboard');
                            }),
                            _buildIconButton(context, Icons.share, 'Share', () {
                              Share.share(translatedText, subject: 'Translated Text');
                            }),
                            _buildIconButton(context, Icons.delete, 'Delete', () {
                              controller.conversationList.removeAt(index);
                              controller.saveConversationList();
                            }),
                            _buildIconButton(
                              context,
                              record['isFavorite'] == true ? Icons.star : Icons.star_border,
                              record['isFavorite'] == true ? 'Unfavorite' : 'Favorite',
                                  () {
                                controller.toggleFavorite(index);
                                showCustomToast(context,
                                    record['isFavorite'] == true ? 'Added to Favorite' : 'Removed from Favorite');
                              },
                            ),

                          ],
                        ),
                      ],
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildIconButton(BuildContext context, IconData icon, String tooltip, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(left: 8,bottom:5),
      child: Container(
        height:38,
        width: 38,
        decoration: roundedDecoration,
        child: IconButton(
          tooltip: tooltip,
          icon: Icon(icon, color: Colors.blue),
          onPressed: onPressed,
        ),
      ),
    );
  }

}







