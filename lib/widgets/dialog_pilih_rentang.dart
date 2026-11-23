import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/periode.dart';
import 'baris_isian.dart';
import 'kalender.dart';
import 'tombol_pill.dart';
import 'tombol_teks.dart';

// Mengembalikan DateTimeRange lewat Navigator.pop. end = hari terakhir (ikut dihitung).
class DialogPilihRentang extends StatefulWidget {
  final DateTime mulai;
  final DateTime selesai;
  final DateTime batasAwal;
  final DateTime batasAkhir;

  const DialogPilihRentang({
    super.key,
    required this.mulai,
    required this.selesai,
    required this.batasAwal,
    required this.batasAkhir,
  });

  @override
  State<DialogPilihRentang> createState() => _DialogPilihRentangState();
}

class _DialogPilihRentangState extends State<DialogPilihRentang> {
  late DateTime _mulai = _tahan(widget.mulai);
  late DateTime _selesai = _tahan(widget.selesai);

  // Jam dibuang supaya perbandingan tanggal tidak terganggu jam.
  DateTime _tahan(DateTime t) {
    DateTime hasil = tahanTanggal(t, widget.batasAwal, widget.batasAkhir);
    return DateTime(hasil.year, hasil.month, hasil.day);
  }

  String _teks(DateTime t) => '${formatTanggalPendek(t)} ${t.year}';

  Future<void> _pilihMulai() async {
    DateTime? hasil = await bukaKalender(
      context,
      awal: _mulai,
      batasAwal: widget.batasAwal,
      batasAkhir: widget.batasAkhir,
      judul: 'Waktu mulai',
    );
    if (hasil == null) return;
    setState(() {
      _mulai = hasil;
      // Selesai tidak boleh sebelum mulai, jadi ikut digeser.
      if (_selesai.isBefore(hasil)) _selesai = hasil;
    });
  }

  Future<void> _pilihSelesai() async {
    DateTime? hasil = await bukaKalender(
      context,
      awal: _selesai,
      batasAwal: _mulai,
      batasAkhir: widget.batasAkhir,
      judul: 'Waktu selesai',
    );
    if (hasil != null) setState(() => _selesai = hasil);
  }

  @override
  Widget build(BuildContext context) {
    DateTime hariIni = widget.batasAkhir;
    return Dialog(
      // Lebih lebar dari bawaan supaya tanggal di BarisIsian tidak terpotong.
      insetPadding: const EdgeInsets.all(JarakApp.tepiHalaman),
      child: Padding(
        padding: const EdgeInsets.all(JarakApp.tepiHalaman),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Pilih rentang', style: TeksApp.judulSeksi),
            const SizedBox(height: JarakApp.j12),
            Wrap(
              spacing: JarakApp.j8,
              runSpacing: JarakApp.j8,
              children: [
                _bangunPilihan(
                  '7 hari terakhir',
                  DateTime(hariIni.year, hariIni.month, hariIni.day - 6),
                ),
                _bangunPilihan(
                  '30 hari terakhir',
                  DateTime(hariIni.year, hariIni.month, hariIni.day - 29),
                ),
                _bangunPilihan(
                  'Bulan ini',
                  DateTime(hariIni.year, hariIni.month),
                ),
              ],
            ),
            const SizedBox(height: JarakApp.j8),
            BarisIsian(
              ikon: LucideIcons.calendar,
              label: 'Waktu mulai',
              nilai: _teks(_mulai),
              onTekan: _pilihMulai,
            ),
            const Divider(height: 1),
            BarisIsian(
              ikon: LucideIcons.calendar,
              label: 'Waktu selesai',
              nilai: _teks(_selesai),
              onTekan: _pilihSelesai,
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
                  teks: 'Terapkan',
                  onTekan: () => Navigator.pop(
                    context,
                    DateTimeRange(start: _mulai, end: _selesai),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Pilihan cepat selalu berakhir hari ini.
  Widget _bangunPilihan(String teks, DateTime mulai) {
    return TombolPill(
      teks: teks,
      kecil: true,
      onTekan: () => setState(() {
        _mulai = _tahan(mulai);
        _selesai = _tahan(widget.batasAkhir);
      }),
    );
  }
}
