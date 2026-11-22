import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../models/transaksi.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/baris_transaksi.dart';
import '../widgets/judul_seksi.dart';
import '../widgets/grid_kantong.dart';
import '../widgets/pemilih_bulan.dart';
import '../widgets/progress_tipis.dart';
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

  void _bukaBudget() =>
      Navigator.push(context, buatTransisiHalaman(const BudgetScreen()));

  void _pilihBulan(DateTime bulan) {
    AppData.bulanDipilih = bulan;
    AppData.refreshNotifier.value++;
  }

  void _bukaDetail(CatatanTransaksi transaksi) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SheetDetailTransaksi(transaksi: transaksi),
    );
  }

  bool _hariSama(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _cocok(CatatanTransaksi t) {
    DateTime bulan = AppData.bulanDipilih;
    if (t.tanggal.year != bulan.year || t.tanggal.month != bulan.month) {
      return false;
    }
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
                  _tepi(_bangunHeader()),
                  _tepi(_bangunBudget()),
                  _tepi(_bangunKantong()),
                  const SizedBox(height: JarakApp.j24),
                  Container(height: 8, color: WarnaApp.latarSeksi),
                  _tepi(_bangunPencarian()),
                  _tepi(_bangunDaftar()),
                  _tepi(_bangunNavigasiBulan()),
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

  Widget _bangunTeksKosong(String teks) => Padding(
    padding: const EdgeInsets.symmetric(vertical: JarakApp.j16),
    child: Text(teks, style: TeksApp.kecil),
  );

  Widget _bangunHeader() {
    return const Row(
      children: [
        Expanded(child: Text('Transaksi', style: TeksApp.judulHalaman)),
        PemilihBulan(),
      ],
    );
  }

  Widget _bangunBudget() {
    int anggaran = AppData.anggaranBulanan;
    int terpakai = AppData.terpakaiAnggaran(AppData.bulanDipilih);
    int sisa = anggaran - terpakai;
    // Anggaran 0 tidak bisa dibagi, jadi persennya dianggap 0.
    double persen = anggaran > 0 ? terpakai / anggaran : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JudulSeksi(judul: 'Budget', aksi: 'Atur', onAksi: _bukaBudget),
        const SizedBox(height: JarakApp.j12),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: formatRupiah(terpakai), style: TeksApp.angka),
              TextSpan(
                text: ' dari ${formatRupiah(anggaran)}',
                style: TeksApp.kecil,
              ),
            ],
          ),
        ),
        const SizedBox(height: JarakApp.j8),
        ProgressTipis(persen: persen),
        const SizedBox(height: JarakApp.j8),
        Text(
          'Sisa ${formatRupiah(sisa)}',
          style: TeksApp.kecil.copyWith(
            color: sisa < 0 ? WarnaApp.bahaya : null,
          ),
        ),
      ],
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
        GridKantong(bulan: AppData.bulanDipilih, onTekanKartu: _bukaBudget),
      ],
    );
  }

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
    List<CatatanTransaksi> daftar = AppData.daftarTransaksi
        .where(_cocok)
        .toList();
    daftar.sort((a, b) => b.tanggal.compareTo(a.tanggal));

    if (daftar.isEmpty) {
      bool adaSaringan = _filter != 0 || _kataKunci.isNotEmpty;
      return _bangunTeksKosong(
        adaSaringan
            ? 'Tidak ada transaksi yang sesuai'
            : 'Belum ada transaksi di bulan ini',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < daftar.length; i++) ...[
          // Judul tanggal hanya muncul di transaksi pertama setiap hari.
          if (i == 0 || !_hariSama(daftar[i - 1].tanggal, daftar[i].tanggal))
            _bangunJudulTanggal(daftar[i].tanggal, daftar)
          else
            const Divider(height: 1),
          BarisTransaksi(
            transaksi: daftar[i],
            onTekan: () => _bukaDetail(daftar[i]),
          ),
        ],
      ],
    );
  }

  Widget _bangunJudulTanggal(DateTime tanggal, List<CatatanTransaksi> daftar) {
    int keluar = 0;
    for (var t in daftar) {
      bool pengeluaran = !t.isPemasukan && !t.isTransfer;
      if (pengeluaran && _hariSama(t.tanggal, tanggal)) keluar += t.nominal;
    }

    return Padding(
      padding: const EdgeInsets.only(top: JarakApp.j16, bottom: JarakApp.j4),
      child: Row(
        children: [
          Expanded(
            child: Text(formatTanggal(tanggal), style: TeksApp.tombolKecil),
          ),
          if (keluar > 0)
            Text('-${formatRupiah(keluar)}', style: TeksApp.kecil),
        ],
      ),
    );
  }

  String _teksBulan(DateTime b) => '${namaBulan[b.month - 1]} ${b.year}';

  Widget _bangunNavigasiBulan() {
    DateTime? sebelum = AppData.bulanBerdataSebelum(AppData.bulanDipilih);
    DateTime? sesudah = AppData.bulanBerdataSesudah(AppData.bulanDipilih);

    return Row(
      children: [
        if (sebelum != null)
          TombolPill(
            teks: _teksBulan(sebelum),
            ikon: LucideIcons.arrowLeft,
            onTekan: () => _pilihBulan(sebelum),
          ),
        const Spacer(),
        if (sesudah != null)
          TombolPill(
            teks: _teksBulan(sesudah),
            ikon: LucideIcons.arrowRight,
            ikonDiKanan: true,
            onTekan: () => _pilihBulan(sesudah),
          ),
      ],
    );
  }
}
