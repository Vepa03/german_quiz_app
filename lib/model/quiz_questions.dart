class QuizCategories {
  final String id;
  final String Category;
  final List<QuizQuestions> questions;

  QuizCategories({
    required this.id,
    required this.Category,
    required this.questions
  });

  factory QuizCategories.fromJson(Map<String, dynamic> json){
    return QuizCategories(
      id: json['id'] as String, 
      Category: json['questions'] as String, 
      questions: (json['questions'] as List<dynamic>).map((e)=> QuizQuestions.fromJson(e as Map<String, dynamic>)).toList(),
      );
  }
}

class QuizQuestions {
  final String id;
  final String question;          
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
