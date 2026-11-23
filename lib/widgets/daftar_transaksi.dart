import 'package:flutter/material.dart';

import '../models/transaksi.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'baris_transaksi.dart';

// Daftar transaksi yang dikelompokkan per tanggal, terbaru di atas.
class DaftarTransaksi extends StatelessWidget {
  final List<CatatanTransaksi> daftar;
  final String teksKosong;
  final void Function(CatatanTransaksi transaksi) onTekan;

  const DaftarTransaksi({
    super.key,
    required this.daftar,
    required this.teksKosong,
    required this.onTekan,
  });

  bool _hariSama(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    if (daftar.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: JarakApp.j16),
        child: Text(teksKosong, style: TeksApp.kecil),
      );
    }

    List<CatatanTransaksi> urut = List.of(daftar);
    urut.sort((a, b) => b.tanggal.compareTo(a.tanggal));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < urut.length; i++) ...[
          // Judul tanggal hanya muncul di transaksi pertama setiap hari.
          if (i == 0 || !_hariSama(urut[i - 1].tanggal, urut[i].tanggal))
            _bangunJudulTanggal(urut[i].tanggal, urut)
          else
            const Divider(height: 1),
          BarisTransaksi(
            transaksi: urut[i],
            onTekan: () => onTekan(urut[i]),
            tampilkanTanggal: false,
          ),
        ],
      ],
    );
  }

  Widget _bangunJudulTanggal(DateTime tanggal, List<CatatanTransaksi> urut) {
    int keluar = 0;
    for (var t in urut) {
      bool pengeluaran = !t.isPemasukan && !t.isTransfer;
      if (pengeluaran && _hariSama(t.tanggal, tanggal)) keluar += t.nominal;
    }

    return Padding(
      padding: const EdgeInsets.only(top: JarakApp.j16, bottom: JarakApp.j4),
      child: Row(
        children: [
          Expanded(
            child: Text(formatTanggal(tanggal), style: TeksApp.tombolKecil),
          ),
          if (keluar > 0)
            Text('-${formatRupiah(keluar)}', style: TeksApp.kecil),
        ],
      ),
    );
  }
}
