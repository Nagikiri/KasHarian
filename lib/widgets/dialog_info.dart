import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'ikon_bulat.dart';

// Dialog pemberitahuan dengan satu tombol. Gayanya sama dengan DialogKonfirmasiHapus.
class DialogInfo extends StatelessWidget {
  final IconData ikon;
  final String judul;
  final String pesan;

  const DialogInfo({
    super.key,
    required this.ikon,
    required this.judul,
    required this.pesan,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IkonBulat(ikon: ikon),
          const SizedBox(height: JarakApp.j16),
          Text(judul, style: TeksApp.judulSeksi),
        ],
      ),
      content: Text(
        pesan,
        style: TeksApp.isi.copyWith(color: WarnaApp.teksKedua),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Mengerti',
            style: TeksApp.tombolKecil.copyWith(color: WarnaApp.primer),
          ),
        ),
      ],
    );
  }
}
