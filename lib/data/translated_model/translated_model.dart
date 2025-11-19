class TranslationRecord {
  final String originalText;
  final String translatedText;
  final String originalLanguage;
  final String translatedLanguage;
  final String originalFlag;
  final String translatedFlag;

  TranslationRecord({
    required this.originalText,
    required this.translatedText,
    required this.originalLanguage,
    required this.translatedLanguage,
    required this.originalFlag,
    required this.translatedFlag,
  });

  Map<String, dynamic> toJson() => {
    'originalText': originalText,
    'translatedText': translatedText,
    'originalLanguage': originalLanguage,
    'translatedLanguage': translatedLanguage,
    'originalFlag': originalFlag,
    'translatedFlag': translatedFlag,
  };

  factory TranslationRecord.fromJson(Map<String, dynamic> json) {
    return TranslationRecord(
      originalText: json['originalText'],
      translatedText: json['translatedText'],
      originalLanguage: json['originalLanguage'],
      translatedLanguage: json['translatedLanguage'],
      originalFlag: json['originalFlag'],
      translatedFlag: json['translatedFlag'],
    );
  }
}
