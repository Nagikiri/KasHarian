import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/periode.dart';
import '../widgets/baris_periode.dart';
import '../widgets/dialog_pilih_bulan.dart';
import '../widgets/dialog_pilih_tahun.dart';
import '../widgets/distribusi_kategori.dart';
import '../widgets/grafik_tren.dart';
import '../widgets/judul_seksi.dart';
import '../widgets/kartu_navigasi.dart';
import '../widgets/kolom_angka.dart';
import '../widgets/lingkaran_anggaran.dart';
import '../widgets/pilihan_segmen.dart';
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

  // Tidak bisa mundur kalau periode sebelumnya berakhir sebelum transaksi paling awal.
  bool _bisaMundur() {
    DateTime? pertama = AppData.tanggalTransaksiPertama();
    if (pertama == null) return false;
    DateTime sebelum = geserPeriode(_jenis, _acuan, -1);
    return akhirPeriode(_jenis, sebelum).isAfter(pertama);
  }

  // Tidak bisa maju kalau periode berikutnya baru dimulai setelah hari ini.
  bool _bisaMaju() {
    DateTime berikut = geserPeriode(_jenis, _acuan, 1);
    return !awalPeriode(_jenis, berikut).isAfter(DateTime.now());
  }

  // Semua pemilih di Ringkasan dibatasi sampai hari ini.
  Future<void> _pilihWaktu() async {
    DateTime sekarang = DateTime.now();
    DateTime? hasil;
    if (_jenis == 0) {
      hasil = await showDatePicker(
        context: context,
        initialDate: _acuan,
        firstDate: DateTime(2024),
        lastDate: sekarang,
        helpText: 'Pilih tanggal dalam pekan',
      );
    } else if (_jenis == 1) {
      hasil = await showDialog<DateTime>(
        context: context,
        builder: (context) => DialogPilihBulan(awal: _acuan, batas: sekarang),
      );
    } else {
      int? tahun = await showDialog<int>(
        context: context,
        builder: (context) =>
            DialogPilihTahun(awal: _acuan.year, tahunTerakhir: sekarang.year),
      );
      if (tahun != null) hasil = DateTime(tahun);
    }
    if (hasil != null) setState(() => _acuan = hasil!);
  }

  Future<void> _pilihRentang() async {
    DateTime sekarang = DateTime.now();
    DateTime? dari = await showDatePicker(
      context: context,
      initialDate: _awal,
      firstDate: DateTime(2024),
      lastDate: sekarang,
      helpText: 'Dari tanggal',
    );
    if (dari == null || !mounted) return;
    // firstDate = dari, jadi tanggal kedua tidak bisa sebelum tanggal pertama.
    DateTime? sampai = await showDatePicker(
      context: context,
      initialDate: dari,
      firstDate: dari,
      lastDate: sekarang,
      helpText: 'Sampai tanggal',
    );
    if (sampai == null) return;
    setState(() {
      _jenis = 3;
      _awalRentang = dari;
      _akhirRentang = DateTime(sampai.year, sampai.month, sampai.day + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<int>(
          valueListenable: AppData.refreshNotifier,
          builder: (context, nilai, child) {
            DateTime awal = _awal;
            DateTime akhir = _akhir;
            int keluar = AppData.pengeluaranAntara(awal, akhir);
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _tepi(const Text('Ringkasan', style: TeksApp.judulHalaman)),
                  _tepi(
                    PilihanSegmen(
                      pilihan: const ['Pekan', 'Bulan', 'Tahun'],
                      indeksAktif: _jenis,
                      onPilih: _gantiJenis,
                    ),
                  ),
                  _tepi(
                    BarisPeriode(
                      jenis: _jenis,
                      awal: awal,
                      akhir: akhir,
                      onSebelum: _bisaMundur() ? () => _geser(-1) : null,
                      onSesudah: _bisaMaju() ? () => _geser(1) : null,
                      onPilih: _pilihWaktu,
                      onRentang: _pilihRentang,
                    ),
                  ),
                  _tepi(_bangunAngka(awal, akhir, keluar)),
                  ..._bangunBagian(
                    const JudulSeksi(judul: 'Pengeluaran per kategori'),
                    DistribusiKategori(
                      perKategori: AppData.pengeluaranPerKategori(awal, akhir),
                    ),
                  ),
                  if (keluar > 0)
                    ..._bangunBagian(
                      const JudulSeksi(judul: 'Tren pengeluaran'),
                      GrafikTren(
                        nilai: AppData.trenPengeluaran(_jenis, awal, akhir),
                        label: labelTren(_jenis, awal, akhir),
                      ),
                    ),
                  if (_jenis == 1)
                    ..._bangunBagian(
                      JudulSeksi(
                        judul: 'Anggaran',
                        aksi: 'Atur',
                        onAksi: () => Navigator.push(
                          context,
                          buatTransisiHalaman(const BudgetScreen()),
                        ),
                      ),
                      _bangunAnggaran(),
                    ),
                  ..._bangunBagian(
                    const JudulSeksi(judul: 'Bendahara AI'),
                    _bangunBendahara(),
                  ),
                  const SizedBox(height: JarakApp.j24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Pita pemisah harus selebar layar, jadi padding samping dipasang per bagian.
  Widget _tepi(Widget isi) => Padding(
    padding: const EdgeInsets.fromLTRB(
      JarakApp.tepiHalaman,
      JarakApp.j16,
      JarakApp.tepiHalaman,
      0,
    ),
    child: isi,
  );

  // Setiap bagian diawali jarak dan pita pemisah, lalu judul seksi dan isinya.
  List<Widget> _bangunBagian(Widget judul, Widget isi) => [
    const SizedBox(height: JarakApp.j24),
    Container(height: 8, color: WarnaApp.latarSeksi),
    _tepi(judul),
    _tepi(isi),
  ];

  Widget _bangunAngka(DateTime awal, DateTime akhir, int keluar) {
    int masuk = AppData.pemasukanAntara(awal, akhir);
    int selisih = masuk - keluar;
    return Row(
      children: [
        Expanded(
          child: KolomAngka(label: 'Pemasukan', nilai: formatRupiah(masuk)),
        ),
        Expanded(
          child: KolomAngka(label: 'Pengeluaran', nilai: formatRupiah(keluar)),
        ),
        Expanded(
          child: KolomAngka(
            label: 'Selisih',
            nilai: formatRupiah(selisih),
            warnaNilai: selisih < 0 ? WarnaApp.bahaya : WarnaApp.primer,
          ),
        ),
      ],
    );
  }

  Widget _bangunAnggaran() {
    int anggaran = AppData.anggaranBulanan;
    int terpakai = AppData.terpakaiAnggaran(_acuan);
    int sisa = anggaran - terpakai;
    // Anggaran 0 tidak bisa dibagi, jadi persennya dianggap 0.
    double persen = anggaran > 0 ? terpakai / anggaran : 0;

    return Row(
      children: [
        LingkaranAnggaran(persen: persen),
        const SizedBox(width: JarakApp.j24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KolomAngka(label: 'Terpakai', nilai: formatRupiah(terpakai)),
              const SizedBox(height: JarakApp.j8),
              KolomAngka(label: 'Anggaran', nilai: formatRupiah(anggaran)),
              const SizedBox(height: JarakApp.j8),
              // Budget adalah rencana, jadi kelebihan ditulis positif, bukan "Sisa -Rp".
              KolomAngka(
                label: sisa < 0 ? 'Lebih' : 'Sisa',
                nilai: formatRupiah(sisa.abs()),
                warnaNilai: sisa < 0 ? WarnaApp.bahaya : null,
              ),
            ],
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
