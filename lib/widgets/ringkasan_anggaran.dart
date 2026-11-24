import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/privasi.dart';
import 'kolom_angka.dart';
import 'lingkaran_anggaran.dart';

// Lingkaran anggaran di Ringkasan mode Bulan, untuk bulan dari tanggal acuan.
class RingkasanAnggaran extends StatelessWidget {
  final DateTime bulan;

  const RingkasanAnggaran({super.key, required this.bulan});

  @override
  Widget build(BuildContext context) {
    int anggaran = AppData.anggaranBulanan;
    int terpakai = AppData.terpakaiAnggaran(bulan);
    int sisa = anggaran - terpakai;
    // Anggaran 0 tidak bisa dibagi, jadi persennya dianggap 0.
    double persen = anggaran > 0 ? terpakai / anggaran : 0;

    return Row(
      children: [
        LingkaranAnggaran(persen: persen),
        const SizedBox(width: JarakApp.j24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KolomAngka(label: 'Terpakai', nilai: rupiahTampil(terpakai)),
              const SizedBox(height: JarakApp.j8),
              KolomAngka(label: 'Anggaran', nilai: rupiahTampil(anggaran)),
              const SizedBox(height: JarakApp.j8),
              // Budget adalah rencana, jadi kelebihan ditulis positif, bukan "Sisa -Rp".
              KolomAngka(
                label: sisa < 0 ? 'Lebih' : 'Sisa',
                nilai: rupiahTampil(sisa.abs()),
                warnaNilai: sisa < 0 ? WarnaApp.bahaya : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
