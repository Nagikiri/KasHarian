import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../models/kategori.dart';
import '../models/wishlist.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/nominal.dart';
import 'baris_isian.dart';
import 'header_sheet.dart';
import 'numpad_simpan.dart';
import 'pilihan_segmen.dart';
import 'sheet_catatan.dart';
import 'tampilan_nominal.dart';
import 'template_nominal.dart';

// Langkah kedua sheet impian baru: harga valas lewat numpad dan nama lewat sheet teks.
class IsianImpian extends StatefulWidget {
  final KategoriItem kategori;
  final VoidCallback onGanti;

  const IsianImpian({super.key, required this.kategori, required this.onGanti});

  @override
  State<IsianImpian> createState() => _IsianImpianState();
}

class _IsianImpianState extends State<IsianImpian> {
  final List<String> _daftarMataUang = ['IDR', ...AppData.kursKeIdr.keys];
  int _mataUang = 0;
  int _harga = 0;
  String _nama = '';

  String get _kode => _daftarMataUang[_mataUang];
  bool get _rupiah => _kode == 'IDR';

  // Satu yen bernilai kecil, jadi templatenya dikali 100.
  List<int> get _template {
    if (_rupiah) return [100000, 500000, 1000000, 5000000];
    if (_kode == 'JPY') return [1000, 5000, 10000, 50000];
    return [10, 50, 100, 500];
  }

  List<String> get _labelTemplate {
    if (_rupiah) return ['+100rb', '+500rb', '+1jt', '+5jt'];
    return [for (int n in _template) '+${formatTitik(n)}'];
  }

  Future<void> _ubahNama() async {
    String? hasil = await bukaCatatan(
      context,
      _nama,
      judul: 'Nama impian',
      petunjuk: 'Tulis nama impian',
    );
    if (hasil == null || !mounted) return;
    setState(() => _nama = hasil);
  }

  void _simpan() {
    AppData.tambahWishlist(
      WishlistItem(
        nama: _nama,
        kategori: widget.kategori.nama,
        mataUang: _kode,
        hargaAsing: _harga,
        targetIdr: AppData.targetDariKurs(_kode, _harga),
        terkumpulIdr: 0,
        ikon: widget.kategori.ikon,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        JarakApp.tepiHalaman,
        JarakApp.j8,
        JarakApp.tepiHalaman,
        JarakApp.j16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeaderSheet(
            judul: widget.kategori.nama,
            ikon: widget.kategori.ikon,
            ujung: TextButton(
              onPressed: widget.onGanti,
              child: Text(
                'Ganti',
                style: TeksApp.tombolKecil.copyWith(color: WarnaApp.primer),
              ),
            ),
          ),
          const SizedBox(height: JarakApp.j16),
          PilihanSegmen(
            pilihan: _daftarMataUang,
            indeksAktif: _mataUang,
            // Angka lama tidak berarti di mata uang lain, jadi harga diulang dari 0.
            onPilih: (i) => setState(() {
              _mataUang = i;
              _harga = 0;
            }),
          ),
          const SizedBox(height: JarakApp.j16),
          TampilanNominal(
            label: 'Harga',
            nominal: _harga,
            prefix: _rupiah ? 'Rp' : _kode,
          ),
          if (!_rupiah) ...[
            const SizedBox(height: JarakApp.j4),
            Text(
              'Setara ${formatRupiah(AppData.targetDariKurs(_kode, _harga))}',
              style: TeksApp.isi.copyWith(
                color: WarnaApp.primer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: JarakApp.j12),
          TemplateNominal(
            daftarNilai: _template,
            daftarLabel: _labelTemplate,
            onTambah: (n) => setState(() => _harga = tambahNominal(_harga, n)),
            onReset: () => setState(() => _harga = 0),
          ),
          const SizedBox(height: JarakApp.j8),
          BarisIsian(
            ikon: LucideIcons.pencilLine,
            label: 'Nama impian',
            nilai: _nama.isEmpty ? 'Belum diisi' : _nama,
            warnaNilai: _nama.isEmpty ? WarnaApp.teksRedup : null,
            onTekan: _ubahNama,
          ),
          const Spacer(),
          NumpadSimpan(
            onAngka: (a) => setState(() => _harga = tambahDigit(_harga, a)),
            onHapus: () => setState(() => _harga = hapusDigit(_harga)),
            onSimpan: _nama.isNotEmpty && _harga > 0 ? _simpan : null,
          ),
        ],
      ),
    );
  }
}
