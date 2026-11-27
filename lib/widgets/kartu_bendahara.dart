import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/privasi.dart';
import 'kartu_bagian.dart';
import 'tombol_utama.dart';

// Kartu Bendahara AI di Ringkasan: saran terakhir dan tombol ke halaman percakapan.
class KartuBendahara extends StatelessWidget {
  final DateTime bulan;
  final VoidCallback onMintaSaran;

  const KartuBendahara({
    super.key,
    required this.bulan,
    required this.onMintaSaran,
  });

  @override
  Widget build(BuildContext context) {
    return KartuBagian(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _bangunKepala(),
          const SizedBox(height: JarakApp.j12),
          const Divider(height: 1),
          const SizedBox(height: JarakApp.j12),
          // Didengarkan langsung supaya kotak ikut berubah saat tombol mata ditekan.
          ValueListenableBuilder<bool>(
            valueListenable: sembunyikanNominal,
            builder: (context, sembunyi, child) =>
                _bangunKotakSaran(nominalTersembunyi()),
          ),
          const SizedBox(height: JarakApp.j12),
          TombolUtama(teks: 'Minta saran', onTekan: onMintaSaran),
        ],
      ),
    );
  }

  Widget _bangunKepala() {
    String teksBulan = '${namaBulanPanjang[bulan.month - 1]} ${bulan.year}';
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: WarnaApp.primer,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            LucideIcons.bot,
            size: 20,
            color: WarnaApp.diAtasPrimer,
          ),
        ),
        const SizedBox(width: JarakApp.j12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Bendahara AI', style: TeksApp.judulSeksi),
              const SizedBox(height: JarakApp.j4),
              Text('Analisis catatan $teksBulan', style: TeksApp.kecil),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bangunKotakSaran(bool sembunyi) {
    String? saran = AppData.saranTerakhir;
    Widget isi;
    if (saran == null) {
      isi = _bangunKeterangan(
        LucideIcons.messageSquare,
        'Belum ada saran.',
        'Ketuk Minta saran untuk menganalisis catatanmu.',
      );
    } else if (sembunyi) {
      // Saran berisi nominal, jadi ikut disembunyikan seperti angka lain.
      isi = _bangunKeterangan(
        LucideIcons.eyeOff,
        'Saran disembunyikan',
        'Ketuk ikon mata di Beranda untuk menampilkan',
      );
    } else {
      isi = Text(
        saran,
        style: TeksApp.isi.copyWith(height: 1.5),
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      );
    }
    return Container(
      padding: const EdgeInsets.all(JarakApp.j16),
      decoration: BoxDecoration(
        color: WarnaApp.latarSeksi,
        borderRadius: BorderRadius.circular(RadiusApp.kartu),
      ),
      child: isi,
    );
  }

  Widget _bangunKeterangan(IconData ikon, String judul, String keterangan) {
    return Column(
      children: [
        Icon(ikon, size: 20, color: WarnaApp.teksRedup),
        const SizedBox(height: JarakApp.j8),
        Text(judul, style: TeksApp.isi),
        const SizedBox(height: JarakApp.j4),
        Text(keterangan, style: TeksApp.kecil, textAlign: TextAlign.center),
      ],
    );
  }
}
