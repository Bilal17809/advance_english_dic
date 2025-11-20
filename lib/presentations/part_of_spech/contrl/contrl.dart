import 'package:get/get.dart';
import '../../../data/hepler/db_class.dart';
import '../../../data/models/models.dart';

class PartOfSpeechController extends GetxController {
  final QuizDatabaseService _dbService = QuizDatabaseService();

  var partOfSpeechList = <PartOfSpeech>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    await _dbService.initDatabase();
    partOfSpeechList.value = await _dbService.fetchMenuData();
    isLoading.value = false;
  }

  @override
  void onClose() {
    _dbService.dispose();
    super.onClose();
  }
}
