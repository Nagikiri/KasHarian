import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';

// Kartu terakhir di GridKartu. mendatar = true kalau kartu ini sendirian di barisnya.
class KartuTambah extends StatelessWidget {
  final String label;
  final VoidCallback onTekan;
  final bool mendatar;

  const KartuTambah({
    super.key,
    required this.label,
    required this.onTekan,
    this.mendatar = false,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius sudut = BorderRadius.circular(RadiusApp.input);
    Widget lingkaran = Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: WarnaApp.latar,
        shape: BoxShape.circle,
      ),
      child: const Icon(LucideIcons.plus, size: 20, color: WarnaApp.primer),
    );
    Text teks = Text(
      label,
      style: TeksApp.tombolKecil.copyWith(color: WarnaApp.primer),
      textAlign: TextAlign.center,
    );

    Widget isi = mendatar
        ? SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                lingkaran,
                const SizedBox(width: JarakApp.j12),
                teks,
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(JarakApp.dalamKartu),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                lingkaran,
                const SizedBox(height: JarakApp.j8),
                teks,
              ],
            ),
          );

    return Material(
      color: WarnaApp.latarSeksi,
      borderRadius: sudut,
      child: InkWell(onTap: onTekan, borderRadius: sudut, child: isi),
    );
  }
}
