import 'package:get/get.dart';

import '../../../data/hepler/top_phrases.dart';
import '../../../data/models/conversation_model.dart';

class ConversationController extends GetxController {
  var allConversations = <ConversationModel>[].obs;
  var filteredConversations = <ConversationModel>[].obs;
  var selectedCategory = ''.obs;
  final dbHelper = DatabaseDServices();


  @override
  void onInit() {
    fetchAllConversations();
    super.onInit();
  }

  void fetchAllConversations() async {
    final conversation = await dbHelper.fetchConversations();
    allConversations.assignAll(conversation);
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    filteredConversations.assignAll(
      allConversations.where((c) => c.category == category).toList(),
    );
  }
}
