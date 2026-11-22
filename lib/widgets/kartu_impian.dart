import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../models/wishlist.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'ikon_bulat.dart';
import 'progress_tipis.dart';

class KartuImpian extends StatelessWidget {
  final WishlistItem impian;
  final VoidCallback? onTabung;
  final VoidCallback? onHapus;

  const KartuImpian({
    super.key,
    required this.impian,
    this.onTabung,
    this.onHapus,
  });

  @override
  Widget build(BuildContext context) {
    double persen = impian.terkumpulIdr / impian.targetIdr;
    int estimasi = AppData.estimasiBulanWishlist(impian);

    // Progress dan baris di bawahnya ikut kolom teks, jadi semuanya sejajar dengan nama.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IkonBulat(ikon: impian.ikon),
        const SizedBox(width: JarakApp.j12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(impian.nama, style: TeksApp.judulSeksi)),
                  if (onHapus != null)
                    GestureDetector(
                      onTap: onHapus,
                      child: const Icon(
                        LucideIcons.trash2,
                        size: 18,
                        color: WarnaApp.teksRedup,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: JarakApp.j4),
              Text(formatRupiah(impian.targetIdr), style: TeksApp.angka),
              Text(
                '${impian.mataUang} ${formatTitik(impian.hargaAsing)}',
                style: TeksApp.kecil,
              ),
              const SizedBox(height: JarakApp.j12),
              ProgressTipis(persen: persen, pakaiWarnaStatus: false, tebal: 8),
              const SizedBox(height: JarakApp.j8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${formatRupiah(impian.terkumpulIdr)} terkumpul',
                      style: TeksApp.isi.copyWith(color: WarnaApp.teksUtama),
                    ),
                  ),
                  Text(
                    '${(persen * 100).floor()}%',
                    style: TeksApp.angka.copyWith(color: WarnaApp.primer),
                  ),
                ],
              ),
              const SizedBox(height: JarakApp.j8),
              Row(
                children: [
                  // Estimasi 0 berarti budget 'Tabungan' belum ada atau target sudah tercapai.
                  Expanded(
                    child: Text(
                      estimasi > 0 ? formatEstimasiBulan(estimasi) : '',
                      style: TeksApp.kecil,
                    ),
                  ),
                  _bangunAksi(persen >= 1),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bangunAksi(bool tercapai) {
    TextStyle gaya = TeksApp.tombolKecil.copyWith(color: WarnaApp.primer);
    if (tercapai) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.circleCheck, size: 16, color: WarnaApp.primer),
          const SizedBox(width: JarakApp.j4),
          Text('Target tercapai', style: gaya),
        ],
      );
    }
    if (onTabung == null) return const SizedBox.shrink();
    return GestureDetector(
      onTap: onTabung,
      child: Text('Tambah tabungan', style: gaya),
    );
  }
}
