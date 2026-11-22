import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class TombolUtama extends StatelessWidget {
  final String teks;
  final VoidCallback? onTekan;

  const TombolUtama({super.key, required this.teks, required this.onTekan});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: onTekan,
        style: FilledButton.styleFrom(
          backgroundColor: WarnaApp.primer,
          foregroundColor: WarnaApp.diAtasPrimer,
          disabledBackgroundColor: WarnaApp.garis,
          disabledForegroundColor: WarnaApp.teksKedua,
          textStyle: TeksApp.tombol,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusApp.tombol),
          ),
        ),
        child: Text(teks),
      ),
    );
  }
}
