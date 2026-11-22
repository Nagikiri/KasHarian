import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'ikon_bulat.dart';
import 'progress_tipis.dart';

// Kartu grid yang dipakai Kantong alokasi dan Impianku. Angka sudah diformat oleh pemanggil.
class KartuProgress extends StatelessWidget {
  final IconData ikon;
  final String persenTeks;
  final String judul;
  final String nominal;
  final String keterangan;
  final Color? warnaKeterangan;
  final double persen;
  final bool pakaiWarnaStatus;
  final String? catatanBawah;
  final VoidCallback onTekan;

  const KartuProgress({
    super.key,
    required this.ikon,
    required this.persenTeks,
    required this.judul,
    required this.nominal,
    required this.keterangan,
    this.warnaKeterangan,
    required this.persen,
    this.pakaiWarnaStatus = true,
    this.catatanBawah,
    required this.onTekan,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius sudut = BorderRadius.circular(RadiusApp.input);
    Color warnaPersen = pakaiWarnaStatus
        ? warnaStatus(persen)
        : WarnaApp.primer;

    return Material(
      color: WarnaApp.latar,
      shape: RoundedRectangleBorder(
        borderRadius: sudut,
        side: const BorderSide(color: WarnaApp.garis),
      ),
      child: InkWell(
        onTap: onTekan,
        borderRadius: sudut,
        child: Padding(
          padding: const EdgeInsets.all(JarakApp.dalamKartu),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IkonBulat(ikon: ikon),
                  const Spacer(),
                  Text(
                    persenTeks,
                    style: TeksApp.angka.copyWith(color: warnaPersen),
                  ),
                ],
              ),
              const SizedBox(height: JarakApp.j12),
              Text(
                judul,
                style: TeksApp.isi,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // Spacer mendorong kelompok bawah ke dasar kartu, jadi progress kartu sebelahan sejajar.
              const Spacer(),
              Text(nominal, style: TeksApp.angka),
              Text(
                keterangan,
                style: TeksApp.kecil.copyWith(color: warnaKeterangan),
              ),
              const SizedBox(height: JarakApp.j8),
              ProgressTipis(persen: persen, pakaiWarnaStatus: pakaiWarnaStatus),
              const SizedBox(height: JarakApp.j8),
              // Teks kosong tetap memakan satu baris, supaya kartu tanpa catatan tetap sejajar.
              Text(catatanBawah ?? '', style: TeksApp.kecil),
            ],
          ),
        ),
      ),
    );
  }
}
