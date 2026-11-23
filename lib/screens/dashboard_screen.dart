import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../models/transaksi.dart';
import '../models/wishlist.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/baris_transaksi.dart';
import '../widgets/judul_seksi.dart';
import '../widgets/kartu_impian.dart';
import '../widgets/kartu_navigasi.dart';
import '../widgets/kolom_angka.dart';
import 'budget_screen.dart';
import 'utang_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _saldoDisembunyikan = false;
  bool _sedangMemuatKurs = false;

  @override
  void initState() {
    super.initState();
    // Beranda dibuat ulang setiap pindah tab, jadi API hanya dipanggil kalau kurs belum live.
    if (!AppData.kursLive) _ambilKurs();
  }

  Future<void> _ambilKurs() async {
    setState(() => _sedangMemuatKurs = true);
    await AppData.perbaruiKurs();
    if (mounted) setState(() => _sedangMemuatKurs = false);
  }

  String _rupiah(int nilai) =>
      _saldoDisembunyikan ? 'Rp ••••••' : formatRupiah(nilai);

  void _buka(Widget halaman) =>
      Navigator.push(context, buatTransisiHalaman(halaman));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<int>(
          valueListenable: AppData.refreshNotifier,
          builder: (context, nilai, child) {
            WishlistItem? impian = AppData.impianTerdekat();
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _seksi(_bangunAtas()),
                  _bangunPita(),
                  _seksi(_bangunKurs()),
                  if (impian != null) ...[
                    _bangunPita(),
                    _seksi(_bangunImpian(impian)),
                  ],
                  _bangunPita(),
                  _seksi(_bangunTransaksiTerbaru()),
                  const SizedBox(height: JarakApp.j24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _seksi(Widget isi) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: JarakApp.tepiHalaman,
      vertical: JarakApp.j16,
    ),
    child: isi,
  );

  Widget _bangunPita() => Container(height: 8, color: WarnaApp.latarSeksi);

  Widget _bangunTeksKosong(String teks) => Padding(
    padding: const EdgeInsets.symmetric(vertical: JarakApp.j16),
    child: Text(teks, style: TeksApp.kecil),
  );

  Widget _barisKolom(List<Widget> kolom) =>
      Row(children: [for (Widget k in kolom) Expanded(child: k)]);

  Widget _bangunAtas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('KasHarian', style: TeksApp.judulHalaman),
        const SizedBox(height: JarakApp.j24),
        GestureDetector(
          onTap: () =>
              setState(() => _saldoDisembunyikan = !_saldoDisembunyikan),
          child: Row(
            children: [
              const Text('Saldo', style: TeksApp.kecil),
              const SizedBox(width: JarakApp.j4),
              Icon(
                _saldoDisembunyikan ? LucideIcons.eyeOff : LucideIcons.eye,
                size: 18,
                color: WarnaApp.teksRedup,
              ),
            ],
          ),
        ),
        const SizedBox(height: JarakApp.j4),
        Text(_rupiah(AppData.saldoTersedia), style: TeksApp.angkaBesar),
        const SizedBox(height: JarakApp.j16),
        _barisKolom([
          KolomAngka(
            label: 'Pemasukan',
            nilai: _rupiah(AppData.totalPemasukan),
          ),
          KolomAngka(
            label: 'Pengeluaran',
            nilai: _rupiah(AppData.totalPengeluaran),
          ),
        ]),
        const SizedBox(height: JarakApp.j24),
        _bangunKartuNavigasi(),
      ],
    );
  }

  Widget _bangunKartuNavigasi() {
    int anggaran = AppData.anggaranBulanan;
    int terpakai = AppData.terpakaiAnggaran(DateTime.now());
    int sisa = anggaran - terpakai;
    int belumLunas = AppData.daftarUtang.where((u) => !u.lunas).length;
    // IntrinsicHeight + stretch membuat kedua kartu setinggi kartu yang paling tinggi.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: KartuNavigasi(
              ikon: LucideIcons.wallet,
              judul: 'Anggaran',
              info: sisa < 0
                  ? 'Lebih ${_rupiah(-sisa)}'
                  : 'Sisa ${_rupiah(sisa)}',
              warnaInfo: sisa < 0 ? WarnaApp.bahaya : null,
              persen: anggaran > 0 ? terpakai / anggaran : 0,
              onTekan: () => _buka(const BudgetScreen()),
            ),
          ),
          const SizedBox(width: JarakApp.j12),
          Expanded(
            child: KartuNavigasi(
              ikon: LucideIcons.handCoins,
              judul: 'Utang & Piutang',
              info: belumLunas == 0 ? 'Semua lunas' : '$belumLunas belum lunas',
              onTekan: () => _buka(const UtangScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bangunKurs() {
    Widget ujung = _sedangMemuatKurs
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: WarnaApp.primer,
            ),
          )
        : GestureDetector(
            onTap: _ambilKurs,
            child: const Icon(
              LucideIcons.refreshCw,
              size: 20,
              color: WarnaApp.teksKedua,
            ),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JudulSeksi(judul: 'Kurs hari ini', ujung: ujung),
        const SizedBox(height: JarakApp.j16),
        _barisKolom([
          _bangunKolomKurs('USD'),
          _bangunKolomKurs('SGD'),
          _bangunKolomKurs('JPY'),
        ]),
        const SizedBox(height: JarakApp.j12),
        Text(
          AppData.infoKurs,
          style: TeksApp.kecil.copyWith(
            color: AppData.kursLive ? WarnaApp.primer : WarnaApp.teksRedup,
          ),
        ),
        const SizedBox(height: JarakApp.j4),
        const Text('Rates By Exchange Rate API', style: TeksApp.mini),
      ],
    );
  }

  Widget _bangunKolomKurs(String kode) => KolomAngka(
    label: kode,
    nilai: 'Rp ${formatTitik(AppData.kursKeIdr[kode] ?? 0)}',
  );

  Widget _bangunTransaksiTerbaru() {
    DateTime bulan = DateTime.now();
    List<CatatanTransaksi> daftar = AppData.daftarTransaksi
        .where(
          (t) => t.tanggal.year == bulan.year && t.tanggal.month == bulan.month,
        )
        .toList();
    daftar.sort((a, b) => b.tanggal.compareTo(a.tanggal));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JudulSeksi(
          judul: 'Transaksi terbaru',
          aksi: 'Lihat semua',
          onAksi: () => AppData.tabAktif.value = 1,
        ),
        const SizedBox(height: JarakApp.j4),
        if (daftar.isEmpty) _bangunTeksKosong('Belum ada transaksi bulan ini'),
        for (int i = 0; i < daftar.length && i < 5; i++) ...[
          if (i > 0) const Divider(height: 1),
          BarisTransaksi(transaksi: daftar[i]),
        ],
      ],
    );
  }

  Widget _bangunImpian(WishlistItem impian) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JudulSeksi(
          judul: 'Impian terdekat',
          aksi: 'Lihat semua',
          onAksi: () => AppData.tabAktif.value = 2,
        ),
        const SizedBox(height: JarakApp.j16),
        KartuImpian(impian: impian),
      ],
    );
  }
}
