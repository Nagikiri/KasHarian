import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class JudulSeksi extends StatelessWidget {
  final String judul;
  final String? aksi;
  final VoidCallback? onAksi;
  final Widget? ujung;

  const JudulSeksi({
    super.key,
    required this.judul,
    this.aksi,
    this.onAksi,
    this.ujung,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(judul, style: TeksApp.judulSeksi)),
        if (aksi != null)
          GestureDetector(
            onTap: onAksi,
            child: Text(
              aksi!,
              style: TeksApp.tombolKecil.copyWith(color: WarnaApp.primer),
            ),
          ),
        ?ujung,
      ],
    );
  }
}
