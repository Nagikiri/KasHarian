import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../theme/app_theme.dart';
import 'baris_distribusi.dart';
import 'donat_kategori.dart';
import 'tampilan_kosong.dart';

class DistribusiKategori extends StatelessWidget {
  // Sudah terurut dari yang terbesar (hasil AppData.pengeluaranPerKategori).
  final Map<String, int> perKategori;

  const DistribusiKategori({super.key, required this.perKategori});

  @override
  Widget build(BuildContext context) {
    if (perKategori.isEmpty) {
      return const TampilanKosong(
        ikon: LucideIcons.chartPie,
        judul: 'Belum ada pengeluaran',
        kalimat: 'Tidak ada pengeluaran di periode ini.',
      );
    }

    List<Color> palet = WarnaApp.paletKategori;
    int total = perKategori.values.fold(0, (jumlah, n) => jumlah + n);
    // Kategori asli "Lainnya" selalu masuk potongan abu, supaya legenda tidak punya dua "Lainnya".
    List<String> besar = perKategori.keys
        .where((nama) => nama != 'Lainnya')
        .take(5)
        .toList();
    int sisa = total;
    for (String nama in besar) {
      sisa -= perKategori[nama]!;
    }

    Color warnaKategori(String nama) {
      int posisi = besar.indexOf(nama);
      return posisi == -1 ? palet.last : palet[posisi];
    }

    List<String> daftarNama = perKategori.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DonatKategori(
          daftarNama: [...besar, if (sisa > 0) 'Lainnya'],
          daftarNilai: [
            for (String nama in besar) perKategori[nama]!,
            if (sisa > 0) sisa,
          ],
          daftarWarna: [
            for (String nama in besar) warnaKategori(nama),
            if (sisa > 0) palet.last,
          ],
          total: total,
        ),
        const SizedBox(height: JarakApp.j8),
        for (int i = 0; i < daftarNama.length; i++) ...[
          if (i > 0) const Divider(height: 1),
          BarisDistribusi(
            ikon: AppData.ikonKategori(daftarNama[i]),
            nama: daftarNama[i],
            nominal: perKategori[daftarNama[i]]!,
            persen: perKategori[daftarNama[i]]! / total,
            warna: warnaKategori(daftarNama[i]),
          ),
        ],
      ],
    );
  }
}
