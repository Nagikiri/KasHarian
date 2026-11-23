import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/periode.dart';
import '../widgets/bar_distribusi.dart';
import '../widgets/baris_distribusi.dart';
import '../widgets/judul_seksi.dart';
import '../widgets/kartu_navigasi.dart';
import '../widgets/kolom_angka.dart';
import '../widgets/lingkaran_anggaran.dart';
import '../widgets/pilihan_segmen.dart';
import '../widgets/sheet_saran_ai.dart';
import '../widgets/tombol_panah.dart';
import 'budget_screen.dart';

class RingkasanScreen extends StatefulWidget {
  const RingkasanScreen({super.key});

  @override
  State<RingkasanScreen> createState() => _RingkasanScreenState();
}

class _RingkasanScreenState extends State<RingkasanScreen> {
  // _jenis: 0 = Pekan, 1 = Bulan, 2 = Tahun.
  int _jenis = 1;
  DateTime _acuan = DateTime.now();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<int>(
          valueListenable: AppData.refreshNotifier,
          builder: (context, nilai, child) {
            DateTime awal = awalPeriode(_jenis, _acuan);
            DateTime akhir = akhirPeriode(_jenis, _acuan);
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
                  _tepi(_bangunPeriode()),
                  _tepi(_bangunAngka(awal, akhir)),
                  const SizedBox(height: JarakApp.j24),
                  _bangunPita(),
                  if (_jenis == 1) ...[
                    _tepi(_bangunAnggaran()),
                    const SizedBox(height: JarakApp.j24),
                    _bangunPita(),
                  ],
                  _tepi(_bangunDistribusi(awal, akhir)),
                  const SizedBox(height: JarakApp.j24),
                  _bangunPita(),
                  _tepi(_bangunBendahara()),
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

  Widget _bangunPita() => Container(height: 8, color: WarnaApp.latarSeksi);

  Widget _bangunPeriode() {
    return Row(
      children: [
        TombolPanah(
          ikon: LucideIcons.chevronLeft,
          onTekan: _bisaMundur() ? () => _geser(-1) : null,
        ),
        Expanded(
          child: Text(
            labelPeriode(_jenis, _acuan),
            style: TeksApp.judulSeksi,
            textAlign: TextAlign.center,
          ),
        ),
        TombolPanah(
          ikon: LucideIcons.chevronRight,
          onTekan: _bisaMaju() ? () => _geser(1) : null,
        ),
      ],
    );
  }

  Widget _bangunAngka(DateTime awal, DateTime akhir) {
    int masuk = AppData.pemasukanAntara(awal, akhir);
    int keluar = AppData.pengeluaranAntara(awal, akhir);
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JudulSeksi(
          judul: 'Anggaran',
          aksi: 'Atur',
          onAksi: () => Navigator.push(
            context,
            buatTransisiHalaman(const BudgetScreen()),
          ),
        ),
        const SizedBox(height: JarakApp.j16),
        Row(
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
        ),
      ],
    );
  }

  Widget _bangunDistribusi(DateTime awal, DateTime akhir) {
    Map<String, int> perKategori = AppData.pengeluaranPerKategori(awal, akhir);
    List<String> daftarNama = perKategori.keys.toList();
    List<int> daftarNominal = perKategori.values.toList();
    int total = daftarNominal.fold(0, (jumlah, n) => jumlah + n);

    // Bar hanya menampilkan 4 terbesar, sisanya digabung jadi satu segmen "Lainnya".
    List<int> nilaiBar = daftarNominal.take(4).toList();
    if (daftarNominal.length > 4) {
      nilaiBar.add(daftarNominal.skip(4).fold(0, (jumlah, n) => jumlah + n));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const JudulSeksi(judul: 'Pengeluaran per kategori'),
        const SizedBox(height: JarakApp.j12),
        if (total == 0)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: JarakApp.j12),
            child: Text(
              'Belum ada pengeluaran di periode ini',
              style: TeksApp.kecil,
            ),
          )
        else ...[
          BarDistribusi(daftarNilai: nilaiBar, daftarWarna: WarnaApp.grafik),
          const SizedBox(height: JarakApp.j8),
          for (int i = 0; i < daftarNama.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            BarisDistribusi(
              ikon: AppData.ikonKategori(daftarNama[i]),
              nama: daftarNama[i],
              nominal: daftarNominal[i],
              persen: daftarNominal[i] / total,
              warnaTitik: i < 4 ? WarnaApp.grafik[i] : null,
            ),
          ],
        ],
      ],
    );
  }

  Widget _bangunBendahara() {
    String bulan = '${namaBulanPanjang[_acuan.month - 1]} ${_acuan.year}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const JudulSeksi(judul: 'Bendahara AI'),
        const SizedBox(height: JarakApp.j12),
        KartuNavigasi(
          ikon: LucideIcons.bot,
          judul: 'Minta saran Bendahara AI',
          info: 'Analisis catatan $bulan',
          onTekan: () => bukaSaranAi(context, _acuan),
        ),
      ],
    );
  }
}
