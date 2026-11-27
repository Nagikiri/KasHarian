import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:kasharian/models/app_data.dart';
import 'package:kasharian/models/budget.dart';
import 'package:kasharian/models/data_contoh.dart';
import 'package:kasharian/models/dompet.dart';
import 'package:kasharian/models/kategori.dart';
import 'package:kasharian/models/pesan_ai.dart';
import 'package:kasharian/models/transaksi.dart';
import 'package:kasharian/models/utang.dart';
import 'package:kasharian/models/wishlist.dart';

void main() {
  DateTime waktu = DateTime(2026, 11, 3, 14, 25, 7);

  test('transaksi kembali sama setelah toMap lalu fromMap', () {
    CatatanTransaksi asli = CatatanTransaksi(
      id: 7,
      kategori: 'Pindah',
      catatan: 'Isi saldo',
      nominal: 150000,
      ikon: LucideIcons.arrowLeftRight,
      tanggal: waktu,
      isTransfer: true,
      sumberDana: 'Rekening Bank',
      sumberTujuan: 'E-Wallet',
    );
    Map<String, dynamic> map = asli.toMap();
    expect(map['tanggal'], '2026-11-03T14:25:07.000');
    expect(map['is_transfer'], 1);
    expect(map['is_pemasukan'], 0);

    CatatanTransaksi hasil = CatatanTransaksi.fromMap(map);
    expect(hasil.id, 7);
    expect(hasil.kategori, 'Pindah');
    expect(hasil.nominal, 150000);
    expect(hasil.ikon, LucideIcons.arrowLeftRight);
    expect(hasil.tanggal, waktu);
    expect(hasil.isTransfer, isTrue);
    expect(hasil.isPemasukan, isFalse);
    expect(hasil.sumberTujuan, 'E-Wallet');
  });

  test('sumber tujuan kosong tetap null', () {
    CatatanTransaksi asli = CatatanTransaksi(
      kategori: 'Gaji',
      catatan: 'Gaji',
      nominal: 1,
      ikon: LucideIcons.banknote,
      tanggal: waktu,
      isPemasukan: true,
    );
    CatatanTransaksi hasil = CatatanTransaksi.fromMap(asli.toMap());
    expect(hasil.id, isNull);
    expect(hasil.sumberTujuan, isNull);
    expect(hasil.isPemasukan, isTrue);
  });

  test('model lain kembali sama setelah toMap lalu fromMap', () {
    KategoriItem kategori = KategoriItem.fromMap(
      KategoriItem(
        id: 3,
        nama: 'Bonus',
        ikon: LucideIcons.award,
        isPemasukan: true,
        indeksWarna: 1,
      ).toMap(),
    );
    expect(kategori.id, 3);
    expect(kategori.ikon, LucideIcons.award);
    expect(kategori.isPemasukan, isTrue);
    expect(kategori.indeksWarna, 1);

    BudgetItem budget = BudgetItem.fromMap(
      BudgetItem(id: 2, kategori: 'Makan', limit: 900000).toMap(),
    );
    expect(budget.kategori, 'Makan');
    expect(budget.limit, 900000);

    UtangItem utang = UtangItem.fromMap(
      UtangItem(
        jenis: 'Utang',
        nama: 'Dimas',
        nominal: 120000,
        keterangan: 'Kafe',
        tanggal: waktu,
        lunas: true,
      ).toMap(),
    );
    expect(utang.lunas, isTrue);
    expect(utang.tanggal, waktu);

    WishlistItem impian = WishlistItem.fromMap(
      WishlistItem(
        nama: 'Kamera',
        kategori: 'Kamera',
        mataUang: 'JPY',
        hargaAsing: 90000,
        targetIdr: 9360000,
        terkumpulIdr: 500000,
        ikon: LucideIcons.camera,
      ).toMap(),
      AppData.ikonImpian('Kamera'),
    );
    expect(impian.terkumpulIdr, 500000);
    expect(impian.ikon, LucideIcons.camera);

    PesanAi pesan = PesanAi.fromMap(
      PesanAi(dariPengguna: true, teks: 'Halo', waktu: waktu).toMap(),
    );
    expect(pesan.dariPengguna, isTrue);
    expect(pesan.waktu, waktu);

    Dompet dompet = Dompet.fromMap(
      Dompet(nama: 'Utama', saldoAwal: 2500000).toMap(),
    );
    expect(dompet.saldoAwal, 2500000);
  });

  test('semua ikon data contoh dan ikon khusus punya nomor urut', () {
    for (var k in kategoriBawaan()) {
      expect(indeksIkon(k.ikon), isNot(-1), reason: k.nama);
    }
    for (var t in contohTransaksi()) {
      expect(indeksIkon(t.ikon), isNot(-1), reason: t.catatan);
    }
    for (var ikon in [
      LucideIcons.arrowLeftRight,
      LucideIcons.handCoins,
      LucideIcons.piggyBank,
    ]) {
      expect(daftarIkonKategori, contains(ikon));
    }
  });

  test('pilihan ikon adalah 16 ikon pertama daftarIkonKategori', () {
    expect(AppData.opsiIkonKategori.length, 16);
    expect(AppData.opsiIkonKategori, daftarIkonKategori.sublist(0, 16));
  });

  test('nomor ikon yang tidak dikenal memakai ikon dompet', () {
    expect(ikonDariIndeks(-1), LucideIcons.wallet);
    expect(ikonDariIndeks(daftarIkonKategori.length), LucideIcons.wallet);
  });

  test('ikon impian mengikuti kategorinya', () {
    for (var w in contohWishlist()) {
      expect(AppData.ikonImpian(w.kategori), w.ikon, reason: w.nama);
    }
  });
}
