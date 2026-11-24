import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';
import 'tombol_pill.dart';

// Kolom cari dan filter tipe di tab Transaksi. Nilainya disimpan oleh halaman.
class PencarianTransaksi extends StatelessWidget {
  // Urutan ini dipakai halaman: 0 Semua, 1 Pengeluaran, 2 Pemasukan, 3 Transfer.
  static const List<String> pilihanFilter = [
    'Semua',
    'Pengeluaran',
    'Pemasukan',
    'Transfer',
  ];

  final int filter;
  final ValueChanged<String> onCari;
  final ValueChanged<int> onFilter;

  const PencarianTransaksi({
    super.key,
    required this.filter,
    required this.onCari,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          onChanged: onCari,
          decoration: const InputDecoration(
            hintText: 'Cari catatan atau kategori',
            prefixIcon: Icon(
              LucideIcons.search,
              size: 18,
              color: WarnaApp.teksRedup,
            ),
          ),
        ),
        const SizedBox(height: JarakApp.j12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int i = 0; i < pilihanFilter.length; i++)
                Padding(
                  padding: const EdgeInsets.only(right: JarakApp.j8),
                  child: TombolPill(
                    teks: pilihanFilter[i],
                    kecil: true,
                    terpilih: filter == i,
                    onTekan: () => onFilter(i),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
