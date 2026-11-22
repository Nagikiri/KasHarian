import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../models/wishlist.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/format_ribuan.dart';
import 'grid_pilih_ikon.dart';
import 'pilihan_segmen.dart';
import 'tombol_utama.dart';

Future<void> bukaSheetImpianBaru(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => const SheetImpianBaru(),
  );
}

class SheetImpianBaru extends StatefulWidget {
  const SheetImpianBaru({super.key});

  @override
  State<SheetImpianBaru> createState() => _SheetImpianBaruState();
}

class _SheetImpianBaruState extends State<SheetImpianBaru> {
  final TextEditingController _namaCtrl = TextEditingController();
  final TextEditingController _hargaCtrl = TextEditingController();
  final List<String> _daftarMataUang = AppData.kursKeIdr.keys.toList();
  int _mataUang = 0;
  IconData _ikon = LucideIcons.star;

  @override
  void dispose() {
    _namaCtrl.dispose();
    _hargaCtrl.dispose();
    super.dispose();
  }

  String get _kode => _daftarMataUang[_mataUang];

  int get _harga => bacaAngka(_hargaCtrl.text);

  void _simpan() {
    AppData.tambahWishlist(
      WishlistItem(
        nama: _namaCtrl.text.trim(),
        mataUang: _kode,
        hargaAsing: _harga,
        targetIdr: AppData.targetDariKurs(_kode, _harga),
        terkumpulIdr: 0,
        ikon: _ikon,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    bool bisaSimpan = _namaCtrl.text.trim().isNotEmpty && _harga > 0;

    // Bisa di-scroll karena grid ikon membuat sheet tinggi, apalagi saat keyboard terbuka.
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        JarakApp.tepiHalaman,
        JarakApp.j24,
        JarakApp.tepiHalaman,
        JarakApp.j24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Impian baru', style: TeksApp.judulSeksi),
          const SizedBox(height: JarakApp.j16),
          TextField(
            controller: _namaCtrl,
            decoration: const InputDecoration(hintText: 'Nama impian'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: JarakApp.j12),
          PilihanSegmen(
            pilihan: _daftarMataUang,
            indeksAktif: _mataUang,
            onPilih: (i) => setState(() => _mataUang = i),
          ),
          const SizedBox(height: JarakApp.j12),
          TextField(
            controller: _hargaCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FormatRibuan()],
            decoration: InputDecoration(
              hintText: 'Harga',
              prefixText: '$_kode ',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: JarakApp.j8),
          Text(
            '≈ ${formatRupiah(AppData.targetDariKurs(_kode, _harga))}',
            style: TeksApp.kecil,
          ),
          const SizedBox(height: JarakApp.j16),
          const Text('Ikon', style: TeksApp.kecil),
          const SizedBox(height: JarakApp.j8),
          GridPilihIkon(
            daftarIkon: AppData.opsiIkonImpian,
            terpilih: _ikon,
            onPilih: (ikon) => setState(() => _ikon = ikon),
          ),
          const SizedBox(height: JarakApp.j24),
          TombolUtama(teks: 'Simpan', onTekan: bisaSimpan ? _simpan : null),
        ],
      ),
    );
  }
}
