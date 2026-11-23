import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class TombolPill extends StatelessWidget {
  final String teks;
  final VoidCallback onTekan;
  final IconData? ikon;
  final bool terpilih;
  final bool kecil;
  final bool ikonDiKanan;
  // Latar primer untuk satu aksi utama, misalnya tombol di TampilanKosong.
  final bool penuh;

  const TombolPill({
    super.key,
    required this.teks,
    required this.onTekan,
    this.ikon,
    this.terpilih = false,
    this.kecil = false,
    this.ikonDiKanan = false,
    this.penuh = false,
  });

  @override
  Widget build(BuildContext context) {
    Color warnaTeks = terpilih ? WarnaApp.primer : WarnaApp.teksUtama;
    Color warnaLatar = terpilih ? WarnaApp.aksenLembut : WarnaApp.latarSeksi;
    if (penuh) {
      warnaTeks = WarnaApp.diAtasPrimer;
      warnaLatar = WarnaApp.primer;
    }
    Widget? gambarIkon = ikon == null
        ? null
        : Icon(ikon, size: 16, color: warnaTeks);

    return Material(
      color: warnaLatar,
      borderRadius: BorderRadius.circular(RadiusApp.pill),
      child: InkWell(
        onTap: onTekan,
        borderRadius: BorderRadius.circular(RadiusApp.pill),
        child: Container(
          height: kecil ? 28 : 36,
          padding: EdgeInsets.symmetric(
            horizontal: kecil ? JarakApp.j12 : JarakApp.j16,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (gambarIkon != null && !ikonDiKanan) ...[
                gambarIkon,
                const SizedBox(width: JarakApp.j4),
              ],
              Text(teks, style: TeksApp.tombolKecil.copyWith(color: warnaTeks)),
              if (gambarIkon != null && ikonDiKanan) ...[
                const SizedBox(width: JarakApp.j4),
                gambarIkon,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
