import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../models/kategori.dart';
import '../models/wishlist.dart';
import '../theme/app_theme.dart';
import '../utils/nominal.dart';
import 'baris_isian.dart';
import 'harga_impian.dart';
import 'header_sheet.dart';
import 'numpad_simpan.dart';
import 'sheet_catatan.dart';
import 'sheet_pilih_mata_uang.dart';

// Langkah kedua sheet impian baru: harga valas lewat numpad dan nama lewat sheet teks.
class IsianImpian extends StatefulWidget {
  final KategoriItem kategori;
  final VoidCallback onGanti;

  const IsianImpian({super.key, required this.kategori, required this.onGanti});

  @override
  State<IsianImpian> createState() => _IsianImpianState();
}

class _IsianImpianState extends State<IsianImpian> {
  String _kode = 'IDR';
  int _harga = 0;
  String _nama = '';

  // Mata uang tanpa kurs boleh dipilih, tapi impiannya belum bisa disimpan.
  bool get _adaKurs => AppData.kursAda(_kode);

  // Angka lama tidak berarti di mata uang lain, jadi harga diulang dari 0.
  Future<void> _pilihMataUang() async {
    String? hasil = await bukaPilihMataUang(context, _kode, denganRupiah: true);
    if (hasil == null || !mounted) return;
    setState(() {
      _kode = hasil;
      _harga = 0;
    });
  }

  Future<void> _ubahNama() async {
    String? hasil = await bukaCatatan(
      context,
      _nama,
      judul: 'Nama impian',
      petunjuk: 'Tulis nama impian',
    );
    if (hasil == null || !mounted) return;
    setState(() => _nama = hasil);
  }

  void _simpan() {
    AppData.tambahWishlist(
      WishlistItem(
        nama: _nama,
        kategori: widget.kategori.nama,
        mataUang: _kode,
        hargaAsing: _harga,
        targetIdr: AppData.targetDariKurs(_kode, _harga),
        terkumpulIdr: 0,
        ikon: widget.kategori.ikon,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        JarakApp.tepiHalaman,
        JarakApp.j8,
        JarakApp.tepiHalaman,
        JarakApp.j16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeaderSheet(
            judul: widget.kategori.nama,
            ikon: widget.kategori.ikon,
            ujung: TextButton(
              onPressed: widget.onGanti,
              child: Text(
                'Ganti',
                style: TeksApp.tombolKecil.copyWith(color: WarnaApp.primer),
              ),
            ),
          ),
          const SizedBox(height: JarakApp.j16),
          BarisIsian(
            ikon: LucideIcons.coins,
            label: 'Mata uang',
            nilai: '$_kode · ${AppData.cariMataUang(_kode).nama}',
            onTekan: _pilihMataUang,
          ),
          const SizedBox(height: JarakApp.j8),
          HargaImpian(
            kode: _kode,
            harga: _harga,
            onTambah: (n) => setState(() => _harga = tambahNominal(_harga, n)),
            onKosongkan: () => setState(() => _harga = 0),
          ),
          const SizedBox(height: JarakApp.j8),
          BarisIsian(
            ikon: LucideIcons.pencilLine,
            label: 'Nama impian',
            nilai: _nama.isEmpty ? 'Belum diisi' : _nama,
            warnaNilai: _nama.isEmpty ? WarnaApp.teksRedup : null,
            onTekan: _ubahNama,
          ),
          const Spacer(),
          NumpadSimpan(
            onAngka: (a) => setState(() => _harga = tambahDigit(_harga, a)),
            onHapus: () => setState(() => _harga = hapusDigit(_harga)),
            onSimpan: _nama.isNotEmpty && _harga > 0 && _adaKurs
                ? _simpan
                : null,
          ),
        ],
      ),
    );
  }
}
