import 'package:flutter/material.dart';

class KategoriItem {
  final String nama;
  final IconData ikon;
  final bool isPemasukan;
  // Indeks ke WarnaApp.paletKategori: 0 sampai 6 bergiliran, 7 (abu) khusus 'Lainnya'.
  final int indeksWarna;

  KategoriItem({
    required this.nama,
    required this.ikon,
    this.isPemasukan = false,
    required this.indeksWarna,
  });
}
