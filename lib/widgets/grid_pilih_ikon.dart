import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'ikon_bulat.dart';

class GridPilihIkon extends StatelessWidget {
  final List<IconData> daftarIkon;
  final IconData terpilih;
  final void Function(IconData ikon) onPilih;

  const GridPilihIkon({
    super.key,
    required this.daftarIkon,
    required this.terpilih,
    required this.onPilih,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: JarakApp.j12,
      childAspectRatio: 1.4,
      children: [for (var ikon in daftarIkon) _bangunOpsi(ikon)],
    );
  }

  Widget _bangunOpsi(IconData ikon) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onPilih(ikon),
      child: Center(
        child: ikon == terpilih
            ? Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: WarnaApp.primer,
                  shape: BoxShape.circle,
                ),
                child: Icon(ikon, size: 24, color: WarnaApp.diAtasPrimer),
              )
            : IkonBulat(ikon: ikon, ukuran: 48),
      ),
    );
  }
}
