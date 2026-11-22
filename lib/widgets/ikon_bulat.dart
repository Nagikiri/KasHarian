import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class IkonBulat extends StatelessWidget {
  final IconData ikon;
  final double ukuran;

  const IkonBulat({super.key, required this.ikon, this.ukuran = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ukuran,
      height: ukuran,
      decoration: const BoxDecoration(
        color: WarnaApp.aksenLembut,
        shape: BoxShape.circle,
      ),
      child: Icon(ikon, size: 20, color: WarnaApp.primer),
    );
  }
}
