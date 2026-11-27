import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:kasharian/models/app_data.dart';
import 'package:kasharian/models/budget.dart';
import 'package:kasharian/models/data_contoh.dart';
import 'package:kasharian/models/dompet.dart';
import 'package:kasharian/models/kategori.dart';
import 'package:kasharian/models/transaksi.dart';
import 'package:kasharian/services/db_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // sqflite asli hanya jalan di HP. Di laptop, test memakai sqflite_common_ffi.
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  // Setiap test mendapat database baru di memori, jadi tidak ada sisa dari test lain.
  setUp(() async {
    await DbService.buka(lokasi: inMemoryDatabasePath);
    await AppData.muat();
  });

  tearDown(() => DbService.tutup());

  test('database baru berisi data contoh dengan urutan yang sama', () async {
    expect(AppData.daftarDompet.map((d) => d.nama), [
      'Utama',
      'Rekening Bank',
      'E-Wallet',
      'Tunai',
      'Tabungan',
    ]);
    expect(AppData.saldoSumber('Utama'), isNot(0));
    expect(
      AppData.daftarKategori.map((k) => k.nama),
      kategoriBawaan().map((k) => k.nama),
    );
    expect(
      AppData.daftarTransaksi.map((t) => t.catatan),
      contohTransaksi().map((t) => t.catatan),
    );
    expect(
      AppData.daftarWishlist.map((w) => w.nama),
      contohWishlist().map((w) => w.nama),
    );
    expect(
      AppData.daftarUtang.map((u) => u.nama),
      contohUtang().map((u) => u.nama),
    );
    expect(
      AppData.daftarBudget.map((b) => b.kategori),
      contohBudget().map((b) => b.kategori),
    );
    expect(AppData.daftarTransaksi.every((t) => t.id != null), isTrue);
  });

  // Seperti flavor prod (DATA_CONTOH false): hanya kategori bawaan dan 5 dompet bersaldo 0.
  test('database baru tanpa data contoh hanya berisi bawaan', () async {
    await DbService.tutup();
    await DbService.buka(lokasi: inMemoryDatabasePath, dataContoh: false);
    await AppData.muat();
    expect(AppData.daftarTransaksi, isEmpty);
    expect(AppData.daftarBudget, isEmpty);
    expect(AppData.daftarUtang, isEmpty);
    expect(AppData.daftarWishlist, isEmpty);
    expect(
      AppData.daftarKategori.map((k) => k.nama),
      kategoriBawaan().map((k) => k.nama),
    );
    expect(AppData.daftarDompet.length, 5);
    expect(AppData.daftarDompet.every((d) => d.saldoAwal == 0), isTrue);
  });

  test('tambah, ubah, dan hapus transaksi tersimpan', () async {
    int jumlahAwal = AppData.daftarTransaksi.length;
    CatatanTransaksi baru = CatatanTransaksi(
      kategori: 'Kopi',
      catatan: 'Kopi susu',
      nominal: 25000,
      ikon: LucideIcons.coffee,
      tanggal: DateTime.now(),
    );
    await AppData.tambahTransaksi(baru);
    expect(baru.id, isNotNull);

    await AppData.muat();
    expect(AppData.daftarTransaksi.length, jumlahAwal + 1);
    CatatanTransaksi tersimpan = AppData.daftarTransaksi.first;
    expect(tersimpan.catatan, 'Kopi susu');

    await AppData.ubahTransaksi(
      tersimpan,
      CatatanTransaksi(
        kategori: 'Kopi',
        catatan: 'Kopi hitam',
        nominal: 18000,
        ikon: LucideIcons.coffee,
        tanggal: tersimpan.tanggal,
      ),
    );
    await AppData.muat();
    expect(AppData.daftarTransaksi.length, jumlahAwal + 1);
    expect(AppData.daftarTransaksi.first.catatan, 'Kopi hitam');
    expect(AppData.daftarTransaksi.first.nominal, 18000);

    await AppData.hapusTransaksi(AppData.daftarTransaksi.first);
    await AppData.muat();
    expect(AppData.daftarTransaksi.length, jumlahAwal);
  });

  test(
    'hapus kategori ikut menghapus kantongnya, ikon transaksi tetap',
    () async {
      KategoriItem kucing = KategoriItem(
        nama: 'Kucing',
        ikon: LucideIcons.pawPrint,
        indeksWarna: 3,
      );
      await AppData.tambahKategori(kucing);
      await AppData.tambahBudget(BudgetItem(kategori: 'Kucing', limit: 200000));
      await AppData.tambahTransaksi(
        CatatanTransaksi(
          kategori: 'Kucing',
          catatan: 'Pasir kucing',
          nominal: 60000,
          ikon: LucideIcons.pawPrint,
          tanggal: DateTime.now(),
        ),
      );

      await AppData.hapusKategori(kucing);
      await AppData.muat();
      expect(AppData.daftarKategori.any((k) => k.nama == 'Kucing'), isFalse);
      expect(AppData.daftarBudget.any((b) => b.kategori == 'Kucing'), isFalse);
      expect(AppData.daftarTransaksi.first.catatan, 'Pasir kucing');
      expect(AppData.daftarTransaksi.first.ikon, LucideIcons.pawPrint);
    },
  );

  test('lunasi utang dan tabung impian menulis ke dua tabel', () async {
    int jumlahTransaksi = AppData.daftarTransaksi.length;
    String namaUtang = AppData.daftarUtang.first.nama;
    await AppData.lunasiUtang(AppData.daftarUtang.first);

    String namaImpian = AppData.daftarWishlist.first.nama;
    int terkumpulAwal = AppData.daftarWishlist.first.terkumpulIdr;
    AppData.tambahTabunganWishlist(AppData.daftarWishlist.first, 100000);

    await AppData.muat();
    expect(AppData.daftarUtang.first.nama, namaUtang);
    expect(AppData.daftarUtang.first.lunas, isTrue);
    expect(AppData.daftarWishlist.first.nama, namaImpian);
    expect(AppData.daftarWishlist.first.terkumpulIdr, terkumpulAwal + 100000);
    expect(AppData.daftarTransaksi.length, jumlahTransaksi + 2);
    expect(AppData.daftarTransaksi[0].catatan, 'Nabung untuk $namaImpian');
    expect(AppData.daftarTransaksi[1].kategori, 'Pelunasan');
  });

  test('ganti nama dompet ikut mengganti transaksi di database', () async {
    Dompet eWallet = AppData.daftarDompet.firstWhere(
      (d) => d.nama == 'E-Wallet',
    );
    int saldoAwal = AppData.saldoSumber('E-Wallet');
    int dipakai = AppData.jumlahTransaksiDompet('E-Wallet');
    expect(dipakai, greaterThan(0));

    await AppData.ubahDompet(
      eWallet,
      nama: 'Dompet Digital',
      ikon: LucideIcons.wallet,
      saldoAwal: 0,
    );
    await AppData.muat();
    expect(AppData.daftarSumberDana, contains('Dompet Digital'));
    expect(AppData.daftarSumberDana, isNot(contains('E-Wallet')));
    expect(AppData.jumlahTransaksiDompet('E-Wallet'), 0);
    expect(AppData.jumlahTransaksiDompet('Dompet Digital'), dipakai);
    expect(AppData.saldoSumber('Dompet Digital'), saldoAwal);
  });

  test('tambah, ubah saldo awal, dan hapus dompet tersimpan', () async {
    await AppData.tambahDompet(Dompet(nama: 'Dana Darurat', saldoAwal: 1000));
    await AppData.muat();
    Dompet darurat = AppData.daftarDompet.last;
    expect(darurat.nama, 'Dana Darurat');
    expect(darurat.saldoAwal, 1000);

    await AppData.ubahDompet(
      darurat,
      nama: 'Dana Darurat',
      ikon: LucideIcons.coins,
      saldoAwal: 3000,
    );
    await AppData.muat();
    expect(AppData.saldoSumber('Dana Darurat'), 3000);
    expect(AppData.ikonDompet('Dana Darurat'), LucideIcons.coins);
    expect(AppData.ikonDompet('Rekening Bank'), LucideIcons.landmark);

    expect(await AppData.hapusDompet(AppData.daftarDompet.last), isTrue);
    await AppData.muat();
    expect(AppData.daftarSumberDana, isNot(contains('Dana Darurat')));
  });

  test('anggaran, favorit, dan kurs terakhir tersimpan', () async {
    await AppData.ubahAnggaran(7000000);
    await AppData.simpanFavorit(['EUR', 'KRW']);
    DateTime waktuKurs = DateTime(2026, 11, 20, 8, 30);
    await DbService.simpanPengaturan('kurs_ke_idr', jsonEncode({'KRW': 11.5}));
    await DbService.simpanPengaturan(
      'kurs_diperbarui',
      waktuKurs.toIso8601String(),
    );
    AppData.anggaranBulanan = 0;
    AppData.mataUangFavorit = [];

    await AppData.muat();
    expect(AppData.anggaranBulanan, 7000000);
    expect(AppData.mataUangFavorit, ['EUR', 'KRW']);
    expect(AppData.kursKeIdr['KRW'], 11.5);
    expect(AppData.kursDiperbarui, waktuKurs);
    expect(AppData.kursPernahLive, isTrue);
    expect(AppData.kursLive, isFalse);
  });

  test('pertanyaan Bendahara disimpan hanya setelah dijawab', () async {
    DateTime bulan = DateTime.now();
    await expectLater(
      AppData.tanyaBendahara('Pertanyaan lain', bulan),
      throwsArgumentError,
    );
    await AppData.muat();
    expect(AppData.percakapanAi, isEmpty);

    String pertanyaan = AppData.daftarPertanyaanAi[0];
    await AppData.tanyaBendahara(pertanyaan, bulan);
    await AppData.muat();
    expect(AppData.percakapanAi.length, 2);
    expect(AppData.percakapanAi[0].dariPengguna, isTrue);
    expect(AppData.percakapanAi[0].teks, pertanyaan);
    expect(AppData.percakapanAi[1].dariPengguna, isFalse);
  });

  test('hapus semua data menyisakan bawaan dan kurs terakhir', () async {
    DateTime waktuKurs = DateTime(2026, 11, 20, 8);
    await DbService.simpanPengaturan('kurs_ke_idr', jsonEncode({'KRW': 11.5}));
    await DbService.simpanPengaturan(
      'kurs_diperbarui',
      waktuKurs.toIso8601String(),
    );
    await AppData.ubahAnggaran(7000000);
    await AppData.simpanFavorit(['EUR']);
    await AppData.ubahCakupanSembunyi(true);

    await AppData.hapusSemuaData();
    expect(AppData.daftarTransaksi, isEmpty);
    expect(AppData.daftarBudget, isEmpty);
    expect(AppData.daftarUtang, isEmpty);
    expect(AppData.daftarWishlist, isEmpty);
    expect(AppData.percakapanAi, isEmpty);
    expect(
      AppData.daftarKategori.map((k) => k.nama),
      kategoriBawaan().map((k) => k.nama),
    );
    expect(
      AppData.daftarDompet.map((d) => d.nama),
      dompetBawaan().map((d) => d.nama),
    );
    expect(AppData.daftarDompet.every((d) => d.saldoAwal == 0), isTrue);
    expect(AppData.daftarDompet.every((d) => d.id != null), isTrue);

    // Nilai di memori dikosongkan dulu, supaya yang diperiksa benar-benar isi database.
    AppData.kursDiperbarui = null;
    AppData.sembunyiSemuaHalaman = false;
    await AppData.muat();
    expect(AppData.anggaranBulanan, AppData.anggaranBawaan);
    expect(AppData.mataUangFavorit, AppData.favoritBawaan);
    expect(AppData.kursDiperbarui, waktuKurs);
    expect(AppData.kursKeIdr['KRW'], 11.5);
    expect(AppData.sembunyiSemuaHalaman, isTrue);
  });

  test('cakupan sembunyi dan sakelar tersimpan setelah muat', () async {
    expect(AppData.sembunyiSemuaHalaman, isFalse);
    expect(AppData.sembunyikanSaatDibuka, isFalse);
    await AppData.ubahCakupanSembunyi(true);
    await AppData.ubahSembunyikanSaatDibuka(true);
    AppData.sembunyiSemuaHalaman = false;
    AppData.sembunyikanSaatDibuka = false;

    await AppData.muat();
    expect(AppData.sembunyiSemuaHalaman, isTrue);
    expect(AppData.sembunyikanSaatDibuka, isTrue);

    await AppData.ubahCakupanSembunyi(false);
    await AppData.ubahSembunyikanSaatDibuka(false);
    await AppData.muat();
    expect(AppData.sembunyiSemuaHalaman, isFalse);
    expect(AppData.sembunyikanSaatDibuka, isFalse);
  });
}
