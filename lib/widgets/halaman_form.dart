import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_bar_form.dart';

// Kerangka halaman isian. Scaffold mengecilkan isi saat keyboard muncul, jadi area bawah tidak tertutup.
class HalamanForm extends StatelessWidget {
  final String judul;
  final IconData? ikon;
  final List<Widget>? aksi;
  // Isi mengisi sisa tinggi layar, jadi pemanggil yang menentukan isi perlu digulir atau tidak.
  final Widget isi;
  // Tombol simpan atau numpad yang menempel di bawah dan tidak ikut digulir.
  final Widget? bawah;

  const HalamanForm({
    super.key,
    required this.judul,
    this.ikon,
    this.aksi,
    required this.isi,
    this.bawah,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buatAppBarForm(judul, ikon: ikon, aksi: aksi),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: isi),
          if (bawah != null) ...[
            const Divider(height: 1),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: JarakApp.tepiHalaman,
                  vertical: JarakApp.j8,
                ),
                child: bawah,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
