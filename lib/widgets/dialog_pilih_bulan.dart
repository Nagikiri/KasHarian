import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/periode.dart';
import 'tombol_panah.dart';
import 'tombol_teks.dart';

// Mengembalikan bulan yang dipilih lewat Navigator.pop. Bulan di luar batas tidak bisa dipilih.
class DialogPilihBulan extends StatefulWidget {
  final DateTime awal;
  final DateTime batasAwal;
  final DateTime batasAkhir;

  const DialogPilihBulan({
    super.key,
    required this.awal,
    required this.batasAwal,
    required this.batasAkhir,
  });

  @override
  State<DialogPilihBulan> createState() => _DialogPilihBulanState();
}

class _DialogPilihBulanState extends State<DialogPilihBulan> {
  // Pilihan sementara, baru dikirim saat tombol Pilih ditekan.
  late DateTime _pilihan = _bulanAwal();
  late int _tahun = _pilihan.year;

  DateTime _bulanAwal() {
    DateTime t = tahanTanggal(widget.awal, widget.batasAwal, widget.batasAkhir);
    return DateTime(t.year, t.month);
  }

  bool _bolehDipilih(DateTime bulan) {
    DateTime awal = DateTime(widget.batasAwal.year, widget.batasAwal.month);
    DateTime akhir = DateTime(widget.batasAkhir.year, widget.batasAkhir.month);
    return !bulan.isBefore(awal) && !bulan.isAfter(akhir);
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
                  onTekan: _tahun > widget.batasAwal.year
                      ? () => setState(() => _tahun--)
                      : null,
                ),
                Text('$_tahun', style: TeksApp.judulSeksi),
                TombolPanah(
                  ikon: LucideIcons.chevronRight,
                  onTekan: _tahun < widget.batasAkhir.year
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
                TombolTeks(
                  teks: 'Batal',
                  onTekan: () => Navigator.pop(context),
                ),
                TombolTeks(
                  teks: 'Pilih',
                  onTekan: () => Navigator.pop(context, _pilihan),
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
}
