import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../theme/app_theme.dart';

// Kotak hasil Hitung kurs. onPilih diisi saat arah Rupiah ke asing, karena mata uangnya ada di sini.
class KotakHasilKurs extends StatelessWidget {
  final String hasil;
  final String kode;
  final VoidCallback? onPilih;

  const KotakHasilKurs({
    super.key,
    required this.hasil,
    required this.kode,
    required this.onPilih,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(JarakApp.j16),
      decoration: BoxDecoration(
        color: WarnaApp.aksenLembut,
        borderRadius: BorderRadius.circular(RadiusApp.input),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Setara dengan', style: TeksApp.kecil),
              ),
              if (onPilih != null) _bangunPilih(),
            ],
          ),
          const SizedBox(height: JarakApp.j4),
          // Angka besar dikecilkan kalau tidak muat, bukan dipotong.
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              hasil,
              style: TeksApp.angkaBesar.copyWith(color: WarnaApp.primer),
            ),
          ),
          const SizedBox(height: JarakApp.j4),
          Text(
            '1 $kode = ${AppData.teksKursRupiah(kode)}',
            style: TeksApp.kecil,
          ),
        ],
      ),
    );
  }

  Widget _bangunPilih() {
    return GestureDetector(
      onTap: onPilih,
      child: Row(
        children: [
          Text(
            kode,
            style: TeksApp.tombolKecil.copyWith(color: WarnaApp.primer),
          ),
          const Icon(LucideIcons.chevronDown, size: 16, color: WarnaApp.primer),
        ],
      ),
    );
  }
}
