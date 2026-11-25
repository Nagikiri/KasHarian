import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';
import 'ikon_bulat.dart';

// AppBar halaman isian: tombol X di kiri, beda dari chevron di halaman turunan.
AppBar buatAppBarForm(String judul, {IconData? ikon, List<Widget>? aksi}) {
  return AppBar(
    // Builder dipakai karena fungsi ini tidak menerima context untuk Navigator.
    leading: Builder(
      builder: (context) => IconButton(
        icon: const Icon(LucideIcons.x, size: 20, color: WarnaApp.teksUtama),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    title: ikon == null
        ? Text(judul)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IkonBulat(ikon: ikon, ukuran: 32),
              const SizedBox(width: JarakApp.j8),
              Flexible(child: Text(judul, overflow: TextOverflow.ellipsis)),
            ],
          ),
    actions: aksi,
  );
}
