import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class KolomAngka extends StatelessWidget {
  final String label;
  final String nilai;
  final Color? warnaNilai;

  const KolomAngka({
    super.key,
    required this.label,
    required this.nilai,
    this.warnaNilai,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TeksApp.kecil),
        const SizedBox(height: JarakApp.j4),
        Text(nilai, style: TeksApp.angka.copyWith(color: warnaNilai)),
      ],
    );
  }
}
