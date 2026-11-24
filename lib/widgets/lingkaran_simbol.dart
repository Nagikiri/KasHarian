import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Simbol seperti HK$ atau NT$ lebih lebar dari lingkaran, jadi dikecilkan, bukan dipotong.
class LingkaranSimbol extends StatelessWidget {
  final String simbol;
  final double ukuran;
  final bool redup;

  const LingkaranSimbol({
    super.key,
    required this.simbol,
    this.ukuran = 28,
    this.redup = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ukuran,
      height: ukuran,
      padding: const EdgeInsets.all(JarakApp.j4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: redup ? WarnaApp.latarSeksi : WarnaApp.aksenLembut,
        shape: BoxShape.circle,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          simbol,
          style: TeksApp.tombolKecil.copyWith(
            color: redup ? WarnaApp.teksRedup : WarnaApp.primer,
          ),
        ),
      ),
    );
  }
}
