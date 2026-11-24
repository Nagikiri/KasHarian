import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../models/budget.dart';
import '../models/transaksi.dart';
import '../theme/app_theme.dart';
import '../widgets/baris_periode.dart';
import '../widgets/budget_bulan.dart';
import '../widgets/daftar_transaksi.dart';
import '../widgets/dialog_pilih_bulan.dart';
import '../widgets/dialog_pilih_rentang.dart';
import '../widgets/grid_kartu.dart';
import '../widgets/header_rentang.dart';
import '../widgets/judul_seksi.dart';
import '../widgets/kartu_bagian.dart';
import '../widgets/kartu_kantong.dart';
import '../widgets/navigasi_bulan.dart';
import '../widgets/pencarian_transaksi.dart';
import '../widgets/sheet_detail_transaksi.dart';
import '../widgets/sheet_tambah_budget.dart';
import '../widgets/tampilan_kosong.dart';
import 'budget_screen.dart';

class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  // Indeks dari PencarianTransaksi.pilihanFilter.
  int _filter = 0;
  String _kataKunci = '';
  // null berarti mode Bulan (memakai AppData.bulanDipilih). end ikut dihitung.
  DateTimeRange? _rentang;
  // Penanda posisi bagian pencarian, tujuan gulir dari "Lihat semua" di Beranda.
  final GlobalKey _kunciDaftar = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (!AppData.gulirKeDaftar) return;
    AppData.gulirKeDaftar = false;
    // Posisi penanda baru diketahui setelah halaman selesai digambar.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BuildContext? tujuan = _kunciDaftar.currentContext;
      if (tujuan == null) return;
      Scrollable.ensureVisible(
        tujuan,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  DateTime get _awal {
    DateTime bulan = AppData.bulanDipilih;
    return _rentang?.start ?? DateTime(bulan.year, bulan.month);
  }

  // Akhir eksklusif, sama seperti akhirPeriode.
  DateTime get _akhir {
    DateTime? hariTerakhir = _rentang?.end;
    if (hariTerakhir == null) {
      return DateTime(
        AppData.bulanDipilih.year,
        AppData.bulanDipilih.month + 1,
      );
    }
    return DateTime(
      hariTerakhir.year,
      hariTerakhir.month,
      hariTerakhir.day + 1,
    );
  }

  void _bukaBudget() =>
      Navigator.push(context, buatTransisiHalaman(const BudgetScreen()));

  // Memilih bulan selalu keluar dari mode rentang.
  void _pilihBulan(DateTime bulan) {
    setState(() => _rentang = null);
    AppData.bulanDipilih = bulan;
    AppData.refreshNotifier.value++;
  }

  // Panah melompat ke bulan terdekat yang punya transaksi. null berarti tidak ada.
  VoidCallback? _aksiPanah(DateTime? tujuan) =>
      tujuan == null ? null : () => _pilihBulan(tujuan);

  Future<void> _bukaDialogBulan() async {
    DateTime? hasil = await showDialog<DateTime>(
      context: context,
      builder: (context) => DialogPilihBulan(
        awal: AppData.bulanDipilih,
        batasAwal: AppData.batasAwal(),
        batasAkhir: AppData.batasAkhir(),
      ),
    );
    if (hasil != null) _pilihBulan(hasil);
  }

  Future<void> _bukaDialogRentang() async {
    DateTimeRange? hasil = await showDialog<DateTimeRange>(
      context: context,
      builder: (context) => DialogPilihRentang(
        mulai: _awal,
        selesai: DateTime(_akhir.year, _akhir.month, _akhir.day - 1),
        batasAwal: AppData.batasAwal(),
        batasAkhir: AppData.batasAkhir(),
      ),
    );
    if (hasil != null) setState(() => _rentang = hasil);
  }

  bool _cocok(CatatanTransaksi t) {
    if (_filter == 1 && (t.isPemasukan || t.isTransfer)) return false;
    if (_filter == 2 && !t.isPemasukan) return false;
    if (_filter == 3 && !t.isTransfer) return false;
    String kunci = _kataKunci.toLowerCase();
    return t.catatan.toLowerCase().contains(kunci) ||
        t.kategori.toLowerCase().contains(kunci);
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold putih untuk area status bar, area gulir abu di belakang kartu.
    return Scaffold(
      body: SafeArea(
        child: ColoredBox(
          color: WarnaApp.latarHalaman,
          child: ValueListenableBuilder<int>(
            valueListenable: AppData.refreshNotifier,
            builder: (context, nilai, child) => _bangunIsi(),
          ),
        ),
      ),
    );
  }

  Widget _bangunIsi() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeaderRentang(
            judul: 'Transaksi',
            rentangAktif: _rentang != null,
            onRentang: _bukaDialogRentang,
            bawah: [_bangunPeriode()],
          ),
          if (_rentang == null) ...[
            _tepi(
              KartuBagian(
                child: BudgetBulan(
                  bulan: AppData.bulanDipilih,
                  onAtur: _bukaBudget,
                ),
              ),
            ),
            _tepi(
              KartuBagian(
                judul: const JudulSeksi(judul: 'Kantong alokasi'),
                child: _bangunKantong(),
              ),
            ),
          ],
          _tepi(
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(key: _kunciDaftar),
                KartuBagian(child: _bangunDaftar()),
              ],
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

  // Transaksi hanya punya mode Bulan (jenis 1) dan Rentang (jenis 3).
  Widget _bangunPeriode() {
    DateTime bulan = AppData.bulanDipilih;
    return BarisPeriode(
      jenis: _rentang == null ? 1 : 3,
      awal: _awal,
      akhir: _akhir,
      onSebelum: _aksiPanah(AppData.bulanBerdataSebelum(bulan)),
      onSesudah: _aksiPanah(AppData.bulanBerdataSesudah(bulan)),
      onPilih: _bukaDialogBulan,
    );
  }

  Widget _bangunKantong() {
    return GridKartu(
      daftar: [for (var b in AppData.daftarBudget) _bangunKartu(b)],
      kosong: TampilanKosong(
        ikon: LucideIcons.wallet,
        judul: 'Belum ada kategori anggaran',
        kalimat:
            'Atur batas belanja per kategori supaya pengeluaran terpantau.',
        labelTombol: 'Tambah kategori',
        onTekan: () => bukaTambahBudget(context),
      ),
      labelTambah: 'Tambah kategori',
      onTambah: () => bukaTambahBudget(context),
    );
  }

  Widget _bangunKartu(BudgetItem b) => KartuKantong(
    budget: b,
    bulan: AppData.bulanDipilih,
    onTekan: _bukaBudget,
  );

  // Pencarian, daftar, dan tombol bulan berada dalam satu kartu karena saling terkait.
  Widget _bangunDaftar() {
    List<CatatanTransaksi> daftar = AppData.transaksiAntara(
      _awal,
      _akhir,
    ).where(_cocok).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PencarianTransaksi(
          filter: _filter,
          onCari: (v) => setState(() => _kataKunci = v),
          onFilter: (i) => setState(() => _filter = i),
        ),
        DaftarTransaksi(
          daftar: daftar,
          adaSaringan: _filter != 0 || _kataKunci.isNotEmpty,
          modeRentang: _rentang != null,
          onTekan: (t) => bukaDetailTransaksi(context, t),
        ),
        if (_rentang == null) ...[
          const SizedBox(height: JarakApp.j16),
          NavigasiBulan(bulan: AppData.bulanDipilih, onPilih: _pilihBulan),
        ],
      ],
    );
  }
}
