import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'kategori.dart';

class Dompet {
  int? id;
  // Tidak final karena nama, ikon, dan saldo awal bisa diubah di form dompet.
  String nama;
  IconData ikon;
  int saldoAwal;

  Dompet({
    this.id,
    required this.nama,
    this.ikon = LucideIcons.wallet,
    this.saldoAwal = 0,
  });

  // Ikon disimpan sebagai nomor urut di daftarIkonKategori, sama dengan kategori dan transaksi.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'indeks_ikon': indeksIkon(ikon),
      'saldo_awal': saldoAwal,
    };
  }

  factory Dompet.fromMap(Map<String, dynamic> map) {
    return Dompet(
      id: map['id'],
      nama: map['nama'],
      ikon: ikonDariIndeks(map['indeks_ikon']),
      saldoAwal: map['saldo_awal'],
    );
  }
}
