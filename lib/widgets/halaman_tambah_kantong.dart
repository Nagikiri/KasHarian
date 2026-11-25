import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../models/budget.dart';
import '../models/kategori.dart';
import '../screens/pengaturan_kategori_screen.dart';
import '../theme/app_theme.dart';
import 'grid_kategori.dart';
import 'halaman_form.dart';
import 'halaman_input_nominal.dart';

Future<void> bukaTambahBudget(BuildContext context) {
  return Navigator.push(
    context,
    buatTransisiHalaman(const HalamanTambahKantong()),
  );
}

// Dua langkah: pilih kategori di sini, lalu halaman ini diganti halaman isi limit.
class HalamanTambahKantong extends StatefulWidget {
  const HalamanTambahKantong({super.key});

  @override
  State<HalamanTambahKantong> createState() => _HalamanTambahKantongState();
}

class _HalamanTambahKantongState extends State<HalamanTambahKantong> {
  bool _sudahAda(String nama) {
    return AppData.daftarBudget.any((b) => b.kategori == nama);
  }

  List<KategoriItem> _kategoriTersedia() {
    List<KategoriItem> hasil = [
      for (var k in AppData.kategoriTipe(0))
        if (!_sudahAda(k.nama)) k,
    ];
    // Tabungan bukan kategori, jadi ditambahkan sebagai pilihan sendiri.
    if (!_sudahAda('Tabungan')) {
      hasil.add(
        KategoriItem(
          nama: 'Tabungan',
          ikon: LucideIcons.piggyBank,
          indeksWarna: AppData.indeksWarnaTabungan,
        ),
      );
    }
    return hasil;
  }

  Future<void> _bukaPengaturanKategori() async {
    await Navigator.push(
      context,
      buatTransisiHalaman(const PengaturanKategoriScreen()),
    );
    if (!mounted) return;
    setState(() {});
  }

  // pushReplacement supaya tombol X di halaman limit langsung kembali ke halaman asal.
  void _pilih(KategoriItem kategori) {
    Navigator.pushReplacement(
      context,
      buatTransisiHalaman(
        HalamanInputNominal(
          judul: 'Limit ${kategori.nama} per bulan',
          ikon: kategori.ikon,
          onSimpan: (limit) => AppData.tambahBudget(
            BudgetItem(kategori: kategori.nama, limit: limit),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<KategoriItem> pilihan = _kategoriTersedia();

    return HalamanForm(
      judul: 'Tambah kantong',
      isi: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (pilihan.isEmpty)
            const Padding(
              padding: EdgeInsets.fromLTRB(
                JarakApp.tepiHalaman,
                JarakApp.j12,
                JarakApp.tepiHalaman,
                0,
              ),
              child: Text(
                'Semua kategori sudah punya kantong',
                style: TeksApp.kecil,
              ),
            ),
          Expanded(
            child: GridKategori(
              daftar: pilihan,
              terpilih: null,
              onPilih: _pilih,
              onAtur: _bukaPengaturanKategori,
            ),
          ),
        ],
      ),
    );
  }
}
