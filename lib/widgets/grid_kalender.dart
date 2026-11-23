import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Grid 3 kolom setinggi area tanggal di kalender bawaan, jadi 12 sel terbagi rata 4 baris.
// Lebih dari 12 sel (misalnya tahun) bisa digeser, seperti daftar tahun di kalender.
class GridKalender extends StatelessWidget {
  final List<Widget> daftarSel;

  const GridKalender({super.key, required this.daftarSel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: KalenderApp.tinggiGrid,
      child: GridView(
        padding: const EdgeInsets.symmetric(horizontal: KalenderApp.tepiGrid),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: KalenderApp.tinggiGrid / 4,
        ),
        children: daftarSel,
      ),
    );
  }
}
