import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';
import '../utils/nominal.dart';
import 'ikon_bulat.dart';
import 'numpad.dart';
import 'tampilan_nominal.dart';
import 'template_nominal.dart';
import 'tombol_utama.dart';

// onHapus mengembalikan true kalau benar-benar dihapus, baru sheet ditutup.
Future<void> bukaInputNominal(
  BuildContext context, {
  required String judul,
  IconData? ikon,
  int nominalAwal = 0,
  String labelTombol = 'Simpan',
  required void Function(int nominal) onSimpan,
  Future<bool> Function()? onHapus,
  String? labelHapus,
}) {
  int nominal = nominalAwal;

  return showModalBottomSheet<void>(
    context: context,
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
                  Center(
                    child: Container(
                      width: 32,
                      height: 4,
                      decoration: BoxDecoration(
                        color: WarnaApp.garis,
                        borderRadius: BorderRadius.circular(RadiusApp.pill),
                      ),
                    ),
                  ),
                  const SizedBox(height: JarakApp.j8),
                  Row(
                    children: [
                      if (ikon != null) ...[
                        IkonBulat(ikon: ikon),
                        const SizedBox(width: JarakApp.j12),
                      ],
                      Expanded(child: Text(judul, style: TeksApp.judulSeksi)),
                      IconButton(
                        icon: const Icon(
                          LucideIcons.x,
                          size: 20,
                          color: WarnaApp.teksUtama,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: JarakApp.j16),
                  TampilanNominal(label: 'Nominal', nominal: nominal),
                  const SizedBox(height: JarakApp.j12),
                  TemplateNominal(
                    onTambah: (n) =>
                        setSheet(() => nominal = tambahNominal(nominal, n)),
                    onReset: () => setSheet(() => nominal = 0),
                  ),
                  const Spacer(),
                  if (onHapus != null)
                    TextButton(
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        bool terhapus = await onHapus();
                        if (terhapus) navigator.pop();
                      },
                      child: Text(
                        labelHapus ?? 'Hapus',
                        style: TeksApp.tombolKecil.copyWith(
                          color: WarnaApp.bahaya,
                        ),
                      ),
                    ),
                  Numpad(
                    onAngka: (a) =>
                        setSheet(() => nominal = tambahDigit(nominal, a)),
                    onHapus: () =>
                        setSheet(() => nominal = hapusDigit(nominal)),
                  ),
                  const SizedBox(height: JarakApp.j12),
                  TombolUtama(
                    teks: labelTombol,
                    onTekan: nominal > 0
                        ? () {
                            onSimpan(nominal);
                            Navigator.pop(context);
                          }
                        : null,
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
