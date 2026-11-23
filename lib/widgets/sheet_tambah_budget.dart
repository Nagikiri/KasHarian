import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../models/budget.dart';
import '../models/kategori.dart';
import '../screens/pengaturan_kategori_screen.dart';
import '../theme/app_theme.dart';
import 'grid_kategori.dart';
import 'header_sheet.dart';
import 'sheet_input_nominal.dart';

// Dua langkah: pilih kategori di sheet grid, lalu isi limit lewat sheet nominal.
Future<void> bukaTambahBudget(BuildContext context) async {
  KategoriItem? kategori = await showModalBottomSheet<KategoriItem>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (context) => const SheetTambahBudget(),
  );
  if (kategori == null || !context.mounted) return;
  bukaInputNominal(
    context,
    judul: 'Limit ${kategori.nama} per bulan',
    ikon: kategori.ikon,
    onSimpan: (limit) =>
        AppData.tambahBudget(BudgetItem(kategori: kategori.nama, limit: limit)),
  );
}

// Langkah pertama tambah budget: memilih kategori. Kategori dikembalikan lewat Navigator.pop.
class SheetTambahBudget extends StatefulWidget {
  const SheetTambahBudget({super.key});

  @override
  State<SheetTambahBudget> createState() => _SheetTambahBudgetState();
}

class _SheetTambahBudgetState extends State<SheetTambahBudget> {
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
      hasil.add(KategoriItem(nama: 'Tabungan', ikon: LucideIcons.piggyBank));
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

  @override
  Widget build(BuildContext context) {
    List<KategoriItem> pilihan = _kategoriTersedia();

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: JarakApp.j8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: JarakApp.tepiHalaman),
                child: HeaderSheet(judul: 'Tambah anggaran'),
              ),
              if (pilihan.isEmpty)
                const Padding(
                  padding: EdgeInsets.fromLTRB(
                    JarakApp.tepiHalaman,
                    JarakApp.j12,
                    JarakApp.tepiHalaman,
                    0,
                  ),
                  child: Text(
                    'Semua kategori sudah punya anggaran',
                    style: TeksApp.kecil,
                  ),
                ),
              Flexible(
                child: GridKategori(
                  daftar: pilihan,
                  terpilih: null,
                  onPilih: (k) => Navigator.pop(context, k),
                  onAtur: _bukaPengaturanKategori,
                  shrinkWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
