import 'package:flutter/material.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../models/kategori.dart';
import '../screens/pengaturan_kategori_screen.dart';
import '../theme/app_theme.dart';
import 'grid_kategori.dart';

// Grid lengkap dari tile "Lainnya". Mengembalikan kategori yang dipilih, atau null kalau ditutup.
Future<KategoriItem?> bukaPilihKategori(
  BuildContext context, {
  required bool pemasukan,
  required KategoriItem? terpilih,
}) {
  return showModalBottomSheet<KategoriItem>(
    context: context,
    isScrollControlled: true,
    builder: (context) =>
        SheetPilihKategori(pemasukan: pemasukan, terpilih: terpilih),
  );
}

class SheetPilihKategori extends StatefulWidget {
  final bool pemasukan;
  final KategoriItem? terpilih;

  const SheetPilihKategori({
    super.key,
    required this.pemasukan,
    required this.terpilih,
  });

  @override
  State<SheetPilihKategori> createState() => _SheetPilihKategoriState();
}

class _SheetPilihKategoriState extends State<SheetPilihKategori> {
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
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                JarakApp.tepiHalaman,
                JarakApp.j24,
                JarakApp.tepiHalaman,
                0,
              ),
              child: Text('Pilih kategori', style: TeksApp.judulSeksi),
            ),
            Expanded(
              child: GridKategori(
                daftar: AppData.kategoriTipe(widget.pemasukan ? 1 : 0),
                terpilih: widget.terpilih,
                onPilih: (k) => Navigator.pop(context, k),
                onAtur: _bukaPengaturanKategori,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
