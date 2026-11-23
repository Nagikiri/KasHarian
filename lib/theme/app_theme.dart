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
  static const Color peringatan = Color(0xFFD97706);
  static const Color garisAksen = Color(0xFFD6EBC6);
  // Tanggal, bulan, atau tahun di luar batas: abu yang masih terbaca.
  static const Color teksNonaktif = Color(0xFFADADA9);
  // Warna kalem per kategori, hanya untuk grafik. Yang terakhir abu khusus "Lainnya".
  static const List<Color> paletKategori = [
    Color(0xFF2F7D4F),
    Color(0xFFE0A93B),
    Color(0xFF4A86B8),
    Color(0xFFD2734F),
    Color(0xFF8C7BBF),
    Color(0xFF3A9E92),
    Color(0xFFCF6F8D),
    Color(0xFFA8A8A4),
  ];

  // Dicampur ke putih (bukan dibuat transparan) supaya hasilnya sama di atas latar apa pun.
  static Color latarKategori(int indeks) =>
      Color.lerp(paletKategori[indeks], latar, 0.9)!;

  static Color lingkaranKategori(int indeks) =>
      Color.lerp(paletKategori[indeks], latar, 0.75)!;

  // Versi lebih gelap untuk ikon, bar, dan cincin, karena warna palet asli terlalu pucat di atas latar muda.
  static Color tegasKategori(int indeks) =>
      Color.lerp(paletKategori[indeks], teksUtama, 0.3)!;
}

// Satu aturan warna untuk semua progress dan persen di aplikasi.
Color warnaStatus(double persen) {
  if (persen >= 0.9) return WarnaApp.bahaya;
  if (persen >= 0.8) return WarnaApp.peringatan;
  return WarnaApp.primer;
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
  // Pilihan saat ini di dialog pemilih waktu, misalnya "November 2026".
  static const TextStyle judulDialog = TextStyle(
    fontFamily: _font,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: WarnaApp.teksUtama,
  );
  // Angka tanggal di kalender dan nama bulan/tahun di grid pemilih waktu.
  static const TextStyle selKalender = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: WarnaApp.teksUtama,
  );
  // Label "November 2026" di kepala kalender dan grid pemilih waktu.
  static const TextStyle kepalaKalender = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: WarnaApp.teksKedua,
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
  static const TextStyle mini = TextStyle(
    fontFamily: _font,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: WarnaApp.teksRedup,
  );
  static const TextStyle labelNav = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: WarnaApp.teksRedup,
  );
}

// Ukuran ini sama dengan CalendarDatePicker bawaan Flutter (Material 3, posisi tegak),
// supaya grid bulan dan tahun buatan sendiri sama persis dengan kalender.
class KalenderApp {
  static const double tinggiKepala = 52;
  static const double tinggiGrid = 336;
  static const double tinggiSel = 40;
  static const double tepiGrid = 12;
}

// Satu aturan warna sel untuk kalender bawaan dan grid bulan/tahun buatan sendiri.
Color warnaTeksSel({
  required bool terpilih,
  required bool nonaktif,
  bool sekarang = false,
}) {
  if (terpilih) return WarnaApp.diAtasPrimer;
  if (nonaktif) return WarnaApp.teksNonaktif;
  return sekarang ? WarnaApp.primer : WarnaApp.teksUtama;
}

Color? latarSel(bool terpilih) => terpilih ? WarnaApp.primer : null;

WidgetStateProperty<Color?> _warnaSelKalender(bool sekarang) {
  return WidgetStateProperty.resolveWith(
    (status) => warnaTeksSel(
      terpilih: status.contains(WidgetState.selected),
      nonaktif: status.contains(WidgetState.disabled),
      sekarang: sekarang,
    ),
  );
}

final WidgetStateProperty<Color?> _latarSelKalender =
    WidgetStateProperty.resolveWith(
      (status) => latarSel(status.contains(WidgetState.selected)),
    );

class JarakApp {
  static const double j4 = 4;
  static const double j8 = 8;
  static const double j12 = 12;
  static const double j16 = 16;
  static const double j24 = 24;
  static const double j32 = 32;
  static const double tepiHalaman = 20;
  static const double dalamKartu = 14;
}

class RadiusApp {
  static const double input = 12;
  static const double tombol = 14;
  static const double pill = 999;
  static const double dialog = 16;
}

const RoundedRectangleBorder _bentukDialog = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(RadiusApp.dialog)),
);

const OutlineInputBorder _garisInput = OutlineInputBorder(
  borderSide: BorderSide.none,
  borderRadius: BorderRadius.all(Radius.circular(RadiusApp.input)),
);

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
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: WarnaApp.latarSeksi,
      contentPadding: const EdgeInsets.all(JarakApp.j16),
      hintStyle: TeksApp.isi.copyWith(color: WarnaApp.teksRedup),
      border: _garisInput,
      enabledBorder: _garisInput,
      focusedBorder: _garisInput,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: WarnaApp.latar,
      surfaceTintColor: Colors.transparent,
      shape: _bentukDialog,
    ),
    // Gaya kalender bawaan diambil dari token yang sama dengan grid bulan dan tahun.
    datePickerTheme: DatePickerThemeData(
      backgroundColor: WarnaApp.latar,
      surfaceTintColor: Colors.transparent,
      shape: _bentukDialog,
      toggleButtonTextStyle: TeksApp.kepalaKalender,
      subHeaderForegroundColor: WarnaApp.teksKedua,
      dayStyle: TeksApp.selKalender,
      dayForegroundColor: _warnaSelKalender(false),
      dayBackgroundColor: _latarSelKalender,
      todayForegroundColor: _warnaSelKalender(true),
      todayBackgroundColor: _latarSelKalender,
      todayBorder: const BorderSide(color: WarnaApp.primer),
      yearStyle: TeksApp.selKalender,
      yearForegroundColor: _warnaSelKalender(false),
      yearBackgroundColor: _latarSelKalender,
    ),
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
