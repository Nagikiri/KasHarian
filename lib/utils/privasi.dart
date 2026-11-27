import 'package:flutter/foundation.dart';

import '../models/app_data.dart';
import 'format.dart';

// Diubah tombol mata di Beranda. Halaman lain membaca nilainya setiap kali dibangun.
final ValueNotifier<bool> sembunyikanNominal = ValueNotifier<bool>(false);

// Halaman selain Beranda hanya ikut tersembunyi kalau cakupan di Pengaturan "Semua halaman".
bool nominalTersembunyi() =>
    sembunyikanNominal.value && AppData.sembunyiSemuaHalaman;

// Tanda minus tetap ditulis, karena arah uang sudah terlihat dari warnanya.
String _tersembunyi(int nilai) => '${nilai < 0 ? '-' : ''}Rp ••••••';

String rupiahTampil(int nilai) =>
    nominalTersembunyi() ? _tersembunyi(nilai) : formatRupiah(nilai);

String ringkasTampil(int nilai) =>
    nominalTersembunyi() ? _tersembunyi(nilai) : formatRingkas(nilai);

// Khusus Beranda: selalu ikut tombol mata, apa pun cakupannya.
String rupiahBeranda(int nilai) =>
    sembunyikanNominal.value ? _tersembunyi(nilai) : formatRupiah(nilai);

String ringkasBeranda(int nilai) =>
    sembunyikanNominal.value ? _tersembunyi(nilai) : formatRingkas(nilai);
