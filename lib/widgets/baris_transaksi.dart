import 'package:flutter/material.dart';

import '../models/transaksi.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'ikon_bulat.dart';

class BarisTransaksi extends StatelessWidget {
  final CatatanTransaksi transaksi;

  const BarisTransaksi({super.key, required this.transaksi});

  @override
  Widget build(BuildContext context) {
    // Transfer hanya memindahkan uang antar-kantong, jadi tanpa tanda + atau -.
    String tanda = '';
    Color warnaNominal = WarnaApp.teksKedua;
    if (transaksi.isPemasukan) {
      tanda = '+';
      warnaNominal = WarnaApp.primer;
    } else if (!transaksi.isTransfer) {
      tanda = '-';
      warnaNominal = WarnaApp.bahaya;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: JarakApp.j12),
      child: Row(
        children: [
          IkonBulat(ikon: transaksi.ikon),
          const SizedBox(width: JarakApp.j12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaksi.catatan,
                  style: TeksApp.isi,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: JarakApp.j4),
                Text(
                  '${transaksi.kategori} · ${transaksi.sumberDana}',
                  style: TeksApp.kecil,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: JarakApp.j12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${tanda}Rp ${formatTitik(transaksi.nominal)}',
                style: TeksApp.angka.copyWith(color: warnaNominal),
              ),
              const SizedBox(height: JarakApp.j4),
              Text(
                formatTanggalPendek(transaksi.tanggal),
                style: TeksApp.kecil,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
