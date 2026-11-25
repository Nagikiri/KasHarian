import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'numpad.dart';
import 'tombol_utama.dart';

// Numpad dengan tombol simpan di bawahnya, dipakai di Catat Transaksi, input nominal, dan impian baru.
class NumpadSimpan extends StatelessWidget {
  final void Function(String angka) onAngka;
  final VoidCallback onHapus;
  final String labelTombol;
  final VoidCallback? onSimpan;

  const NumpadSimpan({
    super.key,
    required this.onAngka,
    required this.onHapus,
    this.labelTombol = 'Simpan',
    required this.onSimpan,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Numpad(onAngka: onAngka, onHapus: onHapus),
        const SizedBox(height: JarakApp.j8),
        TombolUtama(teks: labelTombol, onTekan: onSimpan),
      ],
    );
  }
}
