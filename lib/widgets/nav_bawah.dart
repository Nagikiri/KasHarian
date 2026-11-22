import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';

class NavBawah extends StatelessWidget {
  final int indeksAktif;
  final void Function(int indeks) onPilih;
  final VoidCallback onTambah;

  const NavBawah({
    super.key,
    required this.indeksAktif,
    required this.onPilih,
    required this.onTambah,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: WarnaApp.latar,
        border: Border(top: BorderSide(color: WarnaApp.garis)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _bangunItem(LucideIcons.house, 'Beranda', 0),
              _bangunItem(LucideIcons.receiptText, 'Transaksi', 1),
              Expanded(child: Center(child: _bangunTombolTambah())),
              _bangunItem(LucideIcons.heart, 'Wishlist', 2),
              _bangunItem(LucideIcons.chartPie, 'Ringkasan', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bangunItem(IconData ikon, String label, int indeks) {
    bool aktif = indeks == indeksAktif;
    Color warna = aktif ? WarnaApp.primer : WarnaApp.teksRedup;

    return Expanded(
      child: InkWell(
        onTap: () => onPilih(indeks),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(ikon, size: 22, color: warna),
            const SizedBox(height: JarakApp.j4),
            Text(
              label,
              style: TeksApp.labelNav.copyWith(
                color: warna,
                fontWeight: aktif ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bangunTombolTambah() {
    return Material(
      color: WarnaApp.primer,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTambah,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(LucideIcons.plus, size: 22, color: WarnaApp.diAtasPrimer),
        ),
      ),
    );
  }
}
