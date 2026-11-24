import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../services/api_service.dart';
import '../utils/format.dart';
import '../utils/periode.dart';
import 'bagian_teman.dart';
import 'budget.dart';
import 'kategori.dart';
import 'mata_uang.dart';
import 'transaksi.dart';
import 'utang.dart';
import 'wishlist.dart';

class AppData {
  static final ValueNotifier<int> refreshNotifier = ValueNotifier<int>(0);
  static final ValueNotifier<int> tabAktif = ValueNotifier<int>(0);
  // Diisi "Lihat semua" di Beranda, lalu dibaca sekali oleh tab Transaksi saat dibuka.
  static bool gulirKeDaftar = false;
  static DateTime bulanDipilih = DateTime.now();

  static int saldoAwal = 2500000;
  static int anggaranBulanan = 5000000;

  // Kalau app dibuka di awal bulan, tanggal mundur bisa jatuh ke bulan lalu, jadi ditahan di tanggal 1.
  static DateTime _bulanIni(int mundurHari) {
    DateTime sekarang = DateTime.now();
    DateTime t = sekarang.subtract(Duration(days: mundurHari));
    if (t.month != sekarang.month) {
      return DateTime(sekarang.year, sekarang.month, 1);
    }
    return t;
  }

  static DateTime _bulanLalu(int tanggal) => _mundurBulan(1, tanggal);

  static DateTime _mundurBulan(int jumlahBulan, int tanggal) {
    DateTime sekarang = DateTime.now();
    return DateTime(sekarang.year, sekarang.month - jumlahBulan, tanggal);
  }

  static final List<String> daftarSumberDana = [
    'Kantong Utama',
    'Rekening Bank',
    'Saku QRIS',
    'Dompet Tunai',
    'Tabungan',
  ];

  static final List<KategoriItem> daftarKategori = [
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

  static final List<IconData> opsiIkonKategori = [
    LucideIcons.utensils,
    LucideIcons.coffee,
    LucideIcons.shoppingCart,
    LucideIcons.bus,
    LucideIcons.fuel,
    LucideIcons.receiptText,
    LucideIcons.zap,
    LucideIcons.wifi,
    LucideIcons.house,
    LucideIcons.stethoscope,
    LucideIcons.dumbbell,
    LucideIcons.shirt,
    LucideIcons.bookOpen,
    LucideIcons.gamepad2,
    LucideIcons.gift,
    LucideIcons.pawPrint,
  ];

  // Ikon impian mengikuti kategorinya, jadi tidak dipilih sendiri.
  static final List<KategoriItem> kategoriImpian = [
    KategoriItem(
      nama: 'Ponsel & Tablet',
      ikon: LucideIcons.smartphone,
      indeksWarna: 5,
    ),
    KategoriItem(
      nama: 'Komputer & Aksesori',
      ikon: LucideIcons.laptop,
      indeksWarna: 2,
    ),
    KategoriItem(nama: 'Audio', ikon: LucideIcons.headphones, indeksWarna: 1),
    KategoriItem(nama: 'Kamera', ikon: LucideIcons.camera, indeksWarna: 3),
    KategoriItem(
      nama: 'Gim & Hobi',
      ikon: LucideIcons.gamepad2,
      indeksWarna: 4,
    ),
    KategoriItem(
      nama: 'Jam & Aksesori',
      ikon: LucideIcons.watch,
      indeksWarna: 0,
    ),
    KategoriItem(nama: 'Busana', ikon: LucideIcons.shirt, indeksWarna: 6),
    KategoriItem(nama: 'Kendaraan', ikon: LucideIcons.car, indeksWarna: 4),
    KategoriItem(
      nama: 'Motor & Sepeda',
      ikon: LucideIcons.motorbike,
      indeksWarna: 5,
    ),
    KategoriItem(
      nama: 'Rumah & Perabot',
      ikon: LucideIcons.sofa,
      indeksWarna: 3,
    ),
    KategoriItem(
      nama: 'Elektronik Rumah',
      ikon: LucideIcons.tv,
      indeksWarna: 1,
    ),
    KategoriItem(nama: 'Liburan', ikon: LucideIcons.plane, indeksWarna: 0),
    KategoriItem(
      nama: 'Konser & Acara',
      ikon: LucideIcons.ticket,
      indeksWarna: 6,
    ),
    KategoriItem(
      nama: 'Pendidikan',
      ikon: LucideIcons.graduationCap,
      indeksWarna: 2,
    ),
    KategoriItem(nama: 'Hadiah', ikon: LucideIcons.gift, indeksWarna: 6),
    KategoriItem(nama: 'Lainnya', ikon: LucideIcons.star, indeksWarna: 7),
  ];

  // Nama ini dipakai sistem (budget, transfer, pelunasan utang), jadi tidak boleh jadi nama kategori.
  static final List<String> namaKhusus = ['Tabungan', 'Transfer', 'Pelunasan'];

  static final List<CatatanTransaksi> daftarTransaksi = [
    CatatanTransaksi(
      kategori: 'Kopi',
      catatan: 'Kopi Kenangan & Roti',
      nominal: 35000,
      ikon: LucideIcons.coffee,
      tanggal: _bulanIni(0),
      sumberDana: 'Saku QRIS',
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
      sumberDana: 'Dompet Tunai',
    ),
    CatatanTransaksi(
      kategori: 'Transfer',
      catatan: 'Isi Saldo Saku QRIS',
      nominal: 500000,
      ikon: LucideIcons.arrowLeftRight,
      tanggal: _bulanIni(4),
      isTransfer: true,
      sumberDana: 'Rekening Bank',
      sumberTujuan: 'Saku QRIS',
    ),
    CatatanTransaksi(
      kategori: 'Transfer',
      catatan: 'Tarik Tunai',
      nominal: 300000,
      ikon: LucideIcons.arrowLeftRight,
      tanggal: _bulanIni(4),
      isTransfer: true,
      sumberDana: 'Rekening Bank',
      sumberTujuan: 'Dompet Tunai',
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
      sumberDana: 'Saku QRIS',
    ),
    CatatanTransaksi(
      kategori: 'Bensin',
      catatan: 'Pertalite',
      nominal: 50000,
      ikon: LucideIcons.fuel,
      tanggal: _bulanIni(8),
      sumberDana: 'Dompet Tunai',
    ),
    CatatanTransaksi(
      kategori: 'Transfer',
      catatan: 'Nabung untuk Mouse Logitech M331',
      nominal: 391350,
      ikon: LucideIcons.arrowLeftRight,
      tanggal: _bulanIni(9),
      isTransfer: true,
      sumberDana: 'Rekening Bank',
      sumberTujuan: 'Tabungan',
    ),
    CatatanTransaksi(
      kategori: 'Transfer',
      catatan: 'Tabungan Bulanan',
      nominal: 500000,
      ikon: LucideIcons.arrowLeftRight,
      tanggal: _bulanIni(10),
      isTransfer: true,
      sumberDana: 'Kantong Utama',
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
      kategori: 'Transfer',
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
      sumberDana: 'Saku QRIS',
    ),
    CatatanTransaksi(
      kategori: 'Bensin',
      catatan: 'Pertamax',
      nominal: 100000,
      ikon: LucideIcons.fuel,
      tanggal: _bulanLalu(18),
      sumberDana: 'Dompet Tunai',
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
      kategori: 'Transfer',
      catatan: 'Nabung untuk Tiket Konser Luar Negeri',
      nominal: 1500000,
      ikon: LucideIcons.arrowLeftRight,
      tanggal: _mundurBulan(2, 15),
      isTransfer: true,
      sumberDana: 'Rekening Bank',
      sumberTujuan: 'Tabungan',
    ),
    CatatanTransaksi(
      kategori: 'Transfer',
      catatan: 'Nabung untuk Sony PlayStation 5 Slim',
      nominal: 1500000,
      ikon: LucideIcons.arrowLeftRight,
      tanggal: _mundurBulan(3, 15),
      isTransfer: true,
      sumberDana: 'Rekening Bank',
      sumberTujuan: 'Tabungan',
    ),
  ];

  static final List<WishlistItem> daftarWishlist = [
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

  static final List<BudgetItem> daftarBudget = [
    BudgetItem(kategori: 'Makan', limit: 1400000),
    BudgetItem(kategori: 'Bensin', limit: 400000),
    BudgetItem(kategori: 'Tagihan', limit: 1200000),
    BudgetItem(kategori: 'Tabungan', limit: 2000000),
  ];

  static final List<UtangItem> daftarUtang = [
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

  // Kurs cadangan hanya untuk empat mata uang lama. Yang lain menunggu API berhasil.
  static const Map<String, double> kursCadangan = {
    'USD': 15654,
    'SGD': 11642,
    'JPY': 104,
    'EUR': 16950,
  };

  // Mata uang yang bisa dipilih di pemilih mata uang, urut dari yang paling sering dipakai.
  static const List<MataUang> daftarMataUang = [
    MataUang(kode: 'USD', nama: 'Dolar Amerika', simbol: '\$'),
    MataUang(kode: 'EUR', nama: 'Euro', simbol: '€'),
    MataUang(kode: 'SGD', nama: 'Dolar Singapura', simbol: 'S\$'),
    MataUang(kode: 'JPY', nama: 'Yen Jepang', simbol: '¥'),
    MataUang(kode: 'MYR', nama: 'Ringgit Malaysia', simbol: 'RM'),
    MataUang(kode: 'SAR', nama: 'Riyal Saudi', simbol: 'SR'),
    MataUang(kode: 'AUD', nama: 'Dolar Australia', simbol: 'A\$'),
    MataUang(kode: 'GBP', nama: 'Pound Inggris', simbol: '£'),
    MataUang(kode: 'CNY', nama: 'Yuan Tiongkok', simbol: '¥'),
    MataUang(kode: 'KRW', nama: 'Won Korea', simbol: '₩'),
    MataUang(kode: 'THB', nama: 'Baht Thailand', simbol: '฿'),
    MataUang(kode: 'HKD', nama: 'Dolar Hong Kong', simbol: 'HK\$'),
    MataUang(kode: 'TWD', nama: 'Dolar Taiwan', simbol: 'NT\$'),
    MataUang(kode: 'CHF', nama: 'Franc Swiss', simbol: 'Fr'),
    MataUang(kode: 'CAD', nama: 'Dolar Kanada', simbol: 'C\$'),
    MataUang(kode: 'NZD', nama: 'Dolar Selandia Baru', simbol: 'NZ\$'),
    MataUang(kode: 'INR', nama: 'Rupee India', simbol: '₹'),
    MataUang(kode: 'PHP', nama: 'Peso Filipina', simbol: '₱'),
    MataUang(kode: 'VND', nama: 'Dong Vietnam', simbol: '₫'),
    MataUang(kode: 'AED', nama: 'Dirham UEA', simbol: 'Dh'),
    MataUang(kode: 'TRY', nama: 'Lira Turki', simbol: '₺'),
    MataUang(kode: 'EGP', nama: 'Pound Mesir', simbol: 'E£'),
    MataUang(kode: 'QAR', nama: 'Riyal Qatar', simbol: 'QR'),
    MataUang(kode: 'KWD', nama: 'Dinar Kuwait', simbol: 'KD'),
    MataUang(kode: 'BND', nama: 'Dolar Brunei', simbol: 'B\$'),
  ];

  // Hanya untuk form Impian, yang boleh memakai harga Rupiah langsung.
  static const MataUang rupiah = MataUang(
    kode: 'IDR',
    nama: 'Rupiah',
    simbol: 'Rp',
  );

  // Belum disimpan permanen. Kembali ke bawaan setiap aplikasi dibuka sampai ada sqflite.
  static List<String> mataUangFavorit = ['USD', 'SGD', 'JPY'];

  // Diawali kurs cadangan, lalu ditimpa hasil API saat berhasil.
  static final Map<String, double> kursKeIdr = Map.of(kursCadangan);
  static DateTime? kursDiperbarui;
  static bool kursLive = false;
  // Tetap true walau refresh berikutnya gagal, supaya tahu kursKeIdr berisi hasil API.
  static bool kursPernahLive = false;

  static const String contohSaranAi =
      'Pengeluaran terbesarmu bulan ini ada di Tagihan, jadi coba cek lagi paket internet yang mungkin bisa diganti lebih murah. '
      'Uang jajan kopi dan makan di luar juga lumayan, kalau dikurangi sedikit tiap minggu sisanya bisa langsung masuk ke tabungan PlayStation 5 Slim. '
      'Targetnya sudah lewat setengah jalan, tinggal konsisten beberapa bulan lagi.';

  static void tambahTransaksi(CatatanTransaksi item) {
    daftarTransaksi.insert(0, item);
    refreshNotifier.value++;
  }

  // tipe: 0 = Pengeluaran, 1 = Pemasukan, sama dengan urutan PilihanSegmen.
  static List<KategoriItem> kategoriTipe(int tipe) {
    return daftarKategori.where((k) => k.isPemasukan == (tipe == 1)).toList();
  }

  // Paling sering dipakai di depan. Kalau sama sering, urutan daftarKategori dipertahankan.
  static List<KategoriItem> kategoriSering(bool pemasukan, int jumlah) {
    Map<String, int> hitungan = {};
    for (var t in daftarTransaksi) {
      if (t.isTransfer || t.isPemasukan != pemasukan) continue;
      hitungan[t.kategori] = (hitungan[t.kategori] ?? 0) + 1;
    }
    List<KategoriItem> daftar = kategoriTipe(pemasukan ? 1 : 0);
    daftar.sort((a, b) {
      int selisih = (hitungan[b.nama] ?? 0) - (hitungan[a.nama] ?? 0);
      if (selisih != 0) return selisih;
      return daftarKategori.indexOf(a) - daftarKategori.indexOf(b);
    });
    return daftar.take(jumlah).toList();
  }

  static void tambahKategori(KategoriItem item) {
    daftarKategori.add(item);
    refreshNotifier.value++;
  }

  static void ubahTransaksi(CatatanTransaksi lama, CatatanTransaksi baru) {
    int posisi = daftarTransaksi.indexOf(lama);
    if (posisi == -1) return;
    daftarTransaksi[posisi] = baru;
    refreshNotifier.value++;
  }

  // Budget ikut dihapus supaya tidak ada budget tanpa kategori. Budget hanya ada untuk pengeluaran.
  static void hapusKategori(KategoriItem item) {
    daftarKategori.remove(item);
    if (!item.isPemasukan) {
      daftarBudget.removeWhere((b) => b.kategori == item.nama);
    }
    refreshNotifier.value++;
  }

  static void tambahWishlist(WishlistItem item) {
    daftarWishlist.insert(0, item);
    refreshNotifier.value++;
  }

  // Uang tabungan dipindah ke dompet Tabungan supaya ikut terhitung di budget Tabungan.
  static int tambahTabunganWishlist(WishlistItem item, int nominal) {
    int sisa = item.targetIdr - item.terkumpulIdr;
    int disimpan = nominal > sisa ? sisa : nominal;
    item.terkumpulIdr += disimpan;
    tambahTransaksi(
      CatatanTransaksi(
        kategori: 'Transfer',
        catatan: 'Nabung untuk ${item.nama}',
        nominal: disimpan,
        ikon: LucideIcons.arrowLeftRight,
        tanggal: DateTime.now(),
        isTransfer: true,
        sumberDana: 'Kantong Utama',
        sumberTujuan: 'Tabungan',
      ),
    );
    return disimpan;
  }

  static void hapusWishlist(WishlistItem item) {
    daftarWishlist.remove(item);
    refreshNotifier.value++;
  }

  static MataUang cariMataUang(String kode) {
    if (kode == 'IDR') return rupiah;
    return daftarMataUang.firstWhere((m) => m.kode == kode);
  }

  static bool kursAda(String kode) {
    if (kode == 'IDR') return true;
    return (kursKeIdr[kode] ?? 0) > 0;
  }

  static void simpanFavorit(List<String> daftar) {
    mataUangFavorit = daftar;
    refreshNotifier.value++;
  }

  // IDR tidak ada di kursKeIdr supaya perbaruiKurs dan konverter tidak ikut berubah.
  static int targetDariKurs(String mataUang, int harga) {
    if (mataUang == 'IDR') return harga;
    return (harga * (kursKeIdr[mataUang] ?? 0)).round();
  }

  // Kebalikan targetDariKurs untuk Hitung kurs. Hasil 0 kalau kursnya belum ada.
  static double rupiahKeAsing(String mataUang, int rupiah) {
    double kurs = kursKeIdr[mataUang] ?? 0;
    if (kurs <= 0) return 0;
    return rupiah / kurs;
  }

  // Kurs di bawah Rp 100 ditulis 2 desimal supaya VND dan KRW tidak terbaca 0 atau 11.
  static String teksKursRupiah(String mataUang) {
    double kurs = kursKeIdr[mataUang] ?? 0;
    if (kurs <= 0) return '—';
    if (kurs < 100) return 'Rp ${formatDesimal(kurs)}';
    return 'Rp ${formatTitik(kurs.round())}';
  }

  // Mata uang bernilai kecil butuh template lebih besar supaya tombolnya tetap berguna.
  static List<int> templateMataUang(String mataUang) {
    if (mataUang == 'IDR') return [100000, 500000, 1000000, 5000000];
    double kurs = kursKeIdr[mataUang] ?? 0;
    if (kurs > 0 && kurs < 50) return [10000, 50000, 100000, 500000];
    if (kurs > 0 && kurs < 500) return [1000, 5000, 10000, 50000];
    return [10, 50, 100, 500];
  }

  // Dipusatkan di sini supaya Beranda dan Wishlist memakai kurs yang sama.
  static Future<void> perbaruiKurs() async {
    try {
      final kurs = await ApiService().getKursIdr();
      // Semua kurs disimpan, bukan hanya yang ada di daftarMataUang.
      for (String kode in kurs.daftarRate.keys) {
        double nilai = kurs.keRupiah(kode);
        if (kode != 'IDR' && nilai > 0) kursKeIdr[kode] = nilai;
      }
      kursLive = true;
      kursPernahLive = true;
      kursDiperbarui = DateTime.now();
    } catch (_) {
      kursLive = false;
    }
    refreshNotifier.value++;
  }

  // Satu baris info kurs untuk Beranda dan Hitung kurs. Atribusi ada di BarisInfoKurs.
  static String teksInfoKurs({required bool sedangMemuat}) {
    if (sedangMemuat) return 'Memperbarui kurs…';
    if (kursLive) return 'Diperbarui ${formatTanggalPendek(kursDiperbarui!)}';
    if (kursPernahLive) {
      return 'Kurs terakhir ${formatTanggalPendek(kursDiperbarui!)} · gagal memperbarui';
    }
    return 'Kurs cadangan · gagal memperbarui';
  }

  static void tambahUtang(UtangItem item) {
    daftarUtang.insert(0, item);
    refreshNotifier.value++;
  }

  // Bagian setiap teman dari pengeluaran bersama dicatat sebagai piutang.
  static void catatPiutang(
    List<BagianTeman> daftar,
    String keterangan,
    DateTime tanggal,
  ) {
    for (var teman in daftar) {
      tambahUtang(
        UtangItem(
          jenis: 'Piutang',
          nama: teman.nama.trim(),
          nominal: teman.nominal,
          keterangan: keterangan,
          tanggal: tanggal,
        ),
      );
    }
  }

  // Pelunasan dicatat sebagai transaksi supaya saldo ikut berubah.
  static void lunasiUtang(UtangItem item) {
    item.lunas = true;
    bool piutang = item.jenis == 'Piutang';
    tambahTransaksi(
      CatatanTransaksi(
        kategori: 'Pelunasan',
        catatan: piutang
            ? 'Pelunasan dari ${item.nama}'
            : 'Bayar utang ke ${item.nama}',
        nominal: item.nominal,
        ikon: LucideIcons.handCoins,
        tanggal: DateTime.now(),
        isPemasukan: piutang,
        sumberDana: 'Kantong Utama',
      ),
    );
  }

  // Hasil 0 berarti budget 'Tabungan' belum ada, jadi estimasi tidak bisa dihitung.
  static int estimasiBulanWishlist(WishlistItem item) {
    int limit = 0;
    for (var b in daftarBudget) {
      if (b.kategori == 'Tabungan') limit = b.limit;
    }
    if (limit <= 0) return 0;
    int sisa = item.targetIdr - item.terkumpulIdr;
    // Dibulatkan ke atas: sisa 1,2 bulan tetap dihitung 2 bulan.
    return (sisa / limit).ceil();
  }

  static double _persenImpian(WishlistItem w) => w.terkumpulIdr / w.targetIdr;

  // Impian yang belum tercapai dengan persen terkumpul paling besar.
  static WishlistItem? impianTerdekat() {
    WishlistItem? hasil;
    for (var w in daftarWishlist) {
      if (w.terkumpulIdr >= w.targetIdr) continue;
      if (hasil == null || _persenImpian(w) > _persenImpian(hasil)) hasil = w;
    }
    return hasil;
  }

  // Teks ini yang nanti dikirim ke Gemini sebagai bahan analisis.
  static String rekapUntukAi(DateTime bulan) {
    DateTime awal = DateTime(bulan.year, bulan.month);
    DateTime akhir = DateTime(bulan.year, bulan.month + 1);
    int sisa = anggaranBulanan - terpakaiAnggaran(bulan);
    String teksSisa = sisa < 0
        ? 'lebih ${formatRupiah(-sisa)}'
        : 'sisa ${formatRupiah(sisa)}';
    String hasil =
        'Rekap ${namaBulanPanjang[bulan.month - 1]} ${bulan.year}\n'
        'Pemasukan: ${formatRupiah(pemasukanAntara(awal, akhir))}\n'
        'Pengeluaran: ${formatRupiah(pengeluaranAntara(awal, akhir))}\n'
        'Anggaran: ${formatRupiah(anggaranBulanan)}, $teksSisa\n'
        'Pengeluaran terbesar:\n';
    var kategori = pengeluaranPerKategori(awal, akhir).entries.take(5);
    for (var k in kategori) {
      hasil += '- ${k.key}: ${formatRupiah(k.value)}\n';
    }
    WishlistItem? impian = impianTerdekat();
    if (impian != null) {
      int bulanLagi = estimasiBulanWishlist(impian);
      String estimasi = bulanLagi > 0
          ? formatEstimasiBulan(bulanLagi)
          : 'estimasi belum bisa dihitung';
      hasil +=
          'Impian terdekat: ${impian.nama}, terkumpul '
          '${formatRupiah(impian.terkumpulIdr)} dari '
          '${formatRupiah(impian.targetIdr)}, $estimasi\n';
    }
    return hasil;
  }

  // Isinya akan diganti panggilan Gemini dengan rekapUntukAi(bulan) sebagai bahan.
  static Future<String> mintaSaranAi(DateTime bulan) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return contohSaranAi;
  }

  static int totalBelumLunas(String jenis) {
    int total = 0;
    for (var u in daftarUtang) {
      if (u.jenis == jenis && !u.lunas) total += u.nominal;
    }
    return total;
  }

  static bool _bulanSama(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }

  // Tahun dan bulan diubah jadi satu angka supaya mudah dibandingkan lebih kecil atau lebih besar.
  static int _nomorBulan(DateTime t) => t.year * 12 + t.month - 1;

  static DateTime? bulanBerdataSebelum(DateTime bulan) {
    DateTime? hasil;
    for (var t in daftarTransaksi) {
      int nomor = _nomorBulan(t.tanggal);
      bool sebelum = nomor < _nomorBulan(bulan);
      if (sebelum && (hasil == null || nomor > _nomorBulan(hasil))) {
        hasil = DateTime(t.tanggal.year, t.tanggal.month);
      }
    }
    return hasil;
  }

  static DateTime? bulanBerdataSesudah(DateTime bulan) {
    DateTime? hasil;
    for (var t in daftarTransaksi) {
      int nomor = _nomorBulan(t.tanggal);
      bool sesudah = nomor > _nomorBulan(bulan);
      if (sesudah && (hasil == null || nomor < _nomorBulan(hasil))) {
        hasil = DateTime(t.tanggal.year, t.tanggal.month);
      }
    }
    return hasil;
  }

  static DateTime? tanggalTransaksiPertama() {
    DateTime? hasil;
    for (var t in daftarTransaksi) {
      if (hasil == null || t.tanggal.isBefore(hasil)) hasil = t.tanggal;
    }
    return hasil;
  }

  // Batas bawah tanggal di Catat Transaksi. Transaksi lama tetap boleh dicatat walau lebih tua dari data yang ada.
  static DateTime batasCatatAwal() {
    DateTime sekarang = DateTime.now();
    return DateTime(sekarang.year - 5, sekarang.month);
  }

  // Batas bawah untuk melihat data: awal bulan transaksi paling awal, supaya tidak ada periode kosong di depan.
  static DateTime batasAwal() {
    DateTime? pertama = tanggalTransaksiPertama();
    if (pertama == null) return batasCatatAwal();
    return DateTime(pertama.year, pertama.month);
  }

  // Batas atas semua pemilih waktu: transaksi tidak boleh bertanggal di masa depan.
  static DateTime batasAkhir() => DateTime.now();

  // Akhir eksklusif, jadi transaksi tepat di tanggal akhir tidak ikut.
  static List<CatatanTransaksi> transaksiAntara(DateTime awal, DateTime akhir) {
    return daftarTransaksi
        .where((t) => !t.tanggal.isBefore(awal) && t.tanggal.isBefore(akhir))
        .toList();
  }

  static int pemasukanAntara(DateTime awal, DateTime akhir) {
    int total = 0;
    for (var t in transaksiAntara(awal, akhir)) {
      if (t.isPemasukan) total += t.nominal;
    }
    return total;
  }

  static int pengeluaranAntara(DateTime awal, DateTime akhir) {
    int total = 0;
    for (var t in transaksiAntara(awal, akhir)) {
      if (!t.isPemasukan && !t.isTransfer) total += t.nominal;
    }
    return total;
  }

  // Hasilnya sudah terurut dari yang terbesar, karena Map menyimpan urutan saat diisi.
  static Map<String, int> pengeluaranPerKategori(
    DateTime awal,
    DateTime akhir,
  ) {
    Map<String, int> total = {};
    for (var t in transaksiAntara(awal, akhir)) {
      if (t.isPemasukan || t.isTransfer) continue;
      total[t.kategori] = (total[t.kategori] ?? 0) + t.nominal;
    }
    var urutan = total.entries.toList();
    urutan.sort((a, b) => b.value - a.value);
    return Map.fromEntries(urutan);
  }

  // Satu nilai per batang grafik, batasnya sama dengan slotTren supaya label dan nilai sejajar.
  static List<int> trenPengeluaran(int jenis, DateTime awal, DateTime akhir) {
    List<DateTime> slot = slotTren(jenis, awal, akhir);
    return [
      for (int i = 0; i < slot.length; i++)
        pengeluaranAntara(slot[i], i + 1 < slot.length ? slot[i + 1] : akhir),
    ];
  }

  static int pemasukanBulan(DateTime bulan) {
    return pemasukanAntara(
      DateTime(bulan.year, bulan.month),
      DateTime(bulan.year, bulan.month + 1),
    );
  }

  static int pengeluaranBulan(DateTime bulan) {
    return pengeluaranAntara(
      DateTime(bulan.year, bulan.month),
      DateTime(bulan.year, bulan.month + 1),
    );
  }

  static int get totalPemasukan => pemasukanBulan(DateTime.now());

  static int get totalPengeluaran => pengeluaranBulan(DateTime.now());

  // Saldo dihitung dari semua bulan, bukan hanya bulan berjalan.
  static int get saldoTersedia {
    int saldo = saldoAwal;
    for (var t in daftarTransaksi) {
      if (t.isPemasukan) {
        saldo += t.nominal;
      } else if (!t.isTransfer) {
        saldo -= t.nominal;
      }
    }
    return saldo;
  }

  // Transfer mengurangi dompet asal dan menambah dompet tujuan, jadi total semua dompet tetap sama.
  static int saldoSumber(String sumber) {
    int saldo = sumber == 'Kantong Utama' ? saldoAwal : 0;
    for (var t in daftarTransaksi) {
      if (t.isTransfer && t.sumberTujuan == sumber) saldo += t.nominal;
      if (t.sumberDana != sumber) continue;
      if (t.isPemasukan) {
        saldo += t.nominal;
      } else {
        saldo -= t.nominal;
      }
    }
    return saldo;
  }

  // Budget 'Tabungan' dihitung dari transfer ke dompet Tabungan, kategori lain dari pengeluaran.
  static int terpakaiBudget(String kategori, DateTime bulan) {
    int total = 0;
    for (var t in daftarTransaksi) {
      if (!_bulanSama(t.tanggal, bulan)) continue;
      bool cocok = kategori == 'Tabungan'
          ? t.isTransfer && t.sumberTujuan == 'Tabungan'
          : !t.isPemasukan && !t.isTransfer && t.kategori == kategori;
      if (cocok) total += t.nominal;
    }
    return total;
  }

  // Uang yang ditabung juga diambil dari anggaran bulanan.
  static int terpakaiAnggaran(DateTime bulan) {
    return pengeluaranBulan(bulan) + terpakaiBudget('Tabungan', bulan);
  }

  static int totalLimitBudget() {
    int total = 0;
    for (var b in daftarBudget) {
      total += b.limit;
    }
    return total;
  }

  // Tabungan bukan kategori, jadi warnanya ditulis di sini.
  static const int indeksWarnaTabungan = 0;

  // Indeks ke WarnaApp.paletKategori. Nama yang tidak ditemukan memakai 7 (abu).
  static int indeksWarnaKategori(String nama) {
    if (nama == 'Tabungan') return indeksWarnaTabungan;
    // Pengeluaran dicari dulu karena nama seperti 'Hadiah' ada di kedua tipe.
    for (var k in kategoriTipe(0) + kategoriTipe(1)) {
      if (k.nama == nama) return k.indeksWarna;
    }
    return 7;
  }

  // Ditelusuri sesuai urutan grid 2 kolom, supaya kartu Kantong tidak sewarna dengan tetangga kiri atau atasnya.
  static Map<String, int> petaWarnaAnggaran() {
    Map<String, int> peta = {};
    List<int> perPosisi = [];
    for (int i = 0; i < daftarBudget.length; i++) {
      // indeksWarnaKategori sudah mengembalikan indeksWarnaTabungan untuk 'Tabungan'.
      int indeks = indeksWarnaKategori(daftarBudget[i].kategori);
      int? kiri = i % 2 == 1 ? perPosisi[i - 1] : null;
      int? atas = i >= 2 ? perPosisi[i - 2] : null;
      if (indeks == kiri || indeks == atas) {
        indeks = _warnaPengganti(kiri, atas, perPosisi);
      }
      perPosisi.add(indeks);
      peta[daftarBudget[i].kategori] = indeks;
    }
    return peta;
  }

  // Indeks 0-6 pertama yang bukan milik tetangga. Yang belum dipakai kartu lain didahulukan.
  static int _warnaPengganti(int? kiri, int? atas, List<int> terpakai) {
    int? cadangan;
    for (int i = 0; i < 7; i++) {
      if (i == kiri || i == atas) continue;
      if (!terpakai.contains(i)) return i;
      cadangan ??= i;
    }
    return cadangan!;
  }

  static int indeksWarnaImpian(String nama) {
    for (var k in kategoriImpian) {
      if (k.nama == nama) return k.indeksWarna;
    }
    return 7;
  }

  // Kategori baru mendapat warna bergiliran 0 sampai 6. Indeks 7 khusus 'Lainnya'.
  static int indeksWarnaBerikutnya(bool pemasukan) {
    return kategoriTipe(pemasukan ? 1 : 0).length % 7;
  }

  static IconData ikonKategori(String nama) {
    if (nama == 'Tabungan') return LucideIcons.piggyBank;
    if (nama == 'Pelunasan') return LucideIcons.handCoins;
    // Pengeluaran dicari dulu karena nama seperti 'Hadiah' ada di kedua tipe.
    for (var k in kategoriTipe(0) + kategoriTipe(1)) {
      if (k.nama == nama) return k.ikon;
    }
    return LucideIcons.wallet;
  }

  static void hapusTransaksi(CatatanTransaksi item) {
    daftarTransaksi.remove(item);
    refreshNotifier.value++;
  }

  static void ubahAnggaran(int nominal) {
    anggaranBulanan = nominal;
    refreshNotifier.value++;
  }

  static void tambahBudget(BudgetItem item) {
    daftarBudget.add(item);
    refreshNotifier.value++;
  }

  static void ubahLimitBudget(BudgetItem item, int limit) {
    item.limit = limit;
    refreshNotifier.value++;
  }

  static void hapusBudget(BudgetItem item) {
    daftarBudget.remove(item);
    refreshNotifier.value++;
  }
}
