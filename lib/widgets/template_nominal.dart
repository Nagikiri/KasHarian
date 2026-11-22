import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'tombol_pill.dart';

class TemplateNominal extends StatelessWidget {
  final void Function(int tambahan) onTambah;
  final VoidCallback onReset;
  final List<int> daftarNilai;
  final List<String> daftarLabel;

  const TemplateNominal({
    super.key,
    required this.onTambah,
    required this.onReset,
    this.daftarNilai = const [10000, 50000, 100000, 500000],
    this.daftarLabel = const ['+10rb', '+50rb', '+100rb', '+500rb'],
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < daftarNilai.length; i++) ...[
            TombolPill(
              teks: daftarLabel[i],
              kecil: true,
              onTekan: () => onTambah(daftarNilai[i]),
            ),
            const SizedBox(width: JarakApp.j8),
          ],
          TombolPill(teks: 'Reset', kecil: true, onTekan: onReset),
        ],
      ),
    );
  }
}
