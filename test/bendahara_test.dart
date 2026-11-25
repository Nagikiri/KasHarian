import 'package:flutter_test/flutter_test.dart';
import 'package:kasharian/models/app_data.dart';
import 'package:kasharian/utils/format.dart';

void main() {
  DateTime bulan = DateTime.now();

  setUp(() => AppData.percakapanAi.clear());

  test('saranTerakhir null saat percakapan kosong', () {
    expect(AppData.saranTerakhir, isNull);
  });

  test('tanyaBendahara menyimpan pertanyaan lalu jawaban', () async {
    String pertanyaan = AppData.daftarPertanyaanAi[0];
    await AppData.tanyaBendahara(pertanyaan, bulan);

    expect(AppData.percakapanAi.length, 2);
    expect(AppData.percakapanAi[0].dariPengguna, isTrue);
    expect(AppData.percakapanAi[0].teks, pertanyaan);
    expect(AppData.percakapanAi[1].dariPengguna, isFalse);
    expect(AppData.saranTerakhir, AppData.percakapanAi[1].teks);
    expect(
      AppData.saranTerakhir,
      contains(formatRupiah(AppData.pemasukanBulan(bulan))),
    );
  });

  test('setiap pertanyaan punya jawaban berbeda', () async {
    Set<String> jawaban = {};
    for (var pertanyaan in AppData.daftarPertanyaanAi) {
      jawaban.add(await AppData.mintaSaranAi(bulan, pertanyaan));
    }
    expect(jawaban.length, AppData.daftarPertanyaanAi.length);
  });

  test('kalau gagal, jawaban tidak disimpan dan error diteruskan', () async {
    await expectLater(
      AppData.tanyaBendahara('Pertanyaan lain', bulan),
      throwsArgumentError,
    );
    expect(AppData.percakapanAi.length, 1);
    expect(AppData.percakapanAi.last.dariPengguna, isTrue);
    expect(AppData.saranTerakhir, isNull);
  });

  test('coba lagi tidak menulis pertanyaan yang sama dua kali', () async {
    String pertanyaan = AppData.daftarPertanyaanAi[2];
    await AppData.tanyaBendahara(pertanyaan, bulan);
    await AppData.tanyaBendahara(pertanyaan, bulan);
    expect(AppData.percakapanAi.length, 4);

    AppData.percakapanAi.removeLast();
    await AppData.tanyaBendahara(pertanyaan, bulan);
    expect(AppData.percakapanAi.length, 4);
  });
}
