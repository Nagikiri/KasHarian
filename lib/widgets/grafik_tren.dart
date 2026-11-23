import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/periode.dart';

// Dipanggil hanya kalau ada pengeluaran di periode itu, karena skala dihitung dari nilai tertinggi.
class GrafikTren extends StatefulWidget {
  final int jenis;
  final DateTime awal;
  final DateTime akhir;

  const GrafikTren({
    super.key,
    required this.jenis,
    required this.awal,
    required this.akhir,
  });

  @override
  State<GrafikTren> createState() => _GrafikTrenState();
}

class _GrafikTrenState extends State<GrafikTren> {
  // Batang yang sedang diketuk. null berarti belum ada yang dipilih.
  int? _dipilih;

  // Ketuk batang yang sama atau area kosong untuk melepas pilihan.
  void _ketuk(FlTouchEvent event, BarTouchResponse? respons) {
    if (event is! FlTapUpEvent) return;
    int? indeks = respons?.spot?.touchedBarGroupIndex;
    setState(() => _dipilih = indeks == _dipilih ? null : indeks);
  }

  @override
  Widget build(BuildContext context) {
    int jenis = widget.jenis;
    DateTime awal = widget.awal;
    DateTime akhir = widget.akhir;
    List<int> nilai = AppData.trenPengeluaran(jenis, awal, akhir);
    List<String> label = labelTren(jenis, awal, akhir);
    List<String> tooltip = labelTooltipTren(jenis, awal, akhir);
    int tertinggi = nilai.reduce((a, b) => a > b ? a : b);
    // Sebelum ada yang diketuk, batang tertinggi yang disorot supaya puncaknya langsung terlihat.
    int disorot = _dipilih ?? nilai.indexOf(tertinggi);
    int langkah = langkahSumbu(tertinggi);
    double batasAtas = (langkah * 4).toDouble();
    double lebar = lebarBatang(nilai.length);

    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          maxY: batasAtas,
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: langkah.toDouble(),
            getDrawingHorizontalLine: (_) =>
                const FlLine(color: WarnaApp.garis, strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 52,
                interval: langkah.toDouble(),
                getTitlesWidget: (posisi, meta) => SideTitleWidget(
                  meta: meta,
                  space: JarakApp.j8,
                  // Label 0 disembunyikan supaya dasar grafik tidak ramai.
                  child: Text(
                    posisi == 0 ? '' : formatRingkas(posisi.round()),
                    style: TeksApp.mini,
                  ),
                ),
              ),
            ),
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
            // Tooltip bawaan hilang saat jari diangkat, jadi diganti pilihan yang tetap tampil.
            handleBuiltInTouches: false,
            // Seluruh tinggi kolom bisa diketuk, termasuk batang yang pendek atau 0.
            allowTouchBarBackDraw: true,
            touchCallback: _ketuk,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => WarnaApp.teksUtama,
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItem: (grup, indeksGrup, batang, indeksBatang) =>
                  BarTooltipItem(
                    '${tooltip[indeksGrup]}\n',
                    TeksApp.mini.copyWith(color: WarnaApp.diAtasPrimer),
                    children: [
                      TextSpan(
                        text: formatRupiah(batang.toY.round()),
                        style: TeksApp.angka.copyWith(
                          color: WarnaApp.diAtasPrimer,
                        ),
                      ),
                    ],
                  ),
            ),
          ),
          barGroups: [
            for (int i = 0; i < nilai.length; i++)
              BarChartGroupData(
                x: i,
                showingTooltipIndicators: i == _dipilih ? [0] : [],
                barRods: [
                  BarChartRodData(
                    toY: nilai[i].toDouble(),
                    width: lebar,
                    color: i == disorot
                        ? WarnaApp.primer
                        : WarnaApp.primer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(lebar > 6 ? 6 : 3),
                    ),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: batasAtas,
                      color: Colors.transparent,
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
