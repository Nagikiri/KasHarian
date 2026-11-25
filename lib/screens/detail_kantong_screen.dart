import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../models/budget.dart';
import '../models/transaksi.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/privasi.dart';
import '../widgets/app_bar_turunan.dart';
import '../widgets/baris_transaksi.dart';
import '../widgets/blok_daftar.dart';
import '../widgets/dialog_konfirmasi_hapus.dart';
import '../widgets/halaman_input_nominal.dart';
import '../widgets/ikon_bulat.dart';
import '../widgets/judul_seksi.dart';
import '../widgets/kartu_bagian.dart';
import '../widgets/kolom_angka.dart';
import '../widgets/progress_tipis.dart';
import '../widgets/sheet_detail_transaksi.dart';
import '../widgets/tampilan_kosong.dart';
import '../widgets/tombol_pill.dart';

class DetailKantongScreen extends StatelessWidget {
  final BudgetItem budget;
  // Bulan yang dilihat: bulanDipilih dari tab Transaksi, atau bulan ini dari halaman Anggaran.
  final DateTime bulan;

  const DetailKantongScreen({
    super.key,
    required this.budget,
    required this.bulan,
  });

  Future<void> _hapus(BuildContext context) async {
    final navigator = Navigator.of(context);
    bool? hapus = await showDialog<bool>(
      context: context,
      builder: (context) =>
          DialogKonfirmasiHapus(judul: 'Hapus kantong ${budget.kategori}?'),
    );
    if (hapus != true) return;
    AppData.hapusBudget(budget);
    navigator.pop();
  }

  void _ubahLimit(BuildContext context) {
    bukaInputNominal(
      context,
      judul: 'Limit ${budget.kategori} per bulan',
      ikon: AppData.ikonKategori(budget.kategori),
      nominalAwal: budget.limit,
      onSimpan: (limit) => AppData.ubahLimitBudget(budget, limit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarnaApp.latarHalaman,
      appBar: buatAppBarTurunan(
        'Kantong ${budget.kategori}',
        aksi: [
          IconButton(
            tooltip: 'Hapus kantong',
            icon: const Icon(
              LucideIcons.trash2,
              size: 20,
              color: WarnaApp.teksUtama,
            ),
            onPressed: () => _hapus(context),
          ),
        ],
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: AppData.refreshNotifier,
        builder: (context, nilai, child) => ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                JarakApp.tepiKartu,
                JarakApp.antarKartu,
                JarakApp.tepiKartu,
                0,
              ),
              child: KartuBagian(child: _bangunRingkasan(context)),
            ),
            BlokDaftar(child: _bangunDaftar(context)),
          ],
        ),
      ),
    );
  }

  Widget _bangunRingkasan(BuildContext context) {
    int terpakai = AppData.terpakaiBudget(budget.kategori, bulan);
    // Limit 0 tidak bisa dibagi, jadi persennya dianggap 0.
    double persen = budget.limit > 0 ? terpakai / budget.limit : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IkonBulat(ikon: AppData.ikonKategori(budget.kategori)),
            const SizedBox(width: JarakApp.j12),
            Expanded(
              child: Text.rich(
                TextSpan(
                  style: TeksApp.kecil,
                  children: [
                    TextSpan(
                      text: rupiahTampil(terpakai),
                      style: TeksApp.judulHalaman,
                    ),
                    TextSpan(text: ' dari ${rupiahTampil(budget.limit)}'),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: JarakApp.j12),
        // Menabung banyak itu kabar baik, jadi Tabungan tidak memakai warna peringatan.
        ProgressTipis(
          persen: persen,
          pakaiWarnaStatus: budget.kategori != 'Tabungan',
        ),
        const SizedBox(height: JarakApp.j16),
        _bangunAngka(terpakai),
        const SizedBox(height: JarakApp.j16),
        Align(
          alignment: Alignment.centerLeft,
          child: TombolPill(
            teks: 'Ubah limit',
            kecil: true,
            onTekan: () => _ubahLimit(context),
          ),
        ),
      ],
    );
  }

  Widget _bangunAngka(int terpakai) {
    int sisa = budget.limit - terpakai;
    int? perHari = AppData.jatahPerHari(budget, bulan, DateTime.now());

    return Row(
      children: [
        Expanded(
          // Tidak pernah "Sisa -Rp": kalau lewat, labelnya berubah dan nominal ditulis positif.
          child: KolomAngka(
            label: sisa < 0 ? 'Melebihi' : 'Sisa',
            nilai: rupiahTampil(sisa.abs()),
            warnaNilai: sisa < 0 ? WarnaApp.bahaya : null,
          ),
        ),
        if (perHari != null)
          Expanded(
            child: KolomAngka(label: 'Per hari', nilai: rupiahTampil(perHari)),
          ),
      ],
    );
  }

  Widget _bangunDaftar(BuildContext context) {
    List<CatatanTransaksi> daftar = AppData.transaksiKantong(
      budget.kategori,
      bulan,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        JudulSeksi(judul: 'Transaksi ${namaBulanPanjang[bulan.month - 1]}'),
        const SizedBox(height: JarakApp.j4),
        if (daftar.isEmpty)
          const TampilanKosong(
            ikon: LucideIcons.receipt,
            judul: 'Belum ada transaksi',
            kalimat: 'Transaksi kantong ini di bulan tersebut tampil di sini.',
          ),
        for (var t in daftar)
          BarisTransaksi(
            transaksi: t,
            onTekan: () => bukaDetailTransaksi(context, t),
          ),
      ],
    );
  }
}
