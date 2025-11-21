class LanguageModel {
  final String language;
  final String code;
  final String flag;
  final String locale;
  final String displayName;
  LanguageModel({
    required this.language,
    required this.code,
    required this.flag,
    required this.locale,
    required this.displayName

  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      language: json['language'],
      code: json['code'],
      flag: json['flag'],
      locale: json['locale'],
      displayName: json["display_name"] ?? "Error",
    );

  }
  Map<String, dynamic> toJson() {
    return {
      "language": language,
      "code": code,
      "flag": flag,
      "locale": locale,
      "display_name":displayName
    };
  }
}
