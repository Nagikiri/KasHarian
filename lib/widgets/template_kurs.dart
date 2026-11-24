import 'package:flutter/material.dart';

import 'template_nominal.dart';

// Template Hitung kurs mengganti isian, bukan menambah, karena labelnya tanpa tanda +.
class TemplateKurs extends StatelessWidget {
  final bool dariRupiah;
  final void Function(int nilai) onPilih;

  const TemplateKurs({
    super.key,
    required this.dariRupiah,
    required this.onPilih,
  });

  @override
  Widget build(BuildContext context) {
    if (dariRupiah) {
      return TemplateNominal(
        daftarNilai: const [100000, 500000, 1000000],
        daftarLabel: const ['100rb', '500rb', '1jt'],
        onTambah: onPilih,
        onReset: () => onPilih(0),
      );
    }
    return TemplateNominal(
      daftarNilai: const [10, 100, 1000],
      daftarLabel: const ['10', '100', '1.000'],
      onTambah: onPilih,
      onReset: () => onPilih(0),
    );
  }
}
