import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../adds/binner_adds.dart';
import '../../../adds/instertial_adds.dart';
import '../../../adds/native_adss.dart';
import '../../../adds/open_screen.dart';
import '../../../core/common_widgets/bg_circular.dart';
import '../../../core/common_widgets/go_next_btn.dart';
import '../../../core/theme/app_styles.dart';
import '../../../data/models/quiz_model.dart';
import '../../quiz_result/view/quiz_result_page.dart';
import '../../remove_ads_contrl/remove_ads_contrl.dart';
import '../controller/quiz_controller.dart';

class QuizPage extends StatefulWidget {
  final List<QuizModel> questions;
  final String titleName;
  final int levelId;
  QuizPage({super.key,
  required this.questions,
  required this.titleName,
  required this.levelId
  });
  @override
  State<QuizPage> createState() => _QuizPageState();
}
class _QuizPageState extends State<QuizPage> {
  final PageController _pageController = PageController();
  late final DailyQuizController _controller;
  final RemoveAds removeAds = Get.put(RemoveAds());
  final AppOpenAdController appOpenAdController=Get.put(AppOpenAdController());
  final InterstitialAdController interstitialAdController=Get.put(InterstitialAdController());

  @override
  void initState() {
    super.initState();
    interstitialAdController.checkAndShowAd();
    _controller = Get.put(DailyQuizController());
    _controller.setQuestions(widget.questions);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundCircles(),
          Obx(() {
            if (_controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_controller.quizzes.isEmpty) {
              return const Center(child: Text("No questions found"));
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 50,
                    left: 16,
                    right: 16,
                  ),
                  child: Obx(() {
                    double progress = (_controller.currentIndex.value + 1) / _controller.quizzes.length;
                    return Container(
                      decoration: roundedDecoration,
                      padding: EdgeInsets.all(8),
                      child:  Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.grey[300],
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                                minHeight: 10,
                              ),
                            ),
                          ),
                          SizedBox(width:5,),
                          Text(
                            "${_controller.currentIndex.value + 1}/${_controller.quizzes.length}",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                Expanded(
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    itemCount: _controller.quizzes.length,
                    itemBuilder: (context, index) {
                      final quiz = _controller.quizzes[index];

                      return Obx(() {
                        final selected = _controller.selectedAnswers.value[index];
                        return Padding(
                          padding: const EdgeInsets.only(top:15, left: 15, right: 15),
                          child: Container(
                            decoration: roundedDecoration,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Q${index + 1}: ${quiz.qContent}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    ...["A", "B", "C", "D"].map((code) {
                                      final text = switch (code) {
                                        "A" => quiz.answerA,
                                        "B" => quiz.answerB,
                                        "C" => quiz.answerC,
                                        "D" => quiz.answerD,
                                        _ => "",
                                      };
                                
                                      final correctAnswerText = _controller.correctOptionForHighlight[index];
                                
                                      return OptionTile(
                                        code: code,
                                        text: text,
                                        selectedCode: selected,
                                        correctCode: correctAnswerText ?? "",
                                        onTap: () => _controller.selectAnswer(index, code),
                                      );
                                    }),
                                    SizedBox(height: 10,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                                      child: SettingItem(
                                        title: index == _controller.quizzes.length - 1 ? "Finish" : "Next",
                                        icon: Icons.arrow_forward,
                                        bgColor: selected != null ? Colors.blueAccent : Colors.grey, // grey if not selected
                                        iconColor: Colors.white,
                                        value: index == _controller.quizzes.length - 1 ? "Finish Quiz" : "Next Question",
                                        onTap: () async {
                                          if (selected == null) return; // prevent action if not selected

                                          if (index < _controller.quizzes.length - 1) {
                                            _pageController.nextPage(
                                              duration: const Duration(milliseconds: 400),
                                              curve: Curves.easeInOut,
                                            );
                                            _controller.currentIndex.value = index + 1;
                                          } else {
                                            await _controller.saveResultsToPreferences(widget.levelId);
                                            await _controller.saveDailyPerformance();

                                            List<QuizResultItem> quizResults = List.generate(
                                              _controller.quizzes.length,
                                                  (index) {
                                                final quiz = _controller.quizzes[index];
                                                final selectedCode = _controller.selectedAnswers[index] ?? "";
                                                final selectedText = switch (selectedCode) {
                                                  "A" => quiz.answerA,
                                                  "B" => quiz.answerB,
                                                  "C" => quiz.answerC,
                                                  "D" => quiz.answerD,
                                                  _ => "",
                                                };

                                                return QuizResultItem(
                                                  question: quiz.qContent,
                                                  correctAnswer: quiz.correctAnswer,
                                                  selectedAnswer: selectedText,
                                                  isCorrect: selectedText == quiz.correctAnswer,
                                                );
                                              },
                                            );

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => QuizResultPage(
                                                  correctAnswers: _controller.correctQuizzes.length,
                                                  totalQuestions: _controller.quizzes.length,
                                                  quizResults: quizResults,
                                                  wrongAnswers: _controller.wrongQuizzes.length,
                                                  levelId: widget.levelId,
                                                  name: widget.titleName,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
              ],
            );
          }),
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

class OptionTile extends StatelessWidget {
  final String code;
  final String text;
  final String? selectedCode;
  final String correctCode;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.code,
    required this.text,
    required this.selectedCode,
    required this.correctCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasAnswered = selectedCode != null;
    final bool isSelected = selectedCode == code;
    final bool isCorrectAnswer = text == correctCode;
    final bool isWrongSelection = isSelected && !isCorrectAnswer;

    // Background color
    Color bgColor = Colors.white;
    if (hasAnswered) {
      if (isCorrectAnswer) {
        bgColor = Colors.blue.shade100;
      } else if (isWrongSelection) {
        bgColor = Colors.red.shade100;
      }
    }

    // Icon color
    Color iconBg = Colors.grey.shade300;
    if (hasAnswered) {
      if (isCorrectAnswer) {
        iconBg = Colors.blue;
      } else if (isWrongSelection) {
        iconBg = Colors.red;
      }
    }

    return GestureDetector(
      onTap: hasAnswered ? null : onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: iconBg,
              child: Text(code, style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
