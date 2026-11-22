import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'ikon_bulat.dart';

// Mengembalikan nama sumber dana yang dipilih, atau null kalau sheet ditutup.
Future<String?> bukaSumberDana(BuildContext context, String terpilih) {
  return showModalBottomSheet<String>(
    context: context,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          JarakApp.tepiHalaman,
          JarakApp.j24,
          JarakApp.tepiHalaman,
          JarakApp.j16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Sumber dana', style: TeksApp.judulSeksi),
            const SizedBox(height: JarakApp.j8),
            for (String sumber in AppData.daftarSumberDana)
              InkWell(
                onTap: () => Navigator.pop(context, sumber),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: JarakApp.j12),
                  child: Row(
                    children: [
                      const IkonBulat(ikon: LucideIcons.wallet),
                      const SizedBox(width: JarakApp.j12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(sumber, style: TeksApp.isi),
                            Text(
                              formatRupiah(AppData.saldoSumber(sumber)),
                              style: TeksApp.kecil,
                            ),
                          ],
                        ),
                      ),
                      if (sumber == terpilih)
                        const Icon(
                          LucideIcons.check,
                          size: 20,
                          color: WarnaApp.primer,
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
