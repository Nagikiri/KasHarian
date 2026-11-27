import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../widgets/halaman_form.dart';
import '../widgets/ikon_bulat.dart';
import '../widgets/tombol_utama.dart';

// Halaman penuh, bukan dialog, karena pengguna harus mengetik HAPUS dulu.
class HapusDataScreen extends StatefulWidget {
  const HapusDataScreen({super.key});

  @override
  State<HapusDataScreen> createState() => _HapusDataScreenState();
}

class _HapusDataScreenState extends State<HapusDataScreen> {
  final TextEditingController _isian = TextEditingController();
  bool _sedangMenghapus = false;

  @override
  void dispose() {
    _isian.dispose();
    super.dispose();
  }

  // Spasi di ujung dan huruf besar/kecil diabaikan, jadi "hapus " juga diterima.
  bool get _boleh => _isian.text.trim().toUpperCase() == 'HAPUS';

  Future<void> _hapus() async {
    setState(() => _sedangMenghapus = true);
    await AppData.hapusSemuaData();
    if (!mounted) return;
    AppData.tabAktif.value = 0;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Semua data sudah dihapus')));
    // Kembali sampai halaman paling bawah, yaitu MainNavigation di tab Beranda.
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return HalamanForm(
      judul: 'Hapus semua data',
      isi: SingleChildScrollView(
        padding: const EdgeInsets.all(JarakApp.tepiHalaman),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: IkonBulat(
                ikon: LucideIcons.alertTriangle,
                ukuran: 56,
                warnaLatar: WarnaApp.peringatanLembut,
                warnaIkon: WarnaApp.bahaya,
              ),
            ),
            const SizedBox(height: JarakApp.j16),
            Text(
              'Semua transaksi, kantong, utang, impian, dompet buatanmu, dan '
              'percakapan Bendahara akan dihapus. Kategori dan dompet bawaan '
              'kembali seperti baru. Tindakan ini tidak bisa dibatalkan.',
              style: TeksApp.isi.copyWith(color: WarnaApp.teksKedua),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: JarakApp.j24),
            TextField(
              controller: _isian,
              textCapitalization: TextCapitalization.characters,
              style: TeksApp.judulHalaman,
              decoration: const InputDecoration(
                hintText: 'Ketik HAPUS untuk melanjutkan',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: JarakApp.j16),
            TombolUtama(
              teks: 'Hapus semua data',
              warna: WarnaApp.bahaya,
              onTekan: _boleh && !_sedangMenghapus ? _hapus : null,
            ),
          ],
        ),
      ),
    );
  }
}
