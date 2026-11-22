import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../services/api_service.dart';
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
    'Tabungan',
  ];

  static final List<KategoriItem> daftarKategori = [
    KategoriItem(nama: 'Makan', ikon: LucideIcons.utensils),
    KategoriItem(nama: 'Jajan', ikon: LucideIcons.cookie),
    KategoriItem(nama: 'Kopi', ikon: LucideIcons.coffee),
    KategoriItem(nama: 'Belanja Harian', ikon: LucideIcons.shoppingCart),
    KategoriItem(nama: 'Belanja', ikon: LucideIcons.shoppingBag),
    KategoriItem(nama: 'Transportasi', ikon: LucideIcons.bus),
    KategoriItem(nama: 'Bensin', ikon: LucideIcons.fuel),
    KategoriItem(nama: 'Ojek Online', ikon: LucideIcons.bike),
    KategoriItem(nama: 'Parkir', ikon: LucideIcons.circleParking),
    KategoriItem(nama: 'Tagihan', ikon: LucideIcons.receiptText),
    KategoriItem(nama: 'Listrik', ikon: LucideIcons.zap),
    KategoriItem(nama: 'Air', ikon: LucideIcons.droplet),
    KategoriItem(nama: 'Internet', ikon: LucideIcons.wifi),
    KategoriItem(nama: 'Pulsa & Data', ikon: LucideIcons.smartphone),
    KategoriItem(nama: 'Rumah', ikon: LucideIcons.house),
    KategoriItem(nama: 'Kos & Sewa', ikon: LucideIcons.keyRound),
    KategoriItem(nama: 'Kesehatan', ikon: LucideIcons.stethoscope),
    KategoriItem(nama: 'Obat', ikon: LucideIcons.pill),
    KategoriItem(nama: 'Olahraga', ikon: LucideIcons.dumbbell),
    KategoriItem(nama: 'Perawatan Diri', ikon: LucideIcons.sparkles),
    KategoriItem(nama: 'Pakaian', ikon: LucideIcons.shirt),
    KategoriItem(nama: 'Pendidikan', ikon: LucideIcons.bookOpen),
    KategoriItem(nama: 'Kursus', ikon: LucideIcons.graduationCap),
    KategoriItem(nama: 'Hiburan', ikon: LucideIcons.clapperboard),
    KategoriItem(nama: 'Game', ikon: LucideIcons.gamepad2),
    KategoriItem(nama: 'Langganan', ikon: LucideIcons.tv),
    KategoriItem(nama: 'Liburan', ikon: LucideIcons.plane),
    KategoriItem(nama: 'Hadiah', ikon: LucideIcons.gift),
    KategoriItem(nama: 'Donasi', ikon: LucideIcons.heartHandshake),
    KategoriItem(nama: 'Kondangan', ikon: LucideIcons.partyPopper),
    KategoriItem(nama: 'Hewan Peliharaan', ikon: LucideIcons.pawPrint),
    KategoriItem(nama: 'Anak', ikon: LucideIcons.baby),
    KategoriItem(nama: 'Elektronik', ikon: LucideIcons.monitorSmartphone),
    KategoriItem(nama: 'Servis', ikon: LucideIcons.wrench),
    KategoriItem(nama: 'Pajak', ikon: LucideIcons.landmark),
    KategoriItem(nama: 'Asuransi', ikon: LucideIcons.shieldCheck),
    KategoriItem(nama: 'Lainnya', ikon: LucideIcons.ellipsis),
    KategoriItem(nama: 'Gaji', ikon: LucideIcons.banknote, isPemasukan: true),
    KategoriItem(
      nama: 'Freelance',
      ikon: LucideIcons.laptop,
      isPemasukan: true,
    ),
    KategoriItem(nama: 'Bonus', ikon: LucideIcons.award, isPemasukan: true),
    KategoriItem(
      nama: 'Uang Saku',
      ikon: LucideIcons.wallet,
      isPemasukan: true,
    ),
    KategoriItem(nama: 'Penjualan', ikon: LucideIcons.store, isPemasukan: true),
    KategoriItem(
      nama: 'Investasi',
      ikon: LucideIcons.trendingUp,
      isPemasukan: true,
    ),
    KategoriItem(nama: 'Bunga', ikon: LucideIcons.percent, isPemasukan: true),
    KategoriItem(
      nama: 'Refund',
      ikon: LucideIcons.rotateCcw,
      isPemasukan: true,
    ),
    KategoriItem(nama: 'Hadiah', ikon: LucideIcons.gift, isPemasukan: true),
    KategoriItem(
      nama: 'Lainnya',
      ikon: LucideIcons.ellipsis,
      isPemasukan: true,
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
      kategori: 'Freelance',
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
      catatan: 'Top Up Saku QRIS',
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
    BudgetItem(kategori: 'Tabungan', limit: 1000000),
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

  static IconData ikonKategori(String nama) {
    if (nama == 'Tabungan') return LucideIcons.piggyBank;
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
