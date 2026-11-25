import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../theme/app_theme.dart';
import 'dialog_info.dart';

// Baris bawah yang sama persis di kartu Kurs Beranda dan Hitung kurs.
class BarisInfoKurs extends StatelessWidget {
  final bool sedangMemuat;
  final VoidCallback onPerbarui;

  const BarisInfoKurs({
    super.key,
    required this.sedangMemuat,
    required this.onPerbarui,
  });

  void _bukaSumber(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => const DialogInfo(
        ikon: LucideIcons.info,
        judul: 'Sumber data kurs',
        pesan: 'Rates By Exchange Rate API',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool gagal = !sedangMemuat && !AppData.kursLive;
    return Row(
      children: [
        Expanded(
          child: Text(
            AppData.teksInfoKurs(sedangMemuat: sedangMemuat),
            style: TeksApp.kecil.copyWith(
              color: gagal ? WarnaApp.peringatan : null,
            ),
          ),
        ),
        const SizedBox(width: JarakApp.j12),
        GestureDetector(
          onTap: () => _bukaSumber(context),
          child: const Icon(
            LucideIcons.info,
            size: 18,
            color: WarnaApp.teksKedua,
          ),
        ),
        const SizedBox(width: JarakApp.j16),
        _bangunRefresh(),
      ],
    );
  }

  Widget _bangunRefresh() {
    if (sedangMemuat) {
      return const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: WarnaApp.primer,
        ),
      );
    }
    return GestureDetector(
      onTap: onPerbarui,
      child: const Icon(
        LucideIcons.refreshCw,
        size: 18,
        color: WarnaApp.teksKedua,
      ),
    );
  }
}
