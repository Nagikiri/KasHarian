import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../models/wishlist.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/privasi.dart';
import 'dialog_konfirmasi_hapus.dart';
import 'ikon_bulat.dart';
import 'progress_tipis.dart';
import 'tombol_utama.dart';

// Mengembalikan true lewat Navigator.pop kalau pengguna menekan "Tambah tabungan".
class SheetDetailImpian extends StatelessWidget {
  final WishlistItem impian;

  const SheetDetailImpian({super.key, required this.impian});

  Future<void> _konfirmasiHapus(BuildContext context) async {
    // Diambil sebelum dialog, karena context sheet tidak bisa dipakai setelah pop.
    final navigator = Navigator.of(context);
    bool? hapus = await showDialog<bool>(
      context: context,
      builder: (context) => const DialogKonfirmasiHapus(
        judul: 'Hapus impian ini?',
        pesan: 'Tabungan yang sudah tercatat tidak ikut dihapus.',
      ),
    );
    if (hapus != true) return;
    AppData.hapusWishlist(impian);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    double persen = impian.terkumpulIdr / impian.targetIdr;
    bool tercapai = impian.terkumpulIdr >= impian.targetIdr;
    int estimasi = AppData.estimasiBulanWishlist(impian);

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: IkonBulat(ikon: impian.ikon, ukuran: 56)),
            const SizedBox(height: JarakApp.j12),
            Text(
              impian.nama,
              style: TeksApp.judulHalaman,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: JarakApp.j16),
            _bangunBaris('Kategori', impian.kategori),
            const Divider(height: 1),
            if (impian.mataUang != 'IDR') ...[
              _bangunBaris(
                'Harga valas',
                sembunyikanNominal.value
                    ? '${impian.mataUang} ••••••'
                    : '${impian.mataUang} ${formatTitik(impian.hargaAsing)}',
              ),
              const Divider(height: 1),
            ],
            _bangunBaris('Target', rupiahTampil(impian.targetIdr)),
            const Divider(height: 1),
            _bangunBaris('Terkumpul', rupiahTampil(impian.terkumpulIdr)),
            const Divider(height: 1),
            // Estimasi 0 berarti budget 'Tabungan' belum ada.
            tercapai
                ? _bangunBaris('Status', 'Target tercapai')
                : _bangunBaris(
                    'Estimasi',
                    estimasi > 0
                        ? formatEstimasiBulan(estimasi)
                        : 'Belum ada anggaran Tabungan',
                  ),
            const SizedBox(height: JarakApp.j12),
            ProgressTipis(persen: persen, pakaiWarnaStatus: false, tebal: 8),
            const SizedBox(height: JarakApp.j24),
            if (!tercapai)
              TombolUtama(
                teks: 'Tambah tabungan',
                onTekan: () => Navigator.pop(context, true),
              ),
            TextButton(
              onPressed: () => _konfirmasiHapus(context),
              child: Text(
                'Hapus impian',
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
