import 'package:flutter/material.dart';

class WishlistItem {
  final String nama;
  final String mataUang;
  final int hargaAsing;
  final int targetIdr;
  int terkumpulIdr;
  final IconData ikon;

  WishlistItem({
    required this.nama,
    required this.mataUang,
    required this.hargaAsing,
    required this.targetIdr,
    required this.terkumpulIdr,
    required this.ikon,
  });
}
