import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../models/mata_uang.dart';
import '../theme/app_theme.dart';
import 'lingkaran_simbol.dart';

// Satu baris di halaman pemilih mata uang. onTekan null berarti baris tidak bisa dipilih.
class BarisMataUang extends StatelessWidget {
  final MataUang mataUang;
  final bool terpilih;
  final VoidCallback? onTekan;

  const BarisMataUang({
    super.key,
    required this.mataUang,
    required this.terpilih,
    required this.onTekan,
  });

  @override
  Widget build(BuildContext context) {
    // Mata uang tanpa kurs tetap bisa dipilih, hanya ditampilkan redup.
    bool tanpaKurs = !AppData.kursAda(mataUang.kode);
    return InkWell(
      onTap: onTekan,
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            LingkaranSimbol(
              simbol: mataUang.simbol,
              ukuran: 36,
              redup: tanpaKurs,
            ),
            const SizedBox(width: JarakApp.j12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mataUang.kode,
                    style: TeksApp.tombolKecil.copyWith(
                      color: tanpaKurs ? WarnaApp.teksRedup : null,
                    ),
                  ),
                  Text(mataUang.nama, style: TeksApp.kecil),
                ],
              ),
            ),
            if (tanpaKurs) const Text('—', style: TeksApp.kecil),
            if (terpilih) ...[
              const SizedBox(width: JarakApp.j12),
              const Icon(LucideIcons.check, size: 20, color: WarnaApp.primer),
            ],
          ],
        ),
      ),
    );
  }
}
