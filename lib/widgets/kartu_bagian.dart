import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Pembungkus putih untuk satu bagian halaman di atas latar abu. Jarak luar diatur halaman.
class KartuBagian extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  // Judul seksi opsional di atas isi, berjarak 12 dari isi.
  final Widget? judul;

  const KartuBagian({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(JarakApp.dalamKartu),
    this.judul,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius sudut = BorderRadius.circular(RadiusApp.kartu);
    Widget isi = judul == null
        ? child
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              judul!,
              const SizedBox(height: JarakApp.j12),
              child,
            ],
          );

    // Material (bukan Container) supaya efek ketuk InkWell di dalamnya tetap terlihat.
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: sudut, boxShadow: bayanganKartu),
      child: Material(
        color: WarnaApp.latar,
        borderRadius: sudut,
        clipBehavior: Clip.antiAlias,
        child: Padding(padding: padding, child: isi),
      ),
    );
  }
}
