import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasharian/widgets/template_nominal.dart';

// Lebar baris chip di layar 360 dp: Catat Transaksi dan sheet berjarak tepi 20.
const double lebarBaris = 320;

Future<void> pasangChip(WidgetTester tester, List<String> label) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: lebarBaris,
            child: TemplateNominal(
              daftarNilai: [for (int i = 0; i < label.length; i++) i],
              daftarLabel: label,
              onTambah: (n) {},
              onReset: () {},
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  setUpAll(() async {
    // Font asli dimuat supaya lebar teks sama dengan di HP, bukan font kotak bawaan uji.
    final font = FontLoader('PlusJakartaSans');
    final data = File('assets/font/PlusJakartaSans-SemiBold.ttf').readAsBytes();
    font.addFont(data.then((b) => ByteData.view(b.buffer)));
    await font.load();
  });

  testWidgets('label chip muat utuh tanpa dikecilkan di layar 360 dp', (
    tester,
  ) async {
    const daftarUji = [
      ['+10rb', '+50rb', '+100rb', '+500rb'],
      ['+100rb', '+500rb', '+1jt', '+5jt'],
      ['+10', '+50', '+100', '+500'],
      ['100rb', '500rb', '1jt'],
      ['10', '100', '1.000'],
    ];
    for (List<String> label in daftarUji) {
      await pasangChip(tester, label);
      expect(tester.takeException(), isNull, reason: label.join(' '));
      for (String teks in label) {
        Finder kotak = find.ancestor(
          of: find.text(teks),
          matching: find.byType(FittedBox),
        );
        // Kotak FittedBox selebar teks aslinya berarti teks tidak dikecilkan.
        expect(
          tester.getSize(kotak).width,
          greaterThanOrEqualTo(tester.getSize(find.text(teks)).width),
          reason: teks,
        );
      }
    }
  });

  testWidgets('chip hapus memanggil onReset lewat tooltip Hapus nominal', (
    tester,
  ) async {
    bool direset = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TemplateNominal(
            onTambah: (n) {},
            onReset: () => direset = true,
          ),
        ),
      ),
    );
    await tester.tap(find.byTooltip('Hapus nominal'));
    expect(direset, isTrue);
  });
}
