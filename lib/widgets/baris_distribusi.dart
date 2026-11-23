import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'ikon_bulat.dart';

class BarisDistribusi extends StatelessWidget {
  final IconData ikon;
  final String nama;
  final int nominal;
  final double persen;
  final Color? warnaTitik;

  const BarisDistribusi({
    super.key,
    required this.ikon,
    required this.nama,
    required this.nominal,
    required this.persen,
    this.warnaTitik,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: JarakApp.j12),
      child: Row(
        children: [
          if (warnaTitik != null) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: warnaTitik,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: JarakApp.j8),
          ],
          IkonBulat(ikon: ikon),
          const SizedBox(width: JarakApp.j12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nama, style: TeksApp.isi),
                const SizedBox(height: JarakApp.j4),
                Text('${(persen * 100).round()}%', style: TeksApp.kecil),
              ],
            ),
          ),
          Text(formatRupiah(nominal), style: TeksApp.angka),
        ],
      ),
    );
  }
}
