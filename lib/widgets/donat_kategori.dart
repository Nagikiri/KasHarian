import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/privasi.dart';

class DonatKategori extends StatelessWidget {
  final List<String> daftarNama;
  final List<int> daftarNilai;
  final List<Color> daftarWarna;
  final int total;

  const DonatKategori({
    super.key,
    required this.daftarNama,
    required this.daftarNilai,
    required this.daftarWarna,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox.square(
          dimension: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  centerSpaceRadius: 44,
                  sectionsSpace: 2,
                  // Mulai dari atas (jam 12), bukan dari kanan.
                  startDegreeOffset: -90,
                  sections: [
                    for (int i = 0; i < daftarNilai.length; i++)
                      PieChartSectionData(
                        value: daftarNilai[i].toDouble(),
                        color: daftarWarna[i],
                        radius: 26,
                        showTitle: false,
                      ),
                  ],
                ),
              ),
              // "Rp ••••••" lebih lebar dari angka ringkas, jadi dikecilkan supaya muat di lubang donat.
              SizedBox(
                width: 80,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(ringkasTampil(total), style: TeksApp.angka),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: JarakApp.j16),
        Expanded(
          child: Column(
            children: [
              for (int i = 0; i < daftarNama.length; i++) _bangunLegenda(i),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bangunLegenda(int i) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: JarakApp.j4),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: daftarWarna[i],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: JarakApp.j8),
          Expanded(
            child: Text(
              daftarNama[i],
              style: TeksApp.isi,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${(daftarNilai[i] / total * 100).round()}%',
            style: TeksApp.kecil,
          ),
        ],
      ),
    );
  }
}
