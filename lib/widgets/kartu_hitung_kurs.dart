import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/format_ribuan.dart';
import 'baris_info_kurs.dart';
import 'judul_seksi.dart';
import 'kotak_hasil_kurs.dart';
import 'kotak_input_kurs.dart';
import 'sheet_pilih_mata_uang.dart';
import 'template_nominal.dart';

// Hitung kurs di tab Impian. Pengambilan kurs tetap diatur halaman lewat onPerbarui.
class KartuHitungKurs extends StatefulWidget {
  final bool sedangMemuat;
  final VoidCallback onPerbarui;

  const KartuHitungKurs({
    super.key,
    required this.sedangMemuat,
    required this.onPerbarui,
  });

  @override
  State<KartuHitungKurs> createState() => _KartuHitungKursState();
}

class _KartuHitungKursState extends State<KartuHitungKurs> {
  // Sama dengan batas 10 digit di FormatRibuan, supaya angka hasil balik arah tetap bisa diedit.
  static const int _batasAngka = 9999999999;
  final TextEditingController _jumlahCtrl = TextEditingController(text: '100');
  String _kode = AppData.mataUangFavorit.first;
  bool _dariRupiah = false;

  @override
  void dispose() {
    _jumlahCtrl.dispose();
    super.dispose();
  }

  void _aturJumlah(int nilai) {
    int aman = nilai > _batasAngka ? _batasAngka : nilai;
    setState(() => _jumlahCtrl.text = aman == 0 ? '' : formatTitik(aman));
  }

  Future<void> _pilihMataUang() async {
    String? hasil = await bukaPilihMataUang(context, _kode);
    if (hasil == null || !mounted) return;
    setState(() => _kode = hasil);
  }

  // Hasil sebelumnya menjadi isian baru, supaya angkanya tetap nyambung setelah dibalik.
  void _balikArah() {
    int jumlah = bacaAngka(_jumlahCtrl.text);
    int baru = 0;
    if (AppData.kursAda(_kode)) {
      baru = _dariRupiah
          ? AppData.rupiahKeAsing(_kode, jumlah).round()
          : AppData.targetDariKurs(_kode, jumlah);
    }
    _dariRupiah = !_dariRupiah;
    _aturJumlah(baru);
  }

  String _teksHasil() {
    if (!AppData.kursAda(_kode)) return '—';
    int jumlah = bacaAngka(_jumlahCtrl.text);
    if (_dariRupiah) {
      return '$_kode ${formatDesimal(AppData.rupiahKeAsing(_kode, jumlah))}';
    }
    return formatRupiah(AppData.targetDariKurs(_kode, jumlah));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const JudulSeksi(judul: 'Hitung kurs'),
        const SizedBox(height: JarakApp.j16),
        KotakInputKurs(
          mataUang: AppData.cariMataUang(_dariRupiah ? 'IDR' : _kode),
          controller: _jumlahCtrl,
          onPilih: _dariRupiah ? null : _pilihMataUang,
          onUbah: () => setState(() {}),
        ),
        Center(
          child: IconButton(
            onPressed: _balikArah,
            icon: const Icon(
              LucideIcons.arrowUpDown,
              size: 20,
              color: WarnaApp.primer,
            ),
          ),
        ),
        KotakHasilKurs(
          hasil: _teksHasil(),
          kode: _kode,
          onPilih: _dariRupiah ? _pilihMataUang : null,
        ),
        const SizedBox(height: JarakApp.j12),
        _bangunTemplate(),
        const SizedBox(height: JarakApp.j16),
        BarisInfoKurs(
          sedangMemuat: widget.sedangMemuat,
          onPerbarui: widget.onPerbarui,
        ),
        const SizedBox(height: JarakApp.j4),
        // Atribusi wajib dari penyedia API, jadi di halaman ini selalu terlihat.
        const Text('Rates By Exchange Rate API', style: TeksApp.mini),
      ],
    );
  }

  // Template di sini mengganti isian, bukan menambah, karena labelnya tanpa tanda +.
  Widget _bangunTemplate() {
    if (_dariRupiah) {
      return TemplateNominal(
        daftarNilai: const [100000, 500000, 1000000],
        daftarLabel: const ['100rb', '500rb', '1jt'],
        onTambah: _aturJumlah,
        onReset: () => _aturJumlah(0),
      );
    }
    return TemplateNominal(
      daftarNilai: const [10, 100, 1000],
      daftarLabel: const ['10', '100', '1.000'],
      onTambah: _aturJumlah,
      onReset: () => _aturJumlah(0),
    );
  }
}
