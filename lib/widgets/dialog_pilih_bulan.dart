import 'package:flutter/material.dart';

import '../utils/format.dart';
import '../utils/periode.dart';
import 'dialog_waktu.dart';
import 'grid_kalender.dart';
import 'kepala_kalender.dart';
import 'sel_kalender.dart';

// Mengembalikan bulan yang dipilih lewat Navigator.pop. Bulan di luar batas tidak bisa dipilih.
// Mengetuk label tahun berpindah ke grid tahun, seperti kalender bawaan.
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
  bool _modeTahun = false;

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
    return DialogWaktu(
      judul: 'Pilih bulan',
      teksPilihan: '${namaBulanPanjang[_pilihan.month - 1]} ${_pilihan.year}',
      onPilih: () => Navigator.pop(context, _pilihan),
      isi: Column(
        children: [
          KepalaKalender(
            label: '$_tahun',
            onLabel: () => setState(() => _modeTahun = !_modeTahun),
            terbuka: _modeTahun,
            // Di grid tahun semua tahun sudah tampil, jadi panah tidak diperlukan.
            onSebelum: !_modeTahun && _tahun > widget.batasAwal.year
                ? () => setState(() => _tahun--)
                : null,
            onSesudah: !_modeTahun && _tahun < widget.batasAkhir.year
                ? () => setState(() => _tahun++)
                : null,
          ),
          GridKalender(
            daftarSel: _modeTahun ? _bangunSelTahun() : _bangunSelBulan(),
          ),
        ],
      ),
    );
  }

  List<Widget> _bangunSelBulan() {
    DateTime sekarang = DateTime.now();
    return [
      for (int b = 1; b <= 12; b++)
        SelKalender(
          teks: namaBulanPanjang[b - 1],
          terpilih: _pilihan.year == _tahun && _pilihan.month == b,
          nonaktif: !_bolehDipilih(DateTime(_tahun, b)),
          sekarang: sekarang.year == _tahun && sekarang.month == b,
          onTekan: () => setState(() => _pilihan = DateTime(_tahun, b)),
        ),
    ];
  }

  // Memilih tahun hanya mengganti tahun yang tampil, lalu kembali ke grid bulan.
  List<Widget> _bangunSelTahun() {
    return [
      for (int t = widget.batasAwal.year; t <= widget.batasAkhir.year; t++)
        SelKalender(
          teks: '$t',
          terpilih: t == _tahun,
          nonaktif: false,
          sekarang: t == DateTime.now().year,
          onTekan: () => setState(() {
            _tahun = t;
            _modeTahun = false;
          }),
        ),
    ];
  }
}
