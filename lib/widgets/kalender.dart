import 'package:flutter/material.dart';

import '../utils/format.dart';
import '../utils/periode.dart';
import 'dialog_waktu.dart';

// Satu pintu untuk semua kalender, supaya tanggal awalnya selalu ditahan di dalam batas.
// pekan = true menampilkan pekan dari tanggal yang dipilih, bukan tanggalnya saja.
Future<DateTime?> bukaKalender(
  BuildContext context, {
  required DateTime awal,
  required DateTime batasAwal,
  required DateTime batasAkhir,
  String judul = 'Pilih tanggal',
  bool pekan = false,
}) {
  DateTime pilihan = tahanTanggal(awal, batasAwal, batasAkhir);

  return showDialog<DateTime>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialog) => DialogWaktu(
        judul: judul,
        teksPilihan: pekan
            ? labelPeriode(0, pilihan)
            : formatTanggalPanjang(pilihan),
        onPilih: () => Navigator.pop(context, pilihan),
        isi: CalendarDatePicker(
          initialDate: pilihan,
          firstDate: batasAwal,
          lastDate: batasAkhir,
          onDateChanged: (tanggal) => setDialog(() => pilihan = tanggal),
        ),
      ),
    ),
  );
}
