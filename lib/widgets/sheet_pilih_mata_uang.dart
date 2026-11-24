import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../models/mata_uang.dart';
import '../theme/app_theme.dart';
import 'daftar_mata_uang.dart';
import 'header_sheet.dart';
import 'tombol_utama.dart';

// Satu pilihan, dipakai Hitung kurs dan form Impian. Mengembalikan kode, atau null kalau ditutup.
Future<String?> bukaPilihMataUang(
  BuildContext context,
  String terpilih, {
  bool denganRupiah = false,
}) {
  return showModalBottomSheet<String>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (context) =>
        SheetPilihMataUang(terpilih: [terpilih], denganRupiah: denganRupiah),
  );
}

// Pilih banyak untuk kartu Kurs di Beranda. Mengembalikan daftar kode yang dicentang.
Future<List<String>?> bukaAturFavorit(BuildContext context) {
  return showModalBottomSheet<List<String>>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (context) =>
        SheetPilihMataUang(terpilih: AppData.mataUangFavorit, banyak: true),
  );
}

class SheetPilihMataUang extends StatefulWidget {
  final List<String> terpilih;
  final bool banyak;
  final bool denganRupiah;

  const SheetPilihMataUang({
    super.key,
    required this.terpilih,
    this.banyak = false,
    this.denganRupiah = false,
  });

  @override
  State<SheetPilihMataUang> createState() => _SheetPilihMataUangState();
}

class _SheetPilihMataUangState extends State<SheetPilihMataUang> {
  static const int _batasFavorit = 4;
  late final List<String> _pilihan = List.of(widget.terpilih);
  String _kataKunci = '';

  // Mode banyak: centang dibatasi 4, sama dengan jumlah baris di kartu Kurs.
  VoidCallback? _aksi(String kode) {
    if (!widget.banyak) return () => Navigator.pop(context, kode);
    if (_pilihan.contains(kode)) {
      return () => setState(() => _pilihan.remove(kode));
    }
    if (_pilihan.length >= _batasFavorit) return null;
    return () => setState(() => _pilihan.add(kode));
  }

  // Urutan mengikuti daftarMataUang, bukan urutan saat dicentang.
  void _simpan() {
    Navigator.pop(context, [
      for (MataUang m in AppData.daftarMataUang)
        if (_pilihan.contains(m.kode)) m.kode,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // Ruang keyboard dikurangi supaya daftar dan tombol Simpan tidak tertutup.
    double keyboard = MediaQuery.viewInsetsOf(context).bottom;
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.9,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          JarakApp.tepiHalaman,
          JarakApp.j8,
          JarakApp.tepiHalaman,
          JarakApp.j16 + keyboard,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const HeaderSheet(judul: 'Pilih mata uang'),
            if (widget.banyak)
              const Text(
                'Pilih 1 sampai 4 mata uang untuk kartu Kurs di Beranda.',
                style: TeksApp.kecil,
              ),
            const SizedBox(height: JarakApp.j12),
            TextField(
              onChanged: (v) => setState(() => _kataKunci = v),
              decoration: const InputDecoration(
                hintText: 'Cari kode atau nama',
                prefixIcon: Icon(
                  LucideIcons.search,
                  size: 18,
                  color: WarnaApp.teksRedup,
                ),
              ),
            ),
            Expanded(
              child: DaftarMataUang(
                kataKunci: _kataKunci,
                banyak: widget.banyak,
                denganRupiah: widget.denganRupiah,
                terpilih: _pilihan,
                aksi: _aksi,
              ),
            ),
            if (widget.banyak) ...[
              const SizedBox(height: JarakApp.j12),
              TombolUtama(
                teks: 'Simpan',
                onTekan: _pilihan.isEmpty ? null : _simpan,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
