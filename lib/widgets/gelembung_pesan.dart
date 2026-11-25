import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Satu gelembung percakapan Bendahara AI: pengguna di kanan, Bendahara di kiri.
class GelembungPesan extends StatelessWidget {
  final Widget child;
  final bool dariPengguna;

  const GelembungPesan({
    super.key,
    required this.child,
    this.dariPengguna = false,
  });

  @override
  Widget build(BuildContext context) {
    // Gelembung tidak lebih dari 80% lebar layar supaya kiri dan kanan mudah dibedakan.
    double lebarMaks = MediaQuery.of(context).size.width * 0.8;
    return Align(
      alignment: dariPengguna ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: lebarMaks),
        margin: const EdgeInsets.only(bottom: JarakApp.j8),
        padding: const EdgeInsets.symmetric(
          horizontal: JarakApp.dalamKartu,
          vertical: JarakApp.j12,
        ),
        decoration: BoxDecoration(
          color: dariPengguna ? WarnaApp.primer : WarnaApp.latarSeksi,
          borderRadius: BorderRadius.circular(RadiusApp.dialog),
        ),
        child: child,
      ),
    );
  }
}
