import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'tombol_teks.dart';

// Mengembalikan tahun yang diketuk lewat Navigator.pop.
class DialogPilihTahun extends StatelessWidget {
  final int awal;
  final int tahunPertama;
  final int tahunTerakhir;

  const DialogPilihTahun({
    super.key,
    required this.awal,
    required this.tahunPertama,
    required this.tahunTerakhir,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(JarakApp.tepiHalaman),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Pilih tahun',
              style: TeksApp.judulSeksi,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: JarakApp.j12),
            GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 2,
              mainAxisSpacing: JarakApp.j8,
              crossAxisSpacing: JarakApp.j8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (int t = tahunPertama; t <= tahunTerakhir; t++)
                  _bangunSelTahun(context, t),
              ],
            ),
            const SizedBox(height: JarakApp.j12),
            Align(
              alignment: Alignment.centerRight,
              child: TombolTeks(
                teks: 'Batal',
                onTekan: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bangunSelTahun(BuildContext context, int tahun) {
    bool terpilih = tahun == awal;
    return GestureDetector(
      onTap: () => Navigator.pop(context, tahun),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: terpilih ? WarnaApp.primer : null,
          borderRadius: BorderRadius.circular(RadiusApp.pill),
        ),
        child: Text(
          '$tahun',
          style: TeksApp.tombolKecil.copyWith(
            color: terpilih ? WarnaApp.diAtasPrimer : WarnaApp.teksUtama,
          ),
        ),
      ),
    );
  }
}
