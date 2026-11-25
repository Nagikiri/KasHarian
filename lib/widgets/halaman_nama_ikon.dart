import 'package:flutter/material.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../models/dompet.dart';
import '../theme/app_theme.dart';
import 'grid_pilih_ikon.dart';
import 'halaman_form.dart';
import 'tombol_utama.dart';

// Mengembalikan Dompet sementara berisi nama dan ikon baru (saldo diabaikan), atau null kalau ditutup lewat X.
// lama = dompet yang sedang diubah, supaya namanya sendiri tidak dianggap kembar.
Future<Dompet?> bukaNamaIkon(
  BuildContext context, {
  required String nama,
  required IconData ikon,
  Dompet? lama,
  bool namaTerkunci = false,
}) async {
  // Disimpan ke var dulu karena buatTransisiHalaman tidak membawa tipe hasil.
  var hasil = await Navigator.push(
    context,
    buatTransisiHalaman(
      HalamanNamaIkon(
        nama: nama,
        ikon: ikon,
        lama: lama,
        namaTerkunci: namaTerkunci,
      ),
    ),
  );
  return hasil;
}

class HalamanNamaIkon extends StatefulWidget {
  final String nama;
  final IconData ikon;
  final Dompet? lama;
  final bool namaTerkunci;

  const HalamanNamaIkon({
    super.key,
    required this.nama,
    required this.ikon,
    this.lama,
    this.namaTerkunci = false,
  });

  @override
  State<HalamanNamaIkon> createState() => _HalamanNamaIkonState();
}

class _HalamanNamaIkonState extends State<HalamanNamaIkon> {
  late final TextEditingController _isian = TextEditingController(
    text: widget.nama,
  );
  late IconData _ikon = widget.ikon;

  String get _nama => _isian.text.trim();
  bool get _namaBoleh => AppData.namaDompetBoleh(_nama, lama: widget.lama);

  @override
  void dispose() {
    _isian.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_namaBoleh) return;
    Navigator.pop(context, Dompet(nama: _nama, ikon: _ikon));
  }

  @override
  Widget build(BuildContext context) {
    // Nama yang terisi tapi ditolak berarti kembar atau nama khusus, jadi alasannya ditampilkan.
    bool namaDitolak = _nama.isNotEmpty && !_namaBoleh;
    return HalamanForm(
      judul: 'Nama & ikon',
      // Digulir supaya tombol Simpan tetap terjangkau di layar pendek saat keyboard muncul.
      isi: SingleChildScrollView(
        padding: const EdgeInsets.all(JarakApp.tepiHalaman),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _isian,
              autofocus: !widget.namaTerkunci,
              enabled: !widget.namaTerkunci,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              style: TeksApp.judulHalaman.copyWith(
                color: widget.namaTerkunci ? WarnaApp.teksRedup : null,
              ),
              decoration: const InputDecoration(
                hintText: 'Misalnya Dana Darurat',
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _simpan(),
            ),
            if (namaDitolak) ...[
              const SizedBox(height: JarakApp.j4),
              Text(
                'Nama ini sudah dipakai',
                style: TeksApp.kecil.copyWith(color: WarnaApp.bahaya),
              ),
            ],
            const SizedBox(height: JarakApp.j24),
            const Text('Ikon', style: TeksApp.kecil),
            const SizedBox(height: JarakApp.j12),
            GridPilihIkon(
              daftarIkon: AppData.opsiIkonDompet,
              label: AppData.labelIkonDompet,
              terpilih: _ikon,
              onPilih: (pilihan) => setState(() => _ikon = pilihan),
            ),
            const SizedBox(height: JarakApp.j16),
            TombolUtama(teks: 'Simpan', onTekan: _namaBoleh ? _simpan : null),
          ],
        ),
      ),
    );
  }
}
