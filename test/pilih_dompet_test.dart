import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasharian/models/app_data.dart';
import 'package:kasharian/theme/app_theme.dart';
import 'package:kasharian/widgets/halaman_pilih_dompet.dart';

void main() {
  testWidgets('dompet baru dari halaman Pilih dompet langsung terpilih', (
    tester,
  ) async {
    // Ukuran layar Pixel 7, sama dengan emulator yang dipakai.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);

    String? hasil;
    await tester.pumpWidget(
      MaterialApp(
        theme: buatTema(),
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              hasil = await bukaPilihDompet(
                context,
                'Utama',
                judul: 'Pilih dompet',
              );
            },
            child: const Text('Buka'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Buka'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih dompet'), findsOneWidget);

    await tester.tap(find.text('Tambah dompet baru'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Isi nama dan ikon'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Dana Darurat');
    // Tombol Simpan baru aktif setelah frame berikutnya digambar.
    await tester.pump();
    // Halaman Nama & ikon: Simpan tepat di bawah isian.
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    // Kembali di form dompet: Simpan di bawah numpad.
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(hasil, 'Dana Darurat');
    expect(find.text('Pilih dompet'), findsNothing);
    expect(AppData.daftarSumberDana.last, 'Dana Darurat');
  });

  testWidgets('dompet yang dikecualikan tidak tampil', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buatTema(),
        home: const HalamanPilihDompet(
          terpilih: 'Utama',
          judul: 'Ke',
          kecuali: 'Utama',
        ),
      ),
    );
    expect(find.text('Utama'), findsNothing);
    expect(find.text('Tabungan'), findsOneWidget);
  });
}
