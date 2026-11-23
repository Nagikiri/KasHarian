import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Meniru kepala CalendarDatePicker: label di kiri, panah di kanan, dengan ukuran dan jarak yang sama.
// Ikonnya sengaja Material (bukan Lucide), karena kalender bawaan memakai ikon Material.
class KepalaKalender extends StatelessWidget {
  final String label;
  final VoidCallback? onLabel;
  final bool terbuka;
  // null berarti tidak ada tujuan ke arah itu, jadi panahnya disembunyikan.
  final VoidCallback? onSebelum;
  final VoidCallback? onSesudah;

  const KepalaKalender({
    super.key,
    required this.label,
    this.onLabel,
    this.terbuka = false,
    this.onSebelum,
    this.onSesudah,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: KalenderApp.tinggiKepala,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 16, end: 4),
        child: Row(
          children: [
            Flexible(
              child: InkWell(
                onTap: onLabel,
                child: SizedBox(
                  height: KalenderApp.tinggiKepala,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            label,
                            overflow: TextOverflow.ellipsis,
                            style: TeksApp.kepalaKalender,
                          ),
                        ),
                        // Label yang tidak bisa diketuk tidak diberi tanda segitiga.
                        if (onLabel != null)
                          Icon(
                            terbuka
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            color: WarnaApp.teksKedua,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (onSebelum != null || onSesudah != null) ...[
              const Spacer(),
              _bangunPanah(Icons.chevron_left, onSebelum),
              _bangunPanah(Icons.chevron_right, onSesudah),
            ],
          ],
        ),
      ),
    );
  }

  // Panah tanpa tujuan diganti ruang kosong selebar tombol supaya panah lainnya tidak bergeser.
  Widget _bangunPanah(IconData ikon, VoidCallback? onTekan) {
    if (onTekan == null) return const SizedBox(width: 48);
    return IconButton(
      icon: Icon(ikon),
      color: WarnaApp.teksKedua,
      onPressed: onTekan,
    );
  }
}
