import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'tombol_teks.dart';

// Bingkai yang sama untuk semua pemilih waktu: tanggal, pekan, bulan, tahun, dan rentang.
class DialogWaktu extends StatelessWidget {
  final String judul;
  final String teksPilihan;
  final Widget isi;
  final VoidCallback onPilih;

  const DialogWaktu({
    super.key,
    required this.judul,
    required this.teksPilihan,
    required this.isi,
    required this.onPilih,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Lebih lebar dari bawaan supaya kalender dan grid bulan tidak berdesakan.
      insetPadding: const EdgeInsets.all(JarakApp.j16),
      // Kalender cukup tinggi, jadi di layar pendek isinya bisa digeser.
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(JarakApp.j24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(judul, style: TeksApp.kecil),
            const SizedBox(height: JarakApp.j4),
            Text(teksPilihan, style: TeksApp.judulDialog),
            const Divider(height: JarakApp.j24),
            isi,
            const SizedBox(height: JarakApp.j8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TombolTeks(
                  teks: 'Batal',
                  onTekan: () => Navigator.pop(context),
                ),
                TombolTeks(teks: 'Pilih', onTekan: onPilih),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
