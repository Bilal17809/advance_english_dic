import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/quiz_model.dart';

class TestQuizController extends GetxController {
  final isLoading = true.obs;
  final currentIndex = 0.obs;
  final selectedAnswers = <int, String>{}.obs;
  final correctQuizzes = <QuizModel>[].obs;
  final wrongQuizzes = <QuizModel>[].obs;
  final correctAnswerStatus = <int, bool?>{}.obs;
  final correctOptionForHighlight = <int, String>{}.obs;
  List<QuizModel> _quizzes = [];
  List<QuizModel> get quizzes => _quizzes;

  void setQuestions(List<QuizModel> questions) {
    _quizzes = questions;
    isLoading.value = false;
  }

  String? getSelectedAnswer(int index) => selectedAnswers[index];

  bool isCorrectAnswer(int index, String code) {
    return _quizzes[index].correctAnswer == code;
  }

  void resetQuiz() {
    currentIndex.value = 0;
    selectedAnswers.clear();
    correctQuizzes.clear();
    wrongQuizzes.clear();
    correctAnswerStatus.clear();
    correctOptionForHighlight.clear();
  }


  void selectAnswer(int index, String code) {
    if (!selectedAnswers.containsKey(index)) {
      selectedAnswers[index] = code;
      selectedAnswers.refresh();

      final quiz = _quizzes[index];
      final selectedText = switch (code) {
        "A" => quiz.answerA,
        "B" => quiz.answerB,
        "C" => quiz.answerC,
        "D" => quiz.answerD,
        _ => "",
      };

      final correctText = quiz.correctAnswer;

      if (selectedText == correctText) {
        correctQuizzes.add(quiz);
        correctAnswerStatus[index] = true;
      } else {
        wrongQuizzes.add(quiz);
        correctAnswerStatus[index] = false;
      }
      correctOptionForHighlight[index] = correctText;
    }
  }

  Future<void> saveResultsToPreferences(int levelId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('${levelId}correct', correctQuizzes.length);
    prefs.setInt('${levelId}wrong', wrongQuizzes.length);
  }

  Future<Map<String, int>> getResultsFromPreferences(int levelId) async {
    final prefs = await SharedPreferences.getInstance();
    final correct = prefs.getInt('${levelId}correct') ?? 0;
    final wrong = prefs.getInt('${levelId}wrong') ?? 0;
    return {
      'correct': correct,
      'wrong': wrong,
    };
  }

  Future<void> saveDailyPerformance() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('EEEE').format(DateTime.now());

    int existingCorrect = prefs.getInt('${today}correctP') ?? 0;
    int existingWrong = prefs.getInt('${today}wrongP') ?? 0;

    prefs.setInt('${today}correctP', existingCorrect + correctQuizzes.length);
    prefs.setInt('${today}wrongP', existingWrong + wrongQuizzes.length);
  }


}
