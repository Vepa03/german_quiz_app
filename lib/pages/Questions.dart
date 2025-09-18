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

  @override
  void initState() {
    super.initState();
    futureQuestions = loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<QuizQuestions>>(
  future: futureQuestions,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Center(child: Text('Hata: ${snapshot.error}'));
    }
    final questions = snapshot.data ?? [];
    if (questions.isEmpty) {
      return const Center(child: Text('Soru bulunamadı.'));
    }

    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final q = questions[index];
        return Card(
          margin: const EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  q.question, // <--- DÜZELTME
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...q.options.map((opt) => ListTile(
                      title: Text(opt.text),
                      onTap: () {
                        final isCorrect = opt.id == q.correctAnswer;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(isCorrect ? "Doğru ✅" : "Yanlış ❌")),
                        );
                      },
                    )),
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

Future<List<QuizQuestions>> loadQuestions() async {
  final data = await rootBundle.loadString('assets/data/sorular.json');
  final List<dynamic> jsonResult = json.decode(data);
  return jsonResult.map((e) => QuizQuestions.fromJson(e)).toList();
}