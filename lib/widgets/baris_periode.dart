import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';
import '../utils/periode.dart';
import 'tombol_panah.dart';

// Dipakai di Transaksi dan Ringkasan. onSebelum atau onSesudah null berarti panah itu nonaktif.
class BarisPeriode extends StatelessWidget {
  final int jenis;
  final DateTime awal;
  final DateTime akhir;
  final VoidCallback? onSebelum;
  final VoidCallback? onSesudah;
  final VoidCallback onPilih;

  const BarisPeriode({
    super.key,
    required this.jenis,
    required this.awal,
    required this.akhir,
    required this.onSebelum,
    required this.onSesudah,
    required this.onPilih,
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
            behavior: HitTestBehavior.opaque,
            onTap: onPilih,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Label panjang dikecilkan di layar sempit, bukan turun ke baris kedua.
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(label, style: TeksApp.judulSeksi),
                  ),
                ),
                const SizedBox(width: JarakApp.j4),
                // Tanda bahwa label bisa diketuk untuk memilih waktu.
                const Icon(
                  LucideIcons.chevronDown,
                  size: 16,
                  color: WarnaApp.teksRedup,
                ),
              ],
            ),
          ),
        ),
        rentang
            ? const SizedBox(width: 40)
            : TombolPanah(ikon: LucideIcons.chevronRight, onTekan: onSesudah),
      ],
    );
  }
}
