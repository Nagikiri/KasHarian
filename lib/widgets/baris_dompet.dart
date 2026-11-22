import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../theme/app_theme.dart';
import 'kartu_dompet.dart';

// Dua kartu dompet untuk transfer: "Dari" di kiri, "Ke" di kanan.
class BarisDompet extends StatelessWidget {
  final String sumber;
  final String tujuan;
  final VoidCallback onDari;
  final VoidCallback onKe;

  const BarisDompet({
    super.key,
    required this.sumber,
    required this.tujuan,
    required this.onDari,
    required this.onKe,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: KartuDompet(
            label: 'Dari',
            nama: sumber,
            saldo: AppData.saldoSumber(sumber),
            onTekan: onDari,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: JarakApp.j8),
          child: Icon(
            LucideIcons.arrowRight,
            size: 20,
            color: WarnaApp.teksRedup,
          ),
        ),
        Expanded(
          child: KartuDompet(
            label: 'Ke',
            nama: tujuan,
            saldo: AppData.saldoSumber(tujuan),
            onTekan: onKe,
          ),
        ),
      ],
    );
  }
}
