import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Satu sel bulan atau tahun. Bentuk dan warnanya sama dengan lingkaran tanggal di kalender bawaan.
class SelKalender extends StatelessWidget {
  final String teks;
  final bool terpilih;
  final bool nonaktif;
  final bool sekarang;
  final VoidCallback onTekan;

  const SelKalender({
    super.key,
    required this.teks,
    required this.terpilih,
    required this.nonaktif,
    required this.sekarang,
    required this.onTekan,
  });

  @override
  Widget build(BuildContext context) {
    // Bulan atau tahun berjalan diberi garis tepi, seperti tanggal hari ini di kalender.
    BorderSide tepi = sekarang && !terpilih
        ? const BorderSide(color: WarnaApp.primer)
        : BorderSide.none;

    return Center(
      child: SizedBox(
        height: KalenderApp.tinggiSel,
        child: Ink(
          decoration: ShapeDecoration(
            color: latarSel(terpilih),
            shape: StadiumBorder(side: tepi),
          ),
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: nonaktif ? null : onTekan,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: JarakApp.j8),
              // Lebar mengikuti teks. Nama bulan panjang di layar sempit sedikit dikecilkan.
              child: Center(
                widthFactor: 1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    teks,
                    style: TeksApp.selKalender.copyWith(
                      color: warnaTeksSel(
                        terpilih: terpilih,
                        nonaktif: nonaktif,
                        sekarang: sekarang,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
