import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../models/wishlist.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'ikon_bulat.dart';
import 'progress_tipis.dart';

// Versi baris untuk "Impian terdekat" di Beranda. Impian yang sudah tercapai tidak tampil di sana.
class KartuImpian extends StatelessWidget {
  final WishlistItem impian;

  const KartuImpian({super.key, required this.impian});

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
              Text(impian.nama, style: TeksApp.judulSeksi),
              const SizedBox(height: JarakApp.j4),
              Text(formatRupiah(impian.targetIdr), style: TeksApp.angka),
              if (impian.mataUang != 'IDR')
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
              // Estimasi 0 berarti budget 'Tabungan' belum ada.
              if (estimasi > 0) ...[
                const SizedBox(height: JarakApp.j8),
                Text(formatEstimasiBulan(estimasi), style: TeksApp.kecil),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
