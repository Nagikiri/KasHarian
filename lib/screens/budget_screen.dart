import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../models/budget.dart';
import '../models/kategori.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/app_bar_turunan.dart';
import '../widgets/baris_budget.dart';
import '../widgets/dialog_konfirmasi_hapus.dart';
import '../widgets/judul_seksi.dart';
import '../widgets/kolom_angka.dart';
import '../widgets/sheet_input_nominal.dart';
import '../widgets/sheet_tambah_budget.dart';
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
      appBar: buatAppBarTurunan('Budget'),
      body: ValueListenableBuilder<int>(
        valueListenable: AppData.refreshNotifier,
        builder: (context, nilai, child) {
          return ListView(
            children: [
              _tepi(_bangunAnggaran()),
              const SizedBox(height: JarakApp.j16),
              Container(height: 8, color: WarnaApp.latarSeksi),
              _tepi(_bangunDaftar()),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(JarakApp.tepiHalaman),
          child: TombolUtama(
            teks: 'Tambah kategori budget',
            onTekan: _bukaTambah,
          ),
        ),
      ),
    );
  }

  Widget _tepi(Widget isi) => Padding(
    padding: const EdgeInsets.fromLTRB(
      JarakApp.tepiHalaman,
      JarakApp.j16,
      JarakApp.tepiHalaman,
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
              child: Text(formatRupiah(anggaran), style: TeksApp.angkaBesar),
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
                nilai: formatRupiah(totalLimit),
              ),
            ),
            Expanded(
              // Kalau minus, nominal ditulis positif dan labelnya yang berubah.
              child: KolomAngka(
                label: melebihi ? 'Melebihi anggaran' : 'Belum dialokasikan',
                nilai: formatRupiah(sisa.abs()),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const JudulSeksi(judul: 'Per kategori'),
        const SizedBox(height: JarakApp.j4),
        if (daftar.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: JarakApp.j16),
            child: Text('Belum ada kategori budget', style: TeksApp.kecil),
          ),
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
      labelHapus: 'Hapus budget',
    );
  }

  Future<bool> _hapusBudget(BudgetItem budget) async {
    bool? hapus = await showDialog<bool>(
      context: context,
      builder: (context) =>
          DialogKonfirmasiHapus(judul: 'Hapus budget ${budget.kategori}?'),
    );
    if (hapus != true) return false;
    AppData.hapusBudget(budget);
    return true;
  }

  // Dua langkah: pilih kategori di sheet grid, lalu isi limit lewat sheet nominal.
  Future<void> _bukaTambah() async {
    KategoriItem? kategori = await showModalBottomSheet<KategoriItem>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const SheetTambahBudget(),
    );
    if (kategori == null || !mounted) return;
    bukaInputNominal(
      context,
      judul: 'Limit ${kategori.nama} per bulan',
      ikon: kategori.ikon,
      onSimpan: (limit) => AppData.tambahBudget(
        BudgetItem(kategori: kategori.nama, limit: limit),
      ),
    );
  }
}
