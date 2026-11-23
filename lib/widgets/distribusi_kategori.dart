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

    // Satu peta untuk donat, legenda, dan daftar, supaya warna di satu layar selalu cocok.
    Map<String, Color> petaWarna = _hitungPetaWarna(besar);
    // Kategori yang tidak masuk 5 besar ikut potongan abu di donat.
    Color warnaKategori(String nama) => petaWarna[nama] ?? palet.last;

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

  Map<String, Color> _hitungPetaWarna(List<String> besar) {
    Map<String, Color> peta = {};
    Set<int> terpakai = {};
    Map<String, int> warnaAnggaran = AppData.petaWarnaAnggaran();
    for (String nama in besar) {
      // Kategori yang punya anggaran memakai warna kartu Kantong-nya, supaya cocok antar-halaman.
      int indeks = warnaAnggaran[nama] ?? AppData.indeksWarnaKategori(nama);
      // Warna kembar, atau abu milik potongan Lainnya, diganti warna palet pertama yang belum dipakai.
      if (indeks == 7 || terpakai.contains(indeks)) {
        indeks = 0;
        while (terpakai.contains(indeks)) {
          indeks++;
        }
      }
      terpakai.add(indeks);
      peta[nama] = WarnaApp.paletKategori[indeks];
    }
    return peta;
  }
}
