import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'sheet_pilih_bulan.dart';
import 'tombol_panah.dart';

class PemilihBulan extends StatelessWidget {
  const PemilihBulan({super.key});

  void _pilih(DateTime bulan) {
    AppData.bulanDipilih = bulan;
    AppData.refreshNotifier.value++;
  }

  // Tujuan null berarti tidak ada bulan berdata ke arah itu.
  VoidCallback? _aksiPanah(DateTime? tujuan) =>
      tujuan == null ? null : () => _pilih(tujuan);

  @override
  Widget build(BuildContext context) {
    DateTime bulan = AppData.bulanDipilih;
    DateTime? sebelum = AppData.bulanBerdataSebelum(bulan);
    DateTime? sesudah = AppData.bulanBerdataSesudah(bulan);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TombolPanah(
          ikon: LucideIcons.chevronLeft,
          onTekan: _aksiPanah(sebelum),
        ),
        GestureDetector(
          onTap: () => showModalBottomSheet(
            context: context,
            builder: (context) => const SheetPilihBulan(),
          ),
          child: Text(
            '${namaBulan[bulan.month - 1]} ${bulan.year}',
            style: TeksApp.judulSeksi,
          ),
        ),
        TombolPanah(
          ikon: LucideIcons.chevronRight,
          onTekan: _aksiPanah(sesudah),
        ),
      ],
    );
  }
}
