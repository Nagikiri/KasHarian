import 'package:flutter/material.dart';

class WarnaApp {
  static const Color latar = Color(0xFFFFFFFF);
  static const Color latarSeksi = Color(0xFFF5F5F3);
  static const Color garis = Color(0xFFE8E8E5);
  static const Color teksUtama = Color(0xFF0E0F0C);
  static const Color teksKedua = Color(0xFF4A4B48);
  static const Color teksRedup = Color(0xFF8A8A87);
  static const Color primer = Color(0xFF14532D);
  static const Color aksen = Color(0xFF9FE870);
  static const Color aksenLembut = Color(0xFFEEF8E6);
  static const Color bahaya = Color(0xFFC8372D);
  static const Color diAtasPrimer = Color(0xFFFFFFFF);
}

class TeksApp {
  static const String _font = 'PlusJakartaSans';

  static const TextStyle angkaBesar = TextStyle(
    fontFamily: _font,
    fontSize: 34,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: WarnaApp.teksUtama,
  );
  static const TextStyle judulHalaman = TextStyle(
    fontFamily: _font,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: WarnaApp.teksUtama,
  );
  static const TextStyle judulSeksi = TextStyle(
    fontFamily: _font,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: WarnaApp.teksUtama,
  );
  static const TextStyle isi = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: WarnaApp.teksKedua,
  );
  static const TextStyle angka = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: WarnaApp.teksUtama,
  );
  static const TextStyle kecil = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: WarnaApp.teksRedup,
  );
  static const TextStyle tombol = TextStyle(
    fontFamily: _font,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: WarnaApp.diAtasPrimer,
  );
  static const TextStyle tombolKecil = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: WarnaApp.teksUtama,
  );
  static const TextStyle labelNav = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: WarnaApp.teksRedup,
  );
}

class JarakApp {
  static const double j4 = 4;
  static const double j8 = 8;
  static const double j12 = 12;
  static const double j16 = 16;
  static const double j24 = 24;
  static const double j32 = 32;
  static const double tepiHalaman = 20;
}

class RadiusApp {
  static const double input = 12;
  static const double tombol = 14;
  static const double pill = 999;
}

ThemeData buatTema() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'PlusJakartaSans',
    scaffoldBackgroundColor: WarnaApp.latar,
    colorScheme: ColorScheme.fromSeed(seedColor: WarnaApp.primer),
    appBarTheme: const AppBarTheme(
      backgroundColor: WarnaApp.latar,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: TeksApp.judulHalaman,
    ),
    dividerTheme: const DividerThemeData(color: WarnaApp.garis, thickness: 1),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: WarnaApp.latar,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusApp.input),
        ),
      ),
    ),
  );
}

// Tiga nilai lama ini masih dipakai screen lama, dihapus setelah semua halaman dirombak.
const Color primaryGreen = Color(0xFF14532D);
const Color bgGray = Color(0xFFF1F5F9);
final BoxDecoration cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ],
);
