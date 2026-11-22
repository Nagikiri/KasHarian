import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/format.dart';

class TampilanNominal extends StatelessWidget {
  final String label;
  final int nominal;
  final String prefix;

  const TampilanNominal({
    super.key,
    required this.label,
    required this.nominal,
    this.prefix = 'Rp',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TeksApp.kecil),
        const SizedBox(height: JarakApp.j4),
        // Angka 10 digit bisa lebih lebar dari layar HP kecil, jadi dikecilkan otomatis.
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            '$prefix ${formatTitik(nominal)}',
            style: TeksApp.angkaBesar.copyWith(
              color: nominal == 0 ? WarnaApp.teksRedup : null,
            ),
          ),
        ),
      ],
    );
  }
}
