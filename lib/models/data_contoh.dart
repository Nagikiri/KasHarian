import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'budget.dart';
import 'dompet.dart';
import 'kategori.dart';
import 'transaksi.dart';
import 'utang.dart';
import 'wishlist.dart';

// Data contoh hanya dimasukkan ke database saat database pertama kali dibuat (DbService).
// AppData juga memakainya sebagai isi awal di memori, supaya test bisa berjalan tanpa database.

// Kalau app dibuka di awal bulan, tanggal mundur bisa jatuh ke bulan lalu, jadi ditahan di tanggal 1.
DateTime _bulanIni(int mundurHari) {
  DateTime sekarang = DateTime.now();
  DateTime t = sekarang.subtract(Duration(days: mundurHari));
  if (t.month != sekarang.month) {
    return DateTime(sekarang.year, sekarang.month, 1);
  }
  return t;
}

DateTime _bulanLalu(int tanggal) => _mundurBulan(1, tanggal);

DateTime _mundurBulan(int jumlahBulan, int tanggal) {
  DateTime sekarang = DateTime.now();
  return DateTime(sekarang.year, sekarang.month - jumlahBulan, tanggal);
}

// Bawaan dipakai juga saat "Hapus semua data", jadi saldo awal semua dompet 0.
List<Dompet> dompetBawaan() {
  return [
    Dompet(nama: 'Utama', ikon: LucideIcons.wallet),
    Dompet(nama: 'Rekening Bank', ikon: LucideIcons.landmark),
    Dompet(nama: 'E-Wallet', ikon: LucideIcons.smartphone),
    Dompet(nama: 'Tunai', ikon: LucideIcons.banknote),
    Dompet(nama: 'Tabungan', ikon: LucideIcons.piggyBank),
  ];
}

// Data contoh hanya memberi saldo awal di dompet Utama.
List<Dompet> contohDompet() {
  List<Dompet> daftar = dompetBawaan();
  daftar.first.saldoAwal = 2500000;
  return daftar;
}

// Kategori bawaan dipakai saat database dibuat dan saat "Hapus semua data".
List<KategoriItem> kategoriBawaan() {
  return [
    KategoriItem(nama: 'Makan', ikon: LucideIcons.utensils, indeksWarna: 5),
    KategoriItem(nama: 'Jajan', ikon: LucideIcons.cookie, indeksWarna: 3),
    KategoriItem(nama: 'Kopi', ikon: LucideIcons.coffee, indeksWarna: 1),
    KategoriItem(
      nama: 'Belanja Harian',
      ikon: LucideIcons.shoppingCart,
      indeksWarna: 4,
    ),
    KategoriItem(
      nama: 'Belanja',
      ikon: LucideIcons.shoppingBag,
      indeksWarna: 6,
    ),
    KategoriItem(nama: 'Transportasi', ikon: LucideIcons.bus, indeksWarna: 0),
    KategoriItem(nama: 'Bensin', ikon: LucideIcons.fuel, indeksWarna: 2),
    KategoriItem(nama: 'Ojek Online', ikon: LucideIcons.bike, indeksWarna: 3),
    KategoriItem(
      nama: 'Parkir',
      ikon: LucideIcons.circleParking,
      indeksWarna: 6,
    ),
    KategoriItem(
      nama: 'Tagihan',
      ikon: LucideIcons.receiptText,
      indeksWarna: 4,
    ),
    KategoriItem(nama: 'Listrik', ikon: LucideIcons.zap, indeksWarna: 1),
    KategoriItem(nama: 'Air', ikon: LucideIcons.droplet, indeksWarna: 2),
    KategoriItem(nama: 'Internet', ikon: LucideIcons.wifi, indeksWarna: 5),
    KategoriItem(
      nama: 'Pulsa & Data',
      ikon: LucideIcons.smartphone,
      indeksWarna: 0,
    ),
    KategoriItem(nama: 'Rumah', ikon: LucideIcons.house, indeksWarna: 3),
    KategoriItem(
      nama: 'Kos & Sewa',
      ikon: LucideIcons.keyRound,
      indeksWarna: 1,
    ),
    KategoriItem(
      nama: 'Kesehatan',
      ikon: LucideIcons.stethoscope,
      indeksWarna: 2,
    ),
    KategoriItem(nama: 'Obat', ikon: LucideIcons.pill, indeksWarna: 5),
    KategoriItem(nama: 'Olahraga', ikon: LucideIcons.dumbbell, indeksWarna: 0),
    KategoriItem(
      nama: 'Perawatan Diri',
      ikon: LucideIcons.sparkles,
      indeksWarna: 6,
    ),
    KategoriItem(nama: 'Pakaian', ikon: LucideIcons.shirt, indeksWarna: 4),
    KategoriItem(
      nama: 'Pendidikan',
      ikon: LucideIcons.bookOpen,
      indeksWarna: 2,
    ),
    KategoriItem(
      nama: 'Kursus',
      ikon: LucideIcons.graduationCap,
      indeksWarna: 3,
    ),
    KategoriItem(
      nama: 'Hiburan',
      ikon: LucideIcons.clapperboard,
      indeksWarna: 3,
    ),
    KategoriItem(nama: 'Gim', ikon: LucideIcons.gamepad2, indeksWarna: 4),
    KategoriItem(nama: 'Langganan', ikon: LucideIcons.tv, indeksWarna: 5),
    KategoriItem(nama: 'Liburan', ikon: LucideIcons.plane, indeksWarna: 0),
    KategoriItem(nama: 'Hadiah', ikon: LucideIcons.gift, indeksWarna: 6),
    KategoriItem(
      nama: 'Donasi',
      ikon: LucideIcons.heartHandshake,
      indeksWarna: 2,
    ),
    KategoriItem(
      nama: 'Kondangan',
      ikon: LucideIcons.partyPopper,
      indeksWarna: 1,
    ),
    KategoriItem(
      nama: 'Hewan Peliharaan',
      ikon: LucideIcons.pawPrint,
      indeksWarna: 3,
    ),
    KategoriItem(nama: 'Anak', ikon: LucideIcons.baby, indeksWarna: 5),
    KategoriItem(
      nama: 'Elektronik',
      ikon: LucideIcons.monitorSmartphone,
      indeksWarna: 4,
    ),
    KategoriItem(nama: 'Servis', ikon: LucideIcons.wrench, indeksWarna: 1),
    KategoriItem(nama: 'Pajak', ikon: LucideIcons.landmark, indeksWarna: 5),
    KategoriItem(
      nama: 'Asuransi',
      ikon: LucideIcons.shieldCheck,
      indeksWarna: 2,
    ),
    KategoriItem(nama: 'Lainnya', ikon: LucideIcons.ellipsis, indeksWarna: 7),
    KategoriItem(
      nama: 'Gaji',
      ikon: LucideIcons.banknote,
      isPemasukan: true,
      indeksWarna: 0,
    ),
    KategoriItem(
      nama: 'Kerja Lepas',
      ikon: LucideIcons.laptop,
      isPemasukan: true,
      indeksWarna: 2,
    ),
    KategoriItem(
      nama: 'Bonus',
      ikon: LucideIcons.award,
      isPemasukan: true,
      indeksWarna: 1,
    ),
    KategoriItem(
      nama: 'Uang Saku',
      ikon: LucideIcons.wallet,
      isPemasukan: true,
      indeksWarna: 5,
    ),
    KategoriItem(
      nama: 'Penjualan',
      ikon: LucideIcons.store,
      isPemasukan: true,
      indeksWarna: 3,
    ),
    KategoriItem(
      nama: 'Investasi',
      ikon: LucideIcons.trendingUp,
      isPemasukan: true,
      indeksWarna: 4,
    ),
    KategoriItem(
      nama: 'Bunga',
      ikon: LucideIcons.percent,
      isPemasukan: true,
      indeksWarna: 6,
    ),
    KategoriItem(
      nama: 'Pengembalian Dana',
      ikon: LucideIcons.rotateCcw,
      isPemasukan: true,
      indeksWarna: 2,
    ),
    KategoriItem(
      nama: 'Hadiah',
      ikon: LucideIcons.gift,
      isPemasukan: true,
      indeksWarna: 6,
    ),
    KategoriItem(
      nama: 'Lainnya',
      ikon: LucideIcons.ellipsis,
      isPemasukan: true,
      indeksWarna: 7,
    ),
  ];
}

// Terbaru di depan, sama seperti urutan setelah tambahTransaksi.
List<CatatanTransaksi> contohTransaksi() {
  return [
    CatatanTransaksi(
      kategori: 'Kopi',
      catatan: 'Kopi Kenangan & Roti',
      nominal: 35000,
      ikon: LucideIcons.coffee,
      tanggal: _bulanIni(0),
      sumberDana: 'E-Wallet',
    ),
    CatatanTransaksi(
      kategori: 'Bensin',
      catatan: 'Pertamax Full Tank',
      nominal: 100000,
      ikon: LucideIcons.fuel,
      tanggal: _bulanIni(0),
      sumberDana: 'Rekening Bank',
    ),
    CatatanTransaksi(
      kategori: 'Belanja',
      catatan: 'Kebutuhan Harian Kos',
      nominal: 136000,
      ikon: LucideIcons.shoppingBag,
      tanggal: _bulanIni(0),
    ),
    CatatanTransaksi(
      kategori: 'Kerja Lepas',
      catatan: 'Proyek Desain Web',
      nominal: 750000,
      ikon: LucideIcons.laptop,
      tanggal: _bulanIni(1),
      isPemasukan: true,
      sumberDana: 'Rekening Bank',
    ),
    CatatanTransaksi(
      kategori: 'Makan',
      catatan: 'Makan Malam Bersama',
      nominal: 45000,
      ikon: LucideIcons.utensils,
      tanggal: _bulanIni(1),
    ),
    CatatanTransaksi(
      kategori: 'Makan',
      catatan: 'Nasi Padang',
      nominal: 28000,
      ikon: LucideIcons.utensils,
      tanggal: _bulanIni(3),
      sumberDana: 'Tunai',
    ),
    CatatanTransaksi(
      kategori: 'Pindah',
      catatan: 'Isi Saldo E-Wallet',
      nominal: 500000,
      ikon: LucideIcons.arrowLeftRight,
      tanggal: _bulanIni(4),
      isTransfer: true,
      sumberDana: 'Rekening Bank',
      sumberTujuan: 'E-Wallet',
    ),
    CatatanTransaksi(
      kategori: 'Pindah',
      catatan: 'Tarik Tunai',
      nominal: 300000,
      ikon: LucideIcons.arrowLeftRight,
      tanggal: _bulanIni(4),
      isTransfer: true,
      sumberDana: 'Rekening Bank',
      sumberTujuan: 'Tunai',
    ),
    CatatanTransaksi(
      kategori: 'Tagihan',
      catatan: 'Token Listrik',
      nominal: 350000,
      ikon: LucideIcons.receiptText,
      tanggal: _bulanIni(5),
      sumberDana: 'Rekening Bank',
    ),
    CatatanTransaksi(
      kategori: 'Tagihan',
      catatan: 'Paket Internet',
      nominal: 120000,
      ikon: LucideIcons.receiptText,
      tanggal: _bulanIni(6),
      sumberDana: 'E-Wallet',
    ),
    CatatanTransaksi(
      kategori: 'Bensin',
      catatan: 'Pertalite',
      nominal: 50000,
      ikon: LucideIcons.fuel,
      tanggal: _bulanIni(8),
      sumberDana: 'Tunai',
    ),
    CatatanTransaksi(
      kategori: 'Pindah',
      catatan: 'Nabung untuk Mouse Logitech M331',
      nominal: 391350,
      ikon: LucideIcons.arrowLeftRight,
      tanggal: _bulanIni(9),
      isTransfer: true,
      sumberDana: 'Rekening Bank',
      sumberTujuan: 'Tabungan',
    ),
    CatatanTransaksi(
      kategori: 'Pindah',
      catatan: 'Tabungan Bulanan',
      nominal: 500000,
      ikon: LucideIcons.arrowLeftRight,
      tanggal: _bulanIni(10),
      isTransfer: true,
      sumberDana: 'Utama',
      sumberTujuan: 'Tabungan',
    ),
    CatatanTransaksi(
      kategori: 'Gaji',
      catatan: 'Gaji Bulanan',
      nominal: 4500000,
      ikon: LucideIcons.banknote,
      tanggal: _bulanIni(12),
      isPemasukan: true,
      sumberDana: 'Rekening Bank',
    ),
    CatatanTransaksi(
      kategori: 'Makan',
      catatan: 'Makan Siang Kampus',
      nominal: 62000,
      ikon: LucideIcons.utensils,
      tanggal: _bulanIni(14),
    ),
    CatatanTransaksi(
      kategori: 'Pindah',
      catatan: 'Nabung untuk Mechanical Keyboard Keychron Q1',
      nominal: 1200000,
      ikon: LucideIcons.arrowLeftRight,
      tanggal: _bulanLalu(20),
      isTransfer: true,
      sumberDana: 'Rekening Bank',
      sumberTujuan: 'Tabungan',
    ),
    CatatanTransaksi(
      kategori: 'Hiburan',
      catatan: 'Nonton Bioskop',
      nominal: 60000,
      ikon: LucideIcons.clapperboard,
      tanggal: _bulanLalu(24),
      sumberDana: 'E-Wallet',
    ),
    CatatanTransaksi(
      kategori: 'Bensin',
      catatan: 'Pertamax',
      nominal: 100000,
      ikon: LucideIcons.fuel,
      tanggal: _bulanLalu(18),
      sumberDana: 'Tunai',
    ),
    CatatanTransaksi(
      kategori: 'Makan',
      catatan: 'Makan Bersama Keluarga',
      nominal: 75000,
      ikon: LucideIcons.utensils,
      tanggal: _bulanLalu(12),
    ),
    CatatanTransaksi(
      kategori: 'Tagihan',
      catatan: 'Bayar Kos',
      nominal: 450000,
      ikon: LucideIcons.receiptText,
      tanggal: _bulanLalu(5),
      sumberDana: 'Rekening Bank',
    ),
    CatatanTransaksi(
      kategori: 'Gaji',
      catatan: 'Gaji Bulanan',
      nominal: 4500000,
      ikon: LucideIcons.banknote,
      tanggal: _bulanLalu(1),
      isPemasukan: true,
      sumberDana: 'Rekening Bank',
    ),
    CatatanTransaksi(
      kategori: 'Pindah',
      catatan: 'Nabung untuk Tiket Konser Luar Negeri',
      nominal: 1500000,
      ikon: LucideIcons.arrowLeftRight,
      tanggal: _mundurBulan(2, 15),
      isTransfer: true,
      sumberDana: 'Rekening Bank',
      sumberTujuan: 'Tabungan',
    ),
    CatatanTransaksi(
      kategori: 'Pindah',
      catatan: 'Nabung untuk Sony PlayStation 5 Slim',
      nominal: 1500000,
      ikon: LucideIcons.arrowLeftRight,
      tanggal: _mundurBulan(3, 15),
      isTransfer: true,
      sumberDana: 'Rekening Bank',
      sumberTujuan: 'Tabungan',
    ),
  ];
}

List<WishlistItem> contohWishlist() {
  return [
    WishlistItem(
      nama: 'Sony PlayStation 5 Slim',
      kategori: 'Gim & Hobi',
      mataUang: 'USD',
      hargaAsing: 499,
      targetIdr: 7811346,
      terkumpulIdr: 1500000,
      ikon: LucideIcons.gamepad2,
    ),
    WishlistItem(
      nama: 'Tiket Konser Luar Negeri',
      kategori: 'Konser & Acara',
      mataUang: 'JPY',
      hargaAsing: 35000,
      targetIdr: 3640000,
      terkumpulIdr: 1500000,
      ikon: LucideIcons.ticket,
    ),
    WishlistItem(
      nama: 'Mechanical Keyboard Keychron Q1',
      kategori: 'Komputer & Aksesori',
      mataUang: 'USD',
      hargaAsing: 190,
      targetIdr: 2974260,
      terkumpulIdr: 1200000,
      ikon: LucideIcons.laptop,
    ),
    WishlistItem(
      nama: 'Mouse Logitech M331',
      kategori: 'Komputer & Aksesori',
      mataUang: 'USD',
      hargaAsing: 25,
      targetIdr: 391350,
      terkumpulIdr: 391350,
      ikon: LucideIcons.laptop,
    ),
  ];
}

List<BudgetItem> contohBudget() {
  return [
    BudgetItem(kategori: 'Makan', limit: 1400000),
    BudgetItem(kategori: 'Bensin', limit: 400000),
    BudgetItem(kategori: 'Tagihan', limit: 1200000),
    BudgetItem(kategori: 'Tabungan', limit: 2000000),
  ];
}

List<UtangItem> contohUtang() {
  return [
    UtangItem(
      jenis: 'Piutang',
      nama: 'Budi',
      nominal: 50000,
      keterangan: 'Nalangin makan siang',
      tanggal: _bulanIni(2),
    ),
    UtangItem(
      jenis: 'Piutang',
      nama: 'Rian',
      nominal: 85000,
      keterangan: 'Tiket bioskop',
      tanggal: _bulanIni(4),
    ),
    UtangItem(
      jenis: 'Utang',
      nama: 'Dimas',
      nominal: 120000,
      keterangan: 'Patungan kafe',
      tanggal: _bulanIni(6),
    ),
  ];
}
