import 'package:flutter_test/flutter_test.dart';
import 'package:kasharian/models/kurs.dart';

void main() {
  test('Kurs.fromJson membaca JSON API dengan benar', () {
    // JSON tiruan, bentuknya sama dengan respons open.er-api.com
    final json = {
      'result': 'success',
      'base_code': 'IDR',
      'time_last_update_utc': 'Thu, 05 Nov 2026 00:02:31 +0000',
      'rates': {'IDR': 1, 'USD': 0.0000625, 'JPY': 0.01},
    };

    final kurs = Kurs.fromJson(json);

    expect(kurs.mataUangDasar, 'IDR');
    expect(kurs.daftarRate['USD'], 0.0000625);
    expect(kurs.keRupiah('USD'), closeTo(16000, 0.001)); // 1 / 0.0000625
    expect(kurs.keRupiah('JPY'), closeTo(100, 0.001)); // 1 / 0.01
    expect(kurs.keRupiah('XXX'), 0); // mata uang tidak ada
  });

  test('keRupiah tidak membulatkan kurs yang kecil', () {
    final kurs = Kurs.fromJson({
      'base_code': 'IDR',
      'time_last_update_utc': 'Thu, 05 Nov 2026 00:02:31 +0000',
      'rates': {'VND': 1.6, 'KRW': 0.09},
    });

    expect(kurs.keRupiah('VND'), closeTo(0.625, 0.0001));
    expect(kurs.keRupiah('KRW'), closeTo(11.11, 0.01));
  });
}
