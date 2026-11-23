import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../models/budget.dart';
import '../models/transaksi.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/baris_periode.dart';
import '../widgets/budget_bulan.dart';
import '../widgets/daftar_transaksi.dart';
import '../widgets/dialog_pilih_bulan.dart';
import '../widgets/dialog_pilih_rentang.dart';
import '../widgets/grid_kartu.dart';
import '../widgets/header_rentang.dart';
import '../widgets/judul_seksi.dart';
import '../widgets/kartu_kantong.dart';
import '../widgets/sheet_detail_transaksi.dart';
import '../widgets/tombol_pill.dart';
import 'budget_screen.dart';

class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  final List<String> _pilihanFilter = const [
    'Semua',
    'Pengeluaran',
    'Pemasukan',
    'Transfer',
  ];
  int _filter = 0;
  String _kataKunci = '';
  // null berarti mode Bulan (memakai AppData.bulanDipilih). end ikut dihitung.
  DateTimeRange? _rentang;

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

  void _bukaDetail(CatatanTransaksi transaksi) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => SheetDetailTransaksi(transaksi: transaksi),
    );
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
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<int>(
          valueListenable: AppData.refreshNotifier,
          builder: (context, nilai, child) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _tepi(
                    HeaderRentang(
                      judul: 'Transaksi',
                      rentangAktif: _rentang != null,
                      onRentang: _bukaDialogRentang,
                    ),
                  ),
                  _tepi(_bangunPeriode()),
                  if (_rentang == null) ...[
                    _tepi(
                      BudgetBulan(
                        bulan: AppData.bulanDipilih,
                        onAtur: _bukaBudget,
                      ),
                    ),
                    _tepi(_bangunKantong()),
                  ],
                  const SizedBox(height: JarakApp.j24),
                  Container(height: 8, color: WarnaApp.latarSeksi),
                  _tepi(_bangunPencarian()),
                  _tepi(_bangunDaftar()),
                  if (_rentang == null) _tepi(_bangunNavigasiBulan()),
                  const SizedBox(height: JarakApp.j24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Pita pemisah harus selebar layar, jadi padding samping dipasang per bagian.
  Widget _tepi(Widget isi) => Padding(
    padding: const EdgeInsets.fromLTRB(
      JarakApp.tepiHalaman,
      JarakApp.j16,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        JudulSeksi(
          judul: 'Kantong alokasi',
          aksi: '+ Kategori',
          onAksi: _bukaBudget,
        ),
        const SizedBox(height: JarakApp.j12),
        GridKartu(
          teksKosong: 'Belum ada kategori anggaran',
          daftar: [for (var b in AppData.daftarBudget) _bangunKartu(b)],
        ),
      ],
    );
  }

  Widget _bangunKartu(BudgetItem b) => KartuKantong(
    budget: b,
    bulan: AppData.bulanDipilih,
    onTekan: _bukaBudget,
  );

  Widget _bangunPencarian() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          onChanged: (v) => setState(() => _kataKunci = v),
          decoration: const InputDecoration(
            hintText: 'Cari catatan atau kategori',
            prefixIcon: Icon(
              LucideIcons.search,
              size: 18,
              color: WarnaApp.teksRedup,
            ),
          ),
        ),
        const SizedBox(height: JarakApp.j12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int i = 0; i < _pilihanFilter.length; i++)
                Padding(
                  padding: const EdgeInsets.only(right: JarakApp.j8),
                  child: TombolPill(
                    teks: _pilihanFilter[i],
                    kecil: true,
                    terpilih: _filter == i,
                    onTekan: () => setState(() => _filter = i),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bangunDaftar() {
    List<CatatanTransaksi> daftar = AppData.transaksiAntara(
      _awal,
      _akhir,
    ).where(_cocok).toList();
    bool adaSaringan = _filter != 0 || _kataKunci.isNotEmpty;
    String teksKosong = adaSaringan
        ? 'Tidak ada transaksi yang sesuai'
        : 'Belum ada transaksi di ${_rentang == null ? 'bulan' : 'rentang'} ini';
    return DaftarTransaksi(
      daftar: daftar,
      teksKosong: teksKosong,
      onTekan: _bukaDetail,
    );
  }

  Widget _bangunNavigasiBulan() {
    return Row(
      children: [
        _bangunTombolBulan(AppData.bulanBerdataSebelum(AppData.bulanDipilih)),
        const SizedBox(width: JarakApp.j8),
        _bangunTombolBulan(
          AppData.bulanBerdataSesudah(AppData.bulanDipilih),
          kanan: true,
        ),
      ],
    );
  }

  // Setiap tombol mendapat separuh lebar dan dikecilkan kalau nama bulannya panjang.
  Widget _bangunTombolBulan(DateTime? bulan, {bool kanan = false}) {
    return Expanded(
      child: Align(
        alignment: kanan ? Alignment.centerRight : Alignment.centerLeft,
        child: bulan == null
            ? null
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: TombolPill(
                  teks: '${namaBulanPanjang[bulan.month - 1]} ${bulan.year}',
                  ikon: kanan ? LucideIcons.arrowRight : LucideIcons.arrowLeft,
                  ikonDiKanan: kanan,
                  onTekan: () => _pilihBulan(bulan),
                ),
              ),
      ),
    );
  }
}
