import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '/adds/binner_adds.dart';
import '/adds/instertial_adds.dart';
import '/adds/native_adss.dart';
import '/adds/open_screen.dart';
import '/core/common_widgets/animated_card.dart';
import '/core/common_widgets/bg_circular.dart';
import '/core/common_widgets/icon_buttons.dart';
import '/core/common_widgets/round_image.dart';
import '/core/common_widgets/textform_field.dart';
import '/core/constant/constant.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/app_styles.dart';
import '../../remove_ads_contrl/remove_ads_contrl.dart';
import '../contrl/top_word_contrl.dart';

class TopicListScreen extends StatefulWidget {
  const TopicListScreen({super.key});

  @override
  State<TopicListScreen> createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  final TopicController topicController = Get.put(TopicController());
  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();
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
                  Align(alignment: Alignment.centerLeft, child: BackIconButton()),
                  Center(
                    child: Text(
                      "Topic Phrases",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(() {
            if (topicController.topicList.isEmpty) {
              return const Center(child: Text('No data available.'));
            }

            return Padding(
              padding: const EdgeInsets.only(top: 90, left: kBodyHp, right: kBodyHp),
              child: SafeArea(
                child: Container(
                  decoration: roundedDecoration.copyWith(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    )
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        decoration: roundedDecoration.copyWith(
                          border: Border.all(color: Colors.blue.shade50)
                        ),
                        padding: const EdgeInsets.all(10),
                        child: CustomTextFormField(
                          hintText: 'Search Word',
                          hintTextColor: Colors.grey,
                          textAlign: TextAlign.start,
                          controller: searchController,
                          focusNode: focusNode,
                          onChanged: (value) => topicController.searchText.value = value,
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RoundedButton(
                                child:Image.asset("assets/statistics.png",height:25,width:25,),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Obx(() {
                          final topics = topicController.filteredTopics;
                          if (topics.isEmpty) {
                            return const Center(child: Text('No matching topics.'));
                          }
                          const int adInterval = 5;
                          final int adCount = (topics.length / adInterval).floor();
                          final int totalItems = topics.length + adCount;

                          return ListView.builder(
                            itemCount: totalItems,
                            itemBuilder: (context, index) {
                              if (index == 3 && !interstitialAdController.isAdReady.value) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: NativeAdWidget(),
                                );
                              } else {
                                final int topicIndex = index - (index ~/ adInterval);
                                final topic = topics[topicIndex];
                                return AnimatedForwardCard(
                                  title: topic.title ?? 'No title',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Phrases(id: topic.id),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          );
                        }),
                      ),
                      SizedBox(height:12,)
                    ],
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


class Phrases extends StatefulWidget {
  final int id;
  const Phrases({
    required this.id
  });
  @override
  State<Phrases> createState() => _PhrasesState();
}
class _PhrasesState extends State<Phrases> {
  final TopicController topicController = Get.put(TopicController());
  final PageController _pageController = PageController();
  int currentPage = 0;
  final RemoveAds removeAds = Get.put(RemoveAds());
  final AppOpenAdController appOpenAdController=Get.put(AppOpenAdController());
  final InterstitialAdController interstitialAdController=Get.put(InterstitialAdController());

  @override
  void initState() {
    super.initState();
    topicController.loadPhrases(widget.id);
    if (!removeAds.isSubscribedGet.value) {
      interstitialAdController.checkAndShowAd();
    }
  }

  @override
  void dispose() {
    super.dispose();
    topicController.flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final phrases = topicController.phrasesList;

        if (phrases.isEmpty) {
          return const Center(child: Text('No data available.'));
        }

        return Stack(
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
                    Align(alignment: Alignment.centerLeft, child: BackIconButton()),
                    Center(
                      child: Text(
                        "Phrases Example",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 90, left: kBodyHp, right: kBodyHp),
              child: Container(
                decoration: roundedDecoration.copyWith(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    )
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: phrases.length,
                        onPageChanged: (index) {
                          setState(() {
                            currentPage = index;
                          });
                          if (index == phrases.length - 1) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('You reached the end')),
                            );
                          }
                        },
                        itemBuilder: (context, index) {
                          final phrase = phrases[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    phrase.sentence ?? "No sentence",
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                const SizedBox(height: 24),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.shade50,
                                    border: Border.all(color: Colors.blue.shade100),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          _buildActionIcon(Icons.copy, () {
                                            Clipboard.setData(ClipboardData(text: phrase.explain ?? ""));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text("Explanation copied")),
                                            );
                                          }),
                                          const SizedBox(width: 10),
                                          _buildActionIcon(Icons.volume_up, () {
                                            topicController.speakText(phrase.explain ?? "");
                                          }),
                                        ],
                                      ),
                                      SizedBox(height:MediaQuery.of(context).size.height*0.03),
                                      SizedBox(
                                        height: 150, // Adjust height as needed
                                        child: SingleChildScrollView(
                                          child: Text(
                                            phrase.explain?.trim() ?? "No explanation",
                                            style: const TextStyle(fontSize: 16, height: 1.5),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildPageButton(
                          icon: Icons.arrow_back_ios,
                          enabled: currentPage > 0,
                          onPressed: () {
                            topicController.flutterTts.stop();
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                        Text(
                          '${currentPage + 1} / ${phrases.length}',
                          style: const TextStyle(fontSize:18, fontWeight: FontWeight.w600),
                        ),
                        _buildPageButton(
                          icon: Icons.arrow_forward_ios,
                          enabled: currentPage < phrases.length - 1,
                          onPressed: () {
                            topicController.flutterTts.stop();
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            )
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        final interstitial = Get.find<InterstitialAdController>();
        return interstitial.isAdReady.value
            ? const SizedBox()
            :  BannerAdWidget();
      }),
    );
  }
  Widget _buildActionIcon(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: IconButton(
        icon: Icon(icon, color: Colors.blueAccent),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildPageButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(12),
          backgroundColor: enabled ? skyBorderColor : Colors.grey.shade300,
        ),
        child: Icon(icon, size: 22, color: Colors.white),
      ),
    );
  }

}
