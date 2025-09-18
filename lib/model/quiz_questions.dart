class QuizQuestions {
  final String id;
  final String questions;
  final List<Option> options;
  final String correctAnswer;
  
  QuizQuestions({
    required this.id,
    required this.questions,
    required this.options,
    required this.correctAnswer
  });

  factory QuizQuestions.fromJson(Map<String , dynamic> json ){
    return QuizQuestions(
      id: json['id'], 
      questions: json['question'],
      options: (json['options'] as List).map((e)=> Option.fromJson(e)).toList(),
      correctAnswer: json['correct_answer']
    );
  }


}

class Option {
  final String id;
  final String text;

  Option({
    required this.id,
    required this.text
  });

  factory Option.fromJson(Map<String, dynamic> json){
    return Option(id: json['id'], text: json['text']);
  }

}