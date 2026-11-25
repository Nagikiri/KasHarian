import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:kasharian/models/app_data.dart';
import 'package:kasharian/models/dompet.dart';
import 'package:kasharian/screens/form_dompet_screen.dart';
import 'package:kasharian/theme/app_theme.dart';
import 'package:kasharian/widgets/halaman_nama_ikon.dart';
import 'package:kasharian/widgets/tombol_utama.dart';

Dompet cariDompet(String nama) =>
    AppData.daftarDompet.firstWhere((d) => d.nama == nama);

Future<void> pasang(WidgetTester tester, Widget halaman) async {
  // Ukuran layar Pixel 7, sama dengan emulator yang dipakai.
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(theme: buatTema(), home: halaman));
}

bool simpanAktif(WidgetTester tester) =>
    tester.widget<TombolUtama>(find.byType(TombolUtama)).onTekan != null;

void main() {
  testWidgets('Nama & ikon menolak nama kembar dan nama khusus', (
    tester,
  ) async {
    await pasang(
      tester,
      const HalamanNamaIkon(nama: '', ikon: LucideIcons.wallet),
    );
    expect(simpanAktif(tester), isFalse);

    await tester.enterText(find.byType(TextField), 'e-wallet');
    await tester.pump();
    expect(find.text('Nama ini sudah dipakai'), findsOneWidget);
    expect(simpanAktif(tester), isFalse);

    await tester.enterText(find.byType(TextField), 'Pindah');
    await tester.pump();
    expect(simpanAktif(tester), isFalse);

    await tester.enterText(find.byType(TextField), 'Dana Darurat');
    await tester.pump();
    expect(find.text('Nama ini sudah dipakai'), findsNothing);
    expect(simpanAktif(tester), isTrue);
  });

  testWidgets('nama dan ikon baru tampil di baris identitas form', (
    tester,
  ) async {
    await pasang(tester, const FormDompetScreen());
    expect(find.text('Isi nama dan ikon'), findsOneWidget);
    expect(find.text('Saldo sekarang'), findsNothing);

    await tester.tap(find.text('Isi nama dan ikon'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Kartu Kredit');
    await tester.pump();
    await tester.tap(find.text('Kartu'));
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Kartu Kredit'), findsOneWidget);
    expect(find.byIcon(LucideIcons.creditCard), findsOneWidget);
  });

  testWidgets('Utama: nama terkunci, ikon tetap bisa diganti', (tester) async {
    await pasang(tester, FormDompetScreen(dompetLama: cariDompet('Utama')));
    expect(find.text('Saldo sekarang'), findsOneWidget);
    await tester.tap(find.text('Ubah'));
    await tester.pumpAndSettle();

    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
    expect(find.text('Koin'), findsOneWidget);
    expect(simpanAktif(tester), isTrue);
  });

  testWidgets('Tabungan: baris identitas tanpa Ubah', (tester) async {
    await pasang(tester, FormDompetScreen(dompetLama: cariDompet('Tabungan')));
    expect(find.text('Tabungan'), findsOneWidget);
    expect(find.text('Ubah'), findsNothing);
  });
}
