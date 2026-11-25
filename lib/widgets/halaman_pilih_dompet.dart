import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../screens/form_dompet_screen.dart';
import '../theme/app_theme.dart';
import '../utils/privasi.dart';
import 'halaman_form.dart';
import 'ikon_bulat.dart';

// Mengembalikan nama dompet yang dipilih, atau null kalau ditutup lewat X.
// kecuali = dompet yang disembunyikan, supaya Dari dan Ke pindah tidak sama.
Future<String?> bukaPilihDompet(
  BuildContext context,
  String terpilih, {
  required String judul,
  String? kecuali,
}) async {
  // Disimpan ke var dulu karena buatTransisiHalaman tidak membawa tipe hasil.
  var hasil = await Navigator.push(
    context,
    buatTransisiHalaman(
      HalamanPilihDompet(terpilih: terpilih, judul: judul, kecuali: kecuali),
    ),
  );
  return hasil;
}

// Halaman penuh karena daftar dompet bisa terus bertambah panjang.
class HalamanPilihDompet extends StatelessWidget {
  final String terpilih;
  final String judul;
  final String? kecuali;

  const HalamanPilihDompet({
    super.key,
    required this.terpilih,
    required this.judul,
    this.kecuali,
  });

  // Form mengembalikan nama dompet baru, lalu dompet itu langsung dipilih.
  Future<void> _tambahBaru(BuildContext context) async {
    final navigator = Navigator.of(context);
    var baru = await navigator.push(
      buatTransisiHalaman(const FormDompetScreen()),
    );
    if (baru is String) navigator.pop(baru);
  }

  @override
  Widget build(BuildContext context) {
    return HalamanForm(
      judul: judul,
      isi: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: JarakApp.tepiHalaman,
          vertical: JarakApp.j8,
        ),
        children: [
          for (String nama in AppData.daftarSumberDana)
            if (nama != kecuali) _bangunBaris(context, nama),
          const Divider(height: 1),
          _bangunTambah(context),
        ],
      ),
    );
  }

  Widget _bangunBaris(BuildContext context, String nama) {
    return InkWell(
      onTap: () => Navigator.pop(context, nama),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: JarakApp.j12),
        child: Row(
          children: [
            IkonBulat(ikon: AppData.ikonDompet(nama)),
            const SizedBox(width: JarakApp.j12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nama, style: TeksApp.isi),
                  Text(
                    rupiahTampil(AppData.saldoSumber(nama)),
                    style: TeksApp.kecil,
                  ),
                ],
              ),
            ),
            if (nama == terpilih)
              const Icon(LucideIcons.check, size: 20, color: WarnaApp.primer),
          ],
        ),
      ),
    );
  }

  Widget _bangunTambah(BuildContext context) {
    return InkWell(
      onTap: () => _tambahBaru(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: JarakApp.j12),
        child: Row(
          children: [
            const IkonBulat(ikon: LucideIcons.plus),
            const SizedBox(width: JarakApp.j12),
            Text(
              'Tambah dompet baru',
              style: TeksApp.isi.copyWith(color: WarnaApp.primer),
            ),
          ],
        ),
      ),
    );
  }
}
