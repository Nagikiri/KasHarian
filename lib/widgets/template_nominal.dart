import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'tombol_pill.dart';

class TemplateNominal extends StatelessWidget {
  final void Function(int tambahan) onTambah;
  final VoidCallback onReset;

  const TemplateNominal({
    super.key,
    required this.onTambah,
    required this.onReset,
  });

  static const List<int> _pilihan = [10000, 50000, 100000, 500000];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int nilai in _pilihan) ...[
            TombolPill(
              teks: '+${nilai ~/ 1000}rb',
              kecil: true,
              onTekan: () => onTambah(nilai),
            ),
            const SizedBox(width: JarakApp.j8),
          ],
          TombolPill(teks: 'Reset', kecil: true, onTekan: onReset),
        ],
      ),
    );
  }
}
