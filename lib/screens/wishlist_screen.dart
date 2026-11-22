import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../models/wishlist.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/format_ribuan.dart';
import '../widgets/grid_kartu.dart';
import '../widgets/judul_seksi.dart';
import '../widgets/kartu_progress.dart';
import '../widgets/pilihan_segmen.dart';
import '../widgets/sheet_detail_impian.dart';
import '../widgets/sheet_impian_baru.dart';
import '../widgets/sheet_input_nominal.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final List<String> _daftarMataUang = AppData.kursKeIdr.keys.toList();
  final TextEditingController _jumlahCtrl = TextEditingController(text: '100');
  int _mataUang = 0;
  bool _sedangMemuat = false;

  @override
  void initState() {
    super.initState();
    // Kalau Beranda sudah mengambil kurs live, API tidak perlu dipanggil lagi.
    if (!AppData.kursLive) _ambilKurs();
  }

  @override
  void dispose() {
    _jumlahCtrl.dispose();
    super.dispose();
  }

  Future<void> _ambilKurs() async {
    setState(() => _sedangMemuat = true);
    await AppData.perbaruiKurs();
    if (mounted) setState(() => _sedangMemuat = false);
  }

  String get _kode => _daftarMataUang[_mataUang];

  double _persen(WishlistItem w) => w.terkumpulIdr / w.targetIdr;

  bool _tercapai(WishlistItem w) => w.terkumpulIdr >= w.targetIdr;

  // Yang belum tercapai di atas dengan persen terbesar dulu, yang tercapai di bawah.
  List<WishlistItem> _daftarUrut() {
    List<WishlistItem> belum = AppData.daftarWishlist
        .where((w) => !_tercapai(w))
        .toList();
    belum.sort((a, b) => _persen(b).compareTo(_persen(a)));
    return [...belum, ...AppData.daftarWishlist.where(_tercapai)];
  }

  void _bukaTabung(WishlistItem impian) {
    bukaInputNominal(
      context,
      judul: 'Nabung untuk ${impian.nama}',
      ikon: LucideIcons.piggyBank,
      onSimpan: (nominal) {
        int disimpan = AppData.tambahTabunganWishlist(impian, nominal);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${formatRupiah(disimpan)} ditabung ke ${impian.nama}',
            ),
          ),
        );
      },
    );
  }

  // Sheet detail ditutup dulu, baru sheet nominal dibuka dari layar ini.
  Future<void> _bukaDetail(WishlistItem impian) async {
    bool? tabung = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SheetDetailImpian(impian: impian),
    );
    if (tabung == true && mounted) _bukaTabung(impian);
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
                  _seksi(_bangunHeader()),
                  _seksi(_bangunKonverter()),
                  _bangunPita(),
                  _seksi(_bangunDaftarImpian()),
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

  Widget _bangunHeader() {
    return const Text('Wishlist', style: TeksApp.judulHalaman);
  }

  Widget _bangunTombolRefresh() {
    if (_sedangMemuat) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: WarnaApp.primer,
        ),
      );
    }
    return GestureDetector(
      onTap: _ambilKurs,
      child: const Icon(
        LucideIcons.refreshCw,
        size: 20,
        color: WarnaApp.teksKedua,
      ),
    );
  }

  Widget _bangunKonverter() {
    int kurs = AppData.kursKeIdr[_kode] ?? 0;
    int hasil = bacaAngka(_jumlahCtrl.text) * kurs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JudulSeksi(judul: 'Konverter valas', ujung: _bangunTombolRefresh()),
        const SizedBox(height: JarakApp.j16),
        PilihanSegmen(
          pilihan: _daftarMataUang,
          indeksAktif: _mataUang,
          onPilih: (i) => setState(() => _mataUang = i),
        ),
        const SizedBox(height: JarakApp.j12),
        TextField(
          controller: _jumlahCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [FormatRibuan()],
          decoration: InputDecoration(
            hintText: 'Jumlah',
            prefixText: '$_kode ',
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: JarakApp.j16),
        // Angka besar dikecilkan kalau tidak muat, bukan dipotong.
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text('Rp ${formatTitik(hasil)}', style: TeksApp.angkaBesar),
        ),
        const SizedBox(height: JarakApp.j8),
        Text(
          '1 $_kode = ${formatRupiah(kurs)} · ${AppData.infoKurs}',
          style: TeksApp.kecil.copyWith(
            color: AppData.kursLive ? WarnaApp.primer : WarnaApp.teksRedup,
          ),
        ),
        const SizedBox(height: JarakApp.j4),
        const Text('Rates By Exchange Rate API', style: TeksApp.mini),
      ],
    );
  }

  Widget _bangunDaftarImpian() {
    List<WishlistItem> daftar = _daftarUrut();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JudulSeksi(
          judul: 'Impianku',
          aksi: '+ Tambah',
          onAksi: () => bukaSheetImpianBaru(context),
        ),
        const SizedBox(height: JarakApp.j12),
        GridKartu(
          teksKosong: 'Belum ada impian. Tekan + Tambah untuk mulai.',
          daftar: [for (var impian in daftar) _bangunKartu(impian)],
        ),
      ],
    );
  }

  Widget _bangunKartu(WishlistItem impian) {
    double persen = _persen(impian);
    int estimasi = AppData.estimasiBulanWishlist(impian);
    // Estimasi 0 berarti budget 'Tabungan' belum ada, jadi catatan bawah dikosongkan.
    String? catatan;
    if (_tercapai(impian)) {
      catatan = 'Target tercapai';
    } else if (estimasi > 0) {
      catatan = formatEstimasiBulan(estimasi);
    }

    return KartuProgress(
      ikon: impian.ikon,
      persenTeks: '${(persen * 100).floor()}%',
      judul: impian.nama,
      nominal: formatRupiah(impian.terkumpulIdr),
      keterangan: 'dari ${formatRupiah(impian.targetIdr)}',
      persen: persen,
      pakaiWarnaStatus: false,
      catatanBawah: catatan,
      onTekan: () => _bukaDetail(impian),
    );
  }
}
