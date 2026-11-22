import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'tombol_panah.dart';

class SheetPilihBulan extends StatefulWidget {
  const SheetPilihBulan({super.key});

  @override
  State<SheetPilihBulan> createState() => _SheetPilihBulanState();
}

class _SheetPilihBulanState extends State<SheetPilihBulan> {
  // Pilihan sementara, baru disimpan ke AppData saat tombol Pilih ditekan.
  DateTime _pilihan = AppData.bulanDipilih;
  int _tahun = AppData.bulanDipilih.year;

  void _simpan() {
    AppData.bulanDipilih = _pilihan;
    AppData.refreshNotifier.value++;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  onTekan: _tahun < 2030
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
                _bangunTombolTeks('Pilih', _simpan),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bangunSelBulan(DateTime bulan) {
    bool terpilih =
        bulan.year == _pilihan.year && bulan.month == _pilihan.month;
    Color warnaTeks = AppData.punyaTransaksi(bulan)
        ? WarnaApp.teksUtama
        : WarnaApp.teksRedup;

    return GestureDetector(
      onTap: () => setState(() => _pilihan = bulan),
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
