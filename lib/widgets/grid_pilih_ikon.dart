import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'ikon_bulat.dart';

class GridPilihIkon extends StatelessWidget {
  final List<IconData> daftarIkon;
  final IconData terpilih;
  final void Function(IconData ikon) onPilih;
  // Nama kecil di bawah setiap ikon, urutannya sama dengan daftarIkon. null = tanpa nama (kategori).
  final List<String>? label;

  const GridPilihIkon({
    super.key,
    required this.daftarIkon,
    required this.terpilih,
    required this.onPilih,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: JarakApp.j12,
      // Petak dibuat lebih tinggi kalau ada nama di bawah ikon.
      childAspectRatio: label == null ? 1.4 : 1.0,
      children: [
        for (int i = 0; i < daftarIkon.length; i++)
          _bangunOpsi(daftarIkon[i], label?[i]),
      ],
    );
  }

  Widget _bangunOpsi(IconData ikon, String? nama) {
    Widget lingkaran = ikon == terpilih
        ? Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: WarnaApp.primer,
              shape: BoxShape.circle,
            ),
            child: Icon(ikon, size: 24, color: WarnaApp.diAtasPrimer),
          )
        : IkonBulat(ikon: ikon, ukuran: 48);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onPilih(ikon),
      child: Center(
        child: nama == null
            ? lingkaran
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  lingkaran,
                  const SizedBox(height: JarakApp.j4),
                  Text(nama, style: TeksApp.mini),
                ],
              ),
      ),
    );
  }
}
