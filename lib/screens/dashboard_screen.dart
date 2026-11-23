import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../models/transaksi.dart';
import '../models/wishlist.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/baris_transaksi.dart';
import '../widgets/header_beranda.dart';
import '../widgets/judul_seksi.dart';
import '../widgets/kartu_bagian.dart';
import '../widgets/kartu_impian.dart';
import '../widgets/kartu_kurs.dart';
import '../widgets/kartu_navigasi.dart';
import '../widgets/tampilan_kosong.dart';
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: gayaStatusTerang,
      child: Scaffold(
        // Latar tetap abu, jadi ruang kosong di bawah isi tidak pernah hijau.
        backgroundColor: WarnaApp.latarHalaman,
        body: Column(
          children: [
            // Strip hijau di luar area scroll, jadi isi tidak masuk ke bawah ikon status bar.
            Container(
              height: MediaQuery.paddingOf(context).top,
              color: WarnaApp.primer,
            ),
            Expanded(
              child: ValueListenableBuilder<int>(
                valueListenable: AppData.refreshNotifier,
                builder: (context, nilai, child) => _bangunIsi(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bangunIsi() {
    WishlistItem? impian = AppData.impianTerdekat();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeaderBeranda(
            saldo: _rupiah(AppData.saldoTersedia),
            pemasukan: _rupiah(AppData.totalPemasukan),
            pengeluaran: _rupiah(AppData.totalPengeluaran),
            disembunyikan: _saldoDisembunyikan,
            onMata: () =>
                setState(() => _saldoDisembunyikan = !_saldoDisembunyikan),
            bawah: _bangunKartuNavigasi(),
          ),
          _kartu(
            KartuKurs(sedangMemuat: _sedangMemuatKurs, onPerbarui: _ambilKurs),
          ),
          if (impian != null) _kartu(_bangunImpian(impian)),
          _kartu(
            _bangunTransaksiTerbaru(),
            // BarisTransaksi sudah punya jarak bawah 12, jadi padding bawah kartu dikurangi.
            padding: const EdgeInsets.fromLTRB(
              JarakApp.j16,
              JarakApp.j16,
              JarakApp.j16,
              JarakApp.j4,
            ),
          ),
          const SizedBox(height: JarakApp.j24),
        ],
      ),
    );
  }

  // Setiap kartu diberi jarak 16 di atasnya dan sejajar dengan teks header di kiri-kanan.
  Widget _kartu(
    Widget isi, {
    EdgeInsets padding = const EdgeInsets.all(JarakApp.j16),
  }) => Padding(
    padding: const EdgeInsets.fromLTRB(
      JarakApp.tepiHalaman,
      JarakApp.j16,
      JarakApp.tepiHalaman,
      0,
    ),
    child: KartuBagian(padding: padding, child: isi),
  );

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
              putih: true,
              onTekan: () => _buka(const BudgetScreen()),
            ),
          ),
          const SizedBox(width: JarakApp.j12),
          Expanded(
            child: KartuNavigasi(
              ikon: LucideIcons.handCoins,
              judul: 'Utang & Piutang',
              info: belumLunas == 0 ? 'Semua lunas' : '$belumLunas belum lunas',
              putih: true,
              onTekan: () => _buka(const UtangScreen()),
            ),
          ),
        ],
      ),
    );
  }

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
        if (daftar.isEmpty)
          const TampilanKosong(
            ikon: LucideIcons.receipt,
            judul: 'Belum ada transaksi',
            kalimat: 'Transaksi bulan ini akan tampil di sini.',
          ),
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
        KartuImpian(impian: impian, sembunyikanNominal: _saldoDisembunyikan),
      ],
    );
  }
}
