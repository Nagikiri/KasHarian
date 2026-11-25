import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Latar putih selebar layar supaya daftar transaksi tidak terasa sempit, berjarak antarKartu dari kartu di atasnya.
class BlokDaftar extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  // 0 kalau blok menempel langsung di bawah AppBar putih.
  final double jarakAtas;

  const BlokDaftar({
    super.key,
    required this.child,
    this.jarakAtas = JarakApp.antarKartu,
    this.padding = const EdgeInsets.fromLTRB(
      JarakApp.tepiHalaman,
      JarakApp.j16,
      JarakApp.tepiHalaman,
      JarakApp.j24,
    ),
  });

  @override
  Widget build(BuildContext context) {
    // Material (bukan ColoredBox) supaya efek ketuk InkWell di baris transaksi tetap terlihat.
    return Padding(
      padding: EdgeInsets.only(top: jarakAtas),
      child: Material(
        color: WarnaApp.latar,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
