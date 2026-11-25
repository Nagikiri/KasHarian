import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasharian/main.dart';
import 'package:kasharian/models/app_data.dart';

// Beranda digeser seperti jari sampai judul "Impian terdekat" terlihat di layar.
Future<void> _gulirKeImpianTerdekat(WidgetTester tester) async {
  // Ukuran layar Pixel 7, sama dengan emulator yang dipakai.
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);
  // Tab aktif disimpan statis, jadi dikembalikan ke Beranda sebelum setiap uji.
  AppData.tabAktif.value = 0;
  await tester.pumpWidget(const MyApp());
  await tester.pump(const Duration(seconds: 1));

  final judul = find.text('Impian terdekat');
  for (int i = 0; i < 20; i++) {
    if (judul.evaluate().isNotEmpty && tester.getCenter(judul).dy < 500) break;
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -200));
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets('Lihat semua di Impian terdekat menggulir ke Impianku', (
    tester,
  ) async {
    await _gulirKeImpianTerdekat(tester);
    // "Lihat semua" pertama milik Impian terdekat, yang kedua milik Transaksi terbaru.
    await tester.tap(find.text('Lihat semua').first);
    await tester.pumpAndSettle();

    final gulir = tester.state<ScrollableState>(find.byType(Scrollable).first);
    expect(gulir.position.pixels, greaterThan(0));
    // Halaman Impian pendek, jadi gulir mentok di bawah; tanpa gulir judul ada di sekitar 480.
    expect(tester.getTopLeft(find.text('Impianku')).dy, lessThan(300));
  });

  testWidgets('Ketuk kartu impian di Beranda membuka detail impian', (
    tester,
  ) async {
    await _gulirKeImpianTerdekat(tester);
    await tester.tap(find.textContaining('terkumpul').first);
    await tester.pumpAndSettle();

    expect(find.text('Hapus impian'), findsOneWidget);
  });
}
