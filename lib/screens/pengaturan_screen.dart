import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bar_turunan.dart';
import '../widgets/baris_info_kurs.dart';
import '../widgets/baris_pengaturan.dart';
import '../widgets/halaman_pilih_mata_uang.dart';
import '../widgets/judul_seksi.dart';
import '../widgets/kartu_bagian.dart';
import 'budget_screen.dart';
import 'dompet_screen.dart';
import 'hapus_data_screen.dart';
import 'kebijakan_screen.dart';
import 'pengaturan_kategori_screen.dart';

class PengaturanScreen extends StatelessWidget {
  const PengaturanScreen({super.key});

  void _buka(BuildContext context, Widget halaman) =>
      Navigator.push(context, buatTransisiHalaman(halaman));

  Future<void> _aturFavorit(BuildContext context) async {
    List<String>? hasil = await bukaAturFavorit(context);
    if (hasil != null) AppData.simpanFavorit(hasil);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarnaApp.latarHalaman,
      appBar: buatAppBarTurunan('Pengaturan'),
      body: ValueListenableBuilder<int>(
        valueListenable: AppData.refreshNotifier,
        builder: (context, nilai, child) => ListView(
          padding: const EdgeInsets.only(bottom: JarakApp.antarKartu),
          children: [
            _kartu('Keuangan', _bangunKeuangan(context)),
            _kartu('Privasi', _bangunPrivasi(context)),
            _kartu('Data', [
              BarisPengaturan(
                ikon: LucideIcons.trash2,
                judul: 'Hapus semua data',
                bahaya: true,
                onTekan: () => _buka(context, const HapusDataScreen()),
              ),
            ]),
            _kartu('Tentang', _bangunTentang(context)),
          ],
        ),
      ),
    );
  }

  // Kartu ramping berjudul, baris di dalamnya dipisah Divider.
  Widget _kartu(String judul, List<Widget> baris) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        JarakApp.tepiKartu,
        JarakApp.antarKartu,
        JarakApp.tepiKartu,
        0,
      ),
      child: KartuBagian(
        judul: JudulSeksi(judul: judul),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < baris.length; i++) ...[
              if (i > 0) const Divider(height: 1),
              baris[i],
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _bangunKeuangan(BuildContext context) {
    return [
      BarisPengaturan(
        ikon: LucideIcons.wallet,
        judul: 'Dompet',
        onTekan: () => _buka(context, const DompetScreen()),
      ),
      BarisPengaturan(
        ikon: LucideIcons.tags,
        judul: 'Kategori',
        onTekan: () => _buka(context, const PengaturanKategoriScreen()),
      ),
      BarisPengaturan(
        ikon: LucideIcons.chartPie,
        judul: 'Anggaran & kantong',
        onTekan: () => _buka(context, const BudgetScreen()),
      ),
      BarisPengaturan(
        ikon: LucideIcons.coins,
        judul: 'Mata uang favorit',
        nilai: AppData.mataUangFavorit.join(', '),
        onTekan: () => _aturFavorit(context),
      ),
    ];
  }

  List<Widget> _bangunPrivasi(BuildContext context) {
    return [
      BarisPengaturan(
        ikon: LucideIcons.eyeOff,
        judul: 'Sembunyikan nominal',
        nilai: AppData.sembunyiSemuaHalaman ? 'Semua halaman' : 'Beranda saja',
        onTekan: () => _bukaCakupan(context),
      ),
      BarisPengaturan(
        ikon: LucideIcons.lock,
        judul: 'Sembunyikan saat dibuka',
        onTekan: () =>
            AppData.ubahSembunyikanSaatDibuka(!AppData.sembunyikanSaatDibuka),
        ujung: Switch(
          value: AppData.sembunyikanSaatDibuka,
          activeTrackColor: WarnaApp.primer,
          activeThumbColor: WarnaApp.diAtasPrimer,
          onChanged: AppData.ubahSembunyikanSaatDibuka,
        ),
      ),
    ];
  }

  List<Widget> _bangunTentang(BuildContext context) {
    return [
      // Halaman lisensi dibuka dari baris Versi, jadi tidak perlu baris sendiri.
      BarisPengaturan(
        ikon: LucideIcons.info,
        judul: 'Versi',
        nilai: AppData.versiAplikasi,
        onTekan: () => showLicensePage(
          context: context,
          applicationName: 'KasHarian',
          applicationVersion: AppData.versiAplikasi,
        ),
      ),
      BarisPengaturan(
        ikon: LucideIcons.shieldCheck,
        judul: 'Kebijakan privasi',
        onTekan: () => _buka(context, const KebijakanScreen()),
      ),
      BarisPengaturan(
        ikon: LucideIcons.refreshCw,
        judul: 'Sumber data kurs',
        onTekan: () => bukaSumberKurs(context),
      ),
    ];
  }

  // Dialog tengah karena pilihannya hanya dua. Radius 20 diambil dari dialogTheme.
  void _bukaCakupan(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sembunyikan nominal', style: TeksApp.judulSeksi),
        contentPadding: const EdgeInsets.fromLTRB(
          JarakApp.j24,
          JarakApp.j12,
          JarakApp.j24,
          JarakApp.j16,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _bangunPilihan(context, 'Beranda saja', false),
            const Divider(height: 1),
            _bangunPilihan(context, 'Semua halaman', true),
          ],
        ),
      ),
    );
  }

  Widget _bangunPilihan(BuildContext context, String teks, bool semua) {
    bool terpilih = AppData.sembunyiSemuaHalaman == semua;
    return InkWell(
      onTap: () {
        AppData.ubahCakupanSembunyi(semua);
        Navigator.pop(context);
      },
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            Expanded(child: Text(teks, style: TeksApp.isi)),
            if (terpilih)
              const Icon(LucideIcons.check, size: 20, color: WarnaApp.primer),
          ],
        ),
      ),
    );
  }
}
