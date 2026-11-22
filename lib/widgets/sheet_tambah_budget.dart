import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../models/budget.dart';
import '../models/kategori.dart';
import '../screens/pengaturan_kategori_screen.dart';
import '../theme/app_theme.dart';
import '../utils/nominal.dart';
import 'numpad.dart';
import 'pilih_kategori.dart';
import 'tampilan_nominal.dart';
import 'template_nominal.dart';
import 'tombol_utama.dart';

class SheetTambahBudget extends StatefulWidget {
  const SheetTambahBudget({super.key});

  @override
  State<SheetTambahBudget> createState() => _SheetTambahBudgetState();
}

class _SheetTambahBudgetState extends State<SheetTambahBudget> {
  KategoriItem? _kategori;
  int _limit = 0;

  // Yang boleh diberi budget: kategori pengeluaran dan 'Setor Tabungan' yang belum punya budget.
  List<KategoriItem> _kategoriTersedia() {
    List<KategoriItem> hasil = [];
    for (var k in AppData.daftarKategori) {
      bool pengeluaran = !k.isPemasukan && !k.isTransfer;
      bool boleh = pengeluaran || k.nama == 'Setor Tabungan';
      bool sudahAda = AppData.daftarBudget.any((b) => b.kategori == k.nama);
      if (boleh && !sudahAda) hasil.add(k);
    }
    return hasil;
  }

  Future<void> _bukaPengaturanKategori() async {
    await Navigator.push(
      context,
      buatTransisiHalaman(const PengaturanKategoriScreen()),
    );
    if (!mounted) return;
    // Kategori terpilih bisa saja dihapus di Pengaturan Kategori.
    setState(() {
      if (!AppData.daftarKategori.contains(_kategori)) _kategori = null;
    });
  }

  void _simpan() {
    AppData.tambahBudget(BudgetItem(kategori: _kategori!.nama, limit: _limit));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    List<KategoriItem> pilihan = _kategoriTersedia();
    bool bisaSimpan = _kategori != null && _limit > 0;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            JarakApp.tepiHalaman,
            JarakApp.j8,
            JarakApp.tepiHalaman,
            JarakApp.j16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: WarnaApp.garis,
                    borderRadius: BorderRadius.circular(RadiusApp.pill),
                  ),
                ),
              ),
              const SizedBox(height: JarakApp.j8),
              Row(
                children: [
                  const Expanded(
                    child: Text('Tambah budget', style: TeksApp.judulSeksi),
                  ),
                  IconButton(
                    icon: const Icon(
                      LucideIcons.x,
                      size: 20,
                      color: WarnaApp.teksUtama,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: JarakApp.j8),
              if (pilihan.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: JarakApp.j8),
                  child: Text(
                    'Semua kategori sudah punya budget',
                    style: TeksApp.kecil,
                  ),
                ),
              PilihKategori(
                daftar: pilihan,
                terpilih: _kategori,
                onPilih: (k) => setState(() => _kategori = k),
                onTambahBaru: _bukaPengaturanKategori,
              ),
              const SizedBox(height: JarakApp.j16),
              TampilanNominal(label: 'Limit per bulan', nominal: _limit),
              const SizedBox(height: JarakApp.j12),
              TemplateNominal(
                onTambah: (n) =>
                    setState(() => _limit = tambahNominal(_limit, n)),
                onReset: () => setState(() => _limit = 0),
              ),
              const Spacer(),
              Numpad(
                onAngka: (a) => setState(() => _limit = tambahDigit(_limit, a)),
                onHapus: () => setState(() => _limit = hapusDigit(_limit)),
              ),
              const SizedBox(height: JarakApp.j12),
              TombolUtama(teks: 'Simpan', onTekan: bisaSimpan ? _simpan : null),
            ],
          ),
        ),
      ),
    );
  }
}
