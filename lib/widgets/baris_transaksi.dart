import 'package:flutter/material.dart';

import '../models/transaksi.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'ikon_bulat.dart';

class BarisTransaksi extends StatelessWidget {
  final CatatanTransaksi transaksi;
  final VoidCallback? onTekan;

  const BarisTransaksi({super.key, required this.transaksi, this.onTekan});

  // Transfer hanya memindahkan uang antar-kantong, jadi tanpa tanda + atau -.
  static String teksNominal(CatatanTransaksi t) {
    String tanda = '';
    if (t.isPemasukan) {
      tanda = '+';
    } else if (!t.isTransfer) {
      tanda = '-';
    }
    return '${tanda}Rp ${formatTitik(t.nominal)}';
  }

  static Color warnaNominal(CatatanTransaksi t) {
    if (t.isPemasukan) return WarnaApp.primer;
    if (t.isTransfer) return WarnaApp.teksKedua;
    return WarnaApp.bahaya;
  }

  @override
  Widget build(BuildContext context) {
    Widget isi = Padding(
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
                teksNominal(transaksi),
                style: TeksApp.angka.copyWith(color: warnaNominal(transaksi)),
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

    if (onTekan == null) return isi;
    return InkWell(onTap: onTekan, child: isi);
  }
}
