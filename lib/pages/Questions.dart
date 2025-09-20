import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:german_quiz_app/model/quiz_questions.dart';
import 'package:german_quiz_app/simple_provider.dart';

class Questions extends ConsumerStatefulWidget {
  const Questions({super.key});

  @override
  ConsumerState<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends ConsumerState<Questions> {

  late Future<List<QuizQuestions>> futureQuestions;

  final Map<int, String> selected = {};

  @override
  void initState(){
    super.initState();
    futureQuestions = loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    final true_score = ref.watch(trueProvider);
    final false_score = ref.watch(falseProvider);
    return Scaffold(
      appBar: AppBar(title: Row(
        children: [
          Text("Score: $true_score"),
          Text("Score: $false_score"),
        ],
      )),
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
                                    final isInCorrect = o.id != q.correctAnswer;
                                    setState(() {
                                      selected[index] = o.id; // seçimi kaydet
                                      if (isCorrect) ref.read(trueProvider.notifier).state++;
                                      if (isInCorrect) ref.read(falseProvider.notifier).state++;  // sadece ilk ve doğru seçişte artar
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