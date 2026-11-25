import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/privasi.dart';

// Baris "Dompet" di halaman +. Saldo dompet ikut tombol mata di Beranda.
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
    return InkWell(
      onTap: onTekan,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: JarakApp.j8),
          child: Row(
            children: [
              Icon(
                AppData.ikonDompet(sumber),
                size: 20,
                color: WarnaApp.teksRedup,
              ),
              const SizedBox(width: JarakApp.j12),
              const Text('Dompet', style: TeksApp.isi),
              const SizedBox(width: JarakApp.j16),
              // Nama dan saldo boleh turun baris supaya tidak terpotong.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(sumber, style: TeksApp.isi, textAlign: TextAlign.end),
                    Text(
                      rupiahTampil(AppData.saldoSumber(sumber)),
                      style: TeksApp.kecil,
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: JarakApp.j4),
              const Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: WarnaApp.teksRedup,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
