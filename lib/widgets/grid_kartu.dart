import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Menyusun kartu jadi 2 kolom. Dipakai Kantong alokasi dan Impianku.
class GridKartu extends StatelessWidget {
  final List<Widget> daftar;
  final String teksKosong;

  const GridKartu({super.key, required this.daftar, required this.teksKosong});

  @override
  Widget build(BuildContext context) {
    if (daftar.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: JarakApp.j16),
        child: Text(teksKosong, style: TeksApp.kecil),
      );
    }

    return Column(
      children: [for (int i = 0; i < daftar.length; i += 2) _bangunBaris(i)],
    );
  }

  // IntrinsicHeight + stretch membuat dua kartu dalam satu baris sama tinggi.
  Widget _bangunBaris(int i) {
    bool adaKanan = i + 1 < daftar.length;
    return Padding(
      padding: EdgeInsets.only(top: i > 0 ? JarakApp.j12 : 0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: daftar[i]),
            const SizedBox(width: JarakApp.j12),
            Expanded(child: adaKanan ? daftar[i + 1] : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
