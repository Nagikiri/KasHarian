import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class LingkaranAnggaran extends StatelessWidget {
  final double persen;

  const LingkaranAnggaran({super.key, required this.persen});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 96,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Lingkaran dibatasi penuh, tapi teks di tengah tetap menunjukkan persen sebenarnya.
          CircularProgressIndicator(
            value: persen.clamp(0.0, 1.0),
            strokeWidth: 10,
            backgroundColor: WarnaApp.garis,
            color: warnaStatus(persen),
          ),
          Center(
            child: Text('${(persen * 100).round()}%', style: TeksApp.angka),
          ),
        ],
      ),
    );
  }
}
