import 'package:flutter_test/flutter_test.dart';
import 'package:kasharian/models/app_data.dart';

void main() {
  // Kurs diatur di sini supaya hasil uji tidak bergantung pada API.
  setUp(() {
    AppData.kursKeIdr
      ..clear()
      ..addAll({'USD': 16000, 'JPY': 104.5, 'KRW': 11.2, 'VND': 0.6123});
  });

  test('kursAda membedakan mata uang yang punya kurs', () {
    expect(AppData.kursAda('USD'), isTrue);
    expect(AppData.kursAda('IDR'), isTrue);
    expect(AppData.kursAda('BND'), isFalse);
  });

  test('targetDariKurs dan rupiahKeAsing saling berkebalikan', () {
    expect(AppData.targetDariKurs('USD', 100), 1600000);
    expect(AppData.targetDariKurs('VND', 100000), 61230);
    expect(AppData.targetDariKurs('IDR', 5000), 5000);
    expect(AppData.targetDariKurs('BND', 100), 0);
    expect(AppData.rupiahKeAsing('USD', 1600000), 100);
    expect(AppData.rupiahKeAsing('BND', 1600000), 0);
  });

  test('teksKursRupiah memakai desimal untuk kurs di bawah Rp 100', () {
    expect(AppData.teksKursRupiah('USD'), 'Rp 16.000');
    expect(AppData.teksKursRupiah('JPY'), 'Rp 105');
    expect(AppData.teksKursRupiah('KRW'), 'Rp 11,20');
    expect(AppData.teksKursRupiah('VND'), 'Rp 0,61');
    expect(AppData.teksKursRupiah('BND'), '—');
  });

  test('templateMataUang mengikuti besar kurs', () {
    expect(AppData.templateMataUang('IDR'), [100000, 500000, 1000000, 5000000]);
    expect(AppData.templateMataUang('USD'), [10, 50, 100, 500]);
    expect(AppData.templateMataUang('JPY'), [1000, 5000, 10000, 50000]);
    expect(AppData.templateMataUang('VND'), [10000, 50000, 100000, 500000]);
  });

  test('daftarMataUang tidak punya kode ganda dan memuat semua favorit', () {
    List<String> kode = [for (var m in AppData.daftarMataUang) m.kode];
    expect(kode.toSet().length, kode.length);
    for (String f in AppData.mataUangFavorit) {
      expect(kode, contains(f));
    }
  });
}
