import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';

class BarisIsian extends StatelessWidget {
  final IconData ikon;
  final String label;
  final String nilai;
  final VoidCallback onTekan;
  final Color? warnaNilai;

  const BarisIsian({
    super.key,
    required this.ikon,
    required this.label,
    required this.nilai,
    required this.onTekan,
    this.warnaNilai,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTekan,
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            Icon(ikon, size: 20, color: WarnaApp.teksRedup),
            const SizedBox(width: JarakApp.j12),
            Text(label, style: TeksApp.isi),
            const SizedBox(width: JarakApp.j16),
            Expanded(
              child: Text(
                nilai,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: TeksApp.isi.copyWith(
                  color: warnaNilai ?? WarnaApp.teksKedua,
                ),
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
    );
  }
}
