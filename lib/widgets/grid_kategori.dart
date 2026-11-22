import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/kategori.dart';
import '../theme/app_theme.dart';
import 'ikon_bulat.dart';

class GridKategori extends StatelessWidget {
  final List<KategoriItem> daftar;
  final KategoriItem? terpilih;
  final void Function(KategoriItem kategori) onPilih;
  final VoidCallback? onAtur;
  final bool shrinkWrap;

  const GridKategori({
    super.key,
    required this.daftar,
    required this.terpilih,
    required this.onPilih,
    this.onAtur,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: shrinkWrap,
      padding: const EdgeInsets.symmetric(
        horizontal: JarakApp.tepiHalaman,
        vertical: JarakApp.j12,
      ),
      // Tinggi tetap: lingkaran 52 + jarak + dua baris nama.
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisExtent: 96,
        crossAxisSpacing: JarakApp.j8,
        mainAxisSpacing: JarakApp.j12,
      ),
      itemCount: daftar.length + (onAtur == null ? 0 : 1),
      itemBuilder: (context, i) {
        // Kalau onAtur diisi, tile terakhir adalah "Atur" untuk membuka Pengaturan Kategori.
        if (i == daftar.length) {
          return _bangunTile(LucideIcons.settings2, 'Atur', false, onAtur!);
        }
        KategoriItem k = daftar[i];
        return _bangunTile(k.ikon, k.nama, k == terpilih, () => onPilih(k));
      },
    );
  }

  Widget _bangunTile(
    IconData ikon,
    String nama,
    bool aktif,
    VoidCallback onTekan,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTekan,
      child: Column(
        children: [
          aktif
              ? Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: WarnaApp.primer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(ikon, size: 26, color: WarnaApp.diAtasPrimer),
                )
              : IkonBulat(ikon: ikon, ukuran: 52),
          const SizedBox(height: JarakApp.j8),
          Text(
            nama,
            maxLines: 2,
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
    );
  }
}
