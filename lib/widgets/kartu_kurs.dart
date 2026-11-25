import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../models/mata_uang.dart';
import '../theme/app_theme.dart';
import 'baris_info_kurs.dart';
import 'judul_seksi.dart';
import 'lingkaran_simbol.dart';
import 'halaman_pilih_mata_uang.dart';

// Isi kartu Kurs di Beranda. Pembungkus putihnya (KartuBagian) dipasang oleh halaman.
class KartuKurs extends StatelessWidget {
  final bool sedangMemuat;
  final VoidCallback onPerbarui;

  const KartuKurs({
    super.key,
    required this.sedangMemuat,
    required this.onPerbarui,
  });

  Future<void> _aturFavorit(BuildContext context) async {
    List<String>? hasil = await bukaAturFavorit(context);
    if (hasil != null) AppData.simpanFavorit(hasil);
  }

  @override
  Widget build(BuildContext context) {
    List<String> favorit = AppData.mataUangFavorit.take(4).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        JudulSeksi(judul: 'Kurs hari ini', ujung: _bangunKonversi()),
        const SizedBox(height: JarakApp.j12),
        for (String kode in favorit) ...[
          _bangunBaris(AppData.cariMataUang(kode)),
          const Divider(height: 1),
        ],
        _bangunAtur(context),
        const SizedBox(height: JarakApp.j4),
        BarisInfoKurs(sedangMemuat: sedangMemuat, onPerbarui: onPerbarui),
      ],
    );
  }

  // Hitung kurs ada di bagian atas tab Impian.
  Widget _bangunKonversi() {
    return GestureDetector(
      onTap: () => AppData.tabAktif.value = 2,
      child: Row(
        children: [
          Text(
            'Konversi',
            style: TeksApp.tombolKecil.copyWith(color: WarnaApp.primer),
          ),
          const Icon(
            LucideIcons.chevronRight,
            size: 16,
            color: WarnaApp.primer,
          ),
        ],
      ),
    );
  }

  Widget _bangunAtur(BuildContext context) {
    return InkWell(
      onTap: () => _aturFavorit(context),
      child: SizedBox(
        height: 44,
        child: Row(
          children: [
            const Icon(
              LucideIcons.slidersHorizontal,
              size: 18,
              color: WarnaApp.primer,
            ),
            const SizedBox(width: JarakApp.j8),
            Text(
              'Atur mata uang',
              style: TeksApp.tombolKecil.copyWith(color: WarnaApp.primer),
            ),
          ],
        ),
      ),
    );
  }

  // Kolom kanan sengaja berupa Column supaya persen perubahan kurs bisa ditambah di bawah nominal.
  Widget _bangunBaris(MataUang m) {
    bool tanpaKurs = !AppData.kursAda(m.kode);
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          LingkaranSimbol(simbol: m.simbol, redup: tanpaKurs),
          const SizedBox(width: JarakApp.j12),
          Text(m.kode, style: TeksApp.tombolKecil),
          const SizedBox(width: JarakApp.j8),
          Expanded(
            child: Text(
              m.nama,
              style: TeksApp.kecil,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppData.teksKursRupiah(m.kode),
                style: TeksApp.judulSeksi.copyWith(
                  color: tanpaKurs ? WarnaApp.teksRedup : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
