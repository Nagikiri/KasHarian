import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../models/budget.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'ikon_bulat.dart';
import 'progress_tipis.dart';

class BarisBudget extends StatelessWidget {
  final BudgetItem budget;
  final VoidCallback onTekan;

  const BarisBudget({super.key, required this.budget, required this.onTekan});

  @override
  Widget build(BuildContext context) {
    int terpakai = AppData.terpakaiBudget(budget.kategori, DateTime.now());
    // Limit 0 tidak bisa dibagi, jadi persennya dianggap 0.
    double persen = budget.limit > 0 ? terpakai / budget.limit : 0;

    return InkWell(
      onTap: onTekan,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: JarakApp.j12),
        child: Column(
          children: [
            Row(
              children: [
                IkonBulat(ikon: AppData.ikonKategori(budget.kategori)),
                const SizedBox(width: JarakApp.j12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        budget.kategori,
                        style: TeksApp.isi,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: JarakApp.j4),
                      Text(
                        '${formatRupiah(terpakai)} dari ${formatRupiah(budget.limit)}',
                        style: TeksApp.kecil,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: JarakApp.j12),
                Text(
                  '${(persen * 100).round()}%',
                  style: TeksApp.angka.copyWith(color: warnaStatus(persen)),
                ),
              ],
            ),
            const SizedBox(height: JarakApp.j12),
            ProgressTipis(persen: persen),
          ],
        ),
      ),
    );
  }
}
