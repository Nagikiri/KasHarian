import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ProgressTipis extends StatelessWidget {
  final double persen;
  final bool pakaiWarnaStatus;
  final double tebal;
  final Color? warna;

  const ProgressTipis({
    super.key,
    required this.persen,
    this.pakaiWarnaStatus = true,
    this.tebal = 6,
    this.warna,
  });

  @override
  Widget build(BuildContext context) {
    // Tabungan memakai primer saja, karena persen tinggi di sana itu kabar baik.
    Color warnaIsi =
        warna ?? (pakaiWarnaStatus ? warnaStatus(persen) : WarnaApp.primer);
    // Dibatasi 0 sampai 100% supaya isi tidak keluar dari track.
    double lebarIsi = persen.clamp(0.0, 1.0).toDouble();

    return Container(
      height: tebal,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: WarnaApp.garis,
        borderRadius: BorderRadius.circular(RadiusApp.pill),
      ),
      child: FractionallySizedBox(
        widthFactor: lebarIsi,
        child: Container(
          decoration: BoxDecoration(
            color: warnaIsi,
            borderRadius: BorderRadius.circular(RadiusApp.pill),
          ),
        ),
      ),
    );
  }
}
