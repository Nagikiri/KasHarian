import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../models/kategori.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bar_turunan.dart';
import '../widgets/blok_daftar.dart';
import '../widgets/dialog_konfirmasi_hapus.dart';
import '../widgets/ikon_bulat.dart';
import '../widgets/kartu_bagian.dart';
import '../widgets/pilihan_segmen.dart';
import '../widgets/tampilan_kosong.dart';
import '../widgets/tombol_utama.dart';
import 'tambah_kategori_screen.dart';

class PengaturanKategoriScreen extends StatefulWidget {
  const PengaturanKategoriScreen({super.key});

  @override
  State<PengaturanKategoriScreen> createState() =>
      _PengaturanKategoriScreenState();
}

class _PengaturanKategoriScreenState extends State<PengaturanKategoriScreen> {
  // 0 = Pengeluaran, 1 = Pemasukan, sama dengan urutan PilihanSegmen.
  int _tipe = 0;

  Future<void> _hapus(KategoriItem kategori) async {
    // Budget hanya ada untuk kategori pengeluaran.
    bool punyaBudget =
        !kategori.isPemasukan &&
        AppData.daftarBudget.any((b) => b.kategori == kategori.nama);
    bool? hapus = await showDialog<bool>(
      context: context,
      builder: (context) => DialogKonfirmasiHapus(
        judul: 'Hapus kategori ini?',
        pesan: punyaBudget ? 'Kantong kategori ini ikut dihapus.' : null,
      ),
    );
    if (hapus != true) return;
    setState(() => AppData.hapusKategori(kategori));
  }

  // Daftar dimuat ulang setelah kembali, karena kategori baru mungkin sudah ditambahkan.
  Future<void> _bukaTambah() async {
    await Navigator.push(
      context,
      buatTransisiHalaman(TambahKategoriScreen(tipe: _tipe)),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarnaApp.latarHalaman,
      appBar: buatAppBarTurunan('Kategori'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Segmen menyatu dengan AppBar putih, jadi tanpa celah abu di atasnya.
          BlokDaftar(
            jarakAtas: 0,
            padding: const EdgeInsets.fromLTRB(
              JarakApp.tepiHalaman,
              JarakApp.j8,
              JarakApp.tepiHalaman,
              JarakApp.j12,
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
      bottomNavigationBar: ColoredBox(
        color: WarnaApp.latar,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(JarakApp.tepiHalaman),
            child: TombolUtama(teks: 'Tambah kategori', onTekan: _bukaTambah),
          ),
        ),
      ),
    );
  }

  Widget _bangunDaftar() {
    List<KategoriItem> daftar = AppData.kategoriTipe(_tipe);
    if (daftar.isEmpty) {
      return const TampilanKosong(
        ikon: LucideIcons.tag,
        judul: 'Belum ada kategori',
        kalimat: 'Tambahkan lewat tombol di bawah.',
      );
    }
    return ListView(
      padding: const EdgeInsets.all(JarakApp.tepiKartu),
      children: [
        KartuBagian(
          padding: const EdgeInsets.symmetric(horizontal: JarakApp.dalamKartu),
          child: Column(
            children: [
              for (int i = 0; i < daftar.length; i++) ...[
                if (i > 0) const Divider(height: 1),
                _bangunBaris(daftar[i]),
              ],
            ],
          ),
        ),
      ],
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
}
