import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../models/budget.dart';
import '../theme/app_theme.dart';
import 'kartu_kantong.dart';

class GridKantong extends StatelessWidget {
  final DateTime bulan;
  final VoidCallback onTekanKartu;

  const GridKantong({
    super.key,
    required this.bulan,
    required this.onTekanKartu,
  });

  @override
  Widget build(BuildContext context) {
    List<BudgetItem> daftar = AppData.daftarBudget;
    if (daftar.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: JarakApp.j16),
        child: Text('Belum ada kategori budget', style: TeksApp.kecil),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < daftar.length; i += 2) _bangunBaris(daftar, i),
      ],
    );
  }

  // Row + Expanded dipakai (bukan GridView) supaya tinggi kartu mengikuti isinya.
  Widget _bangunBaris(List<BudgetItem> daftar, int i) {
    bool adaKanan = i + 1 < daftar.length;
    return Padding(
      padding: EdgeInsets.only(top: i > 0 ? JarakApp.j12 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _bangunKartu(daftar[i])),
          const SizedBox(width: JarakApp.j12),
          Expanded(
            child: adaKanan
                ? _bangunKartu(daftar[i + 1])
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _bangunKartu(BudgetItem budget) =>
      KartuKantong(budget: budget, bulan: bulan, onTekan: onTekanKartu);
}
