import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../models/wishlist.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'ikon_bulat.dart';
import 'progress_tipis.dart';

class KartuImpian extends StatelessWidget {
  final WishlistItem impian;

  const KartuImpian({super.key, required this.impian});

  @override
  Widget build(BuildContext context) {
    double persen = impian.terkumpulIdr / impian.targetIdr;
    int estimasi = AppData.estimasiBulanWishlist(impian);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IkonBulat(ikon: impian.ikon),
            const SizedBox(width: JarakApp.j12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(impian.nama, style: TeksApp.isi),
                  const SizedBox(height: JarakApp.j4),
                  Text(
                    '${impian.mataUang} ${formatTitik(impian.hargaAsing)}'
                    ' · ${formatRupiah(impian.targetIdr)}',
                    style: TeksApp.kecil,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: JarakApp.j12),
        ProgressTipis(persen: persen, pakaiWarnaStatus: false),
        const SizedBox(height: JarakApp.j8),
        Row(
          children: [
            Expanded(
              child: Text(
                '${formatRupiah(impian.terkumpulIdr)} terkumpul'
                ' · ${(persen * 100).floor()}%',
                style: TeksApp.kecil,
              ),
            ),
            // Estimasi 0 berarti budget 'Tabungan' belum ada.
            if (estimasi > 0)
              Text('± $estimasi bulan lagi', style: TeksApp.kecil),
          ],
        ),
      ],
    );
  }
}
