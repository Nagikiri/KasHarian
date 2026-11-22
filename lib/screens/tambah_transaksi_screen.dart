import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../models/bagian_teman.dart';
import '../models/kategori.dart';
import '../models/transaksi.dart';
import '../models/utang.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/nominal.dart';
import '../widgets/baris_isian.dart';
import '../widgets/numpad.dart';
import '../widgets/pilih_kategori.dart';
import '../widgets/pilihan_segmen.dart';
import '../widgets/sheet_bagi_teman.dart';
import '../widgets/sheet_catatan.dart';
import '../widgets/sheet_sumber_dana.dart';
import '../widgets/tampilan_nominal.dart';
import '../widgets/template_nominal.dart';
import '../widgets/tombol_utama.dart';
import 'pengaturan_kategori_screen.dart';

class TambahTransaksiScreen extends StatefulWidget {
  final CatatanTransaksi? transaksiLama;

  const TambahTransaksiScreen({super.key, this.transaksiLama});

  @override
  State<TambahTransaksiScreen> createState() => _TambahTransaksiScreenState();
}

class _TambahTransaksiScreenState extends State<TambahTransaksiScreen> {
  static const List<String> _labelNominal = [
    'Jumlah pengeluaran',
    'Jumlah pemasukan',
    'Jumlah transfer',
  ];

  // 0 = Keluar, 1 = Masuk, 2 = Transfer, sama dengan urutan PilihanSegmen.
  int _tipe = 0;
  KategoriItem? _kategori;
  int _nominal = 0;
  DateTime _tanggal = DateTime.now();
  String _sumber = 'Kantong Utama';
  String _catatan = '';
  List<BagianTeman> _daftarTeman = [];

  bool get _modeUbah => widget.transaksiLama != null;

  @override
  void initState() {
    super.initState();
    final lama = widget.transaksiLama;
    if (lama != null) {
      _tipe = lama.isPemasukan ? 1 : (lama.isTransfer ? 2 : 0);
      _nominal = lama.nominal;
      _tanggal = lama.tanggal;
      _sumber = lama.sumberDana;
      _catatan = lama.catatan;
      for (var k in AppData.kategoriTipe(_tipe)) {
        if (k.nama == lama.kategori) _kategori = k;
      }
    }
    _pastikanKategori();
  }

  // Kategori terpilih bisa tidak cocok lagi setelah ganti tipe atau setelah kategori dihapus.
  void _pastikanKategori() {
    List<KategoriItem> daftar = AppData.kategoriTipe(_tipe);
    if (!daftar.contains(_kategori)) {
      _kategori = daftar.isEmpty ? null : daftar.first;
    }
  }

  List<BagianTeman> _temanTerisi() {
    return _daftarTeman
        .where((t) => t.nama.trim().isNotEmpty && t.nominal > 0)
        .toList();
  }

  int _totalBagian() {
    int total = 0;
    for (var t in _temanTerisi()) {
      total += t.nominal;
    }
    return total;
  }

  // Hanya berlaku saat baris bagi teman tampil, karena tipe lain tidak membuat piutang.
  bool get _bagianMelebihi =>
      _tipe == 0 && !_modeUbah && _totalBagian() > _nominal;

  String _teksBagi() {
    int jumlah = _temanTerisi().length;
    if (jumlah == 0) return 'Tidak';
    return '$jumlah teman · ${formatRupiah(_totalBagian())}';
  }

  Future<void> _bukaPengaturanKategori() async {
    await Navigator.push(
      context,
      buatTransisiHalaman(const PengaturanKategoriScreen()),
    );
    if (!mounted) return;
    setState(_pastikanKategori);
  }

  Future<void> _pilihSumber() async {
    String? hasil = await bukaSumberDana(context, _sumber);
    if (hasil != null) setState(() => _sumber = hasil);
  }

  Future<void> _pilihTanggal() async {
    DateTime? hasil = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (hasil != null) setState(() => _tanggal = hasil);
  }

  Future<void> _ubahCatatan() async {
    String? hasil = await bukaCatatan(context, _catatan);
    if (hasil != null) setState(() => _catatan = hasil);
  }

  Future<void> _bukaBagiTeman() async {
    List<BagianTeman>? hasil = await showModalBottomSheet<List<BagianTeman>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SheetBagiTeman(total: _nominal, awal: _daftarTeman),
    );
    if (hasil != null) setState(() => _daftarTeman = hasil);
  }

  void _simpan() {
    KategoriItem kategori = _kategori!;
    String catatan = _catatan.isEmpty ? kategori.nama : _catatan;
    CatatanTransaksi baru = CatatanTransaksi(
      kategori: kategori.nama,
      catatan: catatan,
      nominal: _nominal,
      ikon: kategori.ikon,
      warna: WarnaApp.primer,
      tanggal: _tanggal,
      isPemasukan: _tipe == 1,
      isTransfer: _tipe == 2,
      sumberDana: _sumber,
    );
    if (_modeUbah) {
      AppData.ubahTransaksi(widget.transaksiLama!, baru);
    } else {
      AppData.tambahTransaksi(baru);
    }

    // Piutang hanya dibuat untuk pengeluaran baru, bukan saat mengubah transaksi.
    List<BagianTeman> piutang = _tipe == 0 && !_modeUbah ? _temanTerisi() : [];
    for (var teman in piutang) {
      AppData.tambahUtang(
        UtangItem(
          jenis: 'Piutang',
          nama: teman.nama.trim(),
          nominal: teman.nominal,
          keterangan: catatan,
          tanggal: _tanggal,
        ),
      );
    }

    // Diambil sebelum pop, karena context halaman ini tidak bisa dipakai setelah ditutup.
    final pesan = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    String teks = piutang.isEmpty
        ? 'Transaksi disimpan'
        : 'Transaksi disimpan, ${piutang.length} piutang dicatat';
    pesan.showSnackBar(SnackBar(content: Text(teks)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.x, size: 20, color: WarnaApp.teksUtama),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(_modeUbah ? 'Ubah Transaksi' : 'Catat Transaksi'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: JarakApp.tepiHalaman,
                vertical: JarakApp.j16,
              ),
              child: _bangunIsian(),
            ),
          ),
          const Divider(height: 1),
          _bangunBawah(),
        ],
      ),
    );
  }

  Widget _bangunIsian() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PilihanSegmen(
          pilihan: const ['Keluar', 'Masuk', 'Transfer'],
          indeksAktif: _tipe,
          onPilih: (i) => setState(() {
            _tipe = i;
            _pastikanKategori();
          }),
        ),
        const SizedBox(height: JarakApp.j24),
        TampilanNominal(label: _labelNominal[_tipe], nominal: _nominal),
        const SizedBox(height: JarakApp.j12),
        TemplateNominal(
          onTambah: (n) =>
              setState(() => _nominal = tambahNominal(_nominal, n)),
          onReset: () => setState(() => _nominal = 0),
        ),
        const SizedBox(height: JarakApp.j24),
        PilihKategori(
          daftar: AppData.kategoriTipe(_tipe),
          terpilih: _kategori,
          onPilih: (k) => setState(() => _kategori = k),
          onTambahBaru: _bukaPengaturanKategori,
        ),
        const SizedBox(height: JarakApp.j16),
        BarisIsian(
          ikon: LucideIcons.wallet,
          label: 'Sumber dana',
          nilai: '$_sumber · ${formatRupiah(AppData.saldoSumber(_sumber))}',
          onTekan: _pilihSumber,
        ),
        const Divider(height: 1),
        BarisIsian(
          ikon: LucideIcons.calendar,
          label: 'Tanggal',
          nilai: formatTanggal(_tanggal),
          onTekan: _pilihTanggal,
        ),
        const Divider(height: 1),
        BarisIsian(
          ikon: LucideIcons.notebookPen,
          label: 'Catatan',
          nilai: _catatan.isEmpty ? 'Tambah catatan' : _catatan,
          warnaNilai: _catatan.isEmpty ? WarnaApp.teksRedup : null,
          onTekan: _ubahCatatan,
        ),
        if (_tipe == 0 && !_modeUbah) ...[
          const Divider(height: 1),
          BarisIsian(
            ikon: LucideIcons.users,
            label: 'Bagi dengan teman',
            nilai: _teksBagi(),
            warnaNilai: _bagianMelebihi ? WarnaApp.bahaya : null,
            onTekan: _bukaBagiTeman,
          ),
        ],
      ],
    );
  }

  Widget _bangunBawah() {
    bool bisaSimpan = _nominal > 0 && _kategori != null && !_bagianMelebihi;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: JarakApp.tepiHalaman,
          vertical: JarakApp.j8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Numpad(
              onAngka: (a) =>
                  setState(() => _nominal = tambahDigit(_nominal, a)),
              onHapus: () => setState(() => _nominal = hapusDigit(_nominal)),
            ),
            const SizedBox(height: JarakApp.j8),
            TombolUtama(teks: 'Simpan', onTekan: bisaSimpan ? _simpan : null),
          ],
        ),
      ),
    );
  }
}
