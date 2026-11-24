import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/privasi.dart';

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
    // Naik tidak memakai merah, karena merah hanya untuk peringatan bahaya.
    IconData ikon = LucideIcons.minus;
    Color warna = WarnaApp.teksKedua;
    Color latar = WarnaApp.latar;
    if (lalu > 0 && sekarang > lalu) {
      ikon = LucideIcons.trendingUp;
      warna = WarnaApp.peringatan;
      latar = WarnaApp.peringatanLembut;
    } else if (lalu > 0 && sekarang < lalu) {
      ikon = LucideIcons.trendingDown;
      warna = WarnaApp.primer;
      latar = WarnaApp.aksenLembut;
    }
    bool berubah = lalu > 0 && sekarang != lalu;

    return Container(
      padding: const EdgeInsets.all(JarakApp.j12),
      decoration: BoxDecoration(
        color: WarnaApp.latarSeksi,
        borderRadius: BorderRadius.circular(RadiusApp.input),
      ),
      child: Row(
        children: [
          _bangunLingkaran(ikon, warna, latar),
          const SizedBox(width: JarakApp.j12),
          Expanded(
            child: lalu == 0
                ? Text(kalimatTanpaPembanding(jenis), style: TeksApp.isi)
                : _bangunKalimat(warna, berubah),
          ),
          if (berubah) ...[
            const SizedBox(width: JarakApp.j8),
            _bangunPill(warna, latar),
          ],
        ],
      ),
    );
  }

  Widget _bangunLingkaran(IconData ikon, Color warna, Color latar) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: latar, shape: BoxShape.circle),
      child: Icon(ikon, size: 20, color: warna),
    );
  }

  // Kasus "sama" tidak punya nominal: "Pengeluaranmu sama seperti" lalu label periode.
  Widget _bangunKalimat(Color warna, bool berubah) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          kalimatPerbandingan(sekarang, lalu),
          style: TeksApp.kecil.copyWith(color: WarnaApp.teksKedua),
        ),
        if (berubah) ...[
          const SizedBox(height: JarakApp.j4),
          Text(
            rupiahTampil((sekarang - lalu).abs()),
            style: TeksApp.judulHalaman.copyWith(color: warna),
          ),
        ],
        const SizedBox(height: JarakApp.j4),
        Text(
          keteranganPerbandingan(sekarang, lalu, label),
          style: TeksApp.kecil,
        ),
      ],
    );
  }

  Widget _bangunPill(Color warna, Color latar) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: JarakApp.j8,
        vertical: JarakApp.j4,
      ),
      decoration: BoxDecoration(
        color: latar,
        borderRadius: BorderRadius.circular(RadiusApp.pill),
      ),
      child: Text(
        teksPersenPerubahan(sekarang, lalu),
        style: TeksApp.tombolKecil.copyWith(color: warna),
      ),
    );
  }
}
