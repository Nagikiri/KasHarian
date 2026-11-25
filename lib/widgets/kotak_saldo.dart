import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Satu widget untuk kotak Saldo awal dan Saldo sekarang, supaya padding, radius, dan gaya angkanya dijamin sama.
class KotakSaldo extends StatelessWidget {
  final String label;
  final String angka;
  final Color warnaLatar;
  final Color warnaAngka;
  // Teks kecil opsional di bawah angka, misalnya saldo setelah disimpan.
  final String? keterangan;

  const KotakSaldo({
    super.key,
    required this.label,
    required this.angka,
    required this.warnaLatar,
    required this.warnaAngka,
    this.keterangan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(JarakApp.j16),
      decoration: BoxDecoration(
        color: warnaLatar,
        borderRadius: BorderRadius.circular(RadiusApp.input),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TeksApp.kecil),
          const SizedBox(height: JarakApp.j4),
          // Tinggi angka ditetapkan dan angka panjang dikecilkan, jadi kedua kotak selalu sama tinggi.
          SizedBox(
            height: 48,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                angka,
                style: TeksApp.angkaBesar.copyWith(color: warnaAngka),
              ),
            ),
          ),
          if (keterangan != null)
            Text(
              keterangan!,
              style: TeksApp.kecil.copyWith(color: WarnaApp.teksKedua),
            ),
        ],
      ),
    );
  }
}
