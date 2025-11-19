import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/adds/instertial_adds.dart';
import '/core/common_widgets/bg_circular.dart';
import '/core/common_widgets/icon_buttons.dart';
import '/core/constant/constant.dart';
import '/core/theme/app_styles.dart';
import '../../daliy_quiz/contrl/quizz_controller.dart';
import '../../daliy_quiz/view/quizz_page.dart';
import '../../home/view/home_page.dart';
import '../../remove_ads_contrl/remove_ads_contrl.dart';

class QuizResultPage extends StatefulWidget {
  final int correctAnswers;
  final int totalQuestions;
  final List<QuizResultItem> quizResults;
  final int wrongAnswers;
  final int levelId;
  final String name;
  const QuizResultPage({
    Key? key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.quizResults,
    required this.wrongAnswers,
    required this.levelId,
    required this.name
  }) : super(key: key);

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  final RemoveAds removeAds = Get.put(RemoveAds());
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
    double percentage = (widget.correctAnswers / widget.totalQuestions) * 100;

    return Scaffold(
      backgroundColor: Colors.white,
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
                  Center(
                    child: Text(
                      "Quiz Result",
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
          Padding(
            padding: EdgeInsets.only(top: 100, left: kBodyHp, right: kBodyHp),
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Container(
                decoration: roundedDecoration,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Congratulations! You have scored',
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.065,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Correct Answers: ${widget.correctAnswers}',
                            style: context.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: widget.correctAnswers / widget.totalQuestions),
                            duration: const Duration(seconds: 2),
                            builder: (context, value, _) => ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                              child: LinearProgressIndicator(
                                value: value,
                                backgroundColor: Colors.blue.withOpacity(0.2),
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                                minHeight: 10,
                              ),
                            ),
                          ),
                          SizedBox(height:MediaQuery.of(context).size.height*0.030),
                          Text(
                            'Incorrect Answers: ${widget.wrongAnswers}',
                            style: context.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TweenAnimationBuilder<double>(
                            tween: Tween(
                              begin: 0,
                              end: (widget.totalQuestions - widget.correctAnswers) / widget.totalQuestions,
                            ),
                            duration: const Duration(seconds: 2),
                            builder: (context, value, _) => ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                              child: LinearProgressIndicator(
                                value: value,
                                backgroundColor: Colors.red.withOpacity(0.2),
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                                minHeight: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      decoration: roundedDecoration,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Get.to(QuizResultSheet(quizResults: widget.quizResults));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3A8DFF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                              textStyle: const TextStyle(fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Answer Key"),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              final testQuizController = Get.find<TestQuizController>();
                              testQuizController.resetQuiz();

                              Get.off(() => QuizPage(questions: testQuizController.quizzes,
                                titleName:widget.name, levelId:widget.levelId,));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3A8DFF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                              textStyle: const TextStyle(fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Retake"),
                          ),

                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Get.off(() => HomePage());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3A8DFF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                              textStyle: const TextStyle(fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Exit"),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class QuizResultSheet extends StatelessWidget {
  final List<QuizResultItem> quizResults;

  const QuizResultSheet({Key? key, required this.quizResults}) : super(key: key);

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
                      "Quiz Results",
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
          Padding(
            padding: const EdgeInsets.only(top: 90, left: kBodyHp, right: kBodyHp),
            child: Container(
              decoration: roundedDecoration,
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: quizResults.length,
                itemBuilder: (_, index) {
                  final item = quizResults[index];
                  final isCorrect = item.isCorrect;

                  return Container(
                    decoration: roundedDecoration,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Q${index + 1}: ${item.question}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              isCorrect ? Icons.check_circle : Icons.cancel,
                              color: isCorrect ? Colors.green : Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Your Answer: ${item.selectedAnswer}',
                              style: TextStyle(
                                color: isCorrect ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Correct Answer:',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 28.0),
                          child: Text(
                            item.correctAnswer,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuizResultItem {
  final String question;
  final String correctAnswer;
  final String selectedAnswer;
  final bool isCorrect;

  QuizResultItem({
    required this.question,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.isCorrect,
  });
}
