import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';
import 'tombol_pill.dart';

// Judul halaman dengan tombol Rentang di kanan, dipakai di Transaksi dan Ringkasan.
class HeaderRentang extends StatelessWidget {
  final String judul;
  final bool rentangAktif;
  final VoidCallback onRentang;

  const HeaderRentang({
    super.key,
    required this.judul,
    required this.rentangAktif,
    required this.onRentang,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(judul, style: TeksApp.judulHalaman)),
        TombolPill(
          teks: 'Rentang',
          ikon: LucideIcons.calendarRange,
          kecil: true,
          terpilih: rentangAktif,
          onTekan: onRentang,
        ),
      ],
    );
  }
}
