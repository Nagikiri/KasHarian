import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Tombol teks hijau di bawah dialog pemilih waktu (Batal, Pilih, Terapkan).
class TombolTeks extends StatelessWidget {
  final String teks;
  final VoidCallback onTekan;

  const TombolTeks({super.key, required this.teks, required this.onTekan});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTekan,
      child: Text(
        teks,
        style: TeksApp.tombolKecil.copyWith(color: WarnaApp.primer),
      ),
    );
  }
}
