import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';
import 'ikon_bulat.dart';

// Mengembalikan true lewat Navigator.pop kalau pengguna menekan Hapus. Gayanya sama dengan DialogInfo.
class DialogKonfirmasiHapus extends StatelessWidget {
  final String judul;
  final String? pesan;

  const DialogKonfirmasiHapus({super.key, required this.judul, this.pesan});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IkonBulat(
            ikon: LucideIcons.trash2,
            warnaLatar: WarnaApp.peringatanLembut,
            warnaIkon: WarnaApp.bahaya,
          ),
          const SizedBox(height: JarakApp.j16),
          Text(judul, style: TeksApp.judulSeksi),
        ],
      ),
      content: pesan == null
          ? null
          : Text(
              pesan!,
              style: TeksApp.isi.copyWith(color: WarnaApp.teksKedua),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'Batal',
            style: TeksApp.tombolKecil.copyWith(color: WarnaApp.teksKedua),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            'Hapus',
            style: TeksApp.tombolKecil.copyWith(color: WarnaApp.bahaya),
          ),
        ),
      ],
    );
  }
}
