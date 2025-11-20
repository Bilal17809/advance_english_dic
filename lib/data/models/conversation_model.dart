class ConversationModel {
  final String? title;
  final String? conversation;
  final String? category;
  // Constructor
  ConversationModel({
    required this.title,
    required this.conversation,
    required this.category
  });
  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
      title: map['title'] as  String?,
      conversation: map['conversation'] as String?,
      category: map['category'] as String?,
    );
  }
}