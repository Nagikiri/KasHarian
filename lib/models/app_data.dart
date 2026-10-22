import 'package:flutter/material.dart';

String formatTitik(int nilai) {
  String s = nilai.abs().toString();
  String hasil = '';
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) hasil += '.';
    hasil += s[i];
  }
  return hasil;
}

class KategoriItem {
  final String nama;
  final IconData ikon;
  final Color warna;
  final bool isPemasukan;
  final bool isTransfer;

  KategoriItem({
    required this.nama,
    required this.ikon,
    required this.warna,
    this.isPemasukan = false,
    this.isTransfer = false,
  });
}

class CatatanTransaksi {
  final String kategori;
  final String catatan;
  final int nominal;
  final IconData ikon;
  final Color warna;
  final DateTime tanggal;
  final bool isPemasukan;
  final bool isTransfer;
  final String sumberDana;

  CatatanTransaksi({
    required this.kategori,
    required this.catatan,
    required this.nominal,
    required this.ikon,
    required this.warna,
    required this.tanggal,
    this.isPemasukan = false,
    this.isTransfer = false,
    this.sumberDana = 'Kantong Utama',
  });
}

class WishlistItem {
  final String nama;
  final String mataUang;
  final int hargaAsing;
  final int targetIdr;
  int terkumpulIdr;
  final IconData ikon;

  WishlistItem({
    required this.nama,
    required this.mataUang,
    required this.hargaAsing,
    required this.targetIdr,
    required this.terkumpulIdr,
    required this.ikon,
  });
}

class AppData {
  static final ValueNotifier<int> refreshNotifier = ValueNotifier<int>(0);

  static final List<KategoriItem> daftarKategori = [
    KategoriItem(
      nama: 'Makan',
      ikon: Icons.restaurant_outlined,
      warna: const Color(0xFF10B981),
    ),
    KategoriItem(
      nama: 'Bensin',
      ikon: Icons.local_gas_station_outlined,
      warna: const Color(0xFFF59E0B),
    ),
    KategoriItem(
      nama: 'Belanja',
      ikon: Icons.shopping_bag_outlined,
      warna: const Color(0xFF3B82F6),
    ),
    KategoriItem(
      nama: 'Tagihan',
      ikon: Icons.receipt_long_outlined,
      warna: const Color(0xFFEF4444),
    ),
    KategoriItem(
      nama: 'Hiburan',
      ikon: Icons.movie_creation_outlined,
      warna: const Color(0xFF8B5CF6),
    ),
    KategoriItem(
      nama: 'Kopi',
      ikon: Icons.coffee_outlined,
      warna: const Color(0xFF92400E),
    ),
    KategoriItem(
      nama: 'Kesehatan',
      ikon: Icons.medical_services_outlined,
      warna: const Color(0xFFEC4899),
    ),
    KategoriItem(
      nama: 'Pendidikan',
      ikon: Icons.menu_book_outlined,
      warna: const Color(0xFF6366F1),
    ),
    KategoriItem(
      nama: 'Transportasi',
      ikon: Icons.directions_bus_outlined,
      warna: const Color(0xFF14B8A6),
    ),
    KategoriItem(
      nama: 'Pakaian',
      ikon: Icons.checkroom_outlined,
      warna: const Color(0xFFF97316),
    ),
    KategoriItem(
      nama: 'Elektronik',
      ikon: Icons.devices_outlined,
      warna: const Color(0xFF64748B),
    ),
    KategoriItem(
      nama: 'Rumah',
      ikon: Icons.home_outlined,
      warna: const Color(0xFF0EA5E9),
    ),
    KategoriItem(
      nama: 'Gaji',
      ikon: Icons.payments_outlined,
      warna: const Color(0xFF10B981),
      isPemasukan: true,
    ),
    KategoriItem(
      nama: 'Freelance',
      ikon: Icons.laptop_mac_outlined,
      warna: const Color(0xFF0D9488),
      isPemasukan: true,
    ),
    KategoriItem(
      nama: 'Bonus',
      ikon: Icons.workspace_premium_outlined,
      warna: const Color(0xFFF59E0B),
      isPemasukan: true,
    ),
    KategoriItem(
      nama: 'Investasi',
      ikon: Icons.trending_up_outlined,
      warna: const Color(0xFF3B82F6),
      isPemasukan: true,
    ),
    KategoriItem(
      nama: 'Transfer Bank',
      ikon: Icons.account_balance_outlined,
      warna: const Color(0xFF2563EB),
      isTransfer: true,
    ),
    KategoriItem(
      nama: 'Top Up E-Wallet',
      ikon: Icons.account_balance_wallet_outlined,
      warna: const Color(0xFF0D9488),
      isTransfer: true,
    ),
    KategoriItem(
      nama: 'Tarik Tunai ATM',
      ikon: Icons.local_atm_outlined,
      warna: const Color(0xFF475569),
      isTransfer: true,
    ),
    KategoriItem(
      nama: 'Antar Kantong',
      ikon: Icons.swap_horiz_outlined,
      warna: const Color(0xFF14532D),
      isTransfer: true,
    ),
    KategoriItem(
      nama: 'Setor Tabungan',
      ikon: Icons.savings_outlined,
      warna: const Color(0xFF059669),
      isTransfer: true,
    ),
    KategoriItem(
      nama: 'Bayar Kartu',
      ikon: Icons.credit_card_outlined,
      warna: const Color(0xFF7C3AED),
      isTransfer: true,
    ),
  ];

  static final List<CatatanTransaksi> daftarTransaksi = [
    CatatanTransaksi(
      kategori: 'Kopi',
      catatan: 'Kopi Kenangan & Roti',
      nominal: 35000,
      ikon: Icons.coffee_outlined,
      warna: const Color(0xFF92400E),
      tanggal: DateTime.now(),
      sumberDana: 'Saku QRIS',
    ),
    CatatanTransaksi(
      kategori: 'Bensin',
      catatan: 'Pertamax Full Tank',
      nominal: 100000,
      ikon: Icons.local_gas_station_outlined,
      warna: const Color(0xFFF59E0B),
      tanggal: DateTime.now(),
      sumberDana: 'Debit Utama',
    ),
    CatatanTransaksi(
      kategori: 'Belanja',
      catatan: 'Kebutuhan Harian Kos',
      nominal: 136000,
      ikon: Icons.shopping_bag_outlined,
      warna: const Color(0xFF3B82F6),
      tanggal: DateTime.now(),
      sumberDana: 'Kantong Utama',
    ),
    CatatanTransaksi(
      kategori: 'Freelance',
      catatan: 'Proyek Desain Web',
      nominal: 1500000,
      ikon: Icons.laptop_mac_outlined,
      warna: const Color(0xFF0D9488),
      tanggal: DateTime.now().subtract(const Duration(days: 1)),
      isPemasukan: true,
      sumberDana: 'Rekening Bank',
    ),
    CatatanTransaksi(
      kategori: 'Makan',
      catatan: 'Makan Malam Bersama',
      nominal: 45000,
      ikon: Icons.restaurant_outlined,
      warna: const Color(0xFF10B981),
      tanggal: DateTime.now().subtract(const Duration(days: 1)),
      sumberDana: 'Kantong Utama',
    ),
  ];

  static final List<WishlistItem> daftarWishlist = [
    WishlistItem(
      nama: 'Sony PlayStation 5 Slim',
      mataUang: 'USD',
      hargaAsing: 499,
      targetIdr: 7811346,
      terkumpulIdr: 5200000,
      ikon: Icons.sports_esports_outlined,
    ),
    WishlistItem(
      nama: 'Tiket Konser Luar Negeri',
      mataUang: 'JPY',
      hargaAsing: 35000,
      targetIdr: 3640000,
      terkumpulIdr: 2800000,
      ikon: Icons.confirmation_number_outlined,
    ),
    WishlistItem(
      nama: 'Mechanical Keyboard Keychron Q1',
      mataUang: 'USD',
      hargaAsing: 190,
      targetIdr: 2974260,
      terkumpulIdr: 2974260,
      ikon: Icons.keyboard_outlined,
    ),
  ];

  static final List<String> tipsKeuangan = [
    'Alokasikan minimal 20% penghasilan ke Kantong Tabungan di awal bulan agar target tahunan tercapai tepat waktu.',
    'Gunakan fitur batas anggaran pada kategori Makan & Jajan untuk mencegah pengeluaran impulsif di akhir pekan.',
    'Catat setiap pengeluaran kecil di bawah Rp 20.000 karena akumulasi jajan harian sering kali tidak disadari.',
    'Pisahkan rekening kebutuhan bulanan dengan rekening dana darurat agar arus kas tetap sehat.',
  ];

  static final List<String> tipsValas = [
    'Saat menabung untuk barang berharga mata uang asing, sisihkan cadangan sekitar 3% untuk mengantisipasi fluktuasi kurs.',
    'Beli atau konversi mata uang asing secara bertahap (cicil) ketika nilai tukar Rupiah sedang menguat.',
    'Hindari menukar mata uang asing mendekati akhir pekan karena selisih kurs beli dan jual biasanya lebih lebar.',
    'Manfaatkan kalkulator kurs sebelum membeli barang dari luar negeri untuk menghitung estimasi pajak dan biaya kirim.',
  ];

  static void tambahTransaksi(CatatanTransaksi item) {
    daftarTransaksi.insert(0, item);
    refreshNotifier.value++;
  }

  static void tambahKategori(KategoriItem item) {
    daftarKategori.add(item);
    refreshNotifier.value++;
  }

  static void hapusKategori(KategoriItem item) {
    daftarKategori.remove(item);
    refreshNotifier.value++;
  }

  static void tambahWishlist(WishlistItem item) {
    daftarWishlist.insert(0, item);
    refreshNotifier.value++;
  }

  static void tambahTabunganWishlist(int index, int nominal) {
    var item = daftarWishlist[index];
    if (item.terkumpulIdr + nominal >= item.targetIdr) {
      item.terkumpulIdr = item.targetIdr;
    } else {
      item.terkumpulIdr += nominal;
    }
    refreshNotifier.value++;
  }

  static int get totalPemasukan {
    int dasar = 7400000;
    for (var t in daftarTransaksi) {
      if (t.isPemasukan) dasar += t.nominal;
    }
    return dasar;
  }

  static int get totalPengeluaran {
    int dasar = 3174000;
    for (var t in daftarTransaksi) {
      if (!t.isPemasukan && !t.isTransfer) dasar += t.nominal;
    }
    return dasar;
  }

  static int get saldoTersedia => 13000200 + totalPemasukan - totalPengeluaran;
}
