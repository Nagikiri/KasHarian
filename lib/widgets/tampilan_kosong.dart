import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'ikon_bulat.dart';
import 'tombol_pill.dart';

// Pengganti teks kosong polos. Tombol hanya tampil kalau label dan aksinya diisi.
class TampilanKosong extends StatelessWidget {
  final IconData ikon;
  final String judul;
  final String kalimat;
  final String? labelTombol;
  final VoidCallback? onTekan;

  const TampilanKosong({
    super.key,
    required this.ikon,
    required this.judul,
    required this.kalimat,
    this.labelTombol,
    this.onTekan,
  });

  @override
  Widget build(BuildContext context) {
    // Center membuat tampilan ini di tengah walau induknya Column rata kiri.
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: JarakApp.j32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IkonBulat(ikon: ikon, ukuran: 64),
            const SizedBox(height: JarakApp.j16),
            Text(judul, style: TeksApp.judulSeksi, textAlign: TextAlign.center),
            const SizedBox(height: JarakApp.j4),
            Text(
              kalimat,
              style: TeksApp.isi.copyWith(color: WarnaApp.teksKedua),
              textAlign: TextAlign.center,
            ),
            if (labelTombol != null && onTekan != null) ...[
              const SizedBox(height: JarakApp.j16),
              TombolPill(teks: labelTombol!, onTekan: onTekan!, penuh: true),
            ],
          ],
        ),
      ),
    );
  }
}
