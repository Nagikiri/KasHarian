import 'package:flutter/material.dart';

import '../models/transaksi.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/privasi.dart';
import 'ikon_bulat.dart';

class BarisTransaksi extends StatelessWidget {
  final CatatanTransaksi transaksi;
  final VoidCallback? onTekan;
  // false kalau daftarnya sudah dikelompokkan per tanggal, supaya tanggal tidak tertulis dua kali.
  final bool tampilkanTanggal;
  // true untuk Transaksi terbaru, karena Beranda selalu ikut tombol mata.
  final bool diBeranda;

  const BarisTransaksi({
    super.key,
    required this.transaksi,
    this.onTekan,
    this.tampilkanTanggal = true,
    this.diBeranda = false,
  });

  // Transfer hanya memindahkan uang antar-kantong, jadi tanpa tanda + atau -.
  static String teksNominal(CatatanTransaksi t, {bool diBeranda = false}) {
    String tanda = '';
    if (t.isPemasukan) {
      tanda = '+';
    } else if (!t.isTransfer) {
      tanda = '-';
    }
    String nominal = diBeranda
        ? rupiahBeranda(t.nominal)
        : rupiahTampil(t.nominal);
    return '$tanda$nominal';
  }

  // Merah hanya untuk peringatan, jadi uang keluar biasa cukup teksUtama dengan tanda -.
  static Color warnaNominal(CatatanTransaksi t) {
    if (t.isPemasukan) return WarnaApp.primer;
    if (t.isTransfer) return WarnaApp.teksKedua;
    return WarnaApp.teksUtama;
  }

  // Transfer menampilkan arah perpindahan uang, transaksi lain menampilkan kategori.
  String get _subjudul {
    if (transaksi.isTransfer && transaksi.sumberTujuan != null) {
      return '${transaksi.sumberDana} → ${transaksi.sumberTujuan}';
    }
    return '${transaksi.kategori} · ${transaksi.sumberDana}';
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
                  _subjudul,
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
                teksNominal(transaksi, diBeranda: diBeranda),
                style: TeksApp.angka.copyWith(color: warnaNominal(transaksi)),
              ),
              if (tampilkanTanggal) ...[
                const SizedBox(height: JarakApp.j4),
                Text(
                  formatTanggalPendek(transaksi.tanggal),
                  style: TeksApp.kecil,
                ),
              ],
            ],
          ),
        ],
      ),
    );

    if (onTekan == null) return isi;
    return InkWell(onTap: onTekan, child: isi);
  }
}
