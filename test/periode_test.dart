import 'package:flutter_test/flutter_test.dart';
import 'package:kasharian/models/app_data.dart';
import 'package:kasharian/utils/format.dart';
import 'package:kasharian/utils/periode.dart';

void main() {
  group('awalPeriode dan akhirPeriode', () {
    test('Pekan dimulai Senin dan berakhir Senin berikutnya', () {
      DateTime kamis = DateTime(2026, 11, 19, 15, 30);
      expect(awalPeriode(0, kamis), DateTime(2026, 11, 16));
      expect(akhirPeriode(0, kamis), DateTime(2026, 11, 23));
    });

    test('Pekan yang diawali Senin tetap di pekan itu', () {
      expect(awalPeriode(0, DateTime(2026, 11, 23)), DateTime(2026, 11, 23));
    });

    test('Bulan dan Tahun', () {
      DateTime acuan = DateTime(2026, 12, 15);
      expect(awalPeriode(1, acuan), DateTime(2026, 12, 1));
      expect(akhirPeriode(1, acuan), DateTime(2027, 1, 1));
      expect(awalPeriode(2, acuan), DateTime(2026, 1, 1));
      expect(akhirPeriode(2, acuan), DateTime(2027, 1, 1));
    });
  });

  group('geserPeriode', () {
    test('Bulan dari tanggal 31 tidak meloncati Februari', () {
      DateTime hasil = geserPeriode(1, DateTime(2026, 1, 31), 1);
      expect(hasil.year, 2026);
      expect(hasil.month, 2);
    });

    test('Bulan melewati pergantian tahun', () {
      expect(geserPeriode(1, DateTime(2026, 12, 10), 1), DateTime(2027, 1));
      expect(geserPeriode(1, DateTime(2026, 1, 10), -1), DateTime(2025, 12));
    });

    test('Pekan melewati pergantian tahun', () {
      expect(geserPeriode(0, DateTime(2025, 12, 31), 1), DateTime(2026, 1, 5));
      expect(geserPeriode(0, DateTime(2026, 1, 1), -1), DateTime(2025, 12, 22));
    });

    test('Tahun', () {
      expect(geserPeriode(2, DateTime(2026, 6, 15), -1), DateTime(2025));
    });
  });

  group('labelPeriode', () {
    test('Pekan dalam satu bulan', () {
      expect(labelPeriode(0, DateTime(2026, 11, 19)), '16–22 November 2026');
    });

    test('Pekan lintas bulan', () {
      expect(
        labelPeriode(0, DateTime(2026, 10, 29)),
        '26 Oktober–1 November 2026',
      );
    });

    test('Pekan lintas tahun', () {
      expect(
        labelPeriode(0, DateTime(2025, 12, 31)),
        '29 Desember 2025–4 Januari 2026',
      );
    });

    test('Bulan dan Tahun', () {
      expect(labelPeriode(1, DateTime(2026, 11, 23)), 'November 2026');
      expect(labelPeriode(2, DateTime(2026, 11, 23)), '2026');
    });
  });

  test('rekapUntukAi memuat pemasukan, pengeluaran, dan kategori terbesar', () {
    DateTime bulan = DateTime.now();
    String rekap = AppData.rekapUntukAi(bulan);
    Map<String, int> perKategori = AppData.pengeluaranPerKategori(
      DateTime(bulan.year, bulan.month),
      DateTime(bulan.year, bulan.month + 1),
    );
    String terbesar = perKategori.keys.first;

    expect(perKategori, isNotEmpty);
    expect(
      rekap,
      contains('Pemasukan: ${formatRupiah(AppData.pemasukanBulan(bulan))}'),
    );
    expect(
      rekap,
      contains('Pengeluaran: ${formatRupiah(AppData.pengeluaranBulan(bulan))}'),
    );
    expect(
      rekap,
      contains('- $terbesar: ${formatRupiah(perKategori[terbesar]!)}'),
    );
    // Kategori terbesar harus benar-benar yang nominalnya paling besar.
    for (int nominal in perKategori.values) {
      expect(perKategori[terbesar]! >= nominal, isTrue);
    }
  });

  group('labelRentang', () {
    test('Satu bulan, lintas bulan, lintas tahun, dan satu hari', () {
      expect(
        labelRentang(DateTime(2026, 11, 1), DateTime(2026, 11, 15)),
        '1–15 November 2026',
      );
      expect(
        labelRentang(DateTime(2026, 10, 28), DateTime(2026, 11, 5)),
        '28 Oktober–5 November 2026',
      );
      expect(
        labelRentang(DateTime(2025, 12, 20), DateTime(2026, 1, 5)),
        '20 Desember 2025–5 Januari 2026',
      );
      expect(
        labelRentang(DateTime(2026, 11, 5), DateTime(2026, 11, 5)),
        '5 November 2026',
      );
    });
  });

  group('trenPengeluaran', () {
    test('Jumlah nilai sesuai mode', () {
      DateTime senin = DateTime(2026, 11, 16);
      expect(
        AppData.trenPengeluaran(0, senin, akhirPeriode(0, senin)).length,
        7,
      );
      DateTime feb = DateTime(2026, 2);
      expect(AppData.trenPengeluaran(1, feb, akhirPeriode(1, feb)).length, 28);
      DateTime nov = DateTime(2026, 11);
      expect(AppData.trenPengeluaran(1, nov, akhirPeriode(1, nov)).length, 30);
      DateTime tahun = DateTime(2026);
      expect(
        AppData.trenPengeluaran(2, tahun, akhirPeriode(2, tahun)).length,
        12,
      );
    });

    test('Rentang 31 hari per hari, lebih dari itu per bulan', () {
      DateTime awal = DateTime(2026, 10, 1);
      expect(
        AppData.trenPengeluaran(3, awal, DateTime(2026, 11, 1)).length,
        31,
      );
      expect(AppData.trenPengeluaran(3, awal, DateTime(2026, 11, 2)).length, 2);
      expect(
        AppData.trenPengeluaran(
          3,
          DateTime(2026, 8, 15),
          DateTime(2026, 11, 2),
        ).length,
        4,
      );
    });

    test('Total tren sama dengan pengeluaranAntara di setiap mode', () {
      DateTime sekarang = DateTime.now();
      List<List<DateTime>> daftarPeriode = [
        for (int jenis = 0; jenis < 3; jenis++)
          [awalPeriode(jenis, sekarang), akhirPeriode(jenis, sekarang)],
      ];
      for (int jenis = 0; jenis < 3; jenis++) {
        DateTime awal = daftarPeriode[jenis][0];
        DateTime akhir = daftarPeriode[jenis][1];
        List<int> tren = AppData.trenPengeluaran(jenis, awal, akhir);
        expect(
          tren.fold(0, (jumlah, n) => jumlah + n),
          AppData.pengeluaranAntara(awal, akhir),
        );
      }
      DateTime awalRentang = DateTime(sekarang.year, sekarang.month - 3, 10);
      DateTime akhirRentang = DateTime(
        sekarang.year,
        sekarang.month,
        sekarang.day + 1,
      );
      List<int> tren = AppData.trenPengeluaran(3, awalRentang, akhirRentang);
      expect(
        tren.fold(0, (jumlah, n) => jumlah + n),
        AppData.pengeluaranAntara(awalRentang, akhirRentang),
      );
    });

    test('Label tren sejajar dengan nilainya', () {
      DateTime nov = DateTime(2026, 11);
      List<String> label = labelTren(1, nov, akhirPeriode(1, nov));
      expect(label.length, 30);
      expect(label.where((l) => l.isNotEmpty), ['1', '8', '15', '22', '29']);
      DateTime senin = DateTime(2026, 11, 16);
      expect(labelTren(0, senin, akhirPeriode(0, senin)), [
        'Sen',
        'Sel',
        'Rab',
        'Kam',
        'Jum',
        'Sab',
        'Min',
      ]);
    });

    test('Sumbu mode Tahun hanya Januari, April, Juli, Oktober', () {
      DateTime tahun = DateTime(2026);
      List<String> label = labelTren(2, tahun, akhirPeriode(2, tahun));
      expect(label.length, 12);
      expect(label.where((l) => l.isNotEmpty), [
        'Januari',
        'April',
        'Juli',
        'Oktober',
      ]);
    });
  });

  test('formatRingkas', () {
    expect(formatRingkas(0), 'Rp 0');
    expect(formatRingkas(950), 'Rp 950');
    expect(formatRingkas(271500), 'Rp 271rb');
    expect(formatRingkas(999999), 'Rp 999rb');
    expect(formatRingkas(1200000), 'Rp 1,2jt');
    expect(formatRingkas(2000000), 'Rp 2jt');
    expect(formatRingkas(1500000000), 'Rp 1.500jt');
    expect(formatRingkas(-271000), '-Rp 271rb');
  });

  group('batas waktu', () {
    test('tahanTanggal menahan tanggal di dalam batas', () {
      DateTime awal = DateTime(2026, 8, 1);
      DateTime akhir = DateTime(2026, 11, 24);
      expect(tahanTanggal(DateTime(2026, 7, 5), awal, akhir), awal);
      expect(tahanTanggal(DateTime(2026, 12, 1), awal, akhir), akhir);
      expect(
        tahanTanggal(DateTime(2026, 9, 9), awal, akhir),
        DateTime(2026, 9, 9),
      );
    });

    test('batasAwal = awal bulan transaksi paling awal', () {
      DateTime pertama = AppData.tanggalTransaksiPertama()!;
      expect(AppData.batasAwal(), DateTime(pertama.year, pertama.month));
    });

    test('batasAwal = 5 tahun lalu kalau belum ada transaksi', () {
      var cadangan = List.of(AppData.daftarTransaksi);
      AppData.daftarTransaksi.clear();
      DateTime sekarang = DateTime.now();
      expect(AppData.batasAwal(), DateTime(sekarang.year - 5, sekarang.month));
      AppData.daftarTransaksi.addAll(cadangan);
    });
  });
}
