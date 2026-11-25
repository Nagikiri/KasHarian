import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../models/budget.dart';
import '../theme/app_theme.dart';
import '../utils/privasi.dart';
import '../widgets/app_bar_turunan.dart';
import '../widgets/baris_budget.dart';
import '../widgets/dialog_konfirmasi_hapus.dart';
import '../widgets/judul_seksi.dart';
import '../widgets/kartu_bagian.dart';
import '../widgets/kolom_angka.dart';
import '../widgets/sheet_input_nominal.dart';
import '../widgets/sheet_tambah_budget.dart';
import '../widgets/tampilan_kosong.dart';
import '../widgets/tombol_pill.dart';
import '../widgets/tombol_utama.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarnaApp.latarHalaman,
      appBar: buatAppBarTurunan('Anggaran'),
      body: ValueListenableBuilder<int>(
        valueListenable: AppData.refreshNotifier,
        builder: (context, nilai, child) {
          return ListView(
            padding: const EdgeInsets.only(bottom: JarakApp.antarKartu),
            children: [
              _tepi(KartuBagian(child: _bangunAnggaran())),
              _tepi(
                KartuBagian(
                  judul: const JudulSeksi(judul: 'Kantong alokasi'),
                  child: _bangunDaftar(),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: ColoredBox(
        color: WarnaApp.latar,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(JarakApp.tepiHalaman),
            child: TombolUtama(
              teks: 'Tambah kantong',
              onTekan: () => bukaTambahBudget(context),
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

  Widget _bangunAnggaran() {
    int anggaran = AppData.anggaranBulanan;
    int totalLimit = AppData.totalLimitBudget();
    int sisa = anggaran - totalLimit;
    bool melebihi = sisa < 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Anggaran bulanan', style: TeksApp.kecil),
        const SizedBox(height: JarakApp.j4),
        Row(
          children: [
            Expanded(
              child: Text(rupiahTampil(anggaran), style: TeksApp.angkaBesar),
            ),
            TombolPill(teks: 'Ubah', kecil: true, onTekan: _ubahAnggaran),
          ],
        ),
        const SizedBox(height: JarakApp.j16),
        Row(
          children: [
            Expanded(
              child: KolomAngka(
                label: 'Dialokasikan',
                nilai: rupiahTampil(totalLimit),
              ),
            ),
            Expanded(
              // Kalau minus, nominal ditulis positif dan labelnya yang berubah.
              child: KolomAngka(
                label: melebihi ? 'Melebihi anggaran' : 'Belum dialokasikan',
                nilai: rupiahTampil(sisa.abs()),
                warnaNilai: melebihi ? WarnaApp.bahaya : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _bangunDaftar() {
    List<BudgetItem> daftar = AppData.daftarBudget;
    if (daftar.isEmpty) {
      return const TampilanKosong(
        ikon: LucideIcons.wallet,
        judul: 'Belum ada kantong',
        kalimat: 'Tambahkan lewat tombol di bawah.',
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < daftar.length; i++) ...[
          if (i > 0) const Divider(height: 1),
          BarisBudget(budget: daftar[i], onTekan: () => _ubahLimit(daftar[i])),
        ],
      ],
    );
  }

  void _ubahAnggaran() {
    bukaInputNominal(
      context,
      judul: 'Anggaran bulanan',
      ikon: LucideIcons.wallet,
      nominalAwal: AppData.anggaranBulanan,
      onSimpan: AppData.ubahAnggaran,
    );
  }

  void _ubahLimit(BudgetItem budget) {
    bukaInputNominal(
      context,
      judul: 'Limit ${budget.kategori} per bulan',
      ikon: AppData.ikonKategori(budget.kategori),
      nominalAwal: budget.limit,
      onSimpan: (limit) => AppData.ubahLimitBudget(budget, limit),
      onHapus: () => _hapusBudget(budget),
      labelHapus: 'Hapus kantong',
    );
  }

  Future<bool> _hapusBudget(BudgetItem budget) async {
    bool? hapus = await showDialog<bool>(
      context: context,
      builder: (context) =>
          DialogKonfirmasiHapus(judul: 'Hapus kantong ${budget.kategori}?'),
    );
    if (hapus != true) return false;
    AppData.hapusBudget(budget);
    return true;
  }
}
