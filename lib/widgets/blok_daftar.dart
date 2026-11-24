import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Latar putih selebar layar supaya daftar transaksi tidak terasa sempit, berjarak antarKartu dari kartu di atasnya.
class BlokDaftar extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const BlokDaftar({
    super.key,
    required this.child,
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
      padding: const EdgeInsets.only(top: JarakApp.antarKartu),
      child: Material(
        color: WarnaApp.latar,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
