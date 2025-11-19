import 'package:electricity_app/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '/adds/instertial_adds.dart';
import '/adds/native_adss.dart';
import '/core/animation/animation_games.dart';
import '/core/common_widgets/bg_circular.dart';
import '/core/common_widgets/icon_buttons.dart';
import '/core/theme/app_colors.dart';
import '../contrl/contrl.dart';


class PuzzlePage extends StatefulWidget {
  final String level;
  const PuzzlePage({super.key,required this.level});
  @override
  State<PuzzlePage> createState() => _PuzzlePageState();
}
class _PuzzlePageState extends State<PuzzlePage> {
  final PageController pageController = PageController();
  late final PuzzleController controller;
  final SplashInterstitialAdController splashAd = Get.put(SplashInterstitialAdController());


  @override
  void initState() {
    super.initState();
    controller = Get.put(PuzzleController());
    controller.setLevel(widget.level);
    controller.loadPuzzles();
  }

  final List<Color> customColors = [
    kMediumGreen2.withAlpha((255 * 0.5).toInt()),
    kCoral.withAlpha((255 * 0.5).toInt()),
    kMediumGreen1,
    kGold.withAlpha((255 * 0.5).toInt()),
    kSkyBlueColor,
    kViolet.withAlpha((255 * 0.5).toInt()),
    kOrange.withAlpha((255 * 0.05).toInt()),
    kBlue.withAlpha((255 * 0.03).toInt()),
    kIndigo.withAlpha((255 * 0.3).toInt()),
    kYellow.withAlpha((255 * 0.3).toInt()),
    kViolet.withAlpha((255 * 0.3).toInt()),
    kViolet.withAlpha((255 * 0.3).toInt()),
    kSkyBlueColor,
    kOrange.withAlpha((255 * 0.03).toInt()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: BackIconButton(),
        ),
        backgroundColor: kSkyBlueColor,
          title:  Text("Rewarded Quiz",
            style: context.textTheme.titleLarge?.copyWith(
              color: kWhiteFA
            ),
          )),
      body: Obx((){
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return PageView.builder(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.words.length,
          itemBuilder: (context, index) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                      decoration: roundedDecoration.copyWith(
                          color:skyTextColor.withAlpha(50),
                          borderRadius: BorderRadius.circular(2)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical:10.0,horizontal:16),
                        child:Text(
                          "${controller.currentIndex.value + 1}/${controller.words.length} Re-arrange the characters and make correct word.",
                          style: context.textTheme.labelSmall,
                        ),

                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Shuffle Characters:"),
                        SizedBox(height: 16,),
                        Obx(() => Wrap(
                          spacing: 13,
                          runSpacing: 13,
                          children: List.generate(controller.letters.length, (i) {
                            final isUsed = controller.usedIndexes.contains(i);
                            return isUsed
                                ? const GlowingCircle()
                                : AnimatedStaggeredLetter(
                              key: ValueKey('letter_$i'),
                              letter: controller.letters[i],
                              delayIndex: i,
                              onTap: () {
                                controller.addLetter(controller.letters[i], i);
                              },
                            );
                          }),
                        )),
                        SizedBox(height: 5,),
                        AnimatedCardButtons(),
                        const Divider(),
                        const SizedBox(height:8),
                        Text("Arranged Word:"),
                        const SizedBox(height:16),
                        Obx(() {
                          final selected = controller.selectedLetters;
                          return Wrap(
                            spacing: 13,
                            children: List.generate(controller.letters.length, (i) {
                              final isFilled = i < selected.length;
                              final letter = isFilled ? selected[i] : '';
                              final color = customColors[i % customColors.length];

                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                transitionBuilder: (child, anim) =>
                                    ScaleTransition(scale: anim, child: child),
                                child: isFilled
                                    ? GestureDetector(
                                  onTap: () => controller.removeLetterAt(i),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                                    child: AnimatedLetter(
                                      key: ValueKey('letter_$i'),
                                      letter: letter,
                                      color: color,
                                      index: i,
                                    ),
                                  ),
                                )
                                    : const GlowingCircle(),
                              );
                            }),
                          );
                        }),
                        SizedBox(height:MediaQuery.of(context).size.height*0.04),
                        Obx(() {
                          final selected = controller.selectedLetters;
                          final currentWord = controller.currentWord.value;

                          if (selected.isEmpty) {
                            return SizedBox();
                          }
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: roundedDecoration,
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 8,
                              runSpacing: 8, // spacing between lines
                              children: List.generate(selected.length, (i) {
                                return Padding(
                                  key: ValueKey('text_${selected[i]}$i'),
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    selected[i],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        }),
                        SizedBox(height:MediaQuery.of(context).size.height*0.1),
                        Obx(() {
                          final isEnabled = controller.isComplete.value && controller.selectedLetters.isNotEmpty;

                          return Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(160, 50),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                textStyle: const TextStyle(fontSize: 16),
                                backgroundColor: isEnabled ? Colors.blue : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: isEnabled
                                  ? () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => _buildResultDialog(context, controller.isCorrect.value),
                                );
                                Future.delayed(const Duration(seconds: 2), () {
                                  Navigator.of(context).pop();
                                  if (controller.currentIndex.value == 7) {
                                    splashAd.showInterstitialAd();
                                  }
                                  if (controller.currentIndex.value < controller.words.length - 1) {
                                    controller.nextPuzzle();
                                    pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  } else {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => PuzzleCompletePage(
                                          words: controller.words,
                                          correctCount: controller.correctAnswers.length,
                                          totalCount: controller.words.length,
                                        ),
                                      ),
                                    );
                                  }
                                });
                              }
                                  : null,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text("Next"),
                                  const SizedBox(width: 12),
                                  AnimatedForwardArrow(isEnabled: isEnabled),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      })
    );
  }
  Widget _buildResultDialog(BuildContext context, bool isCorrect) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isCorrect ? Icons.check_circle_outline : Icons.cancel_outlined,
              color: isCorrect ? Colors.green : Colors.red,
              size: 60,
            ),
            const SizedBox(height: 12),
            Text(
              isCorrect ? "Correct!" : "Incorrect!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isCorrect ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class PuzzleCompletePage extends StatelessWidget {
  final List<String> words;
  final int correctCount;
  final int totalCount;

  const PuzzleCompletePage({
    super.key,
    required this.words,
    required this.correctCount,
    required this.totalCount

  });

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
                      "Game Result",
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
            padding: const EdgeInsets.only(top:90.0),
            child: Container(
              decoration: roundedDecoration,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height:260,
                        child: Lottie.asset(
                          'assets/won.json',
                          // repeat: false,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: roundedDecoration,
                        child: Column(
                          children: [
                            Text(
                              "Score: $correctCount / $totalCount",
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Points Earned: ${correctCount * 10}",
                              style: const TextStyle(fontSize: 18, color: Colors.green),
                            ),
                            const SizedBox(height:25),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:18.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  textStyle: const TextStyle(fontSize: 16),
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed:() {
                                  Navigator.of(context).pop();
                                }, child:Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text("Try Again"),
                                  const SizedBox(width:12),
                                  AnimatedForwardArrow(isEnabled:true,),
                                ],
                              ),
                              ),
                            ),
                            SizedBox(height:MediaQuery.of(context).size.height*0.02),
                              NativeAdWidget()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }
}
