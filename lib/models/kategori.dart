import 'package:flutter/material.dart';

class KategoriItem {
  final String nama;
  final IconData ikon;
  final bool isPemasukan;

  KategoriItem({
    required this.nama,
    required this.ikon,
    this.isPemasukan = false,
  });
}
