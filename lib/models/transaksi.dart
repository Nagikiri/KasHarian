import 'package:flutter/material.dart';

import 'kategori.dart';

class CatatanTransaksi {
  int? id;
  final String kategori;
  final String catatan;
  final int nominal;
  final IconData ikon;
  final DateTime tanggal;
  final bool isPemasukan;
  final bool isTransfer;
  final String sumberDana;
  // Hanya diisi untuk transfer: dompet yang menerima uang.
  final String? sumberTujuan;

  CatatanTransaksi({
    this.id,
    required this.kategori,
    required this.catatan,
    required this.nominal,
    required this.ikon,
    required this.tanggal,
    this.isPemasukan = false,
    this.isTransfer = false,
    this.sumberDana = 'Utama',
    this.sumberTujuan,
  });

  // Ikon ikut disimpan supaya transaksi lama tetap berikon sama walau kategorinya dihapus.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kategori': kategori,
      'catatan': catatan,
      'nominal': nominal,
      'indeks_ikon': indeksIkon(ikon),
      'tanggal': tanggal.toIso8601String(),
      'is_pemasukan': isPemasukan ? 1 : 0,
      'is_transfer': isTransfer ? 1 : 0,
      'sumber_dana': sumberDana,
      'sumber_tujuan': sumberTujuan,
    };
  }

  factory CatatanTransaksi.fromMap(Map<String, dynamic> map) {
    return CatatanTransaksi(
      id: map['id'],
      kategori: map['kategori'],
      catatan: map['catatan'],
      nominal: map['nominal'],
      ikon: ikonDariIndeks(map['indeks_ikon']),
      tanggal: DateTime.parse(map['tanggal']),
      isPemasukan: map['is_pemasukan'] == 1,
      isTransfer: map['is_transfer'] == 1,
      sumberDana: map['sumber_dana'],
      sumberTujuan: map['sumber_tujuan'],
    );
  }
}
