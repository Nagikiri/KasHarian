import 'package:flutter/material.dart';

import 'screens/dashboard_screen.dart';
import 'screens/transaksi_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/ringkasan_screen.dart';
import 'screens/tambah_transaksi_screen.dart';

void main() {
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
      title: 'Kas Harian',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF14532D)),
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final Color primaryGreen = const Color(0xFF14532D);

  final List<Widget> _pages = [
    const DashboardScreen(),
    const TransaksiScreen(),
    const WishlistScreen(),
    const RingkasanScreen(),
  ];

  void _bukaLayarTambah() {
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
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _pages[_selectedIndex],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryGreen,
        shape: const CircleBorder(),
        elevation: 4,
        onPressed: _bukaLayarTambah,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        elevation: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home, 'Beranda', 0),
              _navItem(Icons.receipt_long, 'Transaksi', 1),
              const SizedBox(width: 48),
              _navItem(Icons.account_balance_wallet_outlined, 'Wishlist', 2),
              _navItem(Icons.pie_chart_outline, 'Ringkasan', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    bool isActive = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? primaryGreen : Colors.grey.shade500,
            size: 24,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isActive ? primaryGreen : Colors.grey.shade500,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
