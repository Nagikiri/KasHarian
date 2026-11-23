import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../models/wishlist.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'ikon_cincin.dart';

// Versi baris untuk "Impian terdekat" di Beranda. Impian yang sudah tercapai tidak tampil di sana.
class KartuImpian extends StatelessWidget {
  final WishlistItem impian;
  // Ikut tombol mata saldo di Beranda. Persen dan estimasi tetap tampil.
  final bool sembunyikanNominal;

  const KartuImpian({
    super.key,
    required this.impian,
    this.sembunyikanNominal = false,
  });

  String _uang(String kode, String nilai) =>
      sembunyikanNominal ? '$kode ••••••' : '$kode $nilai';

  @override
  Widget build(BuildContext context) {
    double persen = impian.terkumpulIdr / impian.targetIdr;
    int estimasi = AppData.estimasiBulanWishlist(impian);

    // Cincin sudah menunjukkan progres, jadi tidak ada bar lagi di sini.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IkonCincin(
          ikon: impian.ikon,
          persen: persen,
          indeksWarna: AppData.indeksWarnaImpian(impian.kategori),
        ),
        const SizedBox(width: JarakApp.j12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(impian.nama, style: TeksApp.judulSeksi)),
                  const SizedBox(width: JarakApp.j8),
                  Text(
                    '${(persen * 100).floor()}%',
                    style: TeksApp.angka.copyWith(color: WarnaApp.primer),
                  ),
                ],
              ),
              const SizedBox(height: JarakApp.j4),
              Text(
                _uang('Rp', formatTitik(impian.targetIdr)),
                style: TeksApp.angka,
              ),
              if (impian.mataUang != 'IDR')
                Text(
                  _uang(impian.mataUang, formatTitik(impian.hargaAsing)),
                  style: TeksApp.kecil,
                ),
              const SizedBox(height: JarakApp.j8),
              Text(
                '${_uang('Rp', formatTitik(impian.terkumpulIdr))} terkumpul',
                style: TeksApp.isi.copyWith(color: WarnaApp.teksUtama),
              ),
              // Estimasi 0 berarti budget 'Tabungan' belum ada.
              if (estimasi > 0) ...[
                const SizedBox(height: JarakApp.j4),
                Text(formatEstimasiBulan(estimasi), style: TeksApp.kecil),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
