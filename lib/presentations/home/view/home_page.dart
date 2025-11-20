import 'dart:io';
import 'package:electricity_app/presentations/ai_translator/view/ai_translator_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../adds/binner_adds.dart';
import '../../../adds/native_adss.dart';
import '../../../adds/open_screen.dart';
import '../../../core/animation/animation_games.dart';
import '../../../core/common_widgets/bg_circular.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../../../core/common_widgets/no_dictionary_data.dart';
import '../../../core/common_widgets/round_image.dart';
import '../../../core/common_widgets/textform_field.dart';
import '../../../core/common_widgets/vertical_line.dart';
import '../../../core/constant/constant.dart';
import '../../../core/routes/routes_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../gen/assets.gen.dart';
import '../../ai_center/view/ai_center_page.dart';
import '../../app_drawer/app_drawer.dart';
import '../../conversations/view/conversation_page.dart';
import '../../part_of_spech/view/part_of_spech_page.dart';
import '../../quiz_levels/view/quiz_levels_page.dart';
import '../../remove_ads_contrl/remove_ads_contrl.dart';
import '../../subscription/subscription_view.dart';
import '../../top_word_phrases/view/top_word_page.dart';
import '../../word_game/view/word_game_view.dart';
import '../../words_detail/contrl/words_detail_contrl.dart';
import '../../words_detail/view/words_detail_page.dart';
import '../contrl/home_contrl.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final WordsDetailContrl controller = Get.put(WordsDetailContrl());
  final nativeAdController = Get.put(NativeAdController());
  bool isDrawerOpen=false;
  final GlobalKey<ScaffoldState> _globalKey=GlobalKey<ScaffoldState>();
  final RemoveAds removeAds=Get.put(RemoveAds());
  final AppOpenAdController appOpenAdController=Get.put(AppOpenAdController());
  final HomeController homeController=Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      drawer: AppDrawer(),
      onDrawerChanged: (isOpen) {
        setState(() {
          isDrawerOpen = isOpen;
        });
      },
      body: Stack(
        children: [
          const BackgroundCircles(),
          // Header section
          Positioned(
            top: 46,
            left: 16,
            right: 16,
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Builder(
                      builder: (context) => GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: const MenuIcon(),
                      ),
                    ),
                  ),
                  if (!removeAds.isSubscribedGet.value)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top:10, right:5),
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Get.to(Subscriptions());
                          },
                          child: Image.asset(
                            'assets/sub1.png',
                            height: 30,
                            width: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  Center(
                    child: Text(
                      "Advance Dictionary",
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
              padding: EdgeInsets.only(top: 80, left:12, right:12),
              child: Container(
                decoration: roundedDecoration,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchWord(),
                    SizedBox(height:12),
                    Expanded(
                      child: Obx(() {
                        final words = controller.relatedWords;
                        final text = controller.searchText.value.trim();
                        final textController = controller.textController.value.text;
                        final isSingleWord = text.split(' ').where((w) => w.isNotEmpty).length == 1;
                        final hasSuggestions = text.isNotEmpty && words.isNotEmpty && isSingleWord && textController.isNotEmpty;

                        if (hasSuggestions) {
                          return const SizedBox.shrink();
                        } else if (controller.showNoResultMessage.value) {
                          return NoResultsMessage(searchText: text);
                        } else {
                          return ListView(
                            padding: EdgeInsets.all(5),
                            children: [
                              const AnimatedPlayGameButton(),
                              SizedBox(height:10),
                              if (!(appOpenAdController.isShowingOpenAd.value||isDrawerOpen))
                                // nativeAdController.nativeAdWidget(),
                                const NativeAdWidget(),
                              SizedBox(height:18),
                              MenuCard(
                                icon: CardIcon(icon: Assets.dictionary.path),
                                label: "AI Dictionary",
                                onTap: () => Navigator.pushNamed(context, RoutesName.aiDictionaryPage),
                              ),
                              SizedBox(height: 16),
                              MenuCard(
                                icon: CardIcon(icon: Assets.ai.path),
                                label: "AI Center",
                                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => OpenRouterPage())),
                              ),
                              SizedBox(height: 16),
                              MenuCard(
                                icon: CardIcon(icon: Assets.bookSale.path),
                                label: "AI Translator",
                                onTap: () => Navigator.pushNamed(context, RoutesName.aiTranslatorPage),
                              ),
                              SizedBox(height: 16),
                              MenuCard(
                                icon: CardIcon(icon: Assets.magicBook.path),
                                label: "Conversations",
                                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConversationPage())),
                              ),
                              SizedBox(height: 16),
                              MenuCard(
                                icon: CardIcon(icon:"assets/speech.png"),
                                label: "Parts of Speech",
                                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PartOfSpechPage())),
                              ),
                              SizedBox(height: 16),
                              MenuCard(
                                icon: CardIcon(icon: Assets.daliyQuiz.path),
                                label: "Daily Quiz",
                                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SubLevelPage())),
                              ),
                              SizedBox(height: 16),
                              MenuCard(
                                icon: CardIcon(icon: "assets/puzzle.png"),
                                label: "Top Words",
                                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => TopicListScreen())),
                              ),
                              SizedBox(height: 16),
                              // MenuCard(
                              //   icon: CardIcon(icon: "assets/puzzle.png"),
                              //   label: "Start Game",
                              //   onTap: () =>
                              //       Navigator.of(context).push(
                              //           MaterialPageRoute(builder: (context) => PuzzlePage())),
                              // ),
                            ],
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(() {
            final words = controller.relatedWords;
            final hasTyped = controller.searchText.value.isNotEmpty;
            final textController=controller.textController.value.text.isNotEmpty;
            final wordCount = controller.searchText.value.trim().split(' ').where((w) => w.isNotEmpty).length;
            final isSingleWord = wordCount == 1;
            final hasSuggestions = hasTyped && words.isNotEmpty && isSingleWord && textController;

            if (!hasSuggestions) {
              return const SizedBox.shrink();
            }
            double estimatedSearchWordHeight = 56;
            double topPadding = MediaQuery.of(context).size.height*0.3;
            double containerPadding = 16;
            double searchBarBottomOffset = topPadding + containerPadding + estimatedSearchWordHeight +25;
            return Positioned(
              top: searchBarBottomOffset,
              left: kBodyHp + containerPadding,
              right: kBodyHp + containerPadding,
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  constraints: BoxConstraints(
                    // maximum height to allow scroll for longer list
                    maxHeight:MediaQuery.of(context).size.height*0.56,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade100, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: words.length,
                    separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade300),
                    itemBuilder: (context, index) {
                      final word = words[index];
                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        leading: const Icon(Icons.search, color: Colors.blueAccent),
                        title: Text(
                          word.word ?? 'Unknown',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          controller.searchText.value = word.word ?? '';
                          controller.relatedWords.clear();
                          controller.hasSearched.value = true;
                          Get.to(WordDetailPage(), arguments: word);
                        },
                      );
                    },
                  ),
                ),
              ),
            );

          }),
        ],
      ),
    );
  }
}


class SearchWord extends StatelessWidget {
  const SearchWord({super.key});

  @override
  Widget build(BuildContext context) {
    final WordsDetailContrl controller = Get.put(WordsDetailContrl());

    return Container(
      decoration: roundedDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  hintText: "Search Word Here...",
                  hintTextColor: Colors.grey,
                  style: TextStyle(fontSize:15),
                  textAlignVertical: TextAlignVertical.top,
                  textAlign: TextAlign.start,
                  onChanged: (val) {
                    final trimmed = val.trim();
                    controller.textController.text = val;
                    controller.searchText.value = trimmed;
                    if (trimmed.isEmpty) {
                      controller.relatedWords.clear();
                      controller.wordDetails.value = null;
                      controller.hasSearched.value = false;
                      return;
                    }

                    final wordCount = trimmed.split(' ').where((w) => w.isNotEmpty).length;
                    if (wordCount > 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter only one word."),
                          duration: Duration(seconds: 3),
                        ),
                      );
                      return;
                    }
                    controller.debouncer.run(() {
                      controller.searchWord(trimmed);
                    });
                  },
                  controller: controller.textController,
                ),
              ),
              RoundedButton(
                backgroundColor: dividerColor,
                child: Obx(() => Icon(
                  controller.isListening.value ? Icons.mic : Icons.keyboard_voice,
                  color: kBlue,
                )),
                onTap: () {
                  if (controller.isListening.value) {
                    controller.stopListening();
                  } else {
                    showWordDetailSpeakDialog(context, controller);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height:30),
          /// Navigation Icons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Get.toNamed(RoutesName.aiDictionaryPage),
                child: Column(
                  children: [
                    Image.asset(Assets.dictionary.path, height: 35),
                    const SizedBox(height: 6),
                    const Text("Dictionary"),
                  ],
                ),
              ),
              const VerticalDividerWidget(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder:(context)=>
                  AiTranslatorPage()));
                },
                // onTap: () => Get.toNamed(RoutesName.aiTranslatorPage),
                child: Column(
                  children: [
                    Image.asset(Assets.translate.path, height: 35),
                    const SizedBox(height: 6),
                    const Text("Translator"),
                  ],
                ),
              ),
              const VerticalDividerWidget(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ConversationPage()));
                },
                child: Column(
                  children: [
                    Image.asset(Assets.magicBook.path, height: 35),
                    const SizedBox(height: 6),
                    const Text("Conversations"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;
  const MenuCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width:18),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showWordDetailSpeakDialog(
    BuildContext context,
    WordsDetailContrl controller,
    ) async {
  // below for ios...
  controller.recognizedText.value = '';
  final RxBool timedOut = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool hasError = false.obs;

  controller.startListening();

  Future.delayed(const Duration(milliseconds: 4000), () {
    if (controller.recognizedText.value.isEmpty && controller.isListening.value) {
      controller.stopListening();
      timedOut.value = true;
    }
  });

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(() {
            final isTimeout = timedOut.value;
            final recognized = controller.recognizedText.value;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Microphone icon
                AnimatedRoundedButton(
                  backgroundColor: skyBorderColor.withOpacity(0.4),
                  child: Icon(
                    Icons.keyboard_voice,
                    color: timedOut.value ? Colors.red : kBlue,
                    size: 55,
                  ),
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                Text(
                  recognized.isEmpty
                      ? (isTimeout ? "Please try again" : "Listening...")
                      : recognized,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),

                // Error message if any
                if (errorMessage.value.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    errorMessage.value,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],

                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: TextButton(
                        onPressed: () {
                          controller.stopListening();
                          Navigator.pop(dialogContext);
                        },
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          if (isTimeout || hasError.value) {
                            controller.recognizedText.value = '';
                            timedOut.value = false;
                            errorMessage.value = '';
                            hasError.value = false;
                            controller.startListening();
                          } else {
                            controller.stopListening();
                            final spoken = controller.recognizedText.value.trim();
                            final wordCount = spoken.split(' ').where((w) => w.isNotEmpty).length;

                            if (spoken.isEmpty) {
                              errorMessage.value = "Please say something.";
                              hasError.value = true;
                            } else if (wordCount > 1) {
                              errorMessage.value = "Please speak only one word for dictionary lookup.";
                              hasError.value = true;
                            } else {
                              errorMessage.value = '';
                              hasError.value = false;
                              controller.textController.text = spoken;
                              controller.searchText.value = spoken;
                              controller.searchWord(spoken);
                              Navigator.pop(dialogContext);
                            }
                          }
                        },
                        child: Text(
                          isTimeout
                              ? "Try Again"
                              : hasError.value
                              ? "Refresh"
                              : "OK",
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      );
    },
  );
}







