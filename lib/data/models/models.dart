class PartOfSpeech {
  final String partOfSpeech;
  final String word;
  final String meaning;
  final String example1;
  final String example2;
  final String example3;
  final String example4;
  final String example5;
  final String example6;
  final String example7;
  final String example8;
  final String example9;
  PartOfSpeech({
    required this.partOfSpeech,
    required this.word,
    required this.meaning,
    required this.example1,
    required this.example2,
    required this.example3,
    required this.example4,
    required this.example5,
    required this.example6,
    required this.example7,
    required this.example8,
    required this.example9,
  });
  factory PartOfSpeech.fromJson(Map<String, dynamic> json) {
    return PartOfSpeech(
        partOfSpeech:json['part_of_speech'] as String,
        word:json['word'] as String,
        meaning:json['meaning'] as String,
        example1:json['example_1'] as String,
        example2:json['example_2'] as String,
        example3:json['example_3'] as String,
        example4:json['example_4'] as String,
        example5:json['example_5'] as String,
        example6:json['example_6'] as String,
        example7:json['example_7'] as String,
        example8:json['example_8'] as String,
        example9:json['example_9'] as String
    );
  }
}



