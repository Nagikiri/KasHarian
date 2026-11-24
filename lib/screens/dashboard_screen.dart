import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../models/transaksi.dart';
import '../models/wishlist.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/privasi.dart';
import '../widgets/baris_judul.dart';
import '../widgets/baris_transaksi.dart';
import '../widgets/judul_seksi.dart';
import '../widgets/kartu_bagian.dart';
import '../widgets/kartu_impian.dart';
import '../widgets/kartu_kurs.dart';
import '../widgets/kartu_navigasi.dart';
import '../widgets/kartu_saldo.dart';
import '../widgets/sheet_detail_transaksi.dart';
import '../widgets/tampilan_kosong.dart';
import 'budget_screen.dart';
import 'utang_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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

  // Tab Transaksi dibuka di bulan berjalan, sama dengan isi Beranda, lalu langsung digulir ke daftar.
  void _lihatSemuaTransaksi() {
    AppData.bulanDipilih = DateTime.now();
    AppData.gulirKeDaftar = true;
    AppData.tabAktif.value = 1;
  }

  void _buka(Widget halaman) =>
      Navigator.push(context, buatTransisiHalaman(halaman));

  @override
  Widget build(BuildContext context) {
    // Scaffold putih untuk area status bar, area gulir abu supaya ruang kosong di bawah isi tetap abu.
    return Scaffold(
      body: SafeArea(
        child: ColoredBox(
          color: WarnaApp.latarHalaman,
          child: ValueListenableBuilder<int>(
            valueListenable: AppData.refreshNotifier,
            // Tombol mata hanya ada di sini, jadi hanya Beranda yang perlu mendengarkan.
            builder: (context, nilai, child) => ValueListenableBuilder<bool>(
              valueListenable: sembunyikanNominal,
              builder: (context, sembunyi, child) => _bangunIsi(),
            ),
          ),
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
          // Sisi kanan disiapkan untuk ikon Pengaturan nanti.
          BarisJudul(
            judul: 'KasHarian',
            keterangan: formatTanggal(DateTime.now()),
          ),
          _tepi(
            KartuSaldo(
              saldo: rupiahTampil(AppData.saldoTersedia),
              pemasukan: rupiahTampil(AppData.totalPemasukan),
              pengeluaran: rupiahTampil(AppData.totalPengeluaran),
              disembunyikan: sembunyikanNominal.value,
              onMata: () =>
                  sembunyikanNominal.value = !sembunyikanNominal.value,
            ),
          ),
          _tepi(_bangunKartuNavigasi()),
          _kartu(
            KartuKurs(sedangMemuat: _sedangMemuatKurs, onPerbarui: _ambilKurs),
          ),
          if (impian != null)
            _kartu(
              KartuImpian(impian: impian),
              judul: JudulSeksi(
                judul: 'Impian terdekat',
                aksi: 'Lihat semua',
                onAksi: () => AppData.tabAktif.value = 2,
              ),
            ),
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

  // Setiap kartu diberi jarak 20 di atasnya dan sejajar dengan teks judul di kiri-kanan.
  Widget _tepi(Widget isi) => Padding(
    padding: const EdgeInsets.fromLTRB(
      JarakApp.tepiHalaman,
      JarakApp.j20,
      JarakApp.tepiHalaman,
      0,
    ),
    child: isi,
  );

  Widget _kartu(
    Widget isi, {
    EdgeInsets padding = const EdgeInsets.all(JarakApp.j16),
    Widget? judul,
  }) => _tepi(KartuBagian(padding: padding, judul: judul, child: isi));

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
                  ? 'Lebih ${rupiahTampil(-sisa)}'
                  : 'Sisa ${rupiahTampil(sisa)}',
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
          onAksi: _lihatSemuaTransaksi,
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
          BarisTransaksi(
            transaksi: daftar[i],
            onTekan: () => bukaDetailTransaksi(context, daftar[i]),
          ),
        ],
      ],
    );
  }
}
