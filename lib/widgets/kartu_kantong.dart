import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../models/budget.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'kartu_progress.dart';

class KartuKantong extends StatelessWidget {
  final BudgetItem budget;
  final DateTime bulan;
  final VoidCallback onTekan;

  const KartuKantong({
    super.key,
    required this.budget,
    required this.bulan,
    required this.onTekan,
  });

  @override
  Widget build(BuildContext context) {
    int terpakai = AppData.terpakaiBudget(budget.kategori, bulan);
    // Limit 0 tidak bisa dibagi, jadi persennya dianggap 0.
    double persen = budget.limit > 0 ? terpakai / budget.limit : 0;
    int lebih = terpakai - budget.limit;

    return KartuProgress(
      ikon: AppData.ikonKategori(budget.kategori),
      persenTeks: '${(persen * 100).round()}%',
      judul: budget.kategori,
      nominal: formatRupiah(terpakai),
      keterangan: lebih > 0
          ? 'Lebih ${formatRupiah(lebih)}'
          : 'dari ${formatRupiah(budget.limit)}',
      warnaKeterangan: lebih > 0 ? WarnaApp.bahaya : null,
      persen: persen,
      onTekan: onTekan,
    );
  }
}
