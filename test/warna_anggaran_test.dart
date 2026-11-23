import 'package:flutter_test/flutter_test.dart';
import 'package:kasharian/models/app_data.dart';
import 'package:kasharian/models/budget.dart';

void main() {
  test('kartu Kantong tidak sewarna dengan tetangga kiri atau atasnya', () {
    // Makan, Internet, Obat, Langganan, Anak, dan Pajak sama-sama indeks 5. Bensin dan Air indeks 2.
    List<String> nama = [
      'Makan',
      'Internet',
      'Obat',
      'Langganan',
      'Bensin',
      'Air',
      'Anak',
      'Pajak',
    ];
    AppData.daftarBudget
      ..clear()
      ..addAll([for (String n in nama) BudgetItem(kategori: n, limit: 100000)]);

    Map<String, int> peta = AppData.petaWarnaAnggaran();

    expect(peta.length, 8);
    for (int i = 0; i < nama.length; i++) {
      int warna = peta[nama[i]]!;
      expect(warna, inInclusiveRange(0, 7));
      if (i % 2 == 1) expect(warna, isNot(peta[nama[i - 1]]), reason: nama[i]);
      if (i >= 2) expect(warna, isNot(peta[nama[i - 2]]), reason: nama[i]);
    }
    // Kartu pertama tidak punya tetangga, jadi tetap memakai warna kategorinya.
    expect(peta['Makan'], AppData.indeksWarnaKategori('Makan'));
  });
}
