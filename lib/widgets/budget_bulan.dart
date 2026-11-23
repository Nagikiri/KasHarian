import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'judul_seksi.dart';
import 'progress_tipis.dart';

// Ringkasan anggaran satu bulan di tab Transaksi.
class BudgetBulan extends StatelessWidget {
  final DateTime bulan;
  final VoidCallback onAtur;

  const BudgetBulan({super.key, required this.bulan, required this.onAtur});

  @override
  Widget build(BuildContext context) {
    int anggaran = AppData.anggaranBulanan;
    int terpakai = AppData.terpakaiAnggaran(bulan);
    int sisa = anggaran - terpakai;
    // Anggaran 0 tidak bisa dibagi, jadi persennya dianggap 0.
    double persen = anggaran > 0 ? terpakai / anggaran : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JudulSeksi(judul: 'Anggaran', aksi: 'Atur', onAksi: onAtur),
        const SizedBox(height: JarakApp.j12),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: formatRupiah(terpakai), style: TeksApp.angka),
              TextSpan(
                text: ' dari ${formatRupiah(anggaran)}',
                style: TeksApp.kecil,
              ),
            ],
          ),
        ),
        const SizedBox(height: JarakApp.j8),
        ProgressTipis(persen: persen),
        const SizedBox(height: JarakApp.j8),
        // Budget adalah rencana, jadi kelebihan ditulis positif, bukan "Sisa -Rp".
        Text(
          sisa < 0
              ? 'Lebih ${formatRupiah(-sisa)} dari anggaran'
              : 'Sisa ${formatRupiah(sisa)}',
          style: TeksApp.kecil.copyWith(
            color: sisa < 0 ? WarnaApp.bahaya : null,
          ),
        ),
      ],
    );
  }
}
