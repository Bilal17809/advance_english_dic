class QuizModel {
  final int subLevel;
  final int qNumber;
  final String qContent;
  final String answerA;
  final String answerB;
  final String answerC;
  final String answerD;
  final String correctAnswer;
  QuizModel({
    required this.subLevel,
    required this.qNumber,
    required this.qContent,
    required this.answerA,
    required this.answerB,
    required this.answerC,
    required this.answerD,
    required this.correctAnswer,
  });
  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
        subLevel:json['SubLevel'] as int,
        qNumber:json['QNumber'] as int,
        qContent:json['QContent'] as String,
        answerA:json['AnswerA'] as String,
        answerB:json['AnswerB'] as String,
        answerC:json['AnswerC'] as String,
        answerD:json['AnswerD'] as String,
        correctAnswer:json['CorrectAnswer'] as String,
    );
  }
}



