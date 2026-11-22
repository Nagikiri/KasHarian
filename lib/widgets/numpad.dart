import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';

class Numpad extends StatelessWidget {
  final void Function(String angka) onAngka;
  final VoidCallback onHapus;

  const Numpad({super.key, required this.onAngka, required this.onHapus});

  static const List<String> _tombol = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '000',
    '0',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int baris = 0; baris < 4; baris++)
          Row(
            children: [
              for (int kolom = 0; kolom < 3; kolom++)
                Expanded(child: _bangunTombol(baris * 3 + kolom)),
            ],
          ),
      ],
    );
  }

  Widget _bangunTombol(int indeks) {
    // Posisi terakhir grid (indeks 11) tidak punya angka, dipakai untuk tombol hapus.
    bool tombolHapus = indeks == _tombol.length;

    return SizedBox(
      height: 56,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: tombolHapus ? onHapus : () => onAngka(_tombol[indeks]),
        child: Center(
          child: tombolHapus
              ? const Icon(
                  LucideIcons.delete,
                  size: 24,
                  color: WarnaApp.teksUtama,
                )
              : Text(
                  _tombol[indeks],
                  style: TeksApp.judulHalaman.copyWith(fontSize: 24),
                ),
        ),
      ),
    );
  }
}
