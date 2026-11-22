import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/kategori.dart';
import '../theme/app_theme.dart';
import 'ikon_bulat.dart';

// 5 slot sama lebar: 4 kategori lalu tile "Lainnya" untuk membuka grid lengkap.
class BarisKategori extends StatelessWidget {
  final List<KategoriItem> daftar;
  final KategoriItem? terpilih;
  final void Function(KategoriItem kategori) onPilih;
  final VoidCallback onLainnya;

  const BarisKategori({
    super.key,
    required this.daftar,
    required this.terpilih,
    required this.onPilih,
    required this.onLainnya,
  });

  @override
  Widget build(BuildContext context) {
    final KategoriItem? pilihan = terpilih;
    List<KategoriItem> tampil = daftar.take(4).toList();
    // Kategori yang dipilih lewat "Lainnya" menggantikan slot terakhir supaya tetap terlihat.
    if (pilihan != null && !tampil.contains(pilihan)) {
      if (tampil.length == 4) tampil.removeLast();
      tampil.add(pilihan);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < 4; i++)
          Expanded(
            child: i < tampil.length
                ? _bangunTile(
                    tampil[i].ikon,
                    tampil[i].nama,
                    tampil[i] == pilihan,
                    () => onPilih(tampil[i]),
                  )
                : const SizedBox(),
          ),
        Expanded(
          child: _bangunTile(LucideIcons.plus, 'Lainnya', false, onLainnya),
        ),
      ],
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
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: WarnaApp.primer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(ikon, size: 24, color: WarnaApp.diAtasPrimer),
                )
              : IkonBulat(ikon: ikon, ukuran: 48),
          const SizedBox(height: JarakApp.j8),
          Text(
            nama,
            maxLines: 2,
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
