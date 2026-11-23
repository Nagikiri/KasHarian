import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasharian/utils/format.dart';
import 'package:kasharian/utils/periode.dart';

void main() {
  group('rentangPembanding dan labelPembanding', () {
    void cek(
      int jenis,
      DateTime hariIni,
      DateTime awal,
      DateTime akhir,
      String label, {
      DateTime? acuan,
    }) {
      DateTimeRange r = rentangPembanding(jenis, acuan ?? hariIni, hariIni);
      expect(r.start, awal);
      expect(r.end, akhir);
      expect(labelPembanding(jenis, acuan ?? hariIni, r), label);
    }

    test('Bulan berjalan dibanding tanggal yang sama bulan lalu', () {
      DateTime hariIni = DateTime(2026, 11, 24, 15);
      cek(
        1,
        hariIni,
        DateTime(2026, 10, 1),
        DateTime(2026, 10, 25),
        '1–24 Oktober 2026',
      );
    });

    test('Bulan yang sudah lewat dibanding bulan lalu penuh', () {
      cek(
        1,
        DateTime(2026, 11, 24),
        DateTime(2026, 9, 1),
        DateTime(2026, 10, 1),
        'September 2026',
        acuan: DateTime(2026, 10, 15),
      );
    });

    test('31 Maret dibanding Februari penuh, tidak meloncat ke Maret', () {
      cek(
        1,
        DateTime(2026, 3, 31),
        DateTime(2026, 2, 1),
        DateTime(2026, 3, 1),
        'Februari 2026',
      );
      cek(
        1,
        DateTime(2026, 3, 30),
        DateTime(2026, 2, 1),
        DateTime(2026, 3, 1),
        'Februari 2026',
      );
      cek(
        1,
        DateTime(2026, 3, 27),
        DateTime(2026, 2, 1),
        DateTime(2026, 2, 28),
        '1–27 Februari 2026',
      );
    });

    test('Pekan berjalan Senin–Selasa dibanding Senin–Selasa pekan lalu', () {
      cek(
        0,
        DateTime(2026, 11, 24),
        DateTime(2026, 11, 16),
        DateTime(2026, 11, 18),
        '16–17 November 2026',
      );
    });

    test('Pekan yang hari ini hari Minggu dibanding pekan lalu penuh', () {
      cek(
        0,
        DateTime(2026, 11, 29),
        DateTime(2026, 11, 16),
        DateTime(2026, 11, 23),
        '16–22 November 2026',
      );
    });

    test('Tahun berjalan dibanding 1 Januari sampai tanggal yang sama', () {
      cek(
        2,
        DateTime(2026, 11, 24),
        DateTime(2025, 1, 1),
        DateTime(2025, 11, 25),
        '1 Januari–24 November 2025',
      );
    });

    test('Tahun yang sudah lewat dibanding tahun sebelumnya penuh', () {
      cek(
        2,
        DateTime(2026, 11, 24),
        DateTime(2024, 1, 1),
        DateTime(2025, 1, 1),
        '2024',
        acuan: DateTime(2025, 6, 1),
      );
    });

    test('Pergantian tahun', () {
      cek(
        1,
        DateTime(2027, 1, 10),
        DateTime(2026, 12, 1),
        DateTime(2026, 12, 11),
        '1–10 Desember 2026',
      );
      // Pekan 5 Januari 2026 dimulai Senin, pekan lalunya masih di 2025.
      cek(
        0,
        DateTime(2026, 1, 6),
        DateTime(2025, 12, 29),
        DateTime(2025, 12, 31),
        '29–30 Desember 2025',
      );
    });
  });

  group('kalimatPerbandingan', () {
    test('baris pertama naik, turun, dan sama', () {
      expect(kalimatPerbandingan(926000, 685000), 'Pengeluaranmu naik');
      expect(kalimatPerbandingan(316000, 548000), 'Pengeluaranmu turun');
      expect(kalimatPerbandingan(50000, 50000), 'Pengeluaranmu sama seperti');
    });

    test('baris kedua memakai nama bulan lengkap', () {
      expect(
        keteranganPerbandingan(926000, 685000, '1–24 Oktober 2026'),
        'dibanding 1–24 Oktober 2026',
      );
      expect(
        keteranganPerbandingan(316000, 548000, '16–17 November 2026'),
        'dibanding 16–17 November 2026',
      );
      expect(
        keteranganPerbandingan(50000, 50000, 'Oktober 2026'),
        'Oktober 2026',
      );
    });

    test('periode lalu kosong memakai kata relatif sesuai jenis', () {
      expect(
        kalimatTanpaPembanding(0),
        'Belum ada data pekan lalu untuk dibandingkan.',
      );
      expect(
        kalimatTanpaPembanding(1),
        'Belum ada data bulan lalu untuk dibandingkan.',
      );
      expect(
        kalimatTanpaPembanding(2),
        'Belum ada data tahun lalu untuk dibandingkan.',
      );
    });
  });

  group('teksSelisih', () {
    test('naik, turun, sama, dan baru', () {
      expect(teksSelisih(470000, 450000), '+Rp 20.000');
      expect(teksSelisih(28000, 62000), '-Rp 34.000');
      expect(teksSelisih(50000, 50000), 'sama');
      expect(teksSelisih(136000, null), 'baru');
    });
  });

  group('grafik tren', () {
    test('lebarBatang mengikuti jumlah batang', () {
      expect(lebarBatang(7), 20);
      expect(lebarBatang(12), 14);
      expect(lebarBatang(30), 6);
    });

    test(
      'langkahSumbu selalu rapi dan 4 langkahnya menutupi nilai tertinggi',
      () {
        expect(langkahSumbu(271000), 100000);
        expect(langkahSumbu(926000), 250000);
        expect(langkahSumbu(35000), 10000);
        expect(langkahSumbu(400000), 100000);
      },
    );

    test('labelTooltipTren per hari dan per bulan', () {
      DateTime senin = DateTime(2026, 11, 23);
      List<String> pekan = labelTooltipTren(0, senin, akhirPeriode(0, senin));
      expect(pekan.length, 7);
      expect(pekan[1], 'Selasa, 24 November');

      DateTime tahun = DateTime(2026);
      List<String> bulan = labelTooltipTren(2, tahun, akhirPeriode(2, tahun));
      expect(bulan.length, 12);
      expect(bulan[10], 'November 2026');
    });
  });
}
