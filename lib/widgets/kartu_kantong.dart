import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../models/budget.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'ikon_bulat.dart';
import 'progress_tipis.dart';

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
    BorderRadius sudut = BorderRadius.circular(RadiusApp.input);

    return Material(
      color: WarnaApp.latar,
      shape: RoundedRectangleBorder(
        borderRadius: sudut,
        side: const BorderSide(color: WarnaApp.garis),
      ),
      child: InkWell(
        onTap: onTekan,
        borderRadius: sudut,
        child: Padding(
          padding: const EdgeInsets.all(JarakApp.dalamKartu),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IkonBulat(ikon: AppData.ikonKategori(budget.kategori)),
                  const Spacer(),
                  Text(
                    '${(persen * 100).round()}%',
                    style: TeksApp.angka.copyWith(color: warnaStatus(persen)),
                  ),
                ],
              ),
              const SizedBox(height: JarakApp.j12),
              Text(
                budget.kategori,
                style: TeksApp.isi,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(formatRupiah(terpakai), style: TeksApp.angka),
              lebih > 0
                  ? Text(
                      'Lebih ${formatRupiah(lebih)}',
                      style: TeksApp.kecil.copyWith(color: WarnaApp.bahaya),
                    )
                  : Text(
                      'dari ${formatRupiah(budget.limit)}',
                      style: TeksApp.kecil,
                    ),
              const SizedBox(height: JarakApp.j8),
              ProgressTipis(persen: persen),
            ],
          ),
        ),
      ),
    );
  }
}
