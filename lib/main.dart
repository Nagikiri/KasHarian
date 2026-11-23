import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'models/app_data.dart';
import 'theme/app_theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/transaksi_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/ringkasan_screen.dart';
import 'screens/tambah_transaksi_screen.dart';
import 'widgets/nav_bawah.dart';

void main() {
  // Ikon status bar dan tombol HP dibuat gelap supaya terlihat di atas latar putih.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: WarnaApp.latar,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

Route buatTransisiHalaman(Widget halaman) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => halaman,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final tween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: Curves.easeInOut));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KasHarian',
      theme: buatTema(),
      // Supaya kalender dan teks bawaan Flutter berbahasa Indonesia.
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('id')],
      locale: const Locale('id'),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  final List<Widget> _halaman = const [
    DashboardScreen(),
    TransaksiScreen(),
    WishlistScreen(),
    RingkasanScreen(),
  ];

  void _bukaLayarTambah(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const TambahTransaksiScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tab aktif disimpan di AppData supaya screen lain bisa memindahkan tab.
    return ValueListenableBuilder<int>(
      valueListenable: AppData.tabAktif,
      builder: (context, tabAktif, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _halaman[tabAktif],
          ),
          bottomNavigationBar: NavBawah(
            indeksAktif: tabAktif,
            onPilih: (i) => AppData.tabAktif.value = i,
            onTambah: () => _bukaLayarTambah(context),
          ),
        );
      },
    );
  }
}
