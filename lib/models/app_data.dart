import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'budget.dart';
import 'kategori.dart';
import 'transaksi.dart';
import 'utang.dart';
import 'wishlist.dart';

class AppData {
  static final ValueNotifier<int> refreshNotifier = ValueNotifier<int>(0);
  static final ValueNotifier<int> tabAktif = ValueNotifier<int>(0);
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

  static DateTime _bulanLalu(int tanggal) {
    DateTime sekarang = DateTime.now();
    return DateTime(sekarang.year, sekarang.month - 1, tanggal);
  }

  static final List<String> daftarSumberDana = [
    'Kantong Utama',
    'Rekening Bank',
    'Saku QRIS',
    'Dompet Tunai',
  ];

  static final List<KategoriItem> daftarKategori = [
    KategoriItem(
      nama: 'Makan',
      ikon: LucideIcons.utensils,
      warna: const Color(0xFF10B981),
    ),
    KategoriItem(
      nama: 'Bensin',
      ikon: LucideIcons.fuel,
      warna: const Color(0xFFF59E0B),
    ),
    KategoriItem(
      nama: 'Belanja',
      ikon: LucideIcons.shoppingBag,
      warna: const Color(0xFF3B82F6),
    ),
    KategoriItem(
      nama: 'Tagihan',
      ikon: LucideIcons.receiptText,
      warna: const Color(0xFFEF4444),
    ),
    KategoriItem(
      nama: 'Hiburan',
      ikon: LucideIcons.clapperboard,
      warna: const Color(0xFF8B5CF6),
    ),
    KategoriItem(
      nama: 'Kopi',
      ikon: LucideIcons.coffee,
      warna: const Color(0xFF92400E),
    ),
    KategoriItem(
      nama: 'Kesehatan',
      ikon: LucideIcons.stethoscope,
      warna: const Color(0xFFEC4899),
    ),
    KategoriItem(
      nama: 'Pendidikan',
      ikon: LucideIcons.bookOpen,
      warna: const Color(0xFF6366F1),
    ),
    KategoriItem(
      nama: 'Transportasi',
      ikon: LucideIcons.bus,
      warna: const Color(0xFF14B8A6),
    ),
    KategoriItem(
      nama: 'Pakaian',
      ikon: LucideIcons.shirt,
      warna: const Color(0xFFF97316),
    ),
    KategoriItem(
      nama: 'Elektronik',
      ikon: LucideIcons.monitorSmartphone,
      warna: const Color(0xFF64748B),
    ),
    KategoriItem(
      nama: 'Rumah',
      ikon: LucideIcons.house,
      warna: const Color(0xFF0EA5E9),
    ),
    KategoriItem(
      nama: 'Gaji',
      ikon: LucideIcons.banknote,
      warna: const Color(0xFF10B981),
      isPemasukan: true,
    ),
    KategoriItem(
      nama: 'Freelance',
      ikon: LucideIcons.laptop,
      warna: const Color(0xFF0D9488),
      isPemasukan: true,
    ),
    KategoriItem(
      nama: 'Bonus',
      ikon: LucideIcons.award,
      warna: const Color(0xFFF59E0B),
      isPemasukan: true,
    ),
    KategoriItem(
      nama: 'Investasi',
      ikon: LucideIcons.trendingUp,
      warna: const Color(0xFF3B82F6),
      isPemasukan: true,
    ),
    KategoriItem(
      nama: 'Transfer Bank',
      ikon: LucideIcons.landmark,
      warna: const Color(0xFF2563EB),
      isTransfer: true,
    ),
    KategoriItem(
      nama: 'Top Up E-Wallet',
      ikon: LucideIcons.wallet,
      warna: const Color(0xFF0D9488),
      isTransfer: true,
    ),
    KategoriItem(
      nama: 'Tarik Tunai ATM',
      ikon: LucideIcons.handCoins,
      warna: const Color(0xFF475569),
      isTransfer: true,
    ),
    KategoriItem(
      nama: 'Antar Kantong',
      ikon: LucideIcons.arrowLeftRight,
      warna: const Color(0xFF14532D),
      isTransfer: true,
    ),
    KategoriItem(
      nama: 'Setor Tabungan',
      ikon: LucideIcons.piggyBank,
      warna: const Color(0xFF059669),
      isTransfer: true,
    ),
    KategoriItem(
      nama: 'Bayar Kartu',
      ikon: LucideIcons.creditCard,
      warna: const Color(0xFF7C3AED),
      isTransfer: true,
    ),
  ];

  static final List<IconData> opsiIkonKategori = [
    LucideIcons.utensils,
    LucideIcons.coffee,
    LucideIcons.gamepad2,
    LucideIcons.clapperboard,
    LucideIcons.dumbbell,
    LucideIcons.pawPrint,
    LucideIcons.shoppingBag,
    LucideIcons.landmark,
  ];

  static final List<CatatanTransaksi> daftarTransaksi = [
    CatatanTransaksi(
      kategori: 'Kopi',
      catatan: 'Kopi Kenangan & Roti',
      nominal: 35000,
      ikon: LucideIcons.coffee,
      warna: const Color(0xFF92400E),
      tanggal: _bulanIni(0),
      sumberDana: 'Saku QRIS',
    ),
    CatatanTransaksi(
      kategori: 'Bensin',
      catatan: 'Pertamax Full Tank',
      nominal: 100000,
      ikon: LucideIcons.fuel,
      warna: const Color(0xFFF59E0B),
      tanggal: _bulanIni(0),
      sumberDana: 'Rekening Bank',
    ),
    CatatanTransaksi(
      kategori: 'Belanja',
      catatan: 'Kebutuhan Harian Kos',
      nominal: 136000,
      ikon: LucideIcons.shoppingBag,
      warna: const Color(0xFF3B82F6),
      tanggal: _bulanIni(0),
    ),
    CatatanTransaksi(
      kategori: 'Freelance',
      catatan: 'Proyek Desain Web',
      nominal: 750000,
      ikon: LucideIcons.laptop,
      warna: const Color(0xFF0D9488),
      tanggal: _bulanIni(1),
      isPemasukan: true,
      sumberDana: 'Rekening Bank',
    ),
    CatatanTransaksi(
      kategori: 'Makan',
      catatan: 'Makan Malam Bersama',
      nominal: 45000,
      ikon: LucideIcons.utensils,
      warna: const Color(0xFF10B981),
      tanggal: _bulanIni(1),
    ),
    CatatanTransaksi(
      kategori: 'Makan',
      catatan: 'Nasi Padang',
      nominal: 28000,
      ikon: LucideIcons.utensils,
      warna: const Color(0xFF10B981),
      tanggal: _bulanIni(3),
      sumberDana: 'Dompet Tunai',
    ),
    CatatanTransaksi(
      kategori: 'Tagihan',
      catatan: 'Token Listrik',
      nominal: 350000,
      ikon: LucideIcons.receiptText,
      warna: const Color(0xFFEF4444),
      tanggal: _bulanIni(5),
      sumberDana: 'Rekening Bank',
    ),
    CatatanTransaksi(
      kategori: 'Tagihan',
      catatan: 'Paket Internet',
      nominal: 120000,
      ikon: LucideIcons.receiptText,
      warna: const Color(0xFFEF4444),
      tanggal: _bulanIni(6),
      sumberDana: 'Saku QRIS',
    ),
    CatatanTransaksi(
      kategori: 'Bensin',
      catatan: 'Pertalite',
      nominal: 50000,
      ikon: LucideIcons.fuel,
      warna: const Color(0xFFF59E0B),
      tanggal: _bulanIni(8),
      sumberDana: 'Dompet Tunai',
    ),
    CatatanTransaksi(
      kategori: 'Setor Tabungan',
      catatan: 'Tabungan Bulanan',
      nominal: 500000,
      ikon: LucideIcons.piggyBank,
      warna: const Color(0xFF059669),
      tanggal: _bulanIni(10),
      isTransfer: true,
      sumberDana: 'Rekening Bank',
    ),
    CatatanTransaksi(
      kategori: 'Gaji',
      catatan: 'Gaji Bulanan',
      nominal: 4500000,
      ikon: LucideIcons.banknote,
      warna: const Color(0xFF10B981),
      tanggal: _bulanIni(12),
      isPemasukan: true,
      sumberDana: 'Rekening Bank',
    ),
    CatatanTransaksi(
      kategori: 'Makan',
      catatan: 'Makan Siang Kampus',
      nominal: 62000,
      ikon: LucideIcons.utensils,
      warna: const Color(0xFF10B981),
      tanggal: _bulanIni(14),
    ),
    CatatanTransaksi(
      kategori: 'Hiburan',
      catatan: 'Nonton Bioskop',
      nominal: 60000,
      ikon: LucideIcons.clapperboard,
      warna: const Color(0xFF8B5CF6),
      tanggal: _bulanLalu(24),
      sumberDana: 'Saku QRIS',
    ),
    CatatanTransaksi(
      kategori: 'Bensin',
      catatan: 'Pertamax',
      nominal: 100000,
      ikon: LucideIcons.fuel,
      warna: const Color(0xFFF59E0B),
      tanggal: _bulanLalu(18),
      sumberDana: 'Dompet Tunai',
    ),
    CatatanTransaksi(
      kategori: 'Makan',
      catatan: 'Makan Bersama Keluarga',
      nominal: 75000,
      ikon: LucideIcons.utensils,
      warna: const Color(0xFF10B981),
      tanggal: _bulanLalu(12),
    ),
    CatatanTransaksi(
      kategori: 'Tagihan',
      catatan: 'Bayar Kos',
      nominal: 450000,
      ikon: LucideIcons.receiptText,
      warna: const Color(0xFFEF4444),
      tanggal: _bulanLalu(5),
      sumberDana: 'Rekening Bank',
    ),
    CatatanTransaksi(
      kategori: 'Gaji',
      catatan: 'Gaji Bulanan',
      nominal: 4500000,
      ikon: LucideIcons.banknote,
      warna: const Color(0xFF10B981),
      tanggal: _bulanLalu(1),
      isPemasukan: true,
      sumberDana: 'Rekening Bank',
    ),
  ];

  static final List<WishlistItem> daftarWishlist = [
    WishlistItem(
      nama: 'Sony PlayStation 5 Slim',
      mataUang: 'USD',
      hargaAsing: 499,
      targetIdr: 7811346,
      terkumpulIdr: 5200000,
      ikon: LucideIcons.gamepad2,
    ),
    WishlistItem(
      nama: 'Tiket Konser Luar Negeri',
      mataUang: 'JPY',
      hargaAsing: 35000,
      targetIdr: 3640000,
      terkumpulIdr: 2800000,
      ikon: LucideIcons.ticket,
    ),
    WishlistItem(
      nama: 'Mechanical Keyboard Keychron Q1',
      mataUang: 'USD',
      hargaAsing: 190,
      targetIdr: 2974260,
      terkumpulIdr: 2974260,
      ikon: LucideIcons.keyboard,
    ),
  ];

  static final List<BudgetItem> daftarBudget = [
    BudgetItem(kategori: 'Makan', limit: 1800000),
    BudgetItem(kategori: 'Bensin', limit: 600000),
    BudgetItem(kategori: 'Tagihan', limit: 1200000),
    BudgetItem(kategori: 'Setor Tabungan', limit: 1000000),
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

  static final Map<String, int> kursCadangan = {
    'USD': 15654,
    'SGD': 11642,
    'JPY': 104,
    'EUR': 16950,
  };

  // Diawali kurs cadangan, lalu ditimpa hasil API saat berhasil.
  static final Map<String, int> kursKeIdr = Map.of(kursCadangan);
  static String infoKurs = 'Kurs cadangan';
  static bool kursLive = false;
  // Tetap true walau refresh berikutnya gagal, supaya tahu kursKeIdr berisi hasil API.
  static bool kursPernahLive = false;

  static const String contohSaranAi =
      'Pengeluaran terbesarmu bulan ini ada di Tagihan, jadi coba cek lagi paket internet yang mungkin bisa diganti lebih murah. '
      'Uang jajan kopi dan makan di luar juga lumayan, kalau dikurangi sedikit tiap minggu sisanya bisa langsung masuk ke tabungan PlayStation 5 Slim. '
      'Targetnya sudah lewat setengah jalan, tinggal konsisten beberapa bulan lagi.';

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

  // tipe: 0 = Pengeluaran, 1 = Pemasukan, 2 = Transfer, sama dengan urutan PilihanSegmen.
  static List<KategoriItem> kategoriTipe(int tipe) {
    return daftarKategori.where((k) {
      if (tipe == 1) return k.isPemasukan;
      if (tipe == 2) return k.isTransfer;
      return !k.isPemasukan && !k.isTransfer;
    }).toList();
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

  // Budget ikut dihapus supaya tidak ada budget tanpa kategori.
  static void hapusKategori(KategoriItem item) {
    daftarKategori.remove(item);
    daftarBudget.removeWhere((b) => b.kategori == item.nama);
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

  // Dipusatkan di sini supaya Beranda dan Wishlist memakai kurs yang sama.
  static Future<void> perbaruiKurs() async {
    try {
      final kurs = await ApiService().getKursIdr();
      for (String kode in kursKeIdr.keys.toList()) {
        int nilai = kurs.keRupiah(kode);
        if (nilai > 0) kursKeIdr[kode] = nilai;
      }
      kursLive = true;
      kursPernahLive = true;
      infoKurs =
          'Kurs live · diperbarui ${formatTanggalPendek(DateTime.now())}';
    } catch (_) {
      kursLive = false;
      infoKurs = kursPernahLive
          ? 'Gagal memperbarui, memakai kurs terakhir'
          : 'Gagal ambil kurs, memakai kurs cadangan';
    }
    refreshNotifier.value++;
  }

  static void tambahUtang(UtangItem item) {
    daftarUtang.insert(0, item);
    refreshNotifier.value++;
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
        warna: WarnaApp.teksUtama,
        tanggal: DateTime.now(),
        isPemasukan: piutang,
        sumberDana: 'Kantong Utama',
      ),
    );
  }

  // Hasil 0 berarti budget 'Setor Tabungan' belum ada, jadi estimasi tidak bisa dihitung.
  static int estimasiBulanWishlist(WishlistItem item) {
    int limit = 0;
    for (var b in daftarBudget) {
      if (b.kategori == 'Setor Tabungan') limit = b.limit;
    }
    if (limit <= 0) return 0;
    int sisa = item.targetIdr - item.terkumpulIdr;
    // Dibulatkan ke atas: sisa 1,2 bulan tetap dihitung 2 bulan.
    return (sisa / limit).ceil();
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

  static bool punyaTransaksi(DateTime bulan) {
    for (var t in daftarTransaksi) {
      if (_bulanSama(t.tanggal, bulan)) return true;
    }
    return false;
  }

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

  static int pemasukanBulan(DateTime bulan) {
    int total = 0;
    for (var t in daftarTransaksi) {
      if (t.isPemasukan && _bulanSama(t.tanggal, bulan)) total += t.nominal;
    }
    return total;
  }

  static int pengeluaranBulan(DateTime bulan) {
    int total = 0;
    for (var t in daftarTransaksi) {
      bool pengeluaran = !t.isPemasukan && !t.isTransfer;
      if (pengeluaran && _bulanSama(t.tanggal, bulan)) total += t.nominal;
    }
    return total;
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

  // Transfer tidak dihitung karena transaksi tidak mencatat sumber tujuannya.
  static int saldoSumber(String sumber) {
    int saldo = sumber == 'Kantong Utama' ? saldoAwal : 0;
    for (var t in daftarTransaksi) {
      if (t.sumberDana != sumber) continue;
      if (t.isPemasukan) {
        saldo += t.nominal;
      } else if (!t.isTransfer) {
        saldo -= t.nominal;
      }
    }
    return saldo;
  }

  // Transfer ikut dihitung supaya budget 'Setor Tabungan' terisi.
  static int terpakaiBudget(String kategori, DateTime bulan) {
    int total = 0;
    for (var t in daftarTransaksi) {
      bool cocok = !t.isPemasukan && t.kategori == kategori;
      if (cocok && _bulanSama(t.tanggal, bulan)) total += t.nominal;
    }
    return total;
  }

  // Uang yang ditabung juga diambil dari anggaran bulanan.
  static int terpakaiAnggaran(DateTime bulan) {
    return pengeluaranBulan(bulan) + terpakaiBudget('Setor Tabungan', bulan);
  }

  static int totalLimitBudget() {
    int total = 0;
    for (var b in daftarBudget) {
      total += b.limit;
    }
    return total;
  }

  static IconData ikonKategori(String nama) {
    for (var k in daftarKategori) {
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
