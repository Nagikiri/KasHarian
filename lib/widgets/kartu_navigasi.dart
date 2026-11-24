import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';
import 'progress_tipis.dart';

class KartuNavigasi extends StatelessWidget {
  final IconData ikon;
  final String judul;
  final String info;
  final VoidCallback onTekan;
  final double? persen;
  final Color? warnaInfo;
  // true di Beranda: kartu putih berbayangan di atas latar abu, seperti KartuBagian.
  final bool putih;

  const KartuNavigasi({
    super.key,
    required this.ikon,
    required this.judul,
    required this.info,
    required this.onTekan,
    this.persen,
    this.warnaInfo,
    this.putih = false,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius sudut = BorderRadius.circular(RadiusApp.kartu);
    Widget kartu = _bangunKartu(sudut);
    if (!putih) return kartu;
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: sudut, boxShadow: bayanganKartu),
      child: kartu,
    );
  }

  Widget _bangunKartu(BorderRadius sudut) {
    return Material(
      color: putih ? WarnaApp.latar : WarnaApp.aksenLembut,
      shape: RoundedRectangleBorder(
        borderRadius: sudut,
        side: putih
            ? BorderSide.none
            : const BorderSide(color: WarnaApp.garisAksen),
      ),
      child: InkWell(
        onTap: onTekan,
        borderRadius: sudut,
        child: Padding(
          padding: const EdgeInsets.all(JarakApp.dalamKartu),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(ikon, size: 20, color: WarnaApp.primer),
                    const SizedBox(height: JarakApp.j8),
                    // Judul panjang dikecilkan di layar sempit, bukan dipotong.
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(judul, style: TeksApp.tombolKecil),
                    ),
                    const SizedBox(height: JarakApp.j4),
                    Text(
                      info,
                      style: TeksApp.kecil.copyWith(color: warnaInfo),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (persen != null) ...[
                      const SizedBox(height: JarakApp.j8),
                      ProgressTipis(persen: persen!),
                    ],
                  ],
                ),
              ),
              const Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: WarnaApp.teksRedup,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
