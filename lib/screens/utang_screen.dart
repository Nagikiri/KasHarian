import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../models/utang.dart';
import '../theme/app_theme.dart';
import '../utils/privasi.dart';
import '../widgets/app_bar_turunan.dart';
import '../widgets/baris_utang.dart';
import '../widgets/blok_daftar.dart';
import '../widgets/kartu_bagian.dart';
import '../widgets/kolom_angka.dart';
import '../widgets/pilihan_segmen.dart';
import '../widgets/tampilan_kosong.dart';
import '../widgets/tombol_utama.dart';
import 'catat_utang_screen.dart';

class UtangScreen extends StatefulWidget {
  const UtangScreen({super.key});

  @override
  State<UtangScreen> createState() => _UtangScreenState();
}

class _UtangScreenState extends State<UtangScreen> {
  final List<String> _pilihanFilter = const ['Semua', 'Utang', 'Piutang'];
  int _filter = 0;
  // Urutannya sama dengan _pilihanFilter.
  final List<String> _judulKosong = const [
    'Belum ada catatan',
    'Belum ada utang',
    'Belum ada piutang',
  ];

  List<UtangItem> _daftarTampil() {
    List<UtangItem> cocok = AppData.daftarUtang
        .where((u) => _filter == 0 || u.jenis == _pilihanFilter[_filter])
        .toList();
    // Yang belum lunas di atas, yang lunas di bawah.
    return [...cocok.where((u) => !u.lunas), ...cocok.where((u) => u.lunas)];
  }

  void _lunasi(UtangItem utang) {
    AppData.lunasiUtang(utang);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${utang.nama} ditandai lunas')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarnaApp.latarHalaman,
      appBar: buatAppBarTurunan('Utang & Piutang'),
      body: ValueListenableBuilder<int>(
        valueListenable: AppData.refreshNotifier,
        builder: (context, nilai, child) {
          List<UtangItem> daftar = _daftarTampil();
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  JarakApp.tepiKartu,
                  JarakApp.antarKartu,
                  JarakApp.tepiKartu,
                  0,
                ),
                child: KartuBagian(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PilihanSegmen(
                        pilihan: _pilihanFilter,
                        indeksAktif: _filter,
                        onPilih: (i) => setState(() => _filter = i),
                      ),
                      const SizedBox(height: JarakApp.j16),
                      _bangunTotal(),
                    ],
                  ),
                ),
              ),
              BlokDaftar(child: _bangunDaftar(daftar)),
            ],
          );
        },
      ),
      bottomNavigationBar: ColoredBox(
        color: WarnaApp.latar,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(JarakApp.tepiHalaman),
            child: TombolUtama(teks: 'Catat Utang', onTekan: _bukaFormUtang),
          ),
        ),
      ),
    );
  }

  Widget _bangunDaftar(List<UtangItem> daftar) {
    if (daftar.isEmpty) {
      return TampilanKosong(
        ikon: LucideIcons.handCoins,
        judul: _judulKosong[_filter],
        kalimat: 'Catat lewat tombol Catat Utang di bawah.',
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < daftar.length; i++) ...[
          if (i > 0) const Divider(height: 1),
          BarisUtang(utang: daftar[i], onLunas: () => _lunasi(daftar[i])),
        ],
      ],
    );
  }

  Widget _bangunTotal() {
    return Row(
      children: [
        Expanded(
          child: KolomAngka(
            label: 'Piutang',
            nilai: _teksTotal('Piutang', '+'),
            warnaNilai: WarnaApp.primer,
          ),
        ),
        Expanded(
          child: KolomAngka(
            label: 'Utang',
            nilai: _teksTotal('Utang', '-'),
            warnaNilai: WarnaApp.teksUtama,
          ),
        ),
      ],
    );
  }

  // Total 0 ditulis tanpa tanda, supaya tidak muncul "-Rp 0".
  String _teksTotal(String jenis, String tanda) {
    int total = AppData.totalBelumLunas(jenis);
    return total == 0 ? 'Rp 0' : '$tanda${rupiahTampil(total)}';
  }

  void _bukaFormUtang() {
    Navigator.push(context, buatTransisiHalaman(const CatatUtangScreen()));
  }
}
