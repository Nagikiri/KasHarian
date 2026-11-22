import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'tombol_utama.dart';

// Dipisah dari layar supaya keyboard tidak bertabrakan dengan numpad di Catat Transaksi.
Future<String?> bukaCatatan(
  BuildContext context,
  String catatanAwal, {
  String judul = 'Catatan',
  String petunjuk = 'Tulis catatan',
}) {
  String catatan = catatanAwal;

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (context) => Padding(
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
          Text(judul, style: TeksApp.judulSeksi),
          const SizedBox(height: JarakApp.j12),
          TextFormField(
            initialValue: catatanAwal,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(hintText: petunjuk),
            onChanged: (v) => catatan = v,
          ),
          const SizedBox(height: JarakApp.j16),
          TombolUtama(
            teks: 'Selesai',
            onTekan: () => Navigator.pop(context, catatan.trim()),
          ),
        ],
      ),
    ),
  );
}
