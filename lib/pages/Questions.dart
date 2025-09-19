import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:german_quiz_app/model/quiz_questions.dart';

class Questions extends StatefulWidget {
  const Questions({super.key});

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {

  late Future<List<QuizQuestions>> futureQuestions;

  int score =0;

  final Map<int, String> selected = {};

  @override
  void initState(){
    super.initState();
    futureQuestions = loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Score: $score")),
      body: FutureBuilder<List<QuizQuestions>>(
        future: futureQuestions,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text("Error ${snapshot.error}"));
          final questions = snapshot.data!;
          if (questions.isEmpty) return Center(child: Text("No Questions"));

          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final q = questions[index];
              final selectedId = selected[index]; // bu soru için seçilen şık (varsa)

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${q.id})  ${q.question}",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        childAspectRatio: 3,
                        children: q.options.map((o) {
                          final bool isChosen = selectedId == o.id;
                          final bool locked = selectedId != null; // bir şık seçildiyse kilitli
                
                          return GestureDetector(
                            onTap: locked
                                ? null // zaten bir seçim yapıldı, tekrar seçilemez
                                : () {
                                    final isCorrect = o.id == q.correctAnswer;
                                    setState(() {
                                      selected[index] = o.id; // seçimi kaydet
                                      if (isCorrect) score++;  // sadece ilk ve doğru seçişte artar
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(isCorrect ? "True" : "False")),
                                    );
                                  },
                            child: Container(
                              margin: EdgeInsets.all(6),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: isChosen
                                    ? (o.id == q.correctAnswer
                                        ? Colors.green.shade100
                                        : Colors.red.shade100)
                                    : Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isChosen ? Colors.black54 : Colors.blueGrey.shade200,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  o.text,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isChosen ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
      
  }
}

Future <List<QuizQuestions>> loadQuestions() async {
  final data = await rootBundle.loadString("assets/data/sorular.json");
  final List<dynamic> jsonResult = jsonDecode(data);
  return jsonResult.map((e)=> QuizQuestions.fromJson(e)).toList(); 
}