import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../ai_translator/controller/speak_dialog_contrl.dart';
import '/adds/binner_adds.dart';
import '/adds/instertial_adds.dart';
import '/adds/open_screen.dart';
import '/core/common_widgets/bg_circular.dart';
import '/core/common_widgets/icon_buttons.dart';
import '/core/common_widgets/no_dictionary_data.dart';
import '/core/common_widgets/round_image.dart';
import '/core/common_widgets/textform_field.dart';
import '/core/constant/constant.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/app_styles.dart';
import '/data/models/dictionary_model.dart';
import '../../home/view/home_page.dart';
import '../../remove_ads_contrl/remove_ads_contrl.dart';
import '../../top_word_phrases/contrl/top_word_contrl.dart';
import '../contrl/words_detail_contrl.dart';

class WordDetailPage extends StatefulWidget {
  const WordDetailPage({super.key});
  @override
  State<WordDetailPage> createState() => _WordDetailPageState();
}

class _WordDetailPageState extends State<WordDetailPage> {
  final RemoveAds removeAds = Get.put(RemoveAds());
  final AppOpenAdController appOpenAdController=Get.put(AppOpenAdController());
  final InterstitialAdController interstitialAdController=Get.put(InterstitialAdController());
  final TopicController topicController = Get.put(TopicController());


  @override
  void initState() {
    super.initState();
    if (!removeAds.isSubscribedGet.value) {
      interstitialAdController.checkAndShowAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    final DictionaryKey initialWord = Get.arguments;
    final controller = Get.put(WordsDetailContrl());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.textController.text.isEmpty || controller.textController.text != initialWord.word) {
        controller.textController.text = initialWord.word ?? '';
        controller.searchText.value = initialWord.word ?? '';
        controller.relatedWords.clear();
        controller.showNoResultMessage.value = false;
      }
      controller.loadWordDetails(initialWord.idRef);
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const BackgroundCircles(),
          Positioned(
            top: 45,
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
                      "Search Word",
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
            padding: const EdgeInsets.only(top: 100, left: kBodyHp, right: kBodyHp),
            child: Container(
              decoration: roundedDecoration,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Column(
                children: [
                  Container(
                    decoration: roundedDecoration,
                    padding: const EdgeInsets.all(10),
                    child: CustomTextFormField(
                      controller: controller.textController,
                      textAlign: TextAlign.start,
                      hintText: 'Search Word',
                      style: TextStyle(fontSize:15),
                      hintTextColor: Colors.grey,
                      onChanged: (val) {
                        controller.searchText.value = val;
                        controller.showNoResultMessage.value = false;
                        if (val.trim().isEmpty) {
                          controller.hasSearched.value = false;
                          controller.wordDetails.value = null;
                          controller.relatedWords.clear();
                          controller.searchText.value = '';
                          return;
                        }

                        final wordCount = val.trim().split(' ').where((w) => w.isNotEmpty).length;

                        if (wordCount > 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter only one word."),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          controller.relatedWords.clear();
                          controller.textController.clear();
                          controller.searchText.value = '';
                          return;
                        }

                        controller.debouncer.run(() {
                          controller.searchWord(val);
                        });
                      },
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RoundedButton(
                            backgroundColor: dividerColor,
                            child: Obx(() => Icon(
                              controller.isListening.value ? Icons.mic : Icons.keyboard_voice,
                              color: kBlue,
                            )),
                            onTap: () async{
                              final connectivityResult = await Connectivity().checkConnectivity();
                              if (!connectivityResult.contains(ConnectivityResult.mobile) &&
                                  !connectivityResult.contains(ConnectivityResult.wifi)) {
                                if (!context.mounted) return;
                                await showNoInternetDialog(context);
                              }
                              else{
                                if (controller.isListening.value) {
                                  controller.stopListening();
                                } else {
                                  showWordDetailSpeakDialog(context, controller);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Obx(() {
                            final words = controller.relatedWords;
                            final hasTyped = controller.searchText.value.isNotEmpty;
                            final wordCount = controller.searchText.value.trim().split(' ').where((w) => w.isNotEmpty).length;
                            final isSingleWord = wordCount == 1;
                            final bool showSuggestions = hasTyped && words.isNotEmpty && isSingleWord;
                            final bool showNoResults = controller.showNoResultMessage.value && hasTyped && isSingleWord;
                            if (showSuggestions) {
                              return Container(
                                padding: EdgeInsets.symmetric(vertical:0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.blue.shade100, width: 1.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ListView.separated(
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: words.length,
                                  separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade300),
                                  itemBuilder: (context, index) {
                                    final word = words[index];
                                    return ListTile(
                                      title: Text(
                                        word.word ?? 'Unknown',
                                        style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),
                                      ),
                                      leading: Icon(Icons.search, color: Colors.blueAccent),
                                      onTap: () async {
                                        controller.searchText.value = word.word ?? '';
                                        controller.textController.text = word.word ?? '';
                                        await controller.loadWordDetails(word.idRef);
                                        controller.relatedWords.clear();
                                        controller.showNoResultMessage.value = false;
                                      },
                                    );
                                  },
                                ),
                              );
                            } else if (showNoResults) {
                              return NoResultsMessage(searchText: controller.searchText.value);
                            }
                            else {
                              return const SizedBox.shrink();
                            }
                          }),
                          const SizedBox(height: 20),
                          Obx(() {
                            final detail = controller.wordDetails.value;
                            final words = controller.relatedWords;
                            final hasTyped = controller.searchText.value.isNotEmpty;
                            final wordCount = controller.searchText.value.trim().split(' ').where((w) => w.isNotEmpty).length;
                            final isSingleWord = wordCount == 1;
                            final bool showSuggestions = hasTyped && words.isNotEmpty && isSingleWord;
                            final bool showNoResults = controller.showNoResultMessage.value && hasTyped && isSingleWord;

                            if (detail == null || showSuggestions || showNoResults) {
                              return const SizedBox.shrink();
                            }

                            return ListView.separated(
                              itemCount: 7,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (_, __) => const Padding(
                                padding: EdgeInsets.symmetric(vertical:10),
                                child: Divider(thickness: 0.3, color: Colors.grey),
                              ),
                              itemBuilder: (context, index) {
                                switch (index) {
                                  case 0:
                                    return RichText(
                                      text: TextSpan(
                                        style: const TextStyle(fontSize: 18, color: Colors.black),
                                        children: [
                                          const TextSpan(
                                            text: 'Word: ',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text: controller.searchText.value,
                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                          if (detail.category != null && detail.category!.isNotEmpty) ...[
                                            const TextSpan(text: '  ('),
                                            TextSpan(
                                              text: detail.category,
                                              style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                                            ),
                                            const TextSpan(text: ')'),
                                          ],
                                        ],
                                      ),
                                    );

                                  case 1:
                                    return Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(horizontal:10,vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Definition",
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(Icons.copy, color: Colors.blueAccent),
                                                    tooltip: "Copy Definition",
                                                    onPressed: () {
                                                      Clipboard.setData(ClipboardData(text: detail.definition ?? ""));
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(content: Text("Definition copied to clipboard")),
                                                      );
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.volume_up, color: Colors.blueAccent),
                                                    tooltip: "Speak Definition",
                                                    onPressed: () {
                                                      topicController.speakText(detail.definition ?? "");
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Text(
                                            detail.definition ?? "No definition available.",
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    );
                                  case 2:
                                    return SynonymsRow(value: detail.synonyms);
                                  case 3:
                                    return DetailRow(label: "Hypernyms", value: detail.hypernams);

                                  case 4:
                                    return Obx(() {
                                      final examples = controller.generatedExamples;
                                      final opposites = controller.oppositeWords;

                                      if (examples.isEmpty && opposites.isEmpty) return SizedBox.shrink();

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (examples.isNotEmpty) ...[
                                            const Text(
                                              "Examples",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.blue),
                                            ),
                                            const SizedBox(height:12),
                                            ...examples.map((e) => Padding(
                                              padding: const EdgeInsets.only(bottom: 6),
                                              child: Text("• $e", style: const TextStyle(fontSize: 16)),
                                            )),
                                            const SizedBox(height: 16),
                                          ],
                                          if (opposites.isNotEmpty) ...[
                                            const Text(
                                              "Opposite Words",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.blue),
                                            ),
                                            const SizedBox(height:12),
                                            Wrap(
                                              spacing: 10,
                                              runSpacing:8,
                                              children: opposites.map((word) {
                                                return Chip(
                                                  label: Text(
                                                    word,
                                                    style: const TextStyle(fontSize: 14),
                                                    overflow: TextOverflow.visible,
                                                    softWrap: true,
                                                  ),
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                  backgroundColor: Colors.blue.shade50,
                                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                );
                                              }).toList(),
                                            )
                                          ]
                                        ],
                                      );
                                    });
                                  case 5:
                                    return DetailRow(label: "Hyponyms", value: detail.hyponyms);

                                  default:
                                    return const SizedBox();
                                }
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
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
class DetailRow extends StatelessWidget {
  final String label;
  final String? value;

  const DetailRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedValue = value?.trim().isEmpty ?? true ? 'N/A' : value!;
    final isList = formattedValue.contains(',');
    final isSynonym = label.toLowerCase().contains('synonym');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        if (isList)
          isSynonym
              ? Wrap(
            spacing: 6,
            runSpacing: 6,
            children: formattedValue
                .split(',')
                .map((item) => Text(
              item.trim(),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blueAccent,
              ),
            ))
                .toList(),
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: formattedValue
                .split(',')
                .map((item) => Text("• ${item.trim()}", style: const TextStyle(fontSize: 16)))
                .toList(),
          )
        else
          Text(
            formattedValue,
            style: TextStyle(
              fontSize: 16,
              color: isSynonym ? Colors.blueAccent : null,
            ),
          ),
      ],
    );
  }
}
class SynonymsRow extends StatelessWidget {
  final String? value;

  const SynonymsRow({Key? key, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.trim().isEmpty) {
      return const SizedBox();
    }

    final synonyms = value!.split(',').map((s) => s.trim()).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Synonyms:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: synonyms.map((syn) {
            return Text(
              syn,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 16,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}



