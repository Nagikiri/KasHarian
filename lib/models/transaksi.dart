import 'package:flutter/material.dart';

class CatatanTransaksi {
  final String kategori;
  final String catatan;
  final int nominal;
  final IconData ikon;
  final Color warna;
  final DateTime tanggal;
  final bool isPemasukan;
  final bool isTransfer;
  final String sumberDana;

  CatatanTransaksi({
    required this.kategori,
    required this.catatan,
    required this.nominal,
    required this.ikon,
    required this.warna,
    required this.tanggal,
    this.isPemasukan = false,
    this.isTransfer = false,
    this.sumberDana = 'Kantong Utama',
  });
}
