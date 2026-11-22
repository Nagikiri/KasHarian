import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/nominal.dart';
import 'header_sheet.dart';
import 'numpad_simpan.dart';
import 'tampilan_nominal.dart';
import 'template_nominal.dart';

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
                  HeaderSheet(judul: judul, ikon: ikon),
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
                  NumpadSimpan(
                    onAngka: (a) =>
                        setSheet(() => nominal = tambahDigit(nominal, a)),
                    onHapus: () =>
                        setSheet(() => nominal = hapusDigit(nominal)),
                    labelTombol: labelTombol,
                    onSimpan: nominal > 0
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
