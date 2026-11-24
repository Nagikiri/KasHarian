import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasharian/main.dart';

void main() {
  testWidgets('Lihat semua di Transaksi terbaru menggulir ke pencarian', (
    tester,
  ) async {
    // Ukuran layar Pixel 7, sama dengan emulator yang dipakai.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 1));

    // Beranda digeser seperti jari sampai "Lihat semua" milik Transaksi terbaru terlihat.
    final lihatSemua = find.text('Lihat semua');
    for (int i = 0; i < 20; i++) {
      if (lihatSemua.evaluate().length == 2 &&
          tester.getCenter(lihatSemua.last).dy < 800) {
        break;
      }
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -200));
      await tester.pumpAndSettle();
    }
    await tester.tap(lihatSemua.last);
    await tester.pumpAndSettle();

    final pencarian = find.widgetWithText(
      TextField,
      'Cari catatan atau kategori',
    );
    final gulir = tester.state<ScrollableState>(find.byType(Scrollable).first);
    expect(gulir.position.pixels, greaterThan(0));
    // Pencarian ada di bagian atas layar, bukan masih di bawah Kantong alokasi.
    expect(tester.getTopLeft(pencarian).dy, lessThan(100));
  });
}
