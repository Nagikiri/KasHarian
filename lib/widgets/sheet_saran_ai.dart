import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../theme/app_theme.dart';
import 'header_sheet.dart';
import 'tombol_pill.dart';

Future<void> bukaSaranAi(BuildContext context, DateTime bulan) {
  // Disimpan di luar builder supaya tidak meminta ulang setiap kali sheet digambar.
  Future<String> permintaan = AppData.mintaSaranAi(bulan);

  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setSheet) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                JarakApp.tepiHalaman,
                JarakApp.j8,
                JarakApp.tepiHalaman,
                JarakApp.j16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const HeaderSheet(
                    judul: 'Bendahara AI',
                    ikon: LucideIcons.bot,
                  ),
                  const SizedBox(height: JarakApp.j16),
                  Expanded(
                    child: FutureBuilder<String>(
                      future: permintaan,
                      builder: (context, hasil) => _bangunIsi(
                        hasil,
                        () => setSheet(
                          () => permintaan = AppData.mintaSaranAi(bulan),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: JarakApp.j12),
                  const Text(
                    'Saran dibuat otomatis, bukan nasihat keuangan profesional.',
                    style: TeksApp.mini,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget _bangunIsi(AsyncSnapshot<String> hasil, VoidCallback onCobaLagi) {
  if (hasil.connectionState != ConnectionState.done) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: WarnaApp.primer,
          ),
        ),
        SizedBox(width: JarakApp.j12),
        Text('Bendahara sedang membaca catatanmu…', style: TeksApp.kecil),
      ],
    );
  }
  if (hasil.hasError) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bendahara belum bisa dihubungi. Coba lagi nanti.',
          style: TeksApp.isi,
        ),
        const SizedBox(height: JarakApp.j12),
        TombolPill(teks: 'Coba lagi', onTekan: onCobaLagi),
      ],
    );
  }
  return SingleChildScrollView(
    child: Text(hasil.data ?? '', style: TeksApp.isi.copyWith(height: 1.6)),
  );
}
