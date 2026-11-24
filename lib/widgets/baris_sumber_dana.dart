import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../utils/privasi.dart';
import 'baris_isian.dart';

// Baris "Sumber dana" di halaman +. Saldo dompet ikut tombol mata di Beranda.
class BarisSumberDana extends StatelessWidget {
  final String sumber;
  final VoidCallback onTekan;

  const BarisSumberDana({
    super.key,
    required this.sumber,
    required this.onTekan,
  });

  @override
  Widget build(BuildContext context) {
    return BarisIsian(
      ikon: LucideIcons.wallet,
      label: 'Sumber dana',
      nilai: '$sumber · ${rupiahTampil(AppData.saldoSumber(sumber))}',
      onTekan: onTekan,
    );
  }
}
