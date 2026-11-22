import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Mengembalikan true lewat Navigator.pop kalau pengguna menekan Hapus.
class DialogKonfirmasiHapus extends StatelessWidget {
  final String judul;
  final String? pesan;

  const DialogKonfirmasiHapus({super.key, required this.judul, this.pesan});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(judul),
      content: pesan == null ? null : Text(pesan!, style: TeksApp.isi),
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
