import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'tombol_pill.dart';

// Tombol bulan sebelum dan sesudah di bawah daftar transaksi. Hanya bulan yang punya transaksi.
class NavigasiBulan extends StatelessWidget {
  final DateTime bulan;
  final ValueChanged<DateTime> onPilih;

  const NavigasiBulan({super.key, required this.bulan, required this.onPilih});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _bangunTombol(AppData.bulanBerdataSebelum(bulan)),
        const SizedBox(width: JarakApp.j8),
        _bangunTombol(AppData.bulanBerdataSesudah(bulan), kanan: true),
      ],
    );
  }

  // Setiap tombol mendapat separuh lebar dan dikecilkan kalau nama bulannya panjang.
  Widget _bangunTombol(DateTime? tujuan, {bool kanan = false}) {
    return Expanded(
      child: Align(
        alignment: kanan ? Alignment.centerRight : Alignment.centerLeft,
        child: tujuan == null
            ? null
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: TombolPill(
                  teks: '${namaBulanPanjang[tujuan.month - 1]} ${tujuan.year}',
                  ikon: kanan ? LucideIcons.arrowRight : LucideIcons.arrowLeft,
                  ikonDiKanan: kanan,
                  onTekan: () => onPilih(tujuan),
                ),
              ),
      ),
    );
  }
}
