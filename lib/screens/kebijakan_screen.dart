import 'package:flutter/material.dart';

import '../models/teks_kebijakan.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bar_turunan.dart';

class KebijakanScreen extends StatelessWidget {
  const KebijakanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Setiap bagian dipisah baris kosong. Baris pertama bagian adalah judulnya.
    List<String> daftarBagian = teksKebijakan.trim().split('\n\n');
    return Scaffold(
      appBar: buatAppBarTurunan('Kebijakan privasi'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(JarakApp.tepiHalaman),
          children: [for (String bagian in daftarBagian) _bangunBagian(bagian)],
        ),
      ),
    );
  }

  Widget _bangunBagian(String bagian) {
    int batas = bagian.indexOf('\n');
    return Padding(
      padding: const EdgeInsets.only(bottom: JarakApp.j24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(bagian.substring(0, batas), style: TeksApp.judulSeksi),
          const SizedBox(height: JarakApp.j8),
          Text(
            bagian.substring(batas + 1),
            textAlign: TextAlign.justify,
            style: TeksApp.isi.copyWith(color: WarnaApp.teksKedua, height: 1.6),
          ),
        ],
      ),
    );
  }
}
