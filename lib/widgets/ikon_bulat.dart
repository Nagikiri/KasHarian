import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class IkonBulat extends StatelessWidget {
  final IconData ikon;
  final double ukuran;
  final Color warnaLatar;
  final Color warnaIkon;

  const IkonBulat({
    super.key,
    required this.ikon,
    this.ukuran = 40,
    this.warnaLatar = WarnaApp.aksenLembut,
    this.warnaIkon = WarnaApp.primer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ukuran,
      height: ukuran,
      decoration: BoxDecoration(color: warnaLatar, shape: BoxShape.circle),
      child: Icon(ikon, size: ukuran * 0.5, color: warnaIkon),
    );
  }
}
