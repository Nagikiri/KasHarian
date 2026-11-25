import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/privasi.dart';
import 'ikon_bulat.dart';

class KartuDompet extends StatelessWidget {
  final String label;
  final String nama;
  final int saldo;
  final VoidCallback onTekan;

  const KartuDompet({
    super.key,
    required this.label,
    required this.nama,
    required this.saldo,
    required this.onTekan,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: WarnaApp.latarSeksi,
      borderRadius: BorderRadius.circular(RadiusApp.input),
      child: InkWell(
        onTap: onTekan,
        borderRadius: BorderRadius.circular(RadiusApp.input),
        child: Padding(
          padding: const EdgeInsets.all(JarakApp.dalamKartu),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TeksApp.kecil),
              const SizedBox(height: JarakApp.j8),
              IkonBulat(ikon: AppData.ikonDompet(nama)),
              const SizedBox(height: JarakApp.j8),
              // Nama boleh turun baris supaya tidak terpotong di layar sempit.
              Text(nama, style: TeksApp.tombolKecil),
              const SizedBox(height: JarakApp.j4),
              Text(rupiahTampil(saldo), style: TeksApp.kecil),
            ],
          ),
        ),
      ),
    );
  }
}
