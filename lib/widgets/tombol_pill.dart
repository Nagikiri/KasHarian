import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class TombolPill extends StatelessWidget {
  final String teks;
  // null = nonaktif, misalnya chip pertanyaan saat Bendahara AI sedang menjawab.
  final VoidCallback? onTekan;
  final IconData? ikon;
  final bool terpilih;
  final bool kecil;
  final bool ikonDiKanan;
  // Latar primer untuk satu aksi utama, misalnya tombol di TampilanKosong.
  final bool penuh;
  // Padding samping kecil untuk pill yang dibagi rata, supaya label muat di layar 360 dp.
  final bool rapat;

  const TombolPill({
    super.key,
    required this.teks,
    required this.onTekan,
    this.ikon,
    this.terpilih = false,
    this.kecil = false,
    this.ikonDiKanan = false,
    this.penuh = false,
    this.rapat = false,
  });

  @override
  Widget build(BuildContext context) {
    Color warnaTeks = terpilih ? WarnaApp.primer : WarnaApp.teksUtama;
    Color warnaLatar = terpilih ? WarnaApp.aksenLembut : WarnaApp.latarSeksi;
    if (penuh) {
      warnaTeks = WarnaApp.diAtasPrimer;
      warnaLatar = WarnaApp.primer;
    }
    if (onTekan == null) warnaTeks = WarnaApp.teksNonaktif;
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
            horizontal: rapat
                ? JarakApp.j4
                : (kecil ? JarakApp.j12 : JarakApp.j16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            // Rata tengah saat pill dilebarkan, misalnya di TemplateNominal.
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (gambarIkon != null && !ikonDiKanan) ...[
                gambarIkon,
                const SizedBox(width: JarakApp.j4),
              ],
              _bangunTeks(warnaTeks),
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

  Widget _bangunTeks(Color warna) {
    Widget teksPill = Text(
      teks,
      style: TeksApp.tombolKecil.copyWith(color: warna),
    );
    if (!rapat) return teksPill;
    // Pengaman kalau ukuran huruf HP diperbesar: teks mengecil, tidak terpotong.
    return Flexible(
      child: FittedBox(fit: BoxFit.scaleDown, child: teksPill),
    );
  }
}
