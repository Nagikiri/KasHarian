import 'package:flutter/material.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../models/kategori.dart';
import '../screens/pengaturan_kategori_screen.dart';
import 'grid_kategori.dart';
import 'halaman_form.dart';

// Grid lengkap dari tile "Lainnya". Mengembalikan kategori yang dipilih, atau null kalau ditutup.
Future<KategoriItem?> bukaPilihKategori(
  BuildContext context, {
  required bool pemasukan,
  required KategoriItem? terpilih,
}) async {
  // Disimpan ke var dulu karena buatTransisiHalaman tidak membawa tipe hasil.
  var hasil = await Navigator.push(
    context,
    buatTransisiHalaman(
      HalamanPilihKategori(pemasukan: pemasukan, terpilih: terpilih),
    ),
  );
  return hasil;
}

class HalamanPilihKategori extends StatefulWidget {
  final bool pemasukan;
  final KategoriItem? terpilih;

  const HalamanPilihKategori({
    super.key,
    required this.pemasukan,
    required this.terpilih,
  });

  @override
  State<HalamanPilihKategori> createState() => _HalamanPilihKategoriState();
}

class _HalamanPilihKategoriState extends State<HalamanPilihKategori> {
  Future<void> _bukaPengaturanKategori() async {
    await Navigator.push(
      context,
      buatTransisiHalaman(const PengaturanKategoriScreen()),
    );
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return HalamanForm(
      judul: 'Pilih kategori',
      isi: GridKategori(
        daftar: AppData.kategoriTipe(widget.pemasukan ? 1 : 0),
        terpilih: widget.terpilih,
        onPilih: (k) => Navigator.pop(context, k),
        onAtur: _bukaPengaturanKategori,
      ),
    );
  }
}
