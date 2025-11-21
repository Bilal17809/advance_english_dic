import 'dart:convert';

import 'package:flutter/services.dart';

import '../data/models/languages_model.dart';

class TranslatorService {
  Future<List<LanguageModel>> loadLanguages() async {
    final String response = await rootBundle.loadString('assets/translator_languages.json');
    final List data = json.decode(response);
    return data.map((e) => LanguageModel.fromJson(e)).toList();
  }
}