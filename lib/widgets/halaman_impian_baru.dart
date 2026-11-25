import 'package:flutter/material.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../models/kategori.dart';
import 'grid_kategori.dart';
import 'halaman_form.dart';
import 'isian_impian.dart';

Future<void> bukaSheetImpianBaru(BuildContext context) {
  return Navigator.push(
    context,
    buatTransisiHalaman(const HalamanImpianBaru()),
  );
}

// Dua langkah: pilih kategori impian, lalu isi harga dan nama.
class HalamanImpianBaru extends StatefulWidget {
  const HalamanImpianBaru({super.key});

  @override
  State<HalamanImpianBaru> createState() => _HalamanImpianBaruState();
}

class _HalamanImpianBaruState extends State<HalamanImpianBaru> {
  KategoriItem? _kategori;
  bool _diIsian = false;

  void _pilihKategori(KategoriItem kategori) {
    setState(() {
      _kategori = kategori;
      _diIsian = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    KategoriItem? kategori = _kategori;

    // IndexedStack menjaga isian tetap ada saat pengguna kembali mengganti kategori.
    return IndexedStack(
      index: _diIsian ? 1 : 0,
      children: [
        HalamanForm(
          judul: 'Impian baru',
          isi: GridKategori(
            daftar: AppData.kategoriImpian,
            terpilih: _kategori,
            onPilih: _pilihKategori,
          ),
        ),
        if (kategori != null)
          IsianImpian(
            kategori: kategori,
            onGanti: () => setState(() => _diIsian = false),
          ),
      ],
    );
  }
}
