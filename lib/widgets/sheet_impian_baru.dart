import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../models/kategori.dart';
import '../theme/app_theme.dart';
import 'grid_kategori.dart';
import 'header_sheet.dart';
import 'isian_impian.dart';

Future<void> bukaSheetImpianBaru(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (context) => const SheetImpianBaru(),
  );
}

// Dua langkah: pilih kategori impian, lalu isi harga dan nama.
class SheetImpianBaru extends StatefulWidget {
  const SheetImpianBaru({super.key});

  @override
  State<SheetImpianBaru> createState() => _SheetImpianBaruState();
}

class _SheetImpianBaruState extends State<SheetImpianBaru> {
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

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: SafeArea(
        // IndexedStack menjaga isian tetap ada saat pengguna kembali mengganti kategori.
        child: IndexedStack(
          index: _diIsian ? 1 : 0,
          children: [
            _bangunLangkahKategori(),
            if (kategori != null)
              IsianImpian(
                kategori: kategori,
                onGanti: () => setState(() => _diIsian = false),
              ),
          ],
        ),
      ),
    );
  }

  Widget _bangunLangkahKategori() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(
            JarakApp.tepiHalaman,
            JarakApp.j8,
            JarakApp.tepiHalaman,
            0,
          ),
          child: HeaderSheet(judul: 'Impian baru'),
        ),
        Expanded(
          child: GridKategori(
            daftar: AppData.kategoriImpian,
            terpilih: _kategori,
            onPilih: _pilihKategori,
          ),
        ),
      ],
    );
  }
}
