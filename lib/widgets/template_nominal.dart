import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';
import 'tombol_pill.dart';

// Chip dibagi rata selebar baris, jadi tidak perlu digeser dan semua label terbaca.
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
    return Row(
      children: [
        for (int i = 0; i < daftarNilai.length; i++) ...[
          Expanded(
            child: TombolPill(
              teks: daftarLabel[i],
              kecil: true,
              rapat: true,
              onTekan: () => onTambah(daftarNilai[i]),
            ),
          ),
          const SizedBox(width: JarakApp.j4),
        ],
        Expanded(child: _bangunHapus()),
      ],
    );
  }

  Widget _bangunHapus() {
    return Tooltip(
      message: 'Hapus nominal',
      child: Material(
        color: WarnaApp.latarSeksi,
        borderRadius: BorderRadius.circular(RadiusApp.pill),
        child: InkWell(
          onTap: onReset,
          borderRadius: BorderRadius.circular(RadiusApp.pill),
          child: const SizedBox(
            height: 28,
            child: Icon(LucideIcons.x, size: 16, color: WarnaApp.teksUtama),
          ),
        ),
      ),
    );
  }
}
