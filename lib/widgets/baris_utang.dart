import 'package:flutter/material.dart';

import '../models/utang.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'tombol_pill.dart';

class BarisUtang extends StatelessWidget {
  final UtangItem utang;
  final VoidCallback? onLunas;

  const BarisUtang({super.key, required this.utang, this.onLunas});

  // Satu kata diambil 1 huruf, dua kata atau lebih diambil huruf awal dua kata pertama.
  String get _inisial {
    List<String> kata = utang.nama.trim().split(' ');
    kata.removeWhere((k) => k.isEmpty);
    if (kata.isEmpty) return '';
    if (kata.length == 1) return kata[0][0].toUpperCase();
    return (kata[0][0] + kata[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    bool piutang = utang.jenis == 'Piutang';
    String tanda = piutang ? '+' : '-';
    Color warnaNominal = piutang ? WarnaApp.primer : WarnaApp.bahaya;

    return Opacity(
      opacity: utang.lunas ? 0.5 : 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: JarakApp.j12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: WarnaApp.latarSeksi,
                shape: BoxShape.circle,
              ),
              child: Text(_inisial, style: TeksApp.tombolKecil),
            ),
            const SizedBox(width: JarakApp.j12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(utang.nama, style: TeksApp.isi),
                  const SizedBox(height: JarakApp.j4),
                  Text(
                    utang.keterangan.isEmpty
                        ? utang.jenis
                        : '${utang.jenis} · ${utang.keterangan}',
                    style: TeksApp.kecil,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: JarakApp.j12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${tanda}Rp ${formatTitik(utang.nominal)}',
                  style: TeksApp.angka.copyWith(color: warnaNominal),
                ),
                const SizedBox(height: JarakApp.j4),
                _bangunStatus(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bangunStatus() {
    if (utang.lunas) return const Text('Lunas', style: TeksApp.kecil);
    if (onLunas == null) return const SizedBox.shrink();
    return TombolPill(teks: 'Lunas', onTekan: onLunas!, kecil: true);
  }
}
