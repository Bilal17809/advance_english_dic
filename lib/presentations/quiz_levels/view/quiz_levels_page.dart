import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/adds/binner_adds.dart';
import '/adds/instertial_adds.dart';
import '/adds/open_screen.dart';
import '/core/common_widgets/bg_circular.dart';
import '/core/common_widgets/icon_buttons.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/app_styles.dart';
import '../../daliy_quiz/view/quizz_page.dart';
import '../../remove_ads_contrl/remove_ads_contrl.dart';
import '../contrl/quiz_level_contrl.dart';
class SubLevelPage extends StatefulWidget {
  @override
  _SubLevelPageState createState() => _SubLevelPageState();
}

class _SubLevelPageState extends State<SubLevelPage> {
  final QuizLevel controller = Get.put(QuizLevel());
  Timer? _refreshTimer;
  final RemoveAds removeAds = Get.put(RemoveAds());
  final AppOpenAdController appOpenAdController=Get.put(AppOpenAdController());
  final InterstitialAdController interstitialAdController=Get.put(InterstitialAdController());

  @override
  void initState() {
    super.initState();
    if (!removeAds.isSubscribedGet.value) {
      interstitialAdController.checkAndShowAd();
    }
    _refreshTimer = Timer.periodic(Duration(seconds:2), (timer) {
      controller.refreshResults();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _refreshTimer?.cancel();
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
                      "Quizzes",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GetBuilder<QuizLevel>(
            builder: (_) {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final subLevels = controller.quizzesBySubLevel.keys.toList()..sort();

              return Padding(
                padding: const EdgeInsets.only(top: 100, left: 15, right: 15),
                child: Container(
                  decoration: roundedDecoration,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: subLevels.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      final level = subLevels[index];
                      final questionCount = controller.quizzesBySubLevel[level]?.length ?? 0;

                      return GestureDetector(
                        onTap: () {
                          final questions = controller.quizzesBySubLevel[level] ?? [];
                          Get.to(() => QuizPage(
                            questions: questions,
                            titleName: "Level: $level",
                            levelId: level,
                          ));
                        },
                        child: Obx(() {
                          final result = controller.results[level] ?? {'correct': 0, 'wrong': 0};
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                decoration: roundedDecoration,
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 20),
                                    Text(
                                      "Level $level",
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    const SizedBox(height: 6),
                                    Text("Total: $questionCount"),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                      decoration: roundedDecoration.copyWith(
                                        color: skyBorderColor.withOpacity(0.2),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("${result['correct']}", style: const TextStyle(color: Colors.green)),
                                          const SizedBox(width: 4),
                                          const Icon(Icons.check_circle, color: Colors.green, size: 18),
                                          const SizedBox(width: 12),
                                          Text("${result['wrong']}", style: const TextStyle(color: Colors.red)),
                                          const SizedBox(width: 4),
                                          const Icon(Icons.cancel, color: Colors.red, size: 18),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                right: 8,
                                child: Builder(
                                  builder: (_) {
                                    final correct = result['correct'] ?? 0;
                                    final wrong = result['wrong'] ?? 0;
                                    final total = correct + wrong;

                                    double percent = 0;
                                    if (total > 0) {
                                      percent = correct / total;
                                    }

                                    int filledStars;
                                    if (percent == 1) {
                                      filledStars = 3;
                                    } else if (percent >= 0.55) {
                                      filledStars = 2;
                                    } else if (percent >= 0.20) {
                                      filledStars = 1;
                                    } else {
                                      filledStars = 0;
                                    }

                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: List.generate(3, (index) {
                                        return Icon(
                                          Icons.star,
                                          size: 16,
                                          color: index < filledStars ? Colors.amber : Colors.grey,
                                        );
                                      }),
                                    );
                                  },
                                ),
                              ),

                            ],
                          );
                        }),
                      );
                    },
                  ),
                ),
              );
            },
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
