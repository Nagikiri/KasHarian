import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'tampilan_nominal.dart';
import 'template_nominal.dart';

// Bagian harga di isian impian: nominal, padanan Rupiah, dan template.
class HargaImpian extends StatelessWidget {
  final String kode;
  final int harga;
  final void Function(int tambahan) onTambah;
  final VoidCallback onKosongkan;

  const HargaImpian({
    super.key,
    required this.kode,
    required this.harga,
    required this.onTambah,
    required this.onKosongkan,
  });

  bool get _rupiah => kode == 'IDR';

  // Label disingkat (rb, jt) supaya empat chip muat dibagi rata di layar 360 dp.
  String _labelTemplate(int n) {
    if (n >= 1000000) return '+${n ~/ 1000000}jt';
    if (n >= 1000) return '+${n ~/ 1000}rb';
    return '+$n';
  }

  String get _teksSetara {
    if (!AppData.kursAda(kode)) return 'Setara —';
    return 'Setara ${formatRupiah(AppData.targetDariKurs(kode, harga))}';
  }

  @override
  Widget build(BuildContext context) {
    List<int> template = AppData.templateMataUang(kode);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TampilanNominal(
          label: 'Harga',
          nominal: harga,
          prefix: _rupiah ? 'Rp' : kode,
        ),
        if (!_rupiah) ...[
          const SizedBox(height: JarakApp.j4),
          Text(
            _teksSetara,
            style: TeksApp.isi.copyWith(
              color: WarnaApp.primer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        const SizedBox(height: JarakApp.j12),
        TemplateNominal(
          daftarNilai: template,
          daftarLabel: [for (int n in template) _labelTemplate(n)],
          onTambah: onTambah,
          onReset: onKosongkan,
        ),
      ],
    );
  }
}
