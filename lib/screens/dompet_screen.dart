import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../models/dompet.dart';
import '../theme/app_theme.dart';
import '../utils/privasi.dart';
import '../widgets/app_bar_turunan.dart';
import '../widgets/ikon_bulat.dart';
import '../widgets/judul_seksi.dart';
import '../widgets/kartu_bagian.dart';
import '../widgets/tombol_utama.dart';
import 'form_dompet_screen.dart';

class DompetScreen extends StatelessWidget {
  const DompetScreen({super.key});

  void _bukaForm(BuildContext context, {Dompet? dompet}) {
    Navigator.push(
      context,
      buatTransisiHalaman(FormDompetScreen(dompetLama: dompet)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarnaApp.latarHalaman,
      appBar: buatAppBarTurunan('Dompet'),
      body: ValueListenableBuilder<int>(
        valueListenable: AppData.refreshNotifier,
        builder: (context, nilai, child) => ListView(
          padding: const EdgeInsets.only(bottom: JarakApp.antarKartu),
          children: [
            _tepi(KartuBagian(child: _bangunTotal())),
            _tepi(
              KartuBagian(
                judul: const JudulSeksi(judul: 'Daftar dompet'),
                child: _bangunDaftar(context),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ColoredBox(
        color: WarnaApp.latar,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(JarakApp.tepiHalaman),
            child: TombolUtama(
              teks: 'Tambah dompet',
              onTekan: () => _bukaForm(context),
            ),
          ),
        ),
      ),
    );
  }

  // Kartu ramping: jarak antarkartu di atasnya dan jarak tepi kartu di kiri-kanan.
  Widget _tepi(Widget isi) => Padding(
    padding: const EdgeInsets.fromLTRB(
      JarakApp.tepiKartu,
      JarakApp.antarKartu,
      JarakApp.tepiKartu,
      0,
    ),
    child: isi,
  );

  Widget _bangunTotal() {
    int total = 0;
    for (var d in AppData.daftarDompet) {
      total += AppData.saldoSumber(d.nama);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Total saldo', style: TeksApp.kecil),
        const SizedBox(height: JarakApp.j4),
        Text(rupiahTampil(total), style: TeksApp.angkaBesar),
      ],
    );
  }

  Widget _bangunDaftar(BuildContext context) {
    List<Dompet> daftar = AppData.daftarDompet;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < daftar.length; i++) ...[
          if (i > 0) const Divider(height: 1),
          _bangunBaris(context, daftar[i]),
        ],
      ],
    );
  }

  Widget _bangunBaris(BuildContext context, Dompet dompet) {
    return InkWell(
      onTap: () => _bukaForm(context, dompet: dompet),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: JarakApp.j12),
        child: Row(
          children: [
            IkonBulat(ikon: dompet.ikon),
            const SizedBox(width: JarakApp.j12),
            Expanded(child: Text(dompet.nama, style: TeksApp.isi)),
            const SizedBox(width: JarakApp.j8),
            Text(
              rupiahTampil(AppData.saldoSumber(dompet.nama)),
              style: TeksApp.angka,
            ),
            const SizedBox(width: JarakApp.j4),
            const Icon(
              LucideIcons.chevronRight,
              size: 18,
              color: WarnaApp.teksRedup,
            ),
          ],
        ),
      ),
    );
  }
}
