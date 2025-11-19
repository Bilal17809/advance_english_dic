import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '/adds/binner_adds.dart';
import '/adds/instertial_adds.dart';
import '/adds/open_screen.dart';
import '/core/common_widgets/bg_circular.dart';
import '/core/common_widgets/icon_buttons.dart';
import '/core/constant/constant.dart';
import '/core/theme/app_styles.dart';
import '/data/models/models.dart';
import '../../remove_ads_contrl/remove_ads_contrl.dart';
import '../../top_word_phrases/contrl/top_word_contrl.dart';

class PartOfSpeechExamplePage extends StatefulWidget {
  final PartOfSpeech part;
  const PartOfSpeechExamplePage({super.key, required this.part});

  @override
  State<PartOfSpeechExamplePage> createState() => _PartOfSpeechExamplePageState();
}

class _PartOfSpeechExamplePageState extends State<PartOfSpeechExamplePage> {
  final RemoveAds removeAds = Get.put(RemoveAds());
  final AppOpenAdController appOpenAdController = Get.put(AppOpenAdController());
  final InterstitialAdController interstitialAdController = Get.put(InterstitialAdController());
  final TopicController topicController = Get.put(TopicController());


  late List<String> examples;
  late List<bool> expandedList;

  @override
  void initState() {
    super.initState();
    if (!removeAds.isSubscribedGet.value) {
      interstitialAdController.checkAndShowAd();
    }

    examples = [
      widget.part.example1,
      widget.part.example2,
      widget.part.example3,
      widget.part.example4,
      widget.part.example5,
      widget.part.example6,
      widget.part.example7,
      widget.part.example8,
      widget.part.example9,
    ].where((e) => e.trim().isNotEmpty).toList();

    expandedList = List.generate(examples.length, (_) => false);
  }
  @override
  void dispose() {
    super.dispose();
    topicController.flutterTts.stop();
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
                      widget.part.word,
                      style: const TextStyle(
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

          /// Main content
          Padding(
            padding: EdgeInsets.only(top: 90, left: kBodyHp, right: kBodyHp),
            child: Container(
              decoration: roundedDecoration.copyWith(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height:10),
                  Text(
                    "${widget.part.word} (${widget.part.partOfSpeech})",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Meaning:",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.part.meaning,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w400
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text(
                    "Examples:",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: examples.length,
                      itemBuilder: (context, index) {
                        final example = examples[index];
                        final isExpanded = expandedList[index];

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Header Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${index + 1}. ",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      example,
                                      maxLines: isExpanded ? null : 2,
                                      overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15.5,
                                        height: 1.6,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        expandedList[index] = !expandedList[index];
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue.shade50,
                                      ),
                                      child: Icon(
                                        isExpanded ? Icons.expand_less : Icons.expand_more,
                                        size: 20,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (isExpanded) const SizedBox(height: 8),
                              if (isExpanded)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.copy, size: 20, color: Colors.grey),
                                      tooltip: "Copy",
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(text: example));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Example copied")),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.volume_up, size: 20, color: Colors.grey),
                                      tooltip: "Speak",
                                      onPressed: () {
                                        topicController.speakText(example);                                      },
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
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

