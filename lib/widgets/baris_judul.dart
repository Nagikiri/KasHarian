import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Blok judul putih di atas setiap tab, ikut digulir bersama isi halaman.
class BarisJudul extends StatelessWidget {
  final String judul;
  final String? keterangan;
  final Widget? ujung;
  // Kontrol halaman (segmen, periode) yang ikut berada di area putih.
  final List<Widget> bawah;

  const BarisJudul({
    super.key,
    required this.judul,
    this.keterangan,
    this.ujung,
    this.bawah = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: WarnaApp.latar,
      padding: const EdgeInsets.fromLTRB(
        JarakApp.tepiHalaman,
        JarakApp.j16,
        JarakApp.tepiHalaman,
        JarakApp.j16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(judul, style: TeksApp.judulHalaman),
                    if (keterangan != null) ...[
                      const SizedBox(height: JarakApp.j4),
                      Text(keterangan!, style: TeksApp.kecil),
                    ],
                  ],
                ),
              ),
              ?ujung,
            ],
          ),
          for (Widget isi in bawah) ...[
            const SizedBox(height: JarakApp.j12),
            isi,
          ],
        ],
      ),
    );
  }
}
