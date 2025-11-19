class DictionaryKey {
  final int idRef;
  final String? word;
  final String? wordAsId;
  // Constructor
  DictionaryKey({
    required this.idRef,
    required this.word,
    required this.wordAsId
  });

  factory DictionaryKey.fromMap(Map<String, dynamic> map) {
    return DictionaryKey(
      idRef: map['_idref'] as int,
      word: map['word'] as String?,
      wordAsId: map['wordasID'] as String?,
    );
  }
}


class DictionaryDes {
  final int id;
  final String? definition;
  final String? category;
  final String? synonyms;
  final String? hyponyms;
  final String? instanceHyponyms;
  final String? hypernams;
  // Constructor
  DictionaryDes({
    required this.id,
    required this.category,
    required this.definition,
    required this.synonyms,
    required this.hypernams,
    required this.hyponyms,
    required this.instanceHyponyms
  });

  factory DictionaryDes.fromMap(Map<String, dynamic> map) {
    return DictionaryDes(
      id: map['_id'] as int,
      definition: map['definition'] as String?,
      category: map['category'] as String?,
      synonyms: map['synonyms'] as String?,
      hyponyms: map['hyponyms'] as String?,
      hypernams: map['hypernyms'] as String?,
      instanceHyponyms: map['instanceHyponyms'] as String?,
    );
  }
}