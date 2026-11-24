import 'package:flutter/foundation.dart';

import 'format.dart';

// Diubah tombol mata di Beranda. Halaman lain membaca nilainya setiap kali dibangun.
final ValueNotifier<bool> sembunyikanNominal = ValueNotifier<bool>(false);

// Tanda minus tetap ditulis, karena arah uang sudah terlihat dari warnanya.
String _tersembunyi(int nilai) => '${nilai < 0 ? '-' : ''}Rp ••••••';

String rupiahTampil(int nilai) =>
    sembunyikanNominal.value ? _tersembunyi(nilai) : formatRupiah(nilai);

String ringkasTampil(int nilai) =>
    sembunyikanNominal.value ? _tersembunyi(nilai) : formatRingkas(nilai);
