import 'package:flutter_test/flutter_test.dart';
import 'package:kasharian/models/app_data.dart';
import 'package:kasharian/utils/privasi.dart';

void main() {
  tearDown(() {
    sembunyikanNominal.value = false;
    AppData.sembunyiSemuaHalaman = false;
  });

  test('tombol mata mati: semua halaman menampilkan nominal', () {
    AppData.sembunyiSemuaHalaman = true;
    expect(rupiahTampil(15000), 'Rp 15.000');
    expect(rupiahBeranda(15000), 'Rp 15.000');
  });

  test('cakupan Beranda saja: hanya Beranda yang disembunyikan', () {
    sembunyikanNominal.value = true;
    expect(rupiahBeranda(15000), 'Rp ••••••');
    expect(rupiahBeranda(-15000), '-Rp ••••••');
    expect(rupiahTampil(15000), 'Rp 15.000');
    expect(nominalTersembunyi(), isFalse);
  });

  test('cakupan Semua halaman: Beranda dan halaman lain disembunyikan', () {
    sembunyikanNominal.value = true;
    AppData.sembunyiSemuaHalaman = true;
    expect(rupiahBeranda(15000), 'Rp ••••••');
    expect(rupiahTampil(15000), 'Rp ••••••');
    expect(ringkasTampil(-15000), '-Rp ••••••');
    expect(nominalTersembunyi(), isTrue);
  });
}
