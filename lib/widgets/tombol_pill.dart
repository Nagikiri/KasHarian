import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class TombolPill extends StatelessWidget {
  final String teks;
  final VoidCallback onTekan;
  final IconData? ikon;
  final bool terpilih;

  const TombolPill({
    super.key,
    required this.teks,
    required this.onTekan,
    this.ikon,
    this.terpilih = false,
  });

  @override
  Widget build(BuildContext context) {
    Color warnaTeks = terpilih ? WarnaApp.primer : WarnaApp.teksUtama;

    return Material(
      color: terpilih ? WarnaApp.aksenLembut : WarnaApp.latarSeksi,
      borderRadius: BorderRadius.circular(RadiusApp.pill),
      child: InkWell(
        onTap: onTekan,
        borderRadius: BorderRadius.circular(RadiusApp.pill),
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: JarakApp.j16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (ikon != null) ...[
                Icon(ikon, size: 16, color: warnaTeks),
                const SizedBox(width: JarakApp.j4),
              ],
              Text(teks, style: TeksApp.tombolKecil.copyWith(color: warnaTeks)),
            ],
          ),
        ),
      ),
    );
  }
}
