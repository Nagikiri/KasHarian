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
      expect(labelPeriode(0, DateTime(2026, 11, 19)), '16–22 Nov 2026');
    });

    test('Pekan lintas bulan', () {
      expect(labelPeriode(0, DateTime(2026, 10, 29)), '26 Okt–1 Nov 2026');
    });

    test('Pekan lintas tahun', () {
      expect(labelPeriode(0, DateTime(2025, 12, 31)), '29 Des 2025–4 Jan 2026');
    });

    test('Bulan dan Tahun', () {
      expect(labelPeriode(1, DateTime(2026, 11, 23)), 'Nov 2026');
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
}
