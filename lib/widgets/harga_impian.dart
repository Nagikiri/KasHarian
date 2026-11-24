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

  List<String> _labelTemplate(List<int> template) {
    if (_rupiah) return ['+100rb', '+500rb', '+1jt', '+5jt'];
    return [for (int n in template) '+${formatTitik(n)}'];
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
          daftarLabel: _labelTemplate(template),
          onTambah: onTambah,
          onReset: onKosongkan,
        ),
      ],
    );
  }
}
