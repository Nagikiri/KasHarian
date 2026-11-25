import 'package:flutter/material.dart';

import '../main.dart';
import '../theme/app_theme.dart';
import '../utils/nominal.dart';
import 'halaman_form.dart';
import 'numpad_simpan.dart';
import 'tampilan_nominal.dart';
import 'template_nominal.dart';

Future<void> bukaInputNominal(
  BuildContext context, {
  required String judul,
  IconData? ikon,
  int nominalAwal = 0,
  required void Function(int nominal) onSimpan,
}) {
  return Navigator.push(
    context,
    buatTransisiHalaman(
      HalamanInputNominal(
        judul: judul,
        ikon: ikon,
        nominalAwal: nominalAwal,
        onSimpan: onSimpan,
      ),
    ),
  );
}

// Isian Rupiah lewat numpad sendiri, jadi keyboard HP tidak pernah muncul di halaman ini.
class HalamanInputNominal extends StatefulWidget {
  final String judul;
  final IconData? ikon;
  final int nominalAwal;
  final void Function(int nominal) onSimpan;

  const HalamanInputNominal({
    super.key,
    required this.judul,
    this.ikon,
    this.nominalAwal = 0,
    required this.onSimpan,
  });

  @override
  State<HalamanInputNominal> createState() => _HalamanInputNominalState();
}

class _HalamanInputNominalState extends State<HalamanInputNominal> {
  late int _nominal = widget.nominalAwal;

  void _ubah(int nilai) => setState(() => _nominal = nilai);

  void _simpan() {
    widget.onSimpan(_nominal);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return HalamanForm(
      judul: widget.judul,
      ikon: widget.ikon,
      isi: SingleChildScrollView(
        padding: const EdgeInsets.all(JarakApp.tepiHalaman),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TampilanNominal(label: 'Nominal', nominal: _nominal),
            const SizedBox(height: JarakApp.j12),
            TemplateNominal(
              onTambah: (n) => _ubah(tambahNominal(_nominal, n)),
              onReset: () => _ubah(0),
            ),
          ],
        ),
      ),
      bawah: NumpadSimpan(
        onAngka: (a) => _ubah(tambahDigit(_nominal, a)),
        onHapus: () => _ubah(hapusDigit(_nominal)),
        onSimpan: _nominal > 0 ? _simpan : null,
      ),
    );
  }
}
