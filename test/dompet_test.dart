import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:kasharian/models/app_data.dart';
import 'package:kasharian/models/data_contoh.dart';
import 'package:kasharian/models/dompet.dart';
import 'package:kasharian/models/kategori.dart';
import 'package:kasharian/models/transaksi.dart';

CatatanTransaksi buatTransaksi(
  int nominal, {
  String sumber = 'Utama',
  String? tujuan,
  bool pemasukan = false,
}) {
  return CatatanTransaksi(
    kategori: tujuan == null ? 'Makan' : 'Pindah',
    catatan: 'Uji',
    nominal: nominal,
    ikon: Icons.circle,
    tanggal: DateTime(2026, 11, 3),
    isPemasukan: pemasukan,
    isTransfer: tujuan != null,
    sumberDana: sumber,
    sumberTujuan: tujuan,
  );
}

Dompet cariDompet(String nama) =>
    AppData.daftarDompet.firstWhere((d) => d.nama == nama);

void main() {
  // Tanpa database: DbService tidak melakukan apa-apa, jadi yang diuji list di AppData.
  setUp(() {
    AppData.daftarDompet
      ..clear()
      ..addAll(contohDompet());
    AppData.daftarTransaksi
      ..clear()
      ..addAll([
        buatTransaksi(100000, sumber: 'E-Wallet', pemasukan: true),
        buatTransaksi(30000, sumber: 'E-Wallet'),
        buatTransaksi(20000, sumber: 'Utama', tujuan: 'E-Wallet'),
      ]);
  });

  test('tambah dompet masuk ke daftar dan pemilih dompet', () async {
    await AppData.tambahDompet(Dompet(nama: 'Dana Darurat', saldoAwal: 5000));
    expect(AppData.daftarSumberDana.last, 'Dana Darurat');
    expect(AppData.saldoSumber('Dana Darurat'), 5000);
  });

  test('nama kembar, nama khusus, dan nama kosong ditolak', () {
    expect(AppData.namaDompetBoleh('Dana Darurat'), isTrue);
    expect(AppData.namaDompetBoleh('e-wallet'), isFalse);
    expect(AppData.namaDompetBoleh('PINDAH'), isFalse);
    expect(AppData.namaDompetBoleh('   '), isFalse);
    // Dompet yang sedang diubah boleh memakai namanya sendiri.
    expect(
      AppData.namaDompetBoleh('E-Wallet', lama: cariDompet('E-Wallet')),
      isTrue,
    );
  });

  test('saldo awal ikut memengaruhi saldoSumber', () async {
    expect(AppData.saldoSumber('E-Wallet'), 90000);
    await AppData.ubahDompet(
      cariDompet('E-Wallet'),
      nama: 'E-Wallet',
      ikon: LucideIcons.wallet,
      saldoAwal: 10000,
    );
    expect(AppData.saldoSumber('E-Wallet'), 100000);
  });

  test('ganti nama ikut mengganti dompet di transaksi lama', () async {
    await AppData.ubahDompet(
      cariDompet('E-Wallet'),
      nama: 'Dompet Digital',
      ikon: LucideIcons.wallet,
      saldoAwal: 0,
    );
    expect(AppData.jumlahTransaksiDompet('E-Wallet'), 0);
    expect(AppData.jumlahTransaksiDompet('Dompet Digital'), 3);
    expect(AppData.daftarTransaksi[2].sumberTujuan, 'Dompet Digital');
    expect(AppData.saldoSumber('Dompet Digital'), 90000);
  });

  test('dompet yang dipakai transaksi tidak bisa dihapus', () async {
    expect(await AppData.hapusDompet(cariDompet('E-Wallet')), isFalse);
    expect(AppData.daftarSumberDana, contains('E-Wallet'));

    expect(await AppData.hapusDompet(cariDompet('Tunai')), isTrue);
    expect(AppData.daftarSumberDana, isNot(contains('Tunai')));
  });

  test('Utama dan Tabungan tidak bisa dihapus walau tidak dipakai', () async {
    AppData.daftarTransaksi.clear();
    expect(await AppData.hapusDompet(cariDompet('Utama')), isFalse);
    expect(await AppData.hapusDompet(cariDompet('Tabungan')), isFalse);
  });

  test('ikon dompet bolak-balik lewat toMap dan fromMap', () {
    Dompet asli = Dompet(nama: 'Kartu', ikon: LucideIcons.creditCard);
    Map<String, dynamic> peta = asli.toMap();
    expect(
      peta['indeks_ikon'],
      daftarIkonKategori.indexOf(LucideIcons.creditCard),
    );
    expect(Dompet.fromMap(peta).ikon, LucideIcons.creditCard);

    // Nomor yang tidak dikenal memakai ikon wallet.
    peta['indeks_ikon'] = 999;
    expect(Dompet.fromMap(peta).ikon, LucideIcons.wallet);
  });

  test('semua pilihan ikon dompet ada di daftarIkonKategori', () {
    expect(AppData.opsiIkonDompet.length, 8);
    expect(AppData.labelIkonDompet.length, AppData.opsiIkonDompet.length);
    for (var ikon in AppData.opsiIkonDompet) {
      expect(daftarIkonKategori, contains(ikon));
    }
  });

  test('ikon bawaan dan ikon hasil ubah dibaca lewat ikonDompet', () async {
    expect(AppData.ikonDompet('Rekening Bank'), LucideIcons.landmark);
    expect(AppData.ikonDompet('E-Wallet'), LucideIcons.smartphone);
    expect(AppData.ikonDompet('Tunai'), LucideIcons.banknote);
    expect(AppData.ikonDompet('Tabungan'), LucideIcons.piggyBank);
    expect(AppData.ikonDompet('Tidak ada'), LucideIcons.wallet);

    await AppData.ubahDompet(
      cariDompet('Tunai'),
      nama: 'Tunai',
      ikon: LucideIcons.coins,
      saldoAwal: 0,
    );
    expect(AppData.ikonDompet('Tunai'), LucideIcons.coins);
  });
}
