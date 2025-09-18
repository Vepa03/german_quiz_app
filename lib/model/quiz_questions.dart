class QuizQuestions {
  final String id;
  final String question;          // <-- Tekil ve "question"
  final List<Option> options;
  final String correctAnswer;     // <-- "correct_answer"

  QuizQuestions({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuizQuestions.fromJson(Map<String, dynamic> json) {
    return QuizQuestions(
      id: json['id'] as String,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => Option.fromJson(e as Map<String, dynamic>))
          .toList(),
      correctAnswer: json['correct_answer'] as String,
    );
  }
}

class Option {
  final String id;
  final String text;

  Option({required this.id, required this.text});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'] as String,
      text: json['text'] as String,
    );
  }
}
