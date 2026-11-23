import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'tombol_panah.dart';

// Mengembalikan bulan yang dipilih lewat Navigator.pop. batas = bulan terakhir yang boleh dipilih.
class DialogPilihBulan extends StatefulWidget {
  final DateTime awal;
  final DateTime? batas;

  const DialogPilihBulan({super.key, required this.awal, this.batas});

  @override
  State<DialogPilihBulan> createState() => _DialogPilihBulanState();
}

class _DialogPilihBulanState extends State<DialogPilihBulan> {
  // Pilihan sementara, baru dikirim saat tombol Pilih ditekan.
  late DateTime _pilihan = DateTime(widget.awal.year, widget.awal.month);
  late int _tahun = widget.awal.year;

  int get _tahunTerakhir => widget.batas?.year ?? 2030;

  bool _bolehDipilih(DateTime bulan) {
    DateTime? batas = widget.batas;
    if (batas == null) return true;
    return !bulan.isAfter(DateTime(batas.year, batas.month));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(JarakApp.tepiHalaman),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TombolPanah(
                  ikon: LucideIcons.chevronLeft,
                  onTekan: _tahun > 2024
                      ? () => setState(() => _tahun--)
                      : null,
                ),
                Text('$_tahun', style: TeksApp.judulSeksi),
                TombolPanah(
                  ikon: LucideIcons.chevronRight,
                  onTekan: _tahun < _tahunTerakhir
                      ? () => setState(() => _tahun++)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: JarakApp.j12),
            GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 2,
              mainAxisSpacing: JarakApp.j8,
              crossAxisSpacing: JarakApp.j8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (int b = 1; b <= 12; b++)
                  _bangunSelBulan(DateTime(_tahun, b)),
              ],
            ),
            const SizedBox(height: JarakApp.j12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _bangunTombolTeks('Batal', () => Navigator.pop(context)),
                _bangunTombolTeks(
                  'Pilih',
                  () => Navigator.pop(context, _pilihan),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bangunSelBulan(DateTime bulan) {
    bool boleh = _bolehDipilih(bulan);
    bool terpilih =
        bulan.year == _pilihan.year && bulan.month == _pilihan.month;
    // Bulan tanpa transaksi diredupkan, bulan di luar batas hampir tidak terlihat.
    Color warnaTeks = !boleh
        ? WarnaApp.garis
        : AppData.punyaTransaksi(bulan)
        ? WarnaApp.teksUtama
        : WarnaApp.teksRedup;

    return GestureDetector(
      onTap: boleh ? () => setState(() => _pilihan = bulan) : null,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: terpilih ? WarnaApp.primer : null,
          borderRadius: BorderRadius.circular(RadiusApp.pill),
        ),
        child: Text(
          namaBulan[bulan.month - 1],
          style: TeksApp.tombolKecil.copyWith(
            color: terpilih ? WarnaApp.diAtasPrimer : warnaTeks,
          ),
        ),
      ),
    );
  }

  Widget _bangunTombolTeks(String teks, VoidCallback onTekan) {
    return TextButton(
      onPressed: onTekan,
      child: Text(
        teks,
        style: TeksApp.tombolKecil.copyWith(color: WarnaApp.primer),
      ),
    );
  }
}
