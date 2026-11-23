import 'package:flutter/material.dart';

import 'dialog_waktu.dart';
import 'grid_kalender.dart';
import 'kepala_kalender.dart';
import 'sel_kalender.dart';

// Mengembalikan tahun yang dipilih lewat Navigator.pop.
class DialogPilihTahun extends StatefulWidget {
  final int awal;
  final int tahunPertama;
  final int tahunTerakhir;

  const DialogPilihTahun({
    super.key,
    required this.awal,
    required this.tahunPertama,
    required this.tahunTerakhir,
  });

  @override
  State<DialogPilihTahun> createState() => _DialogPilihTahunState();
}

class _DialogPilihTahunState extends State<DialogPilihTahun> {
  // Pilihan sementara, ditahan di dalam batas, baru dikirim saat tombol Pilih ditekan.
  late int _pilihan = widget.awal.clamp(
    widget.tahunPertama,
    widget.tahunTerakhir,
  );

  // Label kepala berisi rentang tahun yang tampil di grid.
  String get _labelRentang => widget.tahunPertama == widget.tahunTerakhir
      ? '${widget.tahunPertama}'
      : '${widget.tahunPertama}–${widget.tahunTerakhir}';

  @override
  Widget build(BuildContext context) {
    return DialogWaktu(
      judul: 'Pilih tahun',
      teksPilihan: '$_pilihan',
      onPilih: () => Navigator.pop(context, _pilihan),
      isi: Column(
        children: [
          KepalaKalender(label: _labelRentang),
          GridKalender(
            daftarSel: [
              for (int t = widget.tahunPertama; t <= widget.tahunTerakhir; t++)
                SelKalender(
                  teks: '$t',
                  terpilih: t == _pilihan,
                  nonaktif: false,
                  sekarang: t == DateTime.now().year,
                  onTekan: () => setState(() => _pilihan = t),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
