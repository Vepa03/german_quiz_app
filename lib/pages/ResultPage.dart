import 'package:flutter/material.dart';
import 'package:german_quiz_app/model/quiz_questions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:german_quiz_app/selected_provider.dart';

class ResultsPage extends ConsumerWidget {
  final String title;
  final List<QuizQuestions> questions;
  final Map<int, String> selected;

  const ResultsPage({
    super.key,
    required this.title,
    required this.questions,
    required this.selected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int correct = 0;
    for (var i = 0; i < questions.length; i++) {
      final sel = selected[i];
      if (sel != null && sel == questions[i].correctAnswer) correct++;
    }
    final incorrect = selected.length - correct;

    return Scaffold(
      appBar: AppBar(
        title: Text('$title — Sonuçlar'),
        actions: [
          IconButton(
            tooltip: 'Sıfırla',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(selectedProvider.notifier).clear();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: ListTile(
              title: Text('Toplam ${questions.length} soru'),
              subtitle: Text('✅ Doğru: $correct   ❌ Yanlış: $incorrect'),
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(questions.length, (index) {
            final q = questions[index];
            final sel = selected[index];
            final isCorrect = sel != null && sel == q.correctAnswer;

            // seçilen ve doğru şıkkın metinlerini bul
            String? selectedText =
                q.options.firstWhere((o) => o.id == sel, orElse: () => 
                  // dummy option
                  (/* ignore */) as dynamic,
                ).text;
            String correctText =
                q.options.firstWhere((o) => o.id == q.correctAnswer).text;

            // sel null olabilir, güvenli çözüm:
            selectedText = sel == null
                ? '—'
                : q.options.firstWhere((o) => o.id == sel).text;

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${q.id}) ${q.question}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Text('Seçimin: '),
                        Flexible(
                          child: Text(
                            selectedText,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: sel == null
                                  ? Colors.grey
                                  : (isCorrect ? Colors.green : Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('Doğru: '),
                        Flexible(
                          child: Text(
                            correctText,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
