import 'package:flutter/material.dart';

import '../main.dart';
import '../theme/app_theme.dart';
import 'halaman_form.dart';
import 'tombol_utama.dart';

// Mengembalikan teks yang sudah dirapikan, atau null kalau halaman ditutup lewat X.
Future<String?> bukaIsianTeks(
  BuildContext context,
  String nilaiAwal, {
  String judul = 'Catatan',
  String petunjuk = 'Tulis catatan',
}) async {
  // Disimpan ke var dulu karena buatTransisiHalaman tidak membawa tipe hasil.
  var hasil = await Navigator.push(
    context,
    buatTransisiHalaman(
      HalamanIsianTeks(nilaiAwal: nilaiAwal, judul: judul, petunjuk: petunjuk),
    ),
  );
  return hasil;
}

// Halaman penuh dengan tombol Simpan tepat di bawah kolom, jadi tidak tertutup keyboard.
class HalamanIsianTeks extends StatefulWidget {
  final String nilaiAwal;
  final String judul;
  final String petunjuk;

  const HalamanIsianTeks({
    super.key,
    required this.nilaiAwal,
    required this.judul,
    required this.petunjuk,
  });

  @override
  State<HalamanIsianTeks> createState() => _HalamanIsianTeksState();
}

class _HalamanIsianTeksState extends State<HalamanIsianTeks> {
  late final TextEditingController _isian = TextEditingController(
    text: widget.nilaiAwal,
  );

  @override
  void dispose() {
    _isian.dispose();
    super.dispose();
  }

  void _simpan() => Navigator.pop(context, _isian.text.trim());

  @override
  Widget build(BuildContext context) {
    return HalamanForm(
      judul: widget.judul,
      // Digulir supaya tombol Simpan tetap terjangkau di layar pendek saat keyboard muncul.
      isi: SingleChildScrollView(
        padding: const EdgeInsets.all(JarakApp.tepiHalaman),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _isian,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              style: TeksApp.judulHalaman,
              decoration: InputDecoration(hintText: widget.petunjuk),
              onSubmitted: (_) => _simpan(),
            ),
            const SizedBox(height: JarakApp.j16),
            TombolUtama(teks: 'Simpan', onTekan: _simpan),
          ],
        ),
      ),
    );
  }
}
