import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'judul_seksi.dart';

// Isi kartu Kurs di Beranda. Pembungkus putihnya (KartuBagian) dipasang oleh halaman.
class KartuKurs extends StatelessWidget {
  final bool sedangMemuat;
  final VoidCallback onPerbarui;

  const KartuKurs({
    super.key,
    required this.sedangMemuat,
    required this.onPerbarui,
  });

  @override
  Widget build(BuildContext context) {
    Widget ujung = sedangMemuat
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: WarnaApp.primer,
            ),
          )
        : GestureDetector(
            onTap: onPerbarui,
            child: const Icon(
              LucideIcons.refreshCw,
              size: 20,
              color: WarnaApp.teksKedua,
            ),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JudulSeksi(
          judul: 'Kurs hari ini',
          aksi: 'Konversi',
          // Konverter valas ada di bagian atas tab Impian.
          onAksi: () => AppData.tabAktif.value = 2,
          ujung: Padding(
            padding: const EdgeInsets.only(left: JarakApp.j12),
            child: ujung,
          ),
        ),
        const SizedBox(height: JarakApp.j16),
        // IntrinsicHeight + stretch membuat ketiga petak sama tinggi walau nama turun 2 baris.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _bangunPetak('USD')),
              const SizedBox(width: JarakApp.j12),
              Expanded(child: _bangunPetak('SGD')),
              const SizedBox(width: JarakApp.j12),
              Expanded(child: _bangunPetak('JPY')),
            ],
          ),
        ),
        const SizedBox(height: JarakApp.j16),
        // Atribusi wajib dari penyedia API, jadi boleh turun baris tapi tidak dipotong.
        Text.rich(
          TextSpan(
            text: AppData.infoKurs,
            style: TeksApp.kecil.copyWith(
              color: AppData.kursLive ? WarnaApp.primer : WarnaApp.teksRedup,
            ),
            children: const [
              TextSpan(
                text: ' · Rates By Exchange Rate API',
                style: TeksApp.mini,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bangunPetak(String kode) {
    int indeks = AppData.indeksWarnaKurs[kode]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: WarnaApp.lingkaranKategori(indeks),
            shape: BoxShape.circle,
          ),
          child: Text(
            AppData.simbolMataUang[kode]!,
            style: TeksApp.tombolKecil.copyWith(
              color: WarnaApp.tegasKategori(indeks),
            ),
          ),
        ),
        const SizedBox(height: JarakApp.j8),
        Text(kode, style: TeksApp.tombolKecil),
        Text(AppData.namaMataUang[kode]!, style: TeksApp.kecil, maxLines: 2),
        const SizedBox(height: JarakApp.j8),
        // Spacer mendorong nominal ke dasar petak, jadi ketiga nominal sejajar.
        const Spacer(),
        Text(
          'Rp ${formatTitik(AppData.kursKeIdr[kode] ?? 0)}',
          style: TeksApp.angka,
        ),
      ],
    );
  }
}
