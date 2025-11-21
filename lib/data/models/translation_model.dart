import '/data/models/languages_model.dart';

class TranslationModel {
  final int id;
  final LanguageModel from;
  final LanguageModel to;
  final String input;
  final String output;
  bool isFavorite;

  TranslationModel({
    required this.id,
    required this.from,
    required this.to,
    required this.input,
    required this.output,
    this.isFavorite = false,
  });

  factory TranslationModel.fromJson(Map<String, dynamic> json) => TranslationModel(
    id: json["id"],
    from: LanguageModel.fromJson(json["from"]),
    to: LanguageModel.fromJson(json["to"]),
    input: json["input"],
    output: json["output"],
    isFavorite: json["isFavorite"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "from": from.toJson(),
    "to": to.toJson(),
    "input": input,
    "output": output,
    "isFavorite": isFavorite,
  };
}
