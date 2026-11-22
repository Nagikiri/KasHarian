import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/kategori.dart';
import '../theme/app_theme.dart';
import 'ikon_bulat.dart';

class PilihKategori extends StatelessWidget {
  final List<KategoriItem> daftar;
  final KategoriItem? terpilih;
  final void Function(KategoriItem kategori) onPilih;
  final VoidCallback? onTambahBaru;

  const PilihKategori({
    super.key,
    required this.daftar,
    required this.terpilih,
    required this.onPilih,
    this.onTambahBaru,
  });

  @override
  Widget build(BuildContext context) {
    final VoidCallback? tambahBaru = onTambahBaru;

    return SizedBox(
      height: 76,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (var k in daftar)
            _bangunItem(k.ikon, k.nama, k == terpilih, () => onPilih(k)),
          if (tambahBaru != null)
            _bangunItem(LucideIcons.plus, 'Baru', false, tambahBaru),
        ],
      ),
    );
  }

  Widget _bangunItem(
    IconData ikon,
    String nama,
    bool aktif,
    VoidCallback onTekan,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTekan,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            aktif
                ? _bangunLingkaranAktif(ikon)
                : IkonBulat(ikon: ikon, ukuran: 48),
            const SizedBox(height: JarakApp.j8),
            Text(
              nama,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: aktif
                  ? TeksApp.kecil.copyWith(
                      color: WarnaApp.primer,
                      fontWeight: FontWeight.w600,
                    )
                  : TeksApp.kecil,
            ),
          ],
        ),
      ),
    );
  }

  Widget _bangunLingkaranAktif(IconData ikon) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: WarnaApp.primer,
        shape: BoxShape.circle,
      ),
      child: Icon(ikon, size: 24, color: WarnaApp.diAtasPrimer),
    );
  }
}
