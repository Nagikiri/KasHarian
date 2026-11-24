import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/mata_uang.dart';
import '../theme/app_theme.dart';
import '../utils/format_ribuan.dart';
import 'lingkaran_simbol.dart';

// Kotak isian Hitung kurs. onPilih null berarti mata uangnya tidak bisa diganti (Rupiah).
class KotakInputKurs extends StatelessWidget {
  final MataUang mataUang;
  final TextEditingController controller;
  final VoidCallback? onPilih;
  final VoidCallback onUbah;

  const KotakInputKurs({
    super.key,
    required this.mataUang,
    required this.controller,
    required this.onPilih,
    required this.onUbah,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: JarakApp.j16,
        vertical: JarakApp.j12,
      ),
      decoration: BoxDecoration(
        color: WarnaApp.latarSeksi,
        borderRadius: BorderRadius.circular(RadiusApp.input),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPilih,
            child: Row(
              children: [
                LingkaranSimbol(simbol: mataUang.simbol),
                const SizedBox(width: JarakApp.j8),
                Text(mataUang.kode, style: TeksApp.tombolKecil),
                if (onPilih != null)
                  const Icon(
                    LucideIcons.chevronDown,
                    size: 16,
                    color: WarnaApp.teksKedua,
                  ),
              ],
            ),
          ),
          const SizedBox(width: JarakApp.j12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FormatRibuan()],
              textAlign: TextAlign.end,
              style: TeksApp.angkaBesar,
              // Latar abu sudah dari kotak ini, jadi isian dibuat polos.
              decoration: const InputDecoration(
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: '0',
              ),
              onChanged: (_) => onUbah(),
            ),
          ),
        ],
      ),
    );
  }
}
