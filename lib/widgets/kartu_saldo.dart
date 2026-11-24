import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';

// Kartu hijau Beranda. Angka sudah diformat (dan disembunyikan) oleh pemanggil.
class KartuSaldo extends StatelessWidget {
  final String saldo;
  final String pemasukan;
  final String pengeluaran;
  final bool disembunyikan;
  final VoidCallback onMata;

  const KartuSaldo({
    super.key,
    required this.saldo,
    required this.pemasukan,
    required this.pengeluaran,
    required this.disembunyikan,
    required this.onMata,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle labelRedup = TeksApp.kecil.copyWith(
      color: WarnaApp.diAtasPrimerRedup,
    );

    return Container(
      padding: const EdgeInsets.all(JarakApp.j20),
      decoration: BoxDecoration(
        color: WarnaApp.primer,
        borderRadius: BorderRadius.circular(RadiusApp.kartuSaldo),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onMata,
            child: Row(
              children: [
                Text('Saldo', style: labelRedup),
                const SizedBox(width: JarakApp.j4),
                Icon(
                  disembunyikan ? LucideIcons.eyeOff : LucideIcons.eye,
                  size: 18,
                  color: WarnaApp.diAtasPrimer,
                ),
              ],
            ),
          ),
          const SizedBox(height: JarakApp.j4),
          Text(
            saldo,
            style: TeksApp.angkaBesar.copyWith(color: WarnaApp.diAtasPrimer),
          ),
          const SizedBox(height: JarakApp.j16),
          Row(
            children: [
              Expanded(
                child: _bangunArus(
                  LucideIcons.arrowDownLeft,
                  'Pemasukan',
                  pemasukan,
                  labelRedup,
                ),
              ),
              Expanded(
                child: _bangunArus(
                  LucideIcons.arrowUpRight,
                  'Pengeluaran',
                  pengeluaran,
                  labelRedup,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bangunArus(
    IconData ikon,
    String label,
    String nilai,
    TextStyle gaya,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(ikon, size: 14, color: WarnaApp.aksen),
            const SizedBox(width: JarakApp.j4),
            Text(label, style: gaya),
          ],
        ),
        const SizedBox(height: JarakApp.j4),
        Text(
          nilai,
          style: TeksApp.angka.copyWith(color: WarnaApp.diAtasPrimer),
        ),
      ],
    );
  }
}
