import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/mata_uang.dart';
import '../theme/app_theme.dart';
import '../utils/format_ribuan.dart';
import 'lingkaran_simbol.dart';

// Satu widget untuk kotak isian dan kotak hasil Hitung kurs, supaya ukurannya dijamin sama.
// controller diisi berarti kotak isian. onPilih null berarti mata uangnya tidak bisa diganti.
class KotakKurs extends StatelessWidget {
  final MataUang mataUang;
  final Color warnaLatar;
  final Color warnaAngka;
  final String angka;
  final TextEditingController? controller;
  final VoidCallback? onUbah;
  final VoidCallback? onPilih;

  const KotakKurs({
    super.key,
    required this.mataUang,
    required this.warnaLatar,
    required this.warnaAngka,
    this.angka = '',
    this.controller,
    this.onUbah,
    this.onPilih,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(JarakApp.j16),
      decoration: BoxDecoration(
        color: warnaLatar,
        borderRadius: BorderRadius.circular(RadiusApp.input),
      ),
      // Tinggi isi ditetapkan supaya kotak dengan TextField dan kotak dengan Text sama tinggi.
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            Expanded(
              // Angka panjang dikecilkan supaya tidak menabrak pemilih mata uang.
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: _bangunAngka(),
              ),
            ),
            const SizedBox(width: JarakApp.j12),
            _bangunPemilih(),
          ],
        ),
      ),
    );
  }

  Widget _bangunAngka() {
    TextStyle gaya = TeksApp.angkaBesar.copyWith(color: warnaAngka);
    TextEditingController? isian = controller;
    if (isian == null) return Text(angka, style: gaya);
    // IntrinsicWidth membuat lebar TextField mengikuti angkanya, jadi FittedBox bisa mengecilkannya.
    return IntrinsicWidth(
      child: TextField(
        controller: isian,
        keyboardType: TextInputType.number,
        inputFormatters: [FormatRibuan()],
        style: gaya,
        decoration: InputDecoration(
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: '0',
          hintStyle: gaya.copyWith(color: WarnaApp.teksRedup),
        ),
        onChanged: (_) => onUbah?.call(),
      ),
    );
  }

  Widget _bangunPemilih() {
    return GestureDetector(
      onTap: onPilih,
      child: Row(
        children: [
          LingkaranSimbol(simbol: mataUang.simbol, warnaLatar: WarnaApp.latar),
          const SizedBox(width: JarakApp.j8),
          Text(mataUang.kode, style: TeksApp.tombolKecil),
          // Tanpa chevron, ruangnya tetap disisakan supaya kode di kedua kotak sejajar.
          if (onPilih != null)
            const Icon(
              LucideIcons.chevronDown,
              size: 16,
              color: WarnaApp.teksKedua,
            )
          else
            const SizedBox(width: 16),
        ],
      ),
    );
  }
}
