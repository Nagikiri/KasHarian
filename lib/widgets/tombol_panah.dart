import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class TombolPanah extends StatelessWidget {
  final IconData ikon;
  final VoidCallback? onTekan;

  const TombolPanah({super.key, required this.ikon, this.onTekan});

  @override
  Widget build(BuildContext context) {
    // onTekan null berarti tombol tidak bisa ditekan, jadi diberi warna garis.
    return InkResponse(
      onTap: onTekan,
      radius: 20,
      child: SizedBox.square(
        dimension: 40,
        child: Icon(
          ikon,
          size: 20,
          color: onTekan == null ? WarnaApp.garis : WarnaApp.teksUtama,
        ),
      ),
    );
  }
}
