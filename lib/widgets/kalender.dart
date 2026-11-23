import 'package:flutter/material.dart';

import '../utils/periode.dart';

// Satu pintu untuk semua kalender, supaya tanggal awalnya selalu ditahan di dalam batas.
Future<DateTime?> bukaKalender(
  BuildContext context, {
  required DateTime awal,
  required DateTime batasAwal,
  required DateTime batasAkhir,
  String? judul,
}) {
  return showDatePicker(
    context: context,
    initialDate: tahanTanggal(awal, batasAwal, batasAkhir),
    firstDate: batasAwal,
    lastDate: batasAkhir,
    helpText: judul,
  );
}
