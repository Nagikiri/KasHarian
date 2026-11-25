import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/app_bar_turunan.dart';
import '../widgets/gelembung_pesan.dart';
import '../widgets/tombol_pill.dart';

// Percakapan dengan Bendahara AI lewat pertanyaan siap pakai, tanpa kolom ketik.
class BendaharaScreen extends StatefulWidget {
  final DateTime bulan;

  const BendaharaScreen({super.key, required this.bulan});

  @override
  State<BendaharaScreen> createState() => _BendaharaScreenState();
}

class _BendaharaScreenState extends State<BendaharaScreen> {
  final ScrollController _gulir = ScrollController();
  bool _menunggu = false;
  bool _gagal = false;
  String _pertanyaanTerakhir = '';

  @override
  void dispose() {
    _gulir.dispose();
    super.dispose();
  }

  Future<void> _tanya(String pertanyaan) async {
    // Dipanggil sebelum setState supaya pesan pengguna langsung ikut tergambar.
    Future<void> permintaan = AppData.tanyaBendahara(pertanyaan, widget.bulan);
    setState(() {
      _menunggu = true;
      _gagal = false;
      _pertanyaanTerakhir = pertanyaan;
    });
    _gulirKeBawah();
    bool gagal = false;
    try {
      await permintaan;
    } catch (_) {
      gagal = true;
    }
    if (!mounted) return;
    setState(() {
      _menunggu = false;
      _gagal = gagal;
    });
    _gulirKeBawah();
  }

  // Menunggu frame berikutnya supaya gelembung baru sudah punya ukuran.
  void _gulirKeBawah() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_gulir.hasClients) return;
      _gulir.animateTo(
        _gulir.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Seluruh halaman putih supaya gelembung latarSeksi tetap terlihat.
    return Scaffold(
      backgroundColor: WarnaApp.latar,
      appBar: buatAppBarTurunan('Bendahara AI'),
      body: ListView(
        controller: _gulir,
        padding: const EdgeInsets.all(JarakApp.tepiHalaman),
        children: _bangunDaftarPesan(),
      ),
      bottomNavigationBar: _bangunBawah(),
    );
  }

  List<Widget> _bangunDaftarPesan() {
    List<Widget> hasil = [];
    if (AppData.percakapanAi.isEmpty) {
      String teksBulan =
          '${namaBulanPanjang[widget.bulan.month - 1]} ${widget.bulan.year}';
      hasil.add(
        _bangunTeks(
          'Halo! Pilih pertanyaan di bawah, nanti aku baca catatan '
          '$teksBulan-mu.',
        ),
      );
    }
    for (var pesan in AppData.percakapanAi) {
      hasil.add(_bangunTeks(pesan.teks, dariPengguna: pesan.dariPengguna));
    }
    if (_menunggu) hasil.add(_bangunMenunggu());
    if (_gagal) hasil.add(_bangunGagal());
    return hasil;
  }

  Widget _bangunTeks(String teks, {bool dariPengguna = false}) {
    Color warna = dariPengguna ? WarnaApp.diAtasPrimer : WarnaApp.teksUtama;
    return GelembungPesan(
      dariPengguna: dariPengguna,
      child: Text(teks, style: TeksApp.isi.copyWith(color: warna, height: 1.5)),
    );
  }

  Widget _bangunMenunggu() {
    return const GelembungPesan(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: WarnaApp.primer,
            ),
          ),
          SizedBox(width: JarakApp.j8),
          Flexible(
            child: Text(
              'Bendahara sedang membaca catatanmu…',
              style: TeksApp.kecil,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bangunGagal() {
    return GelembungPesan(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Bendahara belum bisa dihubungi.', style: TeksApp.isi),
          const SizedBox(height: JarakApp.j8),
          TombolPill(
            teks: 'Coba lagi',
            kecil: true,
            onTekan: () => _tanya(_pertanyaanTerakhir),
          ),
        ],
      ),
    );
  }

  Widget _bangunBawah() {
    return Container(
      color: WarnaApp.latar,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                JarakApp.tepiHalaman,
                JarakApp.j12,
                JarakApp.tepiHalaman,
                JarakApp.j12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: JarakApp.j8,
                    runSpacing: JarakApp.j8,
                    children: [
                      for (var pertanyaan in AppData.daftarPertanyaanAi)
                        TombolPill(
                          teks: pertanyaan,
                          onTekan: _menunggu ? null : () => _tanya(pertanyaan),
                        ),
                    ],
                  ),
                  const SizedBox(height: JarakApp.j8),
                  const Text(
                    'Saran dibuat otomatis, bukan nasihat keuangan profesional.',
                    style: TeksApp.mini,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
