import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/hepler/test_quiz_db.dart';
import '../../../data/models/quiz_model.dart';
import 'package:get/get.dart';

class QuizLevelController extends GetxController {
  final TestQuizDbHelper _dbHelper = TestQuizDbHelper();
  List<QuizModel> _quizzes = [];

  bool isLoading = true;

  var results = <int, Map<String, int>>{}.obs;

  Map<int, List<QuizModel>> get quizzesBySubLevel {
    final map = <int, List<QuizModel>>{};
    for (final quiz in _quizzes) {
      map.putIfAbsent(quiz.subLevel, () => []);
      map[quiz.subLevel]!.add(quiz);
    }
    return map;
  }

  @override
  void onInit() {
    super.onInit();
    loadQuizzesFromDb();
  }

  Future<void> loadQuizzesFromDb() async {
    await _dbHelper.initDatabase();
    _quizzes = await _dbHelper.fetchQuizData();
    isLoading = false;
    update();
    await loadAllResults();
  }

  Future<void> loadAllResults() async {
    final prefs = await SharedPreferences.getInstance();
    for (var level in quizzesBySubLevel.keys) {
      final correct = prefs.getInt('${level}correct') ?? 0;
      final wrong = prefs.getInt('${level}wrong') ?? 0;
      results[level] = {'correct': correct, 'wrong': wrong};
    }
  }

  void refreshResults() async {
    await loadAllResults();
  }

  @override
  void onClose() {
    _dbHelper.dispose();
    super.onClose();
  }
}
