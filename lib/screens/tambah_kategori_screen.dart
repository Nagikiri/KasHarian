import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../models/kategori.dart';
import '../theme/app_theme.dart';
import '../widgets/grid_pilih_ikon.dart';
import '../widgets/halaman_form.dart';
import '../widgets/tombol_utama.dart';

class TambahKategoriScreen extends StatefulWidget {
  // 0 = Pengeluaran, 1 = Pemasukan, sama dengan segmen di Pengaturan Kategori.
  final int tipe;

  const TambahKategoriScreen({super.key, required this.tipe});

  @override
  State<TambahKategoriScreen> createState() => _TambahKategoriScreenState();
}

class _TambahKategoriScreenState extends State<TambahKategoriScreen> {
  String _nama = '';
  IconData _ikon = AppData.opsiIkonKategori.first;

  // Kategori dicocokkan lewat nama, jadi nama khusus dan nama kembar di tipe yang sama ditolak.
  bool get _namaDipakai {
    String dicari = _nama.trim().toLowerCase();
    bool khusus = AppData.namaKhusus.any((n) => n.toLowerCase() == dicari);
    bool kembar = AppData.kategoriTipe(widget.tipe)
        .any((k) => k.nama.toLowerCase() == dicari);
    return khusus || kembar;
  }

  void _simpan() {
    bool pemasukan = widget.tipe == 1;
    AppData.tambahKategori(
      KategoriItem(
        nama: _nama.trim(),
        ikon: _ikon,
        isPemasukan: pemasukan,
        indeksWarna: AppData.indeksWarnaBerikutnya(pemasukan),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    bool dipakai = _namaDipakai;
    bool bisaSimpan = _nama.trim().isNotEmpty && !dipakai;

    return HalamanForm(
      judul: 'Tambah kategori',
      isi: SingleChildScrollView(
        padding: const EdgeInsets.all(JarakApp.tepiHalaman),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(hintText: 'Nama kategori'),
              onChanged: (v) => setState(() => _nama = v),
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
              terpilih: _ikon,
              onPilih: (pilihan) => setState(() => _ikon = pilihan),
            ),
          ],
        ),
      ),
      bawah: TombolUtama(teks: 'Simpan', onTekan: bisaSimpan ? _simpan : null),
    );
  }
}
