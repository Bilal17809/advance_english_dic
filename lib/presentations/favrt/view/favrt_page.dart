import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../ai_translator/controller/speak_dialog_contrl.dart';
import '../../ai_translator/controller/speak_text_contrl.dart';
import '/core/common_widgets/bg_circular.dart';
import '/core/common_widgets/country_flag.dart';
import '/core/common_widgets/icon_buttons.dart';
import '../../../core/common_widgets/speak_dialog_box.dart';
import '/core/constant/constant.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/app_styles.dart';
import '/example/contrl.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final ConversationController controller = Get.put(ConversationController());
  final SpeakText speakText = Get.put(SpeakText());

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
                      "Favorites",
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
          Padding(
            padding:  EdgeInsets.only(top:90, left: kBodyHp, right: kBodyHp),
            child: Container(
              decoration: roundedDecoration,
              // padding: const EdgeInsets.all(10),
              child: Obx(() {
                final favorites = controller.conversationList
                    .where((item) => item['isFavorite'] == true)
                    .toList();

                if (favorites.isEmpty) {
                  return Center(
                    child:   Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/search11.png',
                          height: 55,width: 55,color:kBlue,),
                        SizedBox(height:8,),
                        Text("No Favorites yet.",
                          style:context.textTheme.labelMedium,),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline, size: 18, color: Colors.blueAccent),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "This is your saved translation history — revisit, listen, copy, or share the moments you found meaningful.",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: favorites.length,
                        itemBuilder: (context, index) {
                          final fav = favorites[index];
                          bool isExpanded = false;

                          return StatefulBuilder(
                            builder: (context, setInnerState) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(40),
                                    bottomRight: Radius.circular(40),
                                  ),
                                  boxShadow: const [
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
                                    // Top: Original Language
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      child: Row(
                                        children: [
                                          Text(fav['originalFlag'] ?? '🌐', style: const TextStyle(fontSize: 22)),
                                          const SizedBox(width: 6),
                                          Text(fav['originalLabel'] ?? '',
                                              style: context.textTheme.bodyLarge?.copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(fav['originalText'] ?? '',
                                          style: const TextStyle(fontSize: 15)),
                                    ),
                                    const SizedBox(height: 10),

                                    // Bottom: Translated section
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical:15, horizontal: 12),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: isExpanded ? const Radius.circular(40) : const Radius.circular(10),
                                          bottomRight: isExpanded ? const Radius.circular(40) : const Radius.circular(10),
                                        ),
                                        border: Border.all(color: Colors.grey.shade300),
                                      ),
                                      child: Column(
                                        children: [
                                          // Translated header row
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(fav['translatedFlag'] ?? '🌐',
                                                      style: const TextStyle(fontSize: 22)),
                                                  const SizedBox(width: 6),
                                                  Text(fav['translatedLabel'] ?? '',
                                                      style: context.textTheme.bodyLarge?.copyWith(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  isExpanded ? Icons.expand_less : Icons.expand_more,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  setInnerState(() => isExpanded = !isExpanded);
                                                },
                                              ),
                                            ],
                                          ),

                                          Text(fav['translatedText'] ?? '',
                                              style: context.textTheme.bodyLarge
                                                  ?.copyWith(color: Colors.white)),

                                          if (isExpanded) ...[
                                            const SizedBox(height: 16),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                _buildIconButton(context, Icons.volume_up_rounded, 'Speak', () async {
                                                  final connectivityResult = await Connectivity().checkConnectivity();
                                                  if (!connectivityResult.contains(ConnectivityResult.mobile) &&
                                                      !connectivityResult.contains(ConnectivityResult.wifi)) {
                                                    if (!context.mounted) return;
                                                    await showNoInternetDialog(context);
                                                  }
                                                  else{
                                                    final textToSpeak = fav['translatedText'] ?? '';
                                                    final langName = fav['translatedLanguage'] ?? 'English';
                                                    final langCode = languageCodesC[langName] ?? 'en';
                                                    if (textToSpeak.isEmpty) {
                                                      showCustomToast(context, 'No text to speak');
                                                      return;
                                                    }
                                                    try {
                                                      await speakText.playText(context, textToSpeak, langCode);
                                                    } catch (e) {
                                                      showCustomToast(context, 'Failed to play audio');
                                                    }
                                                  }
                                                }),
                                                _buildIconButton(context, Icons.copy, 'Copy', () {
                                                  Clipboard.setData(
                                                      ClipboardData(text: fav['translatedText']));
                                                  showCustomToast(context, 'Text copied to clipboard');
                                                }),
                                                _buildIconButton(context, Icons.share, 'Share', () {
                                                  Share.share(fav['translatedText'], subject: 'Translated Text');
                                                }),
                                                _buildIconButton(context, Icons.delete, 'Delete', () {
                                                  final originalIndex = controller.conversationList.indexWhere(
                                                        (element) =>
                                                    element['originalText'] == fav['originalText'] &&
                                                        element['translatedText'] == fav['translatedText'],
                                                  );
                                                  if (originalIndex != -1) {
                                                    controller.conversationList.removeAt(originalIndex);
                                                    controller.saveConversationList();
                                                  }
                                                }),
                                                _buildIconButton(
                                                  context,
                                                  Icons.star,
                                                  'Unfavorite',
                                                      () {
                                                    final originalIndex = controller.conversationList.indexWhere(
                                                          (element) =>
                                                      element['originalText'] == fav['originalText'] &&
                                                          element['translatedText'] == fav['translatedText'],
                                                    );
                                                    if (originalIndex != -1) {
                                                      controller.toggleFavorite(originalIndex);
                                                      showCustomToast(context, 'Removed from Favorite');
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
      BuildContext context, IconData icon, String tooltip, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: IconButton(
          tooltip: tooltip,
          icon: Icon(icon, color: Colors.blue),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
