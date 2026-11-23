import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'ikon_bulat.dart';

// Lingkaran ikon yang dikelilingi cincin progres tipis. Dipakai kartu Impianku.
class IkonCincin extends StatelessWidget {
  final IconData ikon;
  final double persen;
  final int indeksWarna;

  const IkonCincin({
    super.key,
    required this.ikon,
    required this.persen,
    required this.indeksWarna,
  });

  @override
  Widget build(BuildContext context) {
    Color tegas = WarnaApp.tegasKategori(indeksWarna);

    // Cincin 48 dan lingkaran 40 menyisakan celah tipis di antara keduanya.
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: persen.clamp(0.0, 1.0).toDouble(),
              strokeWidth: 3,
              color: tegas,
              backgroundColor: WarnaApp.garis,
            ),
          ),
          IkonBulat(
            ikon: ikon,
            warnaLatar: WarnaApp.lingkaranKategori(indeksWarna),
            warnaIkon: tegas,
          ),
        ],
      ),
    );
  }
}
