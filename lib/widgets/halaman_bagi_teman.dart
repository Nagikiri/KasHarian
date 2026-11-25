import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../main.dart';
import '../models/bagian_teman.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'halaman_form.dart';
import 'halaman_input_nominal.dart';
import 'tombol_pill.dart';
import 'tombol_utama.dart';

// Mengembalikan List<BagianTeman> saat Selesai ditekan, atau null kalau ditutup.
Future<List<BagianTeman>?> bukaBagiTeman(
  BuildContext context, {
  required int total,
  required List<BagianTeman> awal,
}) async {
  // Disimpan ke var dulu karena buatTransisiHalaman tidak membawa tipe hasil.
  var hasil = await Navigator.push(
    context,
    buatTransisiHalaman(HalamanBagiTeman(total: total, awal: awal)),
  );
  return hasil;
}

class HalamanBagiTeman extends StatefulWidget {
  final int total;
  final List<BagianTeman> awal;

  const HalamanBagiTeman({super.key, required this.total, required this.awal});

  @override
  State<HalamanBagiTeman> createState() => _HalamanBagiTemanState();
}

class _HalamanBagiTemanState extends State<HalamanBagiTeman> {
  // Disalin supaya perubahan batal kalau halaman ditutup tanpa menekan Selesai.
  late final List<BagianTeman> _daftar = [
    for (var t in widget.awal) BagianTeman(nama: t.nama, nominal: t.nominal),
  ];

  void _bagiRata() {
    // Ditambah 1 karena diri sendiri juga menanggung satu bagian.
    int bagian = widget.total ~/ (_daftar.length + 1);
    setState(() {
      for (var t in _daftar) {
        t.nominal = bagian;
      }
    });
  }

  void _ubahNominal(BagianTeman teman) {
    String nama = teman.nama.trim();
    bukaInputNominal(
      context,
      judul: nama.isEmpty ? 'Bagian teman' : 'Bagian $nama',
      ikon: LucideIcons.user,
      nominalAwal: teman.nominal,
      onSimpan: (n) => setState(() => teman.nominal = n),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool melebihi = totalBagian(_daftar) > widget.total;

    return HalamanForm(
      judul: 'Bagi dengan teman',
      isi: ListView(
        padding: const EdgeInsets.all(JarakApp.tepiHalaman),
        children: [
          Text('Total ${formatRupiah(widget.total)}', style: TeksApp.kecil),
          const SizedBox(height: JarakApp.j16),
          if (_daftar.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: JarakApp.j12),
              child: Text('Belum ada teman', style: TeksApp.kecil),
            ),
          for (var teman in _daftar) _bangunBaris(teman),
          const SizedBox(height: JarakApp.j4),
          Row(
            children: [
              TombolPill(
                teks: '+ Teman',
                kecil: true,
                onTekan: () => setState(() => _daftar.add(BagianTeman())),
              ),
              const SizedBox(width: JarakApp.j8),
              if (_daftar.isNotEmpty)
                TombolPill(teks: 'Bagi rata', kecil: true, onTekan: _bagiRata),
            ],
          ),
          if (melebihi) ...[
            const SizedBox(height: JarakApp.j12),
            Text(
              'Bagian teman melebihi total',
              style: TeksApp.kecil.copyWith(color: WarnaApp.bahaya),
            ),
          ],
        ],
      ),
      bawah: TombolUtama(
        teks: 'Selesai',
        onTekan: melebihi ? null : () => Navigator.pop(context, _daftar),
      ),
    );
  }

  Widget _bangunBaris(BagianTeman teman) {
    return Padding(
      // Key dari objek teman supaya isi TextField tidak tertukar saat baris dihapus.
      key: ObjectKey(teman),
      padding: const EdgeInsets.only(bottom: JarakApp.j8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: teman.nama,
              decoration: const InputDecoration(hintText: 'Nama teman'),
              onChanged: (v) => teman.nama = v,
            ),
          ),
          const SizedBox(width: JarakApp.j8),
          TombolPill(
            teks: formatRupiah(teman.nominal),
            onTekan: () => _ubahNominal(teman),
          ),
          IconButton(
            icon: const Icon(
              LucideIcons.trash2,
              size: 20,
              color: WarnaApp.teksRedup,
            ),
            onPressed: () => setState(() => _daftar.remove(teman)),
          ),
        ],
      ),
    );
  }
}
