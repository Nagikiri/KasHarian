import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';
import 'ikon_bulat.dart';
import 'ikon_cincin.dart';
import 'progress_tipis.dart';

// Kartu grid yang dipakai Kantong alokasi dan Impianku. Angka sudah diformat oleh pemanggil.
class KartuProgress extends StatelessWidget {
  final IconData ikon;
  final int indeksWarna;
  final String persenTeks;
  final String judul;
  final String nominal;
  final String keterangan;
  final Color? warnaKeterangan;
  final double persen;
  final bool pakaiWarnaStatus;
  // true untuk Impian: kartu putih, progres berupa cincin di sekeliling ikon, tanpa bar.
  final bool pakaiCincin;
  final String? catatanBawah;
  final VoidCallback onTekan;

  const KartuProgress({
    super.key,
    required this.ikon,
    required this.indeksWarna,
    required this.persenTeks,
    required this.judul,
    required this.nominal,
    required this.keterangan,
    this.warnaKeterangan,
    required this.persen,
    this.pakaiWarnaStatus = true,
    this.pakaiCincin = false,
    this.catatanBawah,
    required this.onTekan,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius sudut = BorderRadius.circular(RadiusApp.input);
    Color tegas = WarnaApp.tegasKategori(indeksWarna);
    bool adaStatus = pakaiWarnaStatus && persen >= 0.8;
    // Di bawah 80% persen netral, jadi persen berwarna selalu berarti peringatan.
    Color warnaPersen = pakaiCincin ? WarnaApp.primer : WarnaApp.teksUtama;
    if (adaStatus) warnaPersen = warnaStatus(persen);

    return Material(
      color: pakaiCincin ? WarnaApp.latar : WarnaApp.latarKategori(indeksWarna),
      shape: RoundedRectangleBorder(
        borderRadius: sudut,
        side: pakaiCincin
            ? const BorderSide(color: WarnaApp.garis)
            : BorderSide.none,
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
                  _bangunIkon(tegas),
                  const Spacer(),
                  if (adaStatus) ...[
                    Icon(
                      LucideIcons.triangleAlert,
                      size: 14,
                      color: warnaPersen,
                    ),
                    const SizedBox(width: JarakApp.j4),
                  ],
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
              // Spacer mendorong kelompok bawah ke dasar kartu, jadi isi kartu sebelahan sejajar.
              const Spacer(),
              Text(nominal, style: TeksApp.angka),
              Text(
                keterangan,
                style: TeksApp.kecil.copyWith(color: warnaKeterangan),
              ),
              const SizedBox(height: JarakApp.j8),
              if (!pakaiCincin) ...[
                ProgressTipis(
                  persen: persen,
                  warna: adaStatus ? warnaPersen : tegas,
                ),
                const SizedBox(height: JarakApp.j8),
              ],
              // Teks kosong tetap memakan satu baris, supaya kartu tanpa catatan tetap sejajar.
              Text(catatanBawah ?? '', style: TeksApp.kecil),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bangunIkon(Color tegas) {
    if (pakaiCincin) {
      return IkonCincin(ikon: ikon, persen: persen, indeksWarna: indeksWarna);
    }
    return IkonBulat(
      ikon: ikon,
      warnaLatar: WarnaApp.lingkaranKategori(indeksWarna),
      warnaIkon: tegas,
    );
  }
}
