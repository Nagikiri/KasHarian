import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';
import '../utils/format.dart';

// Header hijau Beranda. Angka sudah diformat (dan disembunyikan) oleh pemanggil.
class HeaderBeranda extends StatelessWidget {
  final String saldo;
  final String pemasukan;
  final String pengeluaran;
  final bool disembunyikan;
  final VoidCallback onMata;
  // Kartu navigasi yang separuh bawahnya keluar dari latar hijau.
  final Widget bawah;

  const HeaderBeranda({
    super.key,
    required this.saldo,
    required this.pemasukan,
    required this.pengeluaran,
    required this.disembunyikan,
    required this.onMata,
    required this.bawah,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle labelRedup = TeksApp.kecil.copyWith(
      color: WarnaApp.diAtasPrimerRedup,
    );

    // Tinggi Stack mengikuti isinya, latar hijau saja yang berhenti 48 sebelum dasar.
    return Stack(
      children: [
        const Positioned.fill(
          bottom: JarakApp.tumpukanHeader,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: WarnaApp.primer,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(RadiusApp.header),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            JarakApp.tepiHalaman,
            JarakApp.j16,
            JarakApp.tepiHalaman,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KasHarian',
                style: TeksApp.judulHalaman.copyWith(
                  color: WarnaApp.diAtasPrimer,
                ),
              ),
              const SizedBox(height: JarakApp.j4),
              Text(formatTanggal(DateTime.now()), style: labelRedup),
              const SizedBox(height: JarakApp.j24),
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
                style: TeksApp.angkaBesar.copyWith(
                  color: WarnaApp.diAtasPrimer,
                ),
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
              const SizedBox(height: JarakApp.j24),
              bawah,
            ],
          ),
        ),
      ],
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
