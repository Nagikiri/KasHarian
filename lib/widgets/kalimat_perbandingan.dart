import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';
import '../utils/format.dart';

class KalimatPerbandingan extends StatelessWidget {
  // 0 = Pekan, 1 = Bulan, 2 = Tahun. Dipakai untuk "pekan lalu" dan sejenisnya.
  final int jenis;
  final int sekarang;
  final int lalu;
  final String label;

  const KalimatPerbandingan({
    super.key,
    required this.jenis,
    required this.sekarang,
    required this.lalu,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(JarakApp.j12),
      decoration: BoxDecoration(
        color: WarnaApp.latarSeksi,
        borderRadius: BorderRadius.circular(RadiusApp.input),
      ),
      child: lalu == 0
          ? Text(kalimatTanpaPembanding(jenis), style: TeksApp.isi)
          : _bangunPerbandingan(),
    );
  }

  Widget _bangunPerbandingan() {
    // Naik tidak memakai merah, karena merah hanya untuk peringatan bahaya.
    IconData ikon = LucideIcons.minus;
    Color warna = WarnaApp.teksKedua;
    if (sekarang > lalu) {
      ikon = LucideIcons.trendingUp;
      warna = WarnaApp.peringatan;
    } else if (sekarang < lalu) {
      ikon = LucideIcons.trendingDown;
      warna = WarnaApp.primer;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(ikon, size: 18, color: warna),
        const SizedBox(width: JarakApp.j8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: kalimatPerbandingan(sekarang, lalu),
                  style: TeksApp.isi,
                  children: [
                    if (sekarang != lalu)
                      TextSpan(
                        text: ' ${formatRupiah((sekarang - lalu).abs())}',
                        style: TeksApp.isi.copyWith(
                          fontWeight: FontWeight.w600,
                          color: warna,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: JarakApp.j4),
              Text(
                keteranganPerbandingan(sekarang, lalu, label),
                style: TeksApp.kecil,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
