import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/privasi.dart';

// Label kanan grafik tren. Dipisah dari GrafikTren supaya file itu tetap di bawah 150 baris.
class LabelSumbuTren extends StatelessWidget {
  final double posisi;
  final TitleMeta meta;

  const LabelSumbuTren({super.key, required this.posisi, required this.meta});

  @override
  Widget build(BuildContext context) {
    // Label 0 dikosongkan supaya dasar grafik tidak ramai. Saat nominal disembunyikan, semua dikosongkan.
    bool kosong = posisi == 0 || nominalTersembunyi();
    return SideTitleWidget(
      meta: meta,
      space: JarakApp.j8,
      child: Text(
        kosong ? '' : formatRingkas(posisi.round()),
        style: TeksApp.mini,
      ),
    );
  }
}
