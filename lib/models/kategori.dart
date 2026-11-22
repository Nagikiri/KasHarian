import 'package:flutter/material.dart';

class KategoriItem {
  final String nama;
  final IconData ikon;
  final Color warna;
  final bool isPemasukan;
  final bool isTransfer;

  KategoriItem({
    required this.nama,
    required this.ikon,
    required this.warna,
    this.isPemasukan = false,
    this.isTransfer = false,
  });
}
