import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'baris_judul.dart';
import 'tombol_pill.dart';

// Baris judul dengan tombol Rentang di kanan, dipakai di Transaksi dan Ringkasan.
class HeaderRentang extends StatelessWidget {
  final String judul;
  final bool rentangAktif;
  final VoidCallback onRentang;
  final List<Widget> bawah;

  const HeaderRentang({
    super.key,
    required this.judul,
    required this.rentangAktif,
    required this.onRentang,
    this.bawah = const [],
  });

  @override
  Widget build(BuildContext context) {
    return BarisJudul(
      judul: judul,
      ujung: TombolPill(
        teks: 'Rentang',
        ikon: LucideIcons.calendarRange,
        kecil: true,
        terpilih: rentangAktif,
        onTekan: onRentang,
      ),
      bawah: bawah,
    );
  }
}
