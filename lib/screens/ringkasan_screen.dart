import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/privasi.dart';
import '../utils/periode.dart';
import '../widgets/baris_periode.dart';
import '../widgets/dialog_pilih_bulan.dart';
import '../widgets/dialog_pilih_rentang.dart';
import '../widgets/dialog_pilih_tahun.dart';
import '../widgets/distribusi_kategori.dart';
import '../widgets/grafik_tren.dart';
import '../widgets/header_rentang.dart';
import '../widgets/judul_seksi.dart';
import '../widgets/kalender.dart';
import '../widgets/kartu_bagian.dart';
import '../widgets/kartu_navigasi.dart';
import '../widgets/kolom_angka.dart';
import '../widgets/pilihan_segmen.dart';
import '../widgets/ringkasan_anggaran.dart';
import '../widgets/sheet_saran_ai.dart';
import 'budget_screen.dart';

class RingkasanScreen extends StatefulWidget {
  const RingkasanScreen({super.key});

  @override
  State<RingkasanScreen> createState() => _RingkasanScreenState();
}

class _RingkasanScreenState extends State<RingkasanScreen> {
  // _jenis: 0 = Pekan, 1 = Bulan, 2 = Tahun, 3 = Rentang.
  int _jenis = 1;
  DateTime _acuan = DateTime.now();
  // Hanya dipakai di mode Rentang. _akhirRentang eksklusif, sama seperti akhirPeriode.
  DateTime _awalRentang = DateTime.now();
  DateTime _akhirRentang = DateTime.now();

  DateTime get _awal =>
      _jenis == 3 ? _awalRentang : awalPeriode(_jenis, _acuan);

  DateTime get _akhir =>
      _jenis == 3 ? _akhirRentang : akhirPeriode(_jenis, _acuan);

  void _gantiJenis(int jenis) {
    setState(() {
      _jenis = jenis;
      _acuan = DateTime.now();
    });
  }

  void _geser(int arah) {
    setState(() => _acuan = geserPeriode(_jenis, _acuan, arah));
  }

  // Tidak bisa mundur kalau periode sebelumnya berakhir sebelum batas awal data.
  bool _bisaMundur() {
    DateTime sebelum = geserPeriode(_jenis, _acuan, -1);
    return akhirPeriode(_jenis, sebelum).isAfter(AppData.batasAwal());
  }

  // Tidak bisa maju kalau periode berikutnya baru dimulai setelah hari ini.
  bool _bisaMaju() {
    DateTime berikut = geserPeriode(_jenis, _acuan, 1);
    return !awalPeriode(_jenis, berikut).isAfter(AppData.batasAkhir());
  }

  // Panah, dialog, dan kalender memakai batas yang sama dari AppData.
  Future<void> _pilihWaktu() async {
    if (_jenis == 3) return _pilihRentang();
    DateTime batasAwal = AppData.batasAwal();
    DateTime batasAkhir = AppData.batasAkhir();
    DateTime? hasil;
    if (_jenis == 0) {
      hasil = await bukaKalender(
        context,
        awal: _acuan,
        batasAwal: batasAwal,
        batasAkhir: batasAkhir,
        judul: 'Pilih pekan',
        pekan: true,
      );
    } else if (_jenis == 1) {
      hasil = await showDialog<DateTime>(
        context: context,
        builder: (context) => DialogPilihBulan(
          awal: _acuan,
          batasAwal: batasAwal,
          batasAkhir: batasAkhir,
        ),
      );
    } else {
      int? tahun = await showDialog<int>(
        context: context,
        builder: (context) => DialogPilihTahun(
          awal: _acuan.year,
          tahunPertama: batasAwal.year,
          tahunTerakhir: batasAkhir.year,
        ),
      );
      if (tahun != null) hasil = DateTime(tahun);
    }
    if (hasil != null) setState(() => _acuan = hasil!);
  }

  Future<void> _pilihRentang() async {
    DateTimeRange? hasil = await showDialog<DateTimeRange>(
      context: context,
      builder: (context) => DialogPilihRentang(
        mulai: _awal,
        selesai: DateTime(_akhir.year, _akhir.month, _akhir.day - 1),
        batasAwal: AppData.batasAwal(),
        batasAkhir: AppData.batasAkhir(),
      ),
    );
    if (hasil == null) return;
    DateTime akhir = hasil.end;
    setState(() {
      _jenis = 3;
      _awalRentang = hasil.start;
      // end dari dialog ikut dihitung, jadi batas eksklusifnya hari berikutnya.
      _akhirRentang = DateTime(akhir.year, akhir.month, akhir.day + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold putih untuk area status bar, area gulir abu di belakang kartu.
    return Scaffold(
      body: SafeArea(
        child: ColoredBox(
          color: WarnaApp.latarHalaman,
          child: ValueListenableBuilder<int>(
            valueListenable: AppData.refreshNotifier,
            builder: (context, nilai, child) => _bangunIsi(),
          ),
        ),
      ),
    );
  }

  Widget _bangunIsi() {
    DateTime awal = _awal;
    DateTime akhir = _akhir;
    int keluar = AppData.pengeluaranAntara(awal, akhir);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeaderRentang(
            judul: 'Ringkasan',
            rentangAktif: _jenis == 3,
            onRentang: _pilihRentang,
            bawah: [
              PilihanSegmen(
                pilihan: const ['Pekan', 'Bulan', 'Tahun'],
                indeksAktif: _jenis,
                onPilih: _gantiJenis,
              ),
              BarisPeriode(
                jenis: _jenis,
                awal: awal,
                akhir: akhir,
                onSebelum: _bisaMundur() ? () => _geser(-1) : null,
                onSesudah: _bisaMaju() ? () => _geser(1) : null,
                onPilih: _pilihWaktu,
              ),
            ],
          ),
          _kartu(_bangunAngka(awal, akhir, keluar)),
          _kartu(
            DistribusiKategori(
              perKategori: AppData.pengeluaranPerKategori(awal, akhir),
              jenis: _jenis,
              acuan: _acuan,
            ),
            judul: const JudulSeksi(judul: 'Pengeluaran per kategori'),
          ),
          if (keluar > 0)
            _kartu(
              GrafikTren(
                // Pilihan batang dilepas setiap kali periode berganti.
                key: ValueKey('$awal $akhir'),
                jenis: _jenis,
                awal: awal,
                akhir: akhir,
              ),
              judul: const JudulSeksi(judul: 'Tren pengeluaran'),
            ),
          if (_jenis == 1)
            _kartu(
              RingkasanAnggaran(bulan: _acuan),
              judul: JudulSeksi(
                judul: 'Anggaran',
                aksi: 'Atur',
                onAksi: () => Navigator.push(
                  context,
                  buatTransisiHalaman(const BudgetScreen()),
                ),
              ),
            ),
          // Kartu hijau muda ini sudah berupa kartu, jadi tidak dibungkus kartu putih.
          _tepi(_bangunBendahara()),
          const SizedBox(height: JarakApp.j24),
        ],
      ),
    );
  }

  // Kartu ramping: jarak antarkartu di atasnya dan jarak tepi kartu di kiri-kanan.
  Widget _tepi(Widget isi) => Padding(
    padding: const EdgeInsets.fromLTRB(
      JarakApp.tepiKartu,
      JarakApp.antarKartu,
      JarakApp.tepiKartu,
      0,
    ),
    child: isi,
  );

  Widget _kartu(Widget isi, {Widget? judul}) =>
      _tepi(KartuBagian(judul: judul, child: isi));

  Widget _bangunAngka(DateTime awal, DateTime akhir, int keluar) {
    int masuk = AppData.pemasukanAntara(awal, akhir);
    int selisih = masuk - keluar;
    return Row(
      children: [
        Expanded(
          child: KolomAngka(label: 'Pemasukan', nilai: rupiahTampil(masuk)),
        ),
        Expanded(
          child: KolomAngka(label: 'Pengeluaran', nilai: rupiahTampil(keluar)),
        ),
        Expanded(
          child: KolomAngka(
            label: 'Selisih',
            nilai: rupiahTampil(selisih),
            warnaNilai: selisih < 0 ? WarnaApp.bahaya : WarnaApp.primer,
          ),
        ),
      ],
    );
  }

  Widget _bangunBendahara() {
    // Di mode Rentang yang dianalisis bulan dari hari terakhir rentang.
    DateTime bulan = _jenis == 3
        ? DateTime(
            _akhirRentang.year,
            _akhirRentang.month,
            _akhirRentang.day - 1,
          )
        : _acuan;
    String teksBulan = '${namaBulanPanjang[bulan.month - 1]} ${bulan.year}';
    return KartuNavigasi(
      ikon: LucideIcons.bot,
      judul: 'Minta saran Bendahara AI',
      info: 'Analisis catatan $teksBulan',
      onTekan: () => bukaSaranAi(context, bulan),
    );
  }
}
