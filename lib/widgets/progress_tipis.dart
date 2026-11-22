import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ProgressTipis extends StatelessWidget {
  final double persen;

  const ProgressTipis({super.key, required this.persen});

  @override
  Widget build(BuildContext context) {
    Color warnaIsi = persen >= 0.9 ? WarnaApp.bahaya : WarnaApp.aksen;
    // Dibatasi 0 sampai 100% supaya isi tidak keluar dari track.
    double lebarIsi = persen.clamp(0.0, 1.0).toDouble();

    return Container(
      height: 6,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: WarnaApp.latarSeksi,
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
