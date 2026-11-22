import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';
import 'ikon_bulat.dart';

// Tanpa padding kiri-kanan, karena setiap sheet sudah mengatur paddingnya sendiri.
class HeaderSheet extends StatelessWidget {
  final String judul;
  final IconData? ikon;
  final Widget? ujung;

  const HeaderSheet({super.key, required this.judul, this.ikon, this.ujung});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: WarnaApp.garis,
              borderRadius: BorderRadius.circular(RadiusApp.pill),
            ),
          ),
        ),
        const SizedBox(height: JarakApp.j8),
        Row(
          children: [
            if (ikon != null) ...[
              IkonBulat(ikon: ikon!),
              const SizedBox(width: JarakApp.j12),
            ],
            Expanded(child: Text(judul, style: TeksApp.judulHalaman)),
            ?ujung,
            IconButton(
              icon: const Icon(
                LucideIcons.x,
                size: 20,
                color: WarnaApp.teksUtama,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ],
    );
  }
}
