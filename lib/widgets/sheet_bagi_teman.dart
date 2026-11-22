import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/bagian_teman.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'sheet_input_nominal.dart';
import 'tombol_pill.dart';
import 'tombol_utama.dart';

// Mengembalikan List<BagianTeman> lewat Navigator.pop saat Selesai ditekan.
class SheetBagiTeman extends StatefulWidget {
  final int total;
  final List<BagianTeman> awal;

  const SheetBagiTeman({super.key, required this.total, required this.awal});

  @override
  State<SheetBagiTeman> createState() => _SheetBagiTemanState();
}

class _SheetBagiTemanState extends State<SheetBagiTeman> {
  // Disalin supaya perubahan batal kalau sheet ditutup tanpa menekan Selesai.
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

    return Padding(
      // viewInsets.bottom = tinggi keyboard, supaya isian tidak tertutup.
      padding: EdgeInsets.fromLTRB(
        JarakApp.tepiHalaman,
        JarakApp.j24,
        JarakApp.tepiHalaman,
        JarakApp.j24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Bagi dengan teman', style: TeksApp.judulSeksi),
            const SizedBox(height: JarakApp.j4),
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
                  TombolPill(
                    teks: 'Bagi rata',
                    kecil: true,
                    onTekan: _bagiRata,
                  ),
              ],
            ),
            if (melebihi) ...[
              const SizedBox(height: JarakApp.j12),
              Text(
                'Bagian teman melebihi total',
                style: TeksApp.kecil.copyWith(color: WarnaApp.bahaya),
              ),
            ],
            const SizedBox(height: JarakApp.j24),
            TombolUtama(
              teks: 'Selesai',
              onTekan: melebihi ? null : () => Navigator.pop(context, _daftar),
            ),
          ],
        ),
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
