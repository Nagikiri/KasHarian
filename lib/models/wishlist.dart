import 'package:flutter/material.dart';

class WishlistItem {
  int? id;
  final String nama;
  final String kategori;
  final String mataUang;
  final int hargaAsing;
  final int targetIdr;
  int terkumpulIdr;
  final IconData ikon;

  WishlistItem({
    this.id,
    required this.nama,
    required this.kategori,
    required this.mataUang,
    required this.hargaAsing,
    required this.targetIdr,
    required this.terkumpulIdr,
    required this.ikon,
  });

  // Ikon tidak disimpan karena selalu mengikuti kategori impian.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'kategori': kategori,
      'mata_uang': mataUang,
      'harga_asing': hargaAsing,
      'target_idr': targetIdr,
      'terkumpul_idr': terkumpulIdr,
    };
  }

  // Ikon dikirim dari AppData.ikonImpian, karena daftar kategori impian ada di sana.
  factory WishlistItem.fromMap(Map<String, dynamic> map, IconData ikon) {
    return WishlistItem(
      id: map['id'],
      nama: map['nama'],
      kategori: map['kategori'],
      mataUang: map['mata_uang'],
      hargaAsing: map['harga_asing'],
      targetIdr: map['target_idr'],
      terkumpulIdr: map['terkumpul_idr'],
      ikon: ikon,
    );
  }
}
