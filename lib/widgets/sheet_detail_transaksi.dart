import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../models/transaksi.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'baris_transaksi.dart';
import 'dialog_konfirmasi_hapus.dart';
import 'ikon_bulat.dart';

class SheetDetailTransaksi extends StatelessWidget {
  final CatatanTransaksi transaksi;

  const SheetDetailTransaksi({super.key, required this.transaksi});

  String get _tipe {
    if (transaksi.isPemasukan) return 'Pemasukan';
    if (transaksi.isTransfer) return 'Transfer';
    return 'Pengeluaran';
  }

  Future<void> _konfirmasiHapus(BuildContext context) async {
    // Diambil sebelum sheet ditutup, karena context sheet tidak bisa dipakai setelah pop.
    final pesan = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    bool? hapus = await showDialog<bool>(
      context: context,
      builder: (context) =>
          const DialogKonfirmasiHapus(judul: 'Hapus transaksi ini?'),
    );
    if (hapus != true) return;
    AppData.hapusTransaksi(transaksi);
    navigator.pop();
    pesan.showSnackBar(const SnackBar(content: Text('Transaksi dihapus')));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          JarakApp.tepiHalaman,
          JarakApp.j24,
          JarakApp.tepiHalaman,
          JarakApp.j16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IkonBulat(ikon: transaksi.ikon, ukuran: 56),
            const SizedBox(height: JarakApp.j12),
            Text(
              BarisTransaksi.teksNominal(transaksi),
              style: TeksApp.angkaBesar.copyWith(
                color: BarisTransaksi.warnaNominal(transaksi),
              ),
            ),
            const SizedBox(height: JarakApp.j4),
            Text(
              transaksi.catatan,
              style: TeksApp.isi,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: JarakApp.j16),
            _bangunBaris('Kategori', transaksi.kategori),
            const Divider(height: 1),
            _bangunBaris('Tipe', _tipe),
            const Divider(height: 1),
            _bangunBaris('Sumber dana', transaksi.sumberDana),
            const Divider(height: 1),
            _bangunBaris('Tanggal', formatTanggalPanjang(transaksi.tanggal)),
            const SizedBox(height: JarakApp.j16),
            TextButton(
              onPressed: () => _konfirmasiHapus(context),
              child: Text(
                'Hapus transaksi',
                style: TeksApp.tombolKecil.copyWith(color: WarnaApp.bahaya),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bangunBaris(String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: JarakApp.j12),
      child: Row(
        children: [
          Text(label, style: TeksApp.kecil),
          const SizedBox(width: JarakApp.j16),
          Expanded(
            child: Text(nilai, style: TeksApp.isi, textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
