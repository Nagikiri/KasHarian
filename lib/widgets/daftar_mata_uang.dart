import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../models/mata_uang.dart';
import '../theme/app_theme.dart';
import 'baris_mata_uang.dart';
import 'tampilan_kosong.dart';

// Isi halaman pemilih mata uang: hasil pencarian, dengan bagian Favorit di atas kalau perlu.
class DaftarMataUang extends StatelessWidget {
  final String kataKunci;
  final bool banyak;
  final bool denganRupiah;
  final List<String> terpilih;
  final VoidCallback? Function(String kode) aksi;

  const DaftarMataUang({
    super.key,
    required this.kataKunci,
    required this.banyak,
    required this.denganRupiah,
    required this.terpilih,
    required this.aksi,
  });

  bool _cocok(MataUang m) {
    String kunci = kataKunci.toLowerCase();
    return m.kode.toLowerCase().contains(kunci) ||
        m.nama.toLowerCase().contains(kunci);
  }

  @override
  Widget build(BuildContext context) {
    List<MataUang> hasil = [
      if (denganRupiah) AppData.rupiah,
      ...AppData.daftarMataUang,
    ].where(_cocok).toList();
    if (hasil.isEmpty) {
      return const TampilanKosong(
        ikon: LucideIcons.search,
        judul: 'Mata uang tidak ditemukan',
        kalimat: 'Coba cari dengan kode atau nama lain.',
      );
    }
    // Bagian Favorit hanya di mode satu pilihan dan saat tidak sedang mencari.
    bool pakaiFavorit = !banyak && kataKunci.isEmpty;
    return ListView(
      children: [
        if (pakaiFavorit) ...[
          _bangunLabel('Favorit'),
          if (denganRupiah) _bangunBaris(AppData.rupiah),
          for (String kode in AppData.mataUangFavorit)
            _bangunBaris(AppData.cariMataUang(kode)),
          _bangunLabel('Semua'),
        ],
        for (MataUang m in hasil) _bangunBaris(m),
      ],
    );
  }

  Widget _bangunLabel(String teks) => Padding(
    padding: const EdgeInsets.only(top: JarakApp.j16, bottom: JarakApp.j4),
    child: Text(teks, style: TeksApp.kecil),
  );

  Widget _bangunBaris(MataUang m) => BarisMataUang(
    mataUang: m,
    terpilih: terpilih.contains(m.kode),
    onTekan: aksi(m.kode),
  );
}
