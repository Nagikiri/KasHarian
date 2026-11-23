import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'ikon_bulat.dart';
import 'progress_tipis.dart';

class BarisDistribusi extends StatelessWidget {
  final IconData ikon;
  final String nama;
  final int nominal;
  final double persen;
  final Color warna;
  // Contoh "+Rp 20.000", "-Rp 34.000", "sama", atau "baru". null kalau tidak ada pembanding.
  final String? selisih;

  const BarisDistribusi({
    super.key,
    required this.ikon,
    required this.nama,
    required this.nominal,
    required this.persen,
    required this.warna,
    this.selisih,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: JarakApp.j12),
      child: Row(
        children: [
          IkonBulat(ikon: ikon),
          const SizedBox(width: JarakApp.j12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(nama, style: TeksApp.isi)),
                    Text(formatRupiah(nominal), style: TeksApp.angka),
                  ],
                ),
                if (selisih != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(selisih!, style: TeksApp.kecil),
                  ),
                const SizedBox(height: JarakApp.j8),
                Row(
                  children: [
                    // Lebar bar = bagian kategori ini dari total pengeluaran.
                    Expanded(
                      child: ProgressTipis(
                        persen: persen,
                        warna: warna,
                        tebal: 4,
                      ),
                    ),
                    const SizedBox(width: JarakApp.j8),
                    SizedBox(
                      width: 36,
                      child: Text(
                        '${(persen * 100).round()}%',
                        style: TeksApp.kecil,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
