import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'kartu_tambah.dart';

// Menyusun kartu jadi 2 kolom, ditutup kartu Tambah. Dipakai Kantong alokasi dan Impianku.
class GridKartu extends StatelessWidget {
  final List<Widget> daftar;
  final Widget kosong;
  final String labelTambah;
  final VoidCallback onTambah;

  const GridKartu({
    super.key,
    required this.daftar,
    required this.kosong,
    required this.labelTambah,
    required this.onTambah,
  });

  @override
  Widget build(BuildContext context) {
    if (daftar.isEmpty) return kosong;

    List<Widget> semua = [
      ...daftar,
      KartuTambah(label: labelTambah, onTekan: onTambah),
    ];
    return Column(
      children: [
        for (int i = 0; i < semua.length; i += 2) _bangunBaris(semua, i),
      ],
    );
  }

  // IntrinsicHeight + stretch membuat dua kartu dalam satu baris sama tinggi.
  Widget _bangunBaris(List<Widget> semua, int i) {
    // Yang bisa sendirian di baris terakhir hanya kartu Tambah, jadi dibuat mendatar selebar dua kolom.
    Widget baris = i + 1 < semua.length
        ? IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: semua[i]),
                const SizedBox(width: JarakApp.j12),
                Expanded(child: semua[i + 1]),
              ],
            ),
          )
        : KartuTambah(label: labelTambah, onTekan: onTambah, mendatar: true);

    return Padding(
      padding: EdgeInsets.only(top: i > 0 ? JarakApp.j12 : 0),
      child: baris,
    );
  }
}
