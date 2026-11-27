import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';
import 'ikon_bulat.dart';

// Satu baris di halaman Pengaturan: ikon, judul, nilai opsional, lalu chevron atau widget ujung.
class BarisPengaturan extends StatelessWidget {
  final IconData ikon;
  final String judul;
  final String? nilai;
  // Misalnya Switch. Kalau diisi, chevron tidak ditampilkan.
  final Widget? ujung;
  final VoidCallback? onTekan;
  final bool bahaya;

  const BarisPengaturan({
    super.key,
    required this.ikon,
    required this.judul,
    this.nilai,
    this.ujung,
    this.onTekan,
    this.bahaya = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTekan,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: JarakApp.j12),
        child: Row(
          children: [
            IkonBulat(
              ikon: ikon,
              warnaLatar: bahaya
                  ? WarnaApp.peringatanLembut
                  : WarnaApp.aksenLembut,
              warnaIkon: bahaya ? WarnaApp.bahaya : WarnaApp.primer,
            ),
            const SizedBox(width: JarakApp.j12),
            Expanded(
              child: Text(
                judul,
                style: TeksApp.isi.copyWith(
                  color: bahaya ? WarnaApp.bahaya : null,
                ),
              ),
            ),
            if (nilai != null) ...[
              const SizedBox(width: JarakApp.j8),
              Text(nilai!, style: TeksApp.kecil),
            ],
            const SizedBox(width: JarakApp.j4),
            ujung ??
                const Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: WarnaApp.teksRedup,
                ),
          ],
        ),
      ),
    );
  }
}
