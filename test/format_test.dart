import 'package:flutter_test/flutter_test.dart';
import 'package:kasharian/utils/format.dart';

void main() {
  test('formatDesimal menulis dua angka di belakang koma', () {
    expect(formatDesimal(0), '0,00');
    expect(formatDesimal(0.6123), '0,61');
    expect(formatDesimal(1234.5), '1.234,50');
    expect(formatDesimal(1234567.891), '1.234.567,89');
  });

  test('formatDesimal membulatkan ke atas sampai naik satu angka', () {
    expect(formatDesimal(0.999), '1,00');
    expect(formatDesimal(9.996), '10,00');
  });

  test('formatDesimal memberi tanda minus, kecuali hasilnya 0,00', () {
    expect(formatDesimal(-12.5), '-12,50');
    expect(formatDesimal(-0.001), '0,00');
  });
}
