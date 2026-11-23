import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/format.dart';

// Dipanggil hanya kalau ada nilai di atas 0, karena skala grafik dihitung dari nilai tertinggi.
class GrafikTren extends StatelessWidget {
  final List<int> nilai;
  final List<String> label;

  const GrafikTren({super.key, required this.nilai, required this.label});

  @override
  Widget build(BuildContext context) {
    int tertinggi = nilai.reduce((a, b) => a > b ? a : b);
    int indeksTertinggi = nilai.indexOf(tertinggi);
    // Ruang 20% di atas batang tertinggi supaya tooltip tidak terpotong.
    double batasAtas = tertinggi * 1.2;

    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          maxY: batasAtas,
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: batasAtas / 4,
            getDrawingHorizontalLine: (_) =>
                const FlLine(color: WarnaApp.garis, strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (posisi, meta) => SideTitleWidget(
                  meta: meta,
                  space: JarakApp.j4,
                  child: Text(label[posisi.toInt()], style: TeksApp.mini),
                ),
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => WarnaApp.teksUtama,
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItem: (grup, indeksGrup, batang, indeksBatang) =>
                  BarTooltipItem(
                    formatRupiah(batang.toY.round()),
                    TeksApp.kecil.copyWith(color: WarnaApp.diAtasPrimer),
                  ),
            ),
          ),
          barGroups: [
            for (int i = 0; i < nilai.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: nilai[i].toDouble(),
                    width: nilai.length > 12 ? 6 : 16,
                    // Batang tertinggi penuh, yang lain dibuat pudar supaya puncaknya langsung terlihat.
                    color: i == indeksTertinggi
                        ? WarnaApp.primer
                        : WarnaApp.primer.withValues(alpha: 0.4),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(JarakApp.j4),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
