import 'package:get/get.dart';
import '../../../data/hepler/db_class.dart';
import '../../../data/models/models.dart';
class PuzzleController extends GetxController {
  late String level;
  final QuizDatabaseService _dbService = QuizDatabaseService();

  // Puzzle state
  RxList<String> letters = <String>[].obs;
  RxString currentWord = ''.obs;
  RxInt currentIndex = 0.obs;
  RxBool isCorrect = false.obs;
  RxBool isComplete = false.obs;
  RxList<int> usedIndexes = <int>[].obs;
  RxList<String> selectedLetters = <String>[].obs;
  // Data
  var partOfSpeechList = <PartOfSpeech>[].obs;
  var isLoading = true.obs;
  List<String> words = [];
  List<String> hints = [];
  var currentHintVisible = false.obs;
  List<String> correctAnswers = [];
  RxList<int> revealedIndexes = <int>[].obs;

  void removeLetterAt(int index) {
    if (index < selectedLetters.length) {
      final removedLetter = selectedLetters.removeAt(index);
      final originalIndex = letters.indexOf(removedLetter);
      if (originalIndex != -1) {
        usedIndexes.remove(originalIndex);
      }

      selectedLetters.refresh();
      usedIndexes.refresh();
    }
  }


  void addLetter(String letter, int index) {
    if (!usedIndexes.contains(index)) {
      usedIndexes.add(index);
      selectedLetters.add(letter);
      currentWord.value = selectedLetters.join('');
    }
    if (selectedLetters.length == letters.length) {
      isComplete.value = true;
      isCorrect.value = currentWord.value == words[currentIndex.value];

      if (isCorrect.value) {
        correctAnswers.add(currentWord.value);
      }
    }
  }


  void setLevel(String lvl) {
    level = lvl;
  }

  Future<void> loadPuzzles() async {
    isLoading.value = true;

    await _dbService.initDatabase();
    partOfSpeechList.value = await _dbService.fetchMenuData();

    final filtered = partOfSpeechList.where((e) {
      final length = e.word.length;
      switch (level) {
        case '1':
          return length >= 3 && length <= 5;
        case '2':
          return length >= 6 && length <= 7;
        case '3':
          return length >= 8;
        default:
          return true;
      }
    }).toList();

    // Shuffle the filtered list
    filtered.shuffle();

    // Take only 15 items
    final limited = filtered.take(20).toList();

    // Extract words and hints
    words = limited.map((e) => e.word.toUpperCase()).toList();
    hints = limited.map((e) => e.meaning ?? 'No hint available').toList();

    if (words.isNotEmpty) {
      setPuzzle(0);
    }

    isLoading.value = false;
  }


  void setPuzzle(int index) {
    if (index >= 0 && index < words.length) {
      currentIndex.value = index;
      String word = words[index];
      letters.value = word.split('')..shuffle();
      currentWord.value = '';
      selectedLetters.clear();
      usedIndexes.clear();
      isCorrect.value = false;
      isComplete.value = false;
      currentHintVisible.value = false;
    }
  }

  void nextPuzzle() {
    if (currentIndex.value < words.length - 1) {
      // Reset states for the new puzzle
      lastRevealedIndex = -1;
      totalRevealedCount = 0;
      selectedLetters.clear();
      usedIndexes.clear();
      currentWord.value = '';

      setPuzzle(currentIndex.value + 1);
    }
  }


  // void nextPuzzle() {
  //   if (currentIndex.value < words.length - 1) {
  //     setPuzzle(currentIndex.value + 1);
  //   }
  // }

  void revealHint() {
    for (int i = 0; i < letters.length; i++) {
      if (!usedIndexes.contains(i)) {
        addLetter(letters[i], i);
        break;
      }
    }
  }

  String getHintForCurrentWord() {
      return hints[currentIndex.value];
  }


  int lastRevealedIndex = -1;
  int totalRevealedCount = 0;

  void revealPartialCorrectSequence() {
    if (words.isEmpty || currentIndex.value < 0) return;

    String word = words[currentIndex.value];

    // 1. Create a set of used indexes
    Set<int> used = usedIndexes.toSet();

    // 2. Find all correct letters that are not yet used
    for (int i = 0; i < word.length; i++) {
      String correctLetter = word[i];

      // Check if already placed correctly
      if (selectedLetters.length > i && selectedLetters[i] == correctLetter) {
        continue;
      }

      // Find a correct letter in the shuffled list that hasn't been used yet
      for (int j = 0; j < letters.length; j++) {
        if (letters[j] == correctLetter && !used.contains(j)) {
          // Add it to selection
          addLetter(letters[j], j);
          return; // Return after adding one correct letter
        }
      }
    }

    // 3. If no correct letters are found, add any unused letter
    for (int i = 0; i < letters.length; i++) {
      if (!used.contains(i)) {
        addLetter(letters[i], i);
        return;
      }
    }
  }

  @override
  void onClose() {
    _dbService.dispose();
    super.onClose();
  }
}




