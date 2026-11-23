import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BarDistribusi extends StatelessWidget {
  final List<int> daftarNilai;
  final List<Color> daftarWarna;

  const BarDistribusi({
    super.key,
    required this.daftarNilai,
    required this.daftarWarna,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(RadiusApp.pill),
      child: SizedBox(
        height: 12,
        child: Row(
          children: [
            for (int i = 0; i < daftarNilai.length; i++)
              // flex harus lebih dari 0, jadi nilai 0 tidak digambar.
              if (daftarNilai[i] > 0)
                Expanded(
                  flex: daftarNilai[i],
                  child: ColoredBox(color: daftarWarna[i]),
                ),
          ],
        ),
      ),
    );
  }
}
