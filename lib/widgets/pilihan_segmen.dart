import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PilihanSegmen extends StatelessWidget {
  final List<String> pilihan;
  final int indeksAktif;
  final void Function(int indeks) onPilih;

  const PilihanSegmen({
    super.key,
    required this.pilihan,
    required this.indeksAktif,
    required this.onPilih,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(JarakApp.j4),
      decoration: BoxDecoration(
        color: WarnaApp.latarSeksi,
        borderRadius: BorderRadius.circular(RadiusApp.input),
      ),
      child: Row(
        children: [
          for (int i = 0; i < pilihan.length; i++)
            Expanded(child: _bangunItem(i)),
        ],
      ),
    );
  }

  Widget _bangunItem(int indeks) {
    bool aktif = indeks == indeksAktif;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onPilih(indeks),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: JarakApp.j8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: aktif ? WarnaApp.latar : null,
          border: aktif ? Border.all(color: WarnaApp.garis) : null,
          borderRadius: BorderRadius.circular(RadiusApp.input),
        ),
        child: Text(
          pilihan[indeks],
          style: TeksApp.tombolKecil.copyWith(
            color: aktif ? WarnaApp.primer : WarnaApp.teksRedup,
          ),
        ),
      ),
    );
  }
}
