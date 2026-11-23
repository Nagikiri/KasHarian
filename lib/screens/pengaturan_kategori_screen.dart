import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../models/kategori.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bar_turunan.dart';
import '../widgets/dialog_konfirmasi_hapus.dart';
import '../widgets/grid_pilih_ikon.dart';
import '../widgets/ikon_bulat.dart';
import '../widgets/pilihan_segmen.dart';
import '../widgets/tombol_utama.dart';

class PengaturanKategoriScreen extends StatefulWidget {
  const PengaturanKategoriScreen({super.key});

  @override
  State<PengaturanKategoriScreen> createState() =>
      _PengaturanKategoriScreenState();
}

class _PengaturanKategoriScreenState extends State<PengaturanKategoriScreen> {
  // 0 = Pengeluaran, 1 = Pemasukan, sama dengan urutan PilihanSegmen.
  int _tipe = 0;

  // Kategori dicocokkan lewat nama, jadi nama khusus dan nama kembar di tipe yang sama ditolak.
  bool _namaDipakai(String nama) {
    String dicari = nama.trim().toLowerCase();
    bool khusus = AppData.namaKhusus.any((n) => n.toLowerCase() == dicari);
    bool kembar = AppData.kategoriTipe(_tipe)
        .any((k) => k.nama.toLowerCase() == dicari);
    return khusus || kembar;
  }

  Future<void> _hapus(KategoriItem kategori) async {
    // Budget hanya ada untuk kategori pengeluaran.
    bool punyaBudget =
        !kategori.isPemasukan &&
        AppData.daftarBudget.any((b) => b.kategori == kategori.nama);
    bool? hapus = await showDialog<bool>(
      context: context,
      builder: (context) => DialogKonfirmasiHapus(
        judul: 'Hapus kategori ini?',
        pesan: punyaBudget ? 'Anggaran kategori ini ikut dihapus.' : null,
      ),
    );
    if (hapus != true) return;
    setState(() => AppData.hapusKategori(kategori));
  }

  void _simpanKategori(String nama, IconData ikon) {
    setState(() {
      AppData.tambahKategori(
        KategoriItem(nama: nama, ikon: ikon, isPemasukan: _tipe == 1),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buatAppBarTurunan('Kategori'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              JarakApp.tepiHalaman,
              JarakApp.j8,
              JarakApp.tepiHalaman,
              JarakApp.j8,
            ),
            child: PilihanSegmen(
              pilihan: const ['Pengeluaran', 'Pemasukan'],
              indeksAktif: _tipe,
              onPilih: (i) => setState(() => _tipe = i),
            ),
          ),
          Expanded(child: _bangunDaftar()),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(JarakApp.tepiHalaman),
          child: TombolUtama(teks: 'Tambah kategori', onTekan: _bukaTambah),
        ),
      ),
    );
  }

  Widget _bangunDaftar() {
    List<KategoriItem> daftar = AppData.kategoriTipe(_tipe);
    if (daftar.isEmpty) {
      return const Center(
        child: Text('Belum ada kategori', style: TeksApp.kecil),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: JarakApp.tepiHalaman),
      itemCount: daftar.length,
      separatorBuilder: (context, i) => const Divider(height: 1),
      itemBuilder: (context, i) => _bangunBaris(daftar[i]),
    );
  }

  Widget _bangunBaris(KategoriItem kategori) {
    return SizedBox(
      height: 64,
      child: Row(
        children: [
          IkonBulat(ikon: kategori.ikon),
          const SizedBox(width: JarakApp.j12),
          Expanded(child: Text(kategori.nama, style: TeksApp.isi)),
          IconButton(
            icon: const Icon(
              LucideIcons.trash2,
              size: 20,
              color: WarnaApp.teksRedup,
            ),
            onPressed: () => _hapus(kategori),
          ),
        ],
      ),
    );
  }

  void _bukaTambah() {
    // Isian disimpan di variabel biasa, jadi tidak perlu TextEditingController.
    String nama = '';
    IconData ikon = AppData.opsiIkonKategori.first;

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheet) {
          bool dipakai = _namaDipakai(nama);
          bool bisaSimpan = nama.trim().isNotEmpty && !dipakai;

          return SafeArea(
            child: Padding(
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
                  const Text('Tambah kategori', style: TeksApp.judulSeksi),
                  const SizedBox(height: JarakApp.j16),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Nama kategori',
                    ),
                    onChanged: (v) => setSheet(() => nama = v),
                  ),
                  if (dipakai) ...[
                    const SizedBox(height: JarakApp.j4),
                    Text(
                      'Nama sudah dipakai',
                      style: TeksApp.kecil.copyWith(color: WarnaApp.bahaya),
                    ),
                  ],
                  const SizedBox(height: JarakApp.j16),
                  const Text('Ikon', style: TeksApp.kecil),
                  const SizedBox(height: JarakApp.j8),
                  GridPilihIkon(
                    daftarIkon: AppData.opsiIkonKategori,
                    terpilih: ikon,
                    onPilih: (pilihan) => setSheet(() => ikon = pilihan),
                  ),
                  const SizedBox(height: JarakApp.j24),
                  TombolUtama(
                    teks: 'Simpan',
                    onTekan: bisaSimpan
                        ? () {
                            _simpanKategori(nama.trim(), ikon);
                            Navigator.pop(context);
                          }
                        : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
