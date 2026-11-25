import 'package:flutter/material.dart';

// Dialog di tengah untuk isian teks pendek. Dialog ikut naik saat keyboard muncul.
Future<String?> bukaCatatan(
  BuildContext context,
  String catatanAwal, {
  String judul = 'Catatan',
  String petunjuk = 'Tulis catatan',
}) {
  String catatan = catatanAwal;

  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(judul),
      content: TextFormField(
        initialValue: catatanAwal,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(hintText: petunjuk),
        onChanged: (v) => catatan = v,
        onFieldSubmitted: (v) => Navigator.pop(context, v.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, catatan.trim()),
          child: const Text('Selesai'),
        ),
      ],
    ),
  );
}
