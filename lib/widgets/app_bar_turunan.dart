import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';

AppBar buatAppBarTurunan(String judul, {List<Widget>? aksi}) {
  return AppBar(
    // Builder dipakai karena fungsi ini tidak menerima context untuk Navigator.
    leading: Builder(
      builder: (context) => IconButton(
        icon: const Icon(
          LucideIcons.chevronLeft,
          size: 20,
          color: WarnaApp.teksUtama,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    title: Text(judul),
    actions: aksi,
  );
}
