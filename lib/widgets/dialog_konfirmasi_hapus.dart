import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Mengembalikan true lewat Navigator.pop kalau pengguna menekan Hapus.
class DialogKonfirmasiHapus extends StatelessWidget {
  final String judul;

  const DialogKonfirmasiHapus({super.key, required this.judul});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(judul),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Batal'),
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
