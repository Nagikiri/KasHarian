import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../models/wishlist.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/privasi.dart';
import '../widgets/baris_judul.dart';
import '../widgets/grid_kartu.dart';
import '../widgets/judul_seksi.dart';
import '../widgets/kartu_bagian.dart';
import '../widgets/kartu_hitung_kurs.dart';
import '../widgets/kartu_progress.dart';
import '../widgets/sheet_detail_impian.dart';
import '../widgets/sheet_impian_baru.dart';
import '../widgets/sheet_input_nominal.dart';
import '../widgets/tampilan_kosong.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  bool _sedangMemuat = false;

  @override
  void initState() {
    super.initState();
    // Kalau Beranda sudah mengambil kurs live, API tidak perlu dipanggil lagi.
    if (!AppData.kursLive) _ambilKurs();
  }

  Future<void> _ambilKurs() async {
    setState(() => _sedangMemuat = true);
    await AppData.perbaruiKurs();
    if (mounted) setState(() => _sedangMemuat = false);
  }

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
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => SheetDetailImpian(impian: impian),
    );
    if (tabung == true && mounted) _bukaTabung(impian);
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
            builder: (context, nilai, child) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const BarisJudul(judul: 'Impian'),
                  _tepi(
                    KartuBagian(
                      child: KartuHitungKurs(
                        sedangMemuat: _sedangMemuat,
                        onPerbarui: _ambilKurs,
                      ),
                    ),
                  ),
                  _tepi(
                    KartuBagian(
                      judul: const JudulSeksi(judul: 'Impianku'),
                      child: _bangunDaftarImpian(),
                    ),
                  ),
                  const SizedBox(height: JarakApp.j24),
                ],
              ),
            ),
          ),
        ),
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

  Widget _bangunDaftarImpian() {
    return GridKartu(
      daftar: [for (var impian in _daftarUrut()) _bangunKartu(impian)],
      kosong: TampilanKosong(
        ikon: LucideIcons.star,
        judul: 'Belum ada impian',
        kalimat: 'Simpan barang incaran dan pantau tabungannya di sini.',
        labelTombol: 'Tambah impian',
        onTekan: () => bukaSheetImpianBaru(context),
      ),
      labelTambah: 'Tambah impian',
      onTambah: () => bukaSheetImpianBaru(context),
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
      indeksWarna: AppData.indeksWarnaImpian(impian.kategori),
      persenTeks: '${(persen * 100).floor()}%',
      judul: impian.nama,
      nominal: rupiahTampil(impian.terkumpulIdr),
      keterangan: 'dari ${rupiahTampil(impian.targetIdr)}',
      persen: persen,
      pakaiWarnaStatus: false,
      pakaiCincin: true,
      catatanBawah: catatan,
      onTekan: () => _bukaDetail(impian),
    );
  }
}
