import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../models/mata_uang.dart';
import '../theme/app_theme.dart';
import 'daftar_mata_uang.dart';
import 'halaman_form.dart';
import 'tombol_utama.dart';

// Satu pilihan, dipakai Hitung kurs dan form Impian. Mengembalikan kode, atau null kalau ditutup.
Future<String?> bukaPilihMataUang(
  BuildContext context,
  String terpilih, {
  bool denganRupiah = false,
}) async {
  // Disimpan ke var dulu karena buatTransisiHalaman tidak membawa tipe hasil.
  var hasil = await Navigator.push(
    context,
    buatTransisiHalaman(
      HalamanPilihMataUang(terpilih: [terpilih], denganRupiah: denganRupiah),
    ),
  );
  return hasil;
}

// Pilih banyak untuk kartu Kurs di Beranda. Mengembalikan daftar kode yang dicentang.
Future<List<String>?> bukaAturFavorit(BuildContext context) async {
  var hasil = await Navigator.push(
    context,
    buatTransisiHalaman(
      HalamanPilihMataUang(terpilih: AppData.mataUangFavorit, banyak: true),
    ),
  );
  return hasil;
}

class HalamanPilihMataUang extends StatefulWidget {
  final List<String> terpilih;
  final bool banyak;
  final bool denganRupiah;

  const HalamanPilihMataUang({
    super.key,
    required this.terpilih,
    this.banyak = false,
    this.denganRupiah = false,
  });

  @override
  State<HalamanPilihMataUang> createState() => _HalamanPilihMataUangState();
}

class _HalamanPilihMataUangState extends State<HalamanPilihMataUang> {
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
    return HalamanForm(
      judul: 'Pilih mata uang',
      isi: Padding(
        padding: const EdgeInsets.fromLTRB(
          JarakApp.tepiHalaman,
          JarakApp.j8,
          JarakApp.tepiHalaman,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.banyak) ...[
              const Text(
                'Pilih 1 sampai 4 mata uang untuk kartu Kurs di Beranda.',
                style: TeksApp.kecil,
              ),
              const SizedBox(height: JarakApp.j12),
            ],
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
          ],
        ),
      ),
      bawah: widget.banyak
          ? TombolUtama(
              teks: 'Simpan',
              onTekan: _pilihan.isEmpty ? null : _simpan,
            )
          : null,
    );
  }
}
