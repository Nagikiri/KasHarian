import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasharian/models/app_data.dart';
import 'package:kasharian/models/budget.dart';
import 'package:kasharian/models/transaksi.dart';

CatatanTransaksi buatTransaksi(
  String kategori,
  int nominal,
  DateTime tanggal, {
  bool pemasukan = false,
  bool pindah = false,
  String? tujuan,
}) {
  return CatatanTransaksi(
    kategori: kategori,
    catatan: kategori,
    nominal: nominal,
    ikon: Icons.circle,
    tanggal: tanggal,
    isPemasukan: pemasukan,
    isTransfer: pindah,
    sumberTujuan: tujuan,
  );
}

void main() {
  DateTime november = DateTime(2026, 11);

  setUp(() {
    AppData.daftarTransaksi
      ..clear()
      ..addAll([
        buatTransaksi('Makan', 20000, DateTime(2026, 11, 3)),
        buatTransaksi('Makan', 30000, DateTime(2026, 11, 20)),
        buatTransaksi('Makan', 50000, DateTime(2026, 10, 30)),
        buatTransaksi('Bensin', 40000, DateTime(2026, 11, 5)),
        buatTransaksi('Makan', 90000, DateTime(2026, 11, 6), pemasukan: true),
        buatTransaksi(
          'Pindah',
          100000,
          DateTime(2026, 11, 7),
          pindah: true,
          tujuan: 'Tabungan',
        ),
        buatTransaksi(
          'Pindah',
          70000,
          DateTime(2026, 11, 8),
          pindah: true,
          tujuan: 'Tunai',
        ),
      ]);
  });

  group('transaksiKantong', () {
    test('hanya pengeluaran kategori itu di bulan itu, terbaru di atas', () {
      List<CatatanTransaksi> hasil = AppData.transaksiKantong(
        'Makan',
        november,
      );
      expect(hasil.map((t) => t.nominal).toList(), [30000, 20000]);
    });

    test('Tabungan berisi pemindahan ke dompet Tabungan saja', () {
      List<CatatanTransaksi> hasil = AppData.transaksiKantong(
        'Tabungan',
        november,
      );
      expect(hasil.map((t) => t.nominal).toList(), [100000]);
    });

    test('jumlahnya sama dengan terpakaiBudget', () {
      for (String k in ['Makan', 'Bensin', 'Tabungan']) {
        int total = AppData.transaksiKantong(
          k,
          november,
        ).fold(0, (a, t) => a + t.nominal);
        expect(total, AppData.terpakaiBudget(k, november), reason: k);
      }
    });
  });

  group('jatahPerHari', () {
    BudgetItem makan = BudgetItem(kategori: 'Makan', limit: 350000);

    test('sisa dibagi hari tersisa termasuk hari ini', () {
      // Sisa 300.000, tanggal 21 November berarti 10 hari tersisa (21 sampai 30).
      int? hasil = AppData.jatahPerHari(
        makan,
        november,
        DateTime(2026, 11, 21),
      );
      expect(hasil, 30000);
    });

    test('hari terakhir bulan mendapat seluruh sisa', () {
      int? hasil = AppData.jatahPerHari(
        makan,
        november,
        DateTime(2026, 11, 30, 23),
      );
      expect(hasil, 300000);
    });

    test('null kalau bukan bulan berjalan', () {
      int? hasil = AppData.jatahPerHari(makan, november, DateTime(2026, 12, 1));
      expect(hasil, isNull);
    });

    test('null kalau sisa habis atau melebihi', () {
      BudgetItem pas = BudgetItem(kategori: 'Makan', limit: 50000);
      BudgetItem lewat = BudgetItem(kategori: 'Makan', limit: 10000);
      DateTime hariIni = DateTime(2026, 11, 21);
      expect(AppData.jatahPerHari(pas, november, hariIni), isNull);
      expect(AppData.jatahPerHari(lewat, november, hariIni), isNull);
    });
  });
}
