import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../models/budget.dart';
import '../models/transaksi.dart';
import '../theme/app_theme.dart';
import '../utils/privasi.dart';

// Sisa budget kategori setelah nominal yang sedang diketik. Tidak tampil kalau kategori belum punya budget.
class InfoBudget extends StatelessWidget {
  final String kategori;
  final int nominal;
  final DateTime tanggal;
  final CatatanTransaksi? transaksiLama;

  const InfoBudget({
    super.key,
    required this.kategori,
    required this.nominal,
    required this.tanggal,
    this.transaksiLama,
  });

  // Dalam mode ubah, nominal lama sudah ikut di terpakaiBudget, jadi dikurangkan supaya tidak terhitung dua kali.
  int _nominalLama() {
    final lama = transaksiLama;
    if (lama == null || lama.isPemasukan || lama.isTransfer) return 0;
    bool bulanSama =
        lama.tanggal.year == tanggal.year &&
        lama.tanggal.month == tanggal.month;
    return lama.kategori == kategori && bulanSama ? lama.nominal : 0;
  }

  @override
  Widget build(BuildContext context) {
    BudgetItem? budget;
    for (var b in AppData.daftarBudget) {
      if (b.kategori == kategori) budget = b;
    }
    if (budget == null) return const SizedBox.shrink();

    int terpakai =
        AppData.terpakaiBudget(kategori, tanggal) - _nominalLama() + nominal;
    int sisa = budget.limit - terpakai;
    // Limit 0 tidak bisa dibagi, jadi dianggap sudah penuh.
    double persen = budget.limit > 0 ? terpakai / budget.limit : 1;

    String teks = 'Kantong $kategori: sisa ${rupiahTampil(sisa)}';
    Color warna = WarnaApp.teksRedup;
    if (sisa < 0) {
      teks = 'Melebihi kantong $kategori ${rupiahTampil(-sisa)}';
      warna = WarnaApp.bahaya;
    } else if (persen >= 0.8) {
      teks = 'Kantong $kategori tinggal ${rupiahTampil(sisa)}';
      warna = WarnaApp.peringatan;
    }

    return Padding(
      padding: const EdgeInsets.only(top: JarakApp.j12),
      child: Text(teks, style: TeksApp.kecil.copyWith(color: warna)),
    );
  }
}
