import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';
import '../utils/periode.dart';
import 'tombol_panah.dart';
import 'tombol_pill.dart';

// Dipakai di Transaksi dan Ringkasan. onSebelum atau onSesudah null berarti panah itu nonaktif.
class BarisPeriode extends StatelessWidget {
  final int jenis;
  final DateTime awal;
  final DateTime akhir;
  final VoidCallback? onSebelum;
  final VoidCallback? onSesudah;
  final VoidCallback onPilih;
  final VoidCallback onRentang;

  const BarisPeriode({
    super.key,
    required this.jenis,
    required this.awal,
    required this.akhir,
    required this.onSebelum,
    required this.onSesudah,
    required this.onPilih,
    required this.onRentang,
  });

  @override
  Widget build(BuildContext context) {
    bool rentang = jenis == 3;
    // akhir eksklusif, jadi hari terakhirnya satu hari sebelum akhir.
    String label = rentang
        ? labelRentang(awal, DateTime(akhir.year, akhir.month, akhir.day - 1))
        : labelPeriode(jenis, awal);

    return Row(
      children: [
        // Di mode Rentang panah diganti ruang kosong selebar panah supaya label tetap di tengah.
        rentang
            ? const SizedBox(width: 40)
            : TombolPanah(ikon: LucideIcons.chevronLeft, onTekan: onSebelum),
        Expanded(
          child: GestureDetector(
            onTap: onPilih,
            // Label panjang dikecilkan di layar sempit, bukan turun ke baris kedua.
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(label, style: TeksApp.judulSeksi),
            ),
          ),
        ),
        rentang
            ? const SizedBox(width: 40)
            : TombolPanah(ikon: LucideIcons.chevronRight, onTekan: onSesudah),
        const SizedBox(width: JarakApp.j4),
        TombolPill(
          teks: 'Rentang',
          ikon: LucideIcons.calendarRange,
          kecil: true,
          terpilih: rentang,
          onTekan: onRentang,
        ),
      ],
    );
  }
}
