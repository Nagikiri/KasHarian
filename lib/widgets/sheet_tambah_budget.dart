import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/app_data.dart';
import '../models/budget.dart';
import '../theme/app_theme.dart';
import 'tombol_pill.dart';
import 'tombol_utama.dart';

class SheetTambahBudget extends StatefulWidget {
  const SheetTambahBudget({super.key});

  @override
  State<SheetTambahBudget> createState() => _SheetTambahBudgetState();
}

class _SheetTambahBudgetState extends State<SheetTambahBudget> {
  String? _kategori;
  int _limit = 0;

  // Yang boleh diberi budget: kategori pengeluaran dan 'Setor Tabungan' yang belum punya budget.
  List<String> _kategoriTersedia() {
    List<String> hasil = [];
    for (var k in AppData.daftarKategori) {
      bool pengeluaran = !k.isPemasukan && !k.isTransfer;
      bool boleh = pengeluaran || k.nama == 'Setor Tabungan';
      bool sudahAda = AppData.daftarBudget.any((b) => b.kategori == k.nama);
      if (boleh && !sudahAda) hasil.add(k.nama);
    }
    return hasil;
  }

  void _simpan() {
    AppData.tambahBudget(BudgetItem(kategori: _kategori!, limit: _limit));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    List<String> pilihan = _kategoriTersedia();
    bool bisaSimpan = _kategori != null && _limit > 0;

    return Padding(
      // viewInsets.bottom = tinggi keyboard, supaya isian tidak tertutup.
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
          const Text('Tambah kategori budget', style: TeksApp.judulHalaman),
          const SizedBox(height: JarakApp.j16),
          if (pilihan.isEmpty)
            const Text(
              'Semua kategori sudah punya budget',
              style: TeksApp.kecil,
            ),
          Wrap(
            spacing: JarakApp.j8,
            runSpacing: JarakApp.j8,
            children: [
              for (String nama in pilihan)
                TombolPill(
                  teks: nama,
                  kecil: true,
                  terpilih: _kategori == nama,
                  onTekan: () => setState(() => _kategori = nama),
                ),
            ],
          ),
          const SizedBox(height: JarakApp.j16),
          TextField(
            decoration: const InputDecoration(hintText: 'Limit per bulan'),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            onChanged: (v) => setState(() => _limit = int.tryParse(v) ?? 0),
          ),
          const SizedBox(height: JarakApp.j24),
          TombolUtama(teks: 'Simpan', onTekan: bisaSimpan ? _simpan : null),
        ],
      ),
    );
  }
}
