import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../models/utang.dart';
import '../theme/app_theme.dart';
import '../utils/nominal.dart';
import '../widgets/baris_isian.dart';
import '../widgets/halaman_form.dart';
import '../widgets/halaman_isian_teks.dart';
import '../widgets/numpad_simpan.dart';
import '../widgets/pilihan_segmen.dart';
import '../widgets/tampilan_nominal.dart';
import '../widgets/template_nominal.dart';

class CatatUtangScreen extends StatefulWidget {
  const CatatUtangScreen({super.key});

  @override
  State<CatatUtangScreen> createState() => _CatatUtangScreenState();
}

class _CatatUtangScreenState extends State<CatatUtangScreen> {
  // 0 = Utang, 1 = Piutang, sama dengan urutan PilihanSegmen.
  int _jenis = 0;
  String _nama = '';
  String _keterangan = '';
  int _nominal = 0;

  bool get _bisaSimpan => _nama.isNotEmpty && _nominal > 0;

  void _ubahNominal(int nilai) => setState(() => _nominal = nilai);

  Future<void> _ubahNama() async {
    String? hasil = await bukaIsianTeks(
      context,
      _nama,
      judul: 'Nama',
      petunjuk: 'Tulis nama orangnya',
    );
    if (hasil != null && mounted) setState(() => _nama = hasil);
  }

  Future<void> _ubahKeterangan() async {
    String? hasil = await bukaIsianTeks(
      context,
      _keterangan,
      judul: 'Keterangan',
      petunjuk: 'Tulis keterangan',
    );
    if (hasil != null && mounted) setState(() => _keterangan = hasil);
  }

  void _simpan() {
    AppData.tambahUtang(
      UtangItem(
        jenis: _jenis == 0 ? 'Utang' : 'Piutang',
        nama: _nama,
        nominal: _nominal,
        keterangan: _keterangan,
        tanggal: DateTime.now(),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return HalamanForm(
      judul: 'Catat Utang',
      isi: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: JarakApp.tepiHalaman,
          vertical: JarakApp.j8,
        ),
        child: _bangunIsian(),
      ),
      bawah: NumpadSimpan(
        onAngka: (a) => _ubahNominal(tambahDigit(_nominal, a)),
        onHapus: () => _ubahNominal(hapusDigit(_nominal)),
        onSimpan: _bisaSimpan ? _simpan : null,
      ),
    );
  }

  Widget _bangunIsian() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PilihanSegmen(
          pilihan: const ['Utang', 'Piutang'],
          indeksAktif: _jenis,
          onPilih: (i) => setState(() => _jenis = i),
        ),
        const SizedBox(height: JarakApp.j24),
        TampilanNominal(
          label: _jenis == 0 ? 'Jumlah utang' : 'Jumlah piutang',
          nominal: _nominal,
        ),
        const SizedBox(height: JarakApp.j12),
        TemplateNominal(
          onTambah: (n) => _ubahNominal(tambahNominal(_nominal, n)),
          onReset: () => _ubahNominal(0),
        ),
        const SizedBox(height: JarakApp.j16),
        BarisIsian(
          ikon: LucideIcons.user,
          label: 'Nama',
          nilai: _nama.isEmpty ? 'Belum diisi' : _nama,
          warnaNilai: _nama.isEmpty ? WarnaApp.teksRedup : null,
          onTekan: _ubahNama,
        ),
        const Divider(height: 1),
        BarisIsian(
          ikon: LucideIcons.notebookPen,
          label: 'Keterangan',
          nilai: _keterangan.isEmpty ? 'Tambah keterangan' : _keterangan,
          warnaNilai: _keterangan.isEmpty ? WarnaApp.teksRedup : null,
          onTekan: _ubahKeterangan,
        ),
      ],
    );
  }
}
