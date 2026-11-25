import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../models/utang.dart';
import '../theme/app_theme.dart';
import '../utils/format_ribuan.dart';
import '../widgets/halaman_form.dart';
import '../widgets/pilihan_segmen.dart';
import '../widgets/tombol_utama.dart';

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

  bool get _bisaSimpan => _nama.trim().isNotEmpty && _nominal > 0;

  void _simpan() {
    AppData.tambahUtang(
      UtangItem(
        jenis: _jenis == 0 ? 'Utang' : 'Piutang',
        nama: _nama.trim(),
        nominal: _nominal,
        keterangan: _keterangan.trim(),
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
        padding: const EdgeInsets.all(JarakApp.tepiHalaman),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PilihanSegmen(
              pilihan: const ['Utang', 'Piutang'],
              indeksAktif: _jenis,
              onPilih: (i) => setState(() => _jenis = i),
            ),
            const SizedBox(height: JarakApp.j16),
            TextField(
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(hintText: 'Nama'),
              onChanged: (v) => setState(() => _nama = v),
            ),
            const SizedBox(height: JarakApp.j12),
            TextField(
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(hintText: 'Keterangan'),
              onChanged: (v) => _keterangan = v,
            ),
            const SizedBox(height: JarakApp.j12),
            _bangunNominal(),
          ],
        ),
      ),
      bawah: TombolUtama(teks: 'Simpan', onTekan: _bisaSimpan ? _simpan : null),
    );
  }

  // Keyboard angka cukup di sini karena tidak ada numpad sendiri yang bertabrakan.
  Widget _bangunNominal() {
    return TextField(
      keyboardType: TextInputType.number,
      inputFormatters: [FormatRibuan()],
      style: TeksApp.angka,
      decoration: const InputDecoration(
        hintText: 'Nominal',
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: JarakApp.j16, right: JarakApp.j8),
          child: Text('Rp', style: TeksApp.angka),
        ),
        prefixIconConstraints: BoxConstraints(),
      ),
      onChanged: (v) => setState(() => _nominal = bacaAngka(v)),
    );
  }
}
