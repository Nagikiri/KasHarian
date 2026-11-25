import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../models/dompet.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/nominal.dart';
import '../utils/privasi.dart';
import '../widgets/dialog_info.dart';
import '../widgets/dialog_konfirmasi_hapus.dart';
import '../widgets/halaman_form.dart';
import '../widgets/halaman_nama_ikon.dart';
import '../widgets/ikon_bulat.dart';
import '../widgets/kotak_saldo.dart';
import '../widgets/numpad_simpan.dart';
import '../widgets/template_nominal.dart';

// Dipakai untuk tambah (dompetLama null) dan ubah dompet.
class FormDompetScreen extends StatefulWidget {
  final Dompet? dompetLama;

  const FormDompetScreen({super.key, this.dompetLama});

  @override
  State<FormDompetScreen> createState() => _FormDompetScreenState();
}

class _FormDompetScreenState extends State<FormDompetScreen> {
  String _nama = '';
  IconData _ikon = LucideIcons.wallet;
  int _saldoAwal = 0;

  Dompet? get _lama => widget.dompetLama;
  bool get _tetap => _lama != null && AppData.dompetTetap.contains(_lama!.nama);
  bool get _namaBoleh => AppData.namaDompetBoleh(_nama, lama: _lama);
  // Ikon Tabungan dikunci supaya selalu dikenali sebagai celengan di mana pun.
  bool get _ikonTerkunci => _lama?.nama == 'Tabungan';

  @override
  void initState() {
    super.initState();
    _nama = _lama?.nama ?? '';
    _ikon = _lama?.ikon ?? LucideIcons.wallet;
    _saldoAwal = _lama?.saldoAwal ?? 0;
  }

  void _ubahSaldo(int nilai) => setState(() => _saldoAwal = nilai);

  Future<void> _ubahIdentitas() async {
    Dompet? hasil = await bukaNamaIkon(
      context,
      nama: _nama,
      ikon: _ikon,
      lama: _lama,
      namaTerkunci: _tetap,
    );
    if (hasil == null || !mounted) return;
    setState(() {
      _nama = hasil.nama;
      _ikon = hasil.ikon;
    });
  }

  void _simpan() {
    Dompet? lama = _lama;
    if (lama == null) {
      AppData.tambahDompet(
        Dompet(nama: _nama, ikon: _ikon, saldoAwal: _saldoAwal),
      );
    } else {
      AppData.ubahDompet(lama, nama: _nama, ikon: _ikon, saldoAwal: _saldoAwal);
    }
    // Nama dikembalikan supaya halaman Pilih dompet bisa langsung memilih dompet baru.
    Navigator.pop(context, _nama);
  }

  Future<void> _hapus(Dompet dompet) async {
    final navigator = Navigator.of(context);
    int dipakai = AppData.jumlahTransaksiDompet(dompet.nama);
    if (dipakai > 0) {
      await showDialog<void>(
        context: context,
        builder: (context) => DialogInfo(
          ikon: LucideIcons.wallet,
          judul: 'Dompet tidak bisa dihapus',
          pesan:
              'Dompet ini masih dipakai di $dipakai transaksi. Hapus transaksinya dulu, atau biarkan dompet ini tetap ada.',
        ),
      );
      return;
    }
    bool? hapus = await showDialog<bool>(
      context: context,
      builder: (context) =>
          DialogKonfirmasiHapus(judul: 'Hapus dompet ${dompet.nama}?'),
    );
    if (hapus != true) return;
    AppData.hapusDompet(dompet);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    Dompet? lama = _lama;
    return HalamanForm(
      judul: lama == null ? 'Tambah dompet' : 'Ubah dompet',
      aksi: [
        if (lama != null && !_tetap)
          IconButton(
            tooltip: 'Hapus dompet',
            icon: const Icon(
              LucideIcons.trash2,
              size: 20,
              color: WarnaApp.teksUtama,
            ),
            onPressed: () => _hapus(lama),
          ),
      ],
      isi: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: JarakApp.tepiHalaman,
          vertical: JarakApp.j8,
        ),
        child: _bangunIsian(),
      ),
      bawah: NumpadSimpan(
        onAngka: (a) => _ubahSaldo(tambahDigit(_saldoAwal, a)),
        onHapus: () => _ubahSaldo(hapusDigit(_saldoAwal)),
        onSimpan: _namaBoleh ? _simpan : null,
      ),
    );
  }

  Widget _bangunIsian() {
    Dompet? lama = _lama;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _bangunIdentitas(),
        const Divider(height: 1),
        const SizedBox(height: JarakApp.j16),
        KotakSaldo(
          label: 'Saldo awal',
          // Angka yang sedang diketik selalu tampil walau nominal disembunyikan (aturan V4d).
          angka: formatRupiah(_saldoAwal),
          warnaLatar: WarnaApp.latarSeksi,
          warnaAngka: _saldoAwal == 0 ? WarnaApp.teksRedup : WarnaApp.teksUtama,
        ),
        if (lama != null) ...[
          const SizedBox(height: JarakApp.j8),
          KotakSaldo(
            label: 'Saldo sekarang',
            angka: rupiahTampil(AppData.saldoSumber(lama.nama)),
            warnaLatar: WarnaApp.aksenLembut,
            warnaAngka: WarnaApp.primer,
            keterangan: _saldoAwal == lama.saldoAwal
                ? null
                : 'Menjadi ${rupiahTampil(_saldoSetelahDisimpan(lama))} setelah disimpan',
          ),
        ],
        const SizedBox(height: JarakApp.j8),
        Text(
          lama == null ? 'Uang di dompet ini saat mulai dicatat.' : 'Saldo awal hanya untuk modal awal atau koreksi. Untuk menambah uang, catat Pemasukan atau Pindah.',
          style: TeksApp.kecil,
        ),
        const SizedBox(height: JarakApp.j12),
        TemplateNominal(
          onTambah: (n) => _ubahSaldo(tambahNominal(_saldoAwal, n)),
          onReset: () => _ubahSaldo(0),
        ),
      ],
    );
  }

  // Tabungan tidak bisa diketuk karena nama dan ikonnya dikunci.
  Widget _bangunIdentitas() {
    bool bisaUbah = !_ikonTerkunci;
    return InkWell(
      onTap: bisaUbah ? _ubahIdentitas : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: JarakApp.j12),
        child: Row(
          children: [
            IkonBulat(ikon: _ikon),
            const SizedBox(width: JarakApp.j12),
            Expanded(
              child: Text(
                _nama.isEmpty ? 'Isi nama dan ikon' : _nama,
                style: _nama.isEmpty
                    ? TeksApp.isi.copyWith(color: WarnaApp.teksRedup)
                    : TeksApp.judulSeksi,
              ),
            ),
            if (bisaUbah) ...[
              Text(
                'Ubah',
                style: TeksApp.tombolKecil.copyWith(color: WarnaApp.primer),
              ),
              const Icon(
                LucideIcons.chevronRight,
                size: 16,
                color: WarnaApp.primer,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Saldo sekarang ditambah selisih saldo awal, jadi terlihat hasilnya sebelum disimpan.
  int _saldoSetelahDisimpan(Dompet lama) =>
      AppData.saldoSumber(lama.nama) - lama.saldoAwal + _saldoAwal;
}
