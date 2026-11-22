import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../models/bagian_teman.dart';
import '../models/kategori.dart';
import '../models/transaksi.dart';
import '../models/utang.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/nominal.dart';
import '../widgets/baris_isian.dart';
import '../widgets/baris_kategori.dart';
import '../widgets/baris_dompet.dart';
import '../widgets/numpad_simpan.dart';
import '../widgets/pilihan_segmen.dart';
import '../widgets/sheet_bagi_teman.dart';
import '../widgets/sheet_catatan.dart';
import '../widgets/sheet_pilih_kategori.dart';
import '../widgets/sheet_sumber_dana.dart';
import '../widgets/tampilan_nominal.dart';
import '../widgets/template_nominal.dart';

class TambahTransaksiScreen extends StatefulWidget {
  final CatatanTransaksi? transaksiLama;

  const TambahTransaksiScreen({super.key, this.transaksiLama});

  @override
  State<TambahTransaksiScreen> createState() => _TambahTransaksiScreenState();
}

class _TambahTransaksiScreenState extends State<TambahTransaksiScreen> {
  static const List<String> _jenis = ['pengeluaran', 'pemasukan', 'transfer'];

  // 0 = Pengeluaran, 1 = Pemasukan, 2 = Transfer, sama dengan urutan PilihanSegmen.
  int _tipe = 0;
  KategoriItem? _kategori;
  int _nominal = 0;
  DateTime _tanggal = DateTime.now();
  // Untuk transfer, _sumber adalah dompet "Dari" dan _tujuan dompet "Ke".
  String _sumber = 'Kantong Utama';
  String _tujuan = 'Tabungan';
  String _catatan = '';
  List<BagianTeman> _daftarTeman = [];

  bool get _modeUbah => widget.transaksiLama != null;
  bool get _transfer => _tipe == 2;
  bool get _bisaBagi => _tipe == 0 && !_modeUbah;

  @override
  void initState() {
    super.initState();
    final lama = widget.transaksiLama;
    if (lama == null) {
      _pilihKategoriAwal();
      return;
    }
    _tipe = lama.isTransfer ? 2 : (lama.isPemasukan ? 1 : 0);
    _nominal = lama.nominal;
    _tanggal = lama.tanggal;
    _sumber = lama.sumberDana;
    _tujuan = lama.sumberTujuan ?? 'Tabungan';
    _catatan = lama.catatan;
    for (var k in AppData.kategoriTipe(_tipe)) {
      if (k.nama == lama.kategori) _kategori = k;
    }
  }

  void _pilihKategoriAwal() {
    List<KategoriItem> sering = AppData.kategoriSering(_tipe == 1, 4);
    _kategori = _transfer || sering.isEmpty ? null : sering.first;
  }

  bool get _bagianMelebihi =>
      _bisaBagi && totalBagian(temanTerisi(_daftarTeman)) > _nominal;

  void _gantiTipe(int tipe) {
    setState(() {
      _tipe = tipe;
      _pilihKategoriAwal();
      // Dompet yang dipilih sebelumnya bisa sama dengan tujuan bawaan transfer.
      if (_sumber == _tujuan) {
        _tujuan = _sumber == 'Tabungan' ? 'Kantong Utama' : 'Tabungan';
      }
    });
  }

  void _ubahNominal(int nilai) => setState(() => _nominal = nilai);

  Future<void> _bukaLainnya() async {
    KategoriItem? hasil = await bukaPilihKategori(
      context,
      pemasukan: _tipe == 1,
      terpilih: _kategori,
    );
    if (!mounted) return;
    setState(() {
      if (hasil != null) _kategori = hasil;
      // Kategori terpilih bisa saja dihapus lewat "Atur" di dalam sheet.
      if (!AppData.daftarKategori.contains(_kategori)) _pilihKategoriAwal();
    });
  }

  Future<void> _pilihDompet({required bool tujuan}) async {
    String? hasil = await bukaSumberDana(
      context,
      tujuan ? _tujuan : _sumber,
      judul: !_transfer ? 'Sumber dana' : (tujuan ? 'Ke' : 'Dari'),
      kecuali: !_transfer ? null : (tujuan ? _sumber : _tujuan),
    );
    if (hasil == null) return;
    setState(() {
      if (tujuan) {
        _tujuan = hasil;
      } else {
        _sumber = hasil;
      }
    });
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
    String nama = _transfer ? 'Transfer' : _kategori!.nama;
    String bawaan = _transfer ? '$_sumber → $_tujuan' : nama;
    String catatan = _catatan.isEmpty ? bawaan : _catatan;
    CatatanTransaksi baru = CatatanTransaksi(
      kategori: nama,
      catatan: catatan,
      nominal: _nominal,
      ikon: _transfer ? LucideIcons.arrowLeftRight : _kategori!.ikon,
      tanggal: _tanggal,
      isPemasukan: _tipe == 1,
      isTransfer: _transfer,
      sumberDana: _sumber,
      sumberTujuan: _transfer ? _tujuan : null,
    );
    if (_modeUbah) {
      AppData.ubahTransaksi(widget.transaksiLama!, baru);
    } else {
      AppData.tambahTransaksi(baru);
    }

    List<BagianTeman> piutang = _bisaBagi ? temanTerisi(_daftarTeman) : [];
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
    bool bisaSimpan =
        _nominal > 0 && !_bagianMelebihi && (_transfer || _kategori != null);

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
                vertical: JarakApp.j8,
              ),
              child: _bangunIsian(),
            ),
          ),
          const Divider(height: 1),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: JarakApp.tepiHalaman,
                vertical: JarakApp.j8,
              ),
              child: NumpadSimpan(
                onAngka: (a) => _ubahNominal(tambahDigit(_nominal, a)),
                onHapus: () => _ubahNominal(hapusDigit(_nominal)),
                onSimpan: bisaSimpan ? _simpan : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bangunIsian() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PilihanSegmen(
          pilihan: const ['Pengeluaran', 'Pemasukan', 'Transfer'],
          indeksAktif: _tipe,
          onPilih: _gantiTipe,
        ),
        const SizedBox(height: JarakApp.j24),
        TampilanNominal(label: 'Jumlah ${_jenis[_tipe]}', nominal: _nominal),
        const SizedBox(height: JarakApp.j12),
        TemplateNominal(
          onTambah: (n) => _ubahNominal(tambahNominal(_nominal, n)),
          onReset: () => _ubahNominal(0),
        ),
        const SizedBox(height: JarakApp.j24),
        _transfer
            ? BarisDompet(
                sumber: _sumber,
                tujuan: _tujuan,
                onDari: () => _pilihDompet(tujuan: false),
                onKe: () => _pilihDompet(tujuan: true),
              )
            : BarisKategori(
                daftar: AppData.kategoriSering(_tipe == 1, 4),
                terpilih: _kategori,
                onPilih: (k) => setState(() => _kategori = k),
                onLainnya: _bukaLainnya,
              ),
        const SizedBox(height: JarakApp.j16),
        if (!_transfer) ...[
          BarisIsian(
            ikon: LucideIcons.wallet,
            label: 'Sumber dana',
            nilai: '$_sumber · ${formatRupiah(AppData.saldoSumber(_sumber))}',
            onTekan: () => _pilihDompet(tujuan: false),
          ),
          const Divider(height: 1),
        ],
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
        if (_bisaBagi) ...[
          const Divider(height: 1),
          BarisIsian(
            ikon: LucideIcons.users,
            label: 'Bagi dengan teman',
            nilai: ringkasanBagian(_daftarTeman),
            warnaNilai: _bagianMelebihi ? WarnaApp.bahaya : null,
            onTekan: _bukaBagiTeman,
          ),
        ],
      ],
    );
  }
}
