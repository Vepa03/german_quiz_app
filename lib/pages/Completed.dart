import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:german_quiz_app/simple_provider.dart';

class Completed extends ConsumerWidget {
  const Completed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final true_score = ref.watch(trueProvider); // int -> rebuild için watch
    final false_score = ref.watch(falseProvider);
    // Burada toplamı kendin belirle (ör: 30 soru vardı diyelim)

    final data = <_Slice>[
      _Slice('True',   true_score.toDouble(), Colors.blue),
      _Slice('False',  false_score.toDouble(), Colors.red),
    ];

    final total = data.fold<double>(0, (p, e) => p + e.value);
    if (total == 0) {
      return const Scaffold(
        body: Center(child: Text('Grafikte gösterecek veri yok')),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1.3,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                  sections: data.map((d) {
                    final percent = (d.value / total * 100);
                    return PieChartSectionData(
                      color: d.color,
                      value: d.value,
                      title: '${percent.isNaN ? 0 : percent.toStringAsFixed(0)}%',
                      radius: 70,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: data.map((d) {
                final pct = (d.value / total * 100);
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12, height: 12,
                      decoration: BoxDecoration(color: d.color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text('${d.label} • ${pct.isNaN ? 0 : pct.toStringAsFixed(0)}%'),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Slice {
  final String label;
  final double value;
  final Color color;
  _Slice(this.label, this.value, this.color);
}
