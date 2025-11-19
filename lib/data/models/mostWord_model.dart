class TopicPhrases {
  final int id;
  final String? title;
  final String? desc;
  // Constructor
  TopicPhrases({
    required this.id,
    required this.title,
    required this.desc
  });

  factory TopicPhrases.fromMap(Map<String, dynamic> map) {
    return TopicPhrases(
      id: map['id'] as int,
      title: map['title'] as String?,
      desc: map['desc'] as String?,
    );
  }
}

class TopicPhrasesSentence {
  final int id;
  final int topicId;
  final String? explain;
  final String? sentence;
  // Constructor
  TopicPhrasesSentence({
    required this.id,
    required this.topicId,
    required this.explain,
    required this.sentence
  });

  factory TopicPhrasesSentence.fromMap(Map<String, dynamic> map) {
    return TopicPhrasesSentence(
      id: map['id'] as int,
      explain: map['explaination'] as String?,
      sentence: map['sentence'] as String?,
      topicId: map['TopicId'] as int,
    );
  }
}

class Words {
  final int id;
  final String? keyword;
  final String? type;
  final String? definition;
  final String? example;
  // Constructor
  Words({
    required this.id,
    required this.keyword,
    required this.type,
    required this.definition,
    required this.example
  });

  factory Words.fromMap(Map<String, dynamic> map) {
    return Words(
      id: map['id'] as int,
      keyword: map['Keyword'] as String?,
      type: map['type'] as String?,
      definition: map['definition'] as String?,
      example: map['example'] as String?,
    );
  }
}