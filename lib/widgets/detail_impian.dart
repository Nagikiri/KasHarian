import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/app_data.dart';
import '../models/wishlist.dart';
import '../utils/format.dart';
import 'halaman_input_nominal.dart';
import 'sheet_detail_impian.dart';

// Dipakai kartu impian di Beranda dan di tab Impian, jadi perilaku keduanya selalu sama.
Future<void> bukaDetailImpian(BuildContext context, WishlistItem impian) async {
  // Sheet detail ditutup dulu, baru halaman nominal dibuka dari layar pemanggil.
  bool? tabung = await showModalBottomSheet<bool>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (context) => SheetDetailImpian(impian: impian),
  );
  if (tabung != true || !context.mounted) return;
  bukaInputNominal(
    context,
    judul: 'Nabung untuk ${impian.nama}',
    ikon: LucideIcons.piggyBank,
    onSimpan: (nominal) {
      int disimpan = AppData.tambahTabunganWishlist(impian, nominal);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${formatRupiah(disimpan)} ditabung ke ${impian.nama}'),
        ),
      );
    },
  );
}
