import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../services/api_service.dart';
import '../services/db_service.dart';
import '../utils/format.dart';
import '../utils/periode.dart';
import 'bagian_teman.dart';
import 'budget.dart';
import 'data_contoh.dart';
import 'dompet.dart';
import 'kategori.dart';
import 'mata_uang.dart';
import 'pesan_ai.dart';
import 'transaksi.dart';
import 'utang.dart';
import 'wishlist.dart';

class AppData {
  static final ValueNotifier<int> refreshNotifier = ValueNotifier<int>(0);
  static final ValueNotifier<int> tabAktif = ValueNotifier<int>(0);
  // Diisi "Lihat semua" di Beranda, lalu dibaca sekali oleh tab Transaksi saat dibuka.
  static bool gulirKeDaftar = false;
  // Sama seperti gulirKeDaftar, tapi untuk kartu Impianku di tab Impian.
  static bool gulirKeImpian = false;
  static DateTime bulanDipilih = DateTime.now();

  static int anggaranBulanan = 5000000;

  static final List<Dompet> daftarDompet = contohDompet();

  static List<String> get daftarSumberDana => [
    for (var d in daftarDompet) d.nama,
  ];

  static final List<KategoriItem> daftarKategori = contohKategori();

  // Diambil dari daftarIkonKategori supaya ikon pilihan pasti punya nomor urut di database.
  static final List<IconData> opsiIkonKategori = daftarIkonKategori.sublist(
    0,
    16,
  );

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
  static final List<String> namaKhusus = ['Tabungan', 'Pindah', 'Pelunasan'];

  static final List<CatatanTransaksi> daftarTransaksi = contohTransaksi();

  static final List<WishlistItem> daftarWishlist = contohWishlist();

  static final List<BudgetItem> daftarBudget = contohBudget();

  static final List<UtangItem> daftarUtang = contohUtang();

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

  // Bawaan sebelum pengguna memilih sendiri. Pilihannya disimpan di tabel pengaturan.
  static List<String> mataUangFavorit = ['USD', 'SGD', 'JPY'];

  // Diawali kurs cadangan, lalu ditimpa hasil API saat berhasil.
  static final Map<String, double> kursKeIdr = Map.of(kursCadangan);
  static DateTime? kursDiperbarui;
  static bool kursLive = false;
  // Tetap true walau refresh berikutnya gagal, supaya tahu kursKeIdr berisi hasil API.
  static bool kursPernahLive = false;

  static final List<PesanAi> percakapanAi = [];
  // Hanya pertanyaan siap pakai, tanpa ketik bebas, supaya kuota Gemini hemat.
  static const List<String> daftarPertanyaanAi = [
    'Ringkas bulan ini',
    'Di mana bisa hemat?',
    'Cukup sampai akhir bulan?',
  ];

  // Dipanggil sekali di main(): isi database disalin ke list, jadi tampilan tetap membaca AppData.
  static Future<void> muat() async {
    daftarDompet.clear();
    for (var m in await DbService.ambilSemua('dompet')) {
      daftarDompet.add(Dompet.fromMap(m));
    }
    daftarKategori.clear();
    for (var m in await DbService.ambilSemua('kategori')) {
      daftarKategori.add(KategoriItem.fromMap(m));
    }
    daftarBudget.clear();
    for (var m in await DbService.ambilSemua('kantong')) {
      daftarBudget.add(BudgetItem.fromMap(m));
    }
    // Tiga list ini menaruh data baru di depan, jadi id terbesar dimuat lebih dulu.
    daftarTransaksi.clear();
    for (var m in await DbService.ambilSemua('transaksi', terbaruDulu: true)) {
      daftarTransaksi.add(CatatanTransaksi.fromMap(m));
    }
    daftarWishlist.clear();
    for (var m in await DbService.ambilSemua('impian', terbaruDulu: true)) {
      daftarWishlist.add(WishlistItem.fromMap(m, ikonImpian(m['kategori'])));
    }
    daftarUtang.clear();
    for (var m in await DbService.ambilSemua('utang', terbaruDulu: true)) {
      daftarUtang.add(UtangItem.fromMap(m));
    }
    percakapanAi.clear();
    for (var m in await DbService.ambilSemua('pesan_ai')) {
      percakapanAi.add(PesanAi.fromMap(m));
    }
    await _muatPengaturan();
    refreshNotifier.value++;
  }

  // Kunci yang belum pernah disimpan dilewati, jadi nilai bawaan di atas tetap dipakai.
  static Future<void> _muatPengaturan() async {
    Map<String, String> pengaturan = await DbService.ambilPengaturan();
    String? anggaran = pengaturan['anggaran_bulanan'];
    if (anggaran != null) anggaranBulanan = int.parse(anggaran);
    String? favorit = pengaturan['mata_uang_favorit'];
    if (favorit != null) mataUangFavorit = favorit.split(',');
    String? kurs = pengaturan['kurs_ke_idr'];
    String? waktuKurs = pengaturan['kurs_diperbarui'];
    if (kurs != null && waktuKurs != null) {
      // Kurs terakhir dari API, supaya tetap tampil saat offline.
      Map<String, dynamic> tersimpan = jsonDecode(kurs);
      tersimpan.forEach((kode, nilai) {
        kursKeIdr[kode] = (nilai as num).toDouble();
      });
      kursDiperbarui = DateTime.parse(waktuKurs);
      kursPernahLive = true;
    }
  }

  static Future<void> tambahTransaksi(CatatanTransaksi item) async {
    daftarTransaksi.insert(0, item);
    refreshNotifier.value++;
    item.id = await DbService.tambah('transaksi', item.toMap());
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

  static Future<void> tambahKategori(KategoriItem item) async {
    daftarKategori.add(item);
    refreshNotifier.value++;
    item.id = await DbService.tambah('kategori', item.toMap());
  }

  static Future<void> ubahTransaksi(
    CatatanTransaksi lama,
    CatatanTransaksi baru,
  ) async {
    int posisi = daftarTransaksi.indexOf(lama);
    if (posisi == -1) return;
    // Objek baru dibuat di layar tanpa id, jadi id lama dipindahkan supaya baris yang sama yang diubah.
    baru.id = lama.id;
    daftarTransaksi[posisi] = baru;
    refreshNotifier.value++;
    await DbService.ubah('transaksi', baru.toMap());
  }

  // Budget ikut dihapus supaya tidak ada budget tanpa kategori. Budget hanya ada untuk pengeluaran.
  static Future<void> hapusKategori(KategoriItem item) async {
    daftarKategori.remove(item);
    List<BudgetItem> ikutDihapus = item.isPemasukan
        ? []
        : daftarBudget.where((b) => b.kategori == item.nama).toList();
    for (var b in ikutDihapus) {
      daftarBudget.remove(b);
    }
    refreshNotifier.value++;
    await DbService.hapus('kategori', item.id);
    for (var b in ikutDihapus) {
      await DbService.hapus('kantong', b.id);
    }
  }

  static Future<void> tambahWishlist(WishlistItem item) async {
    daftarWishlist.insert(0, item);
    refreshNotifier.value++;
    item.id = await DbService.tambah('impian', item.toMap());
  }

  // Uang tabungan dipindah ke dompet Tabungan supaya ikut terhitung di budget Tabungan.
  static int tambahTabunganWishlist(WishlistItem item, int nominal) {
    int sisa = item.targetIdr - item.terkumpulIdr;
    int disimpan = nominal > sisa ? sisa : nominal;
    item.terkumpulIdr += disimpan;
    tambahTransaksi(
      CatatanTransaksi(
        kategori: 'Pindah',
        catatan: 'Nabung untuk ${item.nama}',
        nominal: disimpan,
        ikon: LucideIcons.arrowLeftRight,
        tanggal: DateTime.now(),
        isTransfer: true,
        sumberDana: 'Utama',
        sumberTujuan: 'Tabungan',
      ),
    );
    // Tidak ditunggu karena layar butuh nilai disimpan sekarang. Urutan tulis tetap dijaga sqflite.
    DbService.ubah('impian', item.toMap());
    return disimpan;
  }

  static Future<void> hapusWishlist(WishlistItem item) async {
    daftarWishlist.remove(item);
    refreshNotifier.value++;
    await DbService.hapus('impian', item.id);
  }

  static MataUang cariMataUang(String kode) {
    if (kode == 'IDR') return rupiah;
    return daftarMataUang.firstWhere((m) => m.kode == kode);
  }

  static bool kursAda(String kode) {
    if (kode == 'IDR') return true;
    return (kursKeIdr[kode] ?? 0) > 0;
  }

  static Future<void> simpanFavorit(List<String> daftar) async {
    mataUangFavorit = daftar;
    refreshNotifier.value++;
    await DbService.simpanPengaturan('mata_uang_favorit', daftar.join(','));
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
    // Hanya kurs dari API yang disimpan. Kurs cadangan tidak perlu disimpan karena sudah ada di kode.
    if (kursLive) {
      await DbService.simpanPengaturan('kurs_ke_idr', jsonEncode(kursKeIdr));
      await DbService.simpanPengaturan(
        'kurs_diperbarui',
        kursDiperbarui!.toIso8601String(),
      );
    }
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

  static Future<void> tambahUtang(UtangItem item) async {
    daftarUtang.insert(0, item);
    refreshNotifier.value++;
    item.id = await DbService.tambah('utang', item.toMap());
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
  static Future<void> lunasiUtang(UtangItem item) async {
    item.lunas = true;
    bool piutang = item.jenis == 'Piutang';
    // tambahTransaksi menyegarkan tampilan sebelum menunggu database, jadi status lunas langsung terlihat.
    await tambahTransaksi(
      CatatanTransaksi(
        kategori: 'Pelunasan',
        catatan: piutang
            ? 'Pelunasan dari ${item.nama}'
            : 'Bayar utang ke ${item.nama}',
        nominal: item.nominal,
        ikon: LucideIcons.handCoins,
        tanggal: DateTime.now(),
        isPemasukan: piutang,
        sumberDana: 'Utama',
      ),
    );
    await DbService.ubah('utang', item.toMap());
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

  static String? get saranTerakhir {
    for (var pesan in percakapanAi.reversed) {
      if (!pesan.dariPengguna) return pesan.teks;
    }
    return null;
  }

  static Future<void> tanyaBendahara(String pertanyaan, DateTime bulan) async {
    // Saat "Coba lagi", pertanyaan yang belum terjawab tidak ditulis dua kali.
    bool belumDijawab =
        percakapanAi.isNotEmpty &&
        percakapanAi.last.dariPengguna &&
        percakapanAi.last.teks == pertanyaan;
    if (!belumDijawab) {
      percakapanAi.add(
        PesanAi(dariPengguna: true, teks: pertanyaan, waktu: DateTime.now()),
      );
    }
    String jawaban = await mintaSaranAi(bulan, pertanyaan);
    PesanAi tanya = percakapanAi.last;
    PesanAi balasan = PesanAi(
      dariPengguna: false,
      teks: jawaban,
      waktu: DateTime.now(),
    );
    percakapanAi.add(balasan);
    refreshNotifier.value++;
    // Pertanyaan baru disimpan setelah dijawab, supaya percakapan tersimpan tidak berakhir dengan pertanyaan tanpa jawaban.
    tanya.id = await DbService.tambah('pesan_ai', tanya.toMap());
    balasan.id = await DbService.tambah('pesan_ai', balasan.toMap());
  }

  // Isinya akan diganti panggilan Gemini dengan rekapUntukAi(bulan) sebagai bahan.
  static Future<String> mintaSaranAi(DateTime bulan, String pertanyaan) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    DateTime awal = DateTime(bulan.year, bulan.month);
    DateTime akhir = DateTime(bulan.year, bulan.month + 1);
    String teksBulan = '${namaBulanPanjang[bulan.month - 1]} ${bulan.year}';
    if (pertanyaan == daftarPertanyaanAi[0]) {
      return _jawabRingkas(awal, akhir, teksBulan);
    }
    if (pertanyaan == daftarPertanyaanAi[1]) {
      return _jawabHemat(awal, akhir, teksBulan);
    }
    if (pertanyaan == daftarPertanyaanAi[2]) {
      return _jawabCukup(bulan, teksBulan);
    }
    throw ArgumentError('Pertanyaan tidak dikenal: $pertanyaan');
  }

  // Angka jawaban dummy diambil dari sumber yang sama dengan rekapUntukAi.
  static String _jawabRingkas(DateTime awal, DateTime akhir, String teksBulan) {
    int masuk = pemasukanAntara(awal, akhir);
    int keluar = pengeluaranAntara(awal, akhir);
    int selisih = masuk - keluar;
    String hasil =
        'Di $teksBulan kamu mencatat pemasukan ${formatRupiah(masuk)} '
        'dan pengeluaran ${formatRupiah(keluar)}. ';
    hasil += selisih < 0
        ? 'Pengeluaranmu lebih besar ${formatRupiah(-selisih)} dari pemasukan.'
        : 'Masih ada selisih ${formatRupiah(selisih)} yang bisa ditabung.';
    var perKategori = pengeluaranPerKategori(awal, akhir);
    if (perKategori.isNotEmpty) {
      var terbesar = perKategori.entries.first;
      hasil +=
          ' Pengeluaran terbesar ada di ${terbesar.key}, '
          'yaitu ${formatRupiah(terbesar.value)}.';
    }
    return hasil;
  }

  static String _jawabHemat(DateTime awal, DateTime akhir, String teksBulan) {
    var teratas = pengeluaranPerKategori(awal, akhir).entries.take(2).toList();
    if (teratas.isEmpty) {
      return 'Belum ada pengeluaran yang tercatat di $teksBulan, '
          'jadi belum ada yang bisa dihemat.';
    }
    int jumlah = 0;
    List<String> bagian = [];
    for (var k in teratas) {
      jumlah += k.value;
      bagian.add('${k.key} (${formatRupiah(k.value)})');
    }
    String hasil =
        'Coba mulai dari ${bagian.join(' dan ')}. Kalau dikurangi 10%, '
        'kamu bisa menyisihkan sekitar ${formatRupiah(jumlah ~/ 10)}.';
    WishlistItem? impian = impianTerdekat();
    if (impian != null) {
      hasil += ' Uang itu bisa langsung masuk ke tabungan ${impian.nama}.';
    }
    return hasil;
  }

  static String _jawabCukup(DateTime bulan, String teksBulan) {
    int sisa = anggaranBulanan - terpakaiAnggaran(bulan);
    if (sisa < 0) {
      return 'Anggaran $teksBulan sudah lebih ${formatRupiah(-sisa)}. '
          'Tahan dulu pengeluaran yang tidak wajib sampai bulan depan.';
    }
    DateTime hariIni = DateTime.now();
    bool bulanBerjalan =
        bulan.year == hariIni.year && bulan.month == hariIni.month;
    if (!bulanBerjalan) {
      return 'Di $teksBulan anggaranmu bersisa ${formatRupiah(sisa)}, '
          'jadi bulan itu cukup sampai akhir.';
    }
    // Hari ini ikut dihitung sebagai hari tersisa.
    int hariTerakhir = DateTime(bulan.year, bulan.month + 1, 0).day;
    int hariTersisa = hariTerakhir - hariIni.day + 1;
    return 'Sisa anggaranmu ${formatRupiah(sisa)} untuk $hariTersisa hari lagi. '
        'Cukup asal belanja paling banyak '
        '${formatRupiah(sisa ~/ hariTersisa)} per hari.';
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
    int saldo = 0;
    for (var d in daftarDompet) {
      saldo += d.saldoAwal;
    }
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
    int saldo = 0;
    for (var d in daftarDompet) {
      if (d.nama == sumber) saldo = d.saldoAwal;
    }
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

  // Kantong 'Tabungan' diisi pemindahan ke dompet Tabungan, kantong lain diisi pengeluaran. Terbaru di atas.
  static List<CatatanTransaksi> transaksiKantong(
    String kategori,
    DateTime bulan,
  ) {
    List<CatatanTransaksi> hasil = [];
    for (var t in daftarTransaksi) {
      if (!_bulanSama(t.tanggal, bulan)) continue;
      bool cocok = kategori == 'Tabungan'
          ? t.isTransfer && t.sumberTujuan == 'Tabungan'
          : !t.isPemasukan && !t.isTransfer && t.kategori == kategori;
      if (cocok) hasil.add(t);
    }
    hasil.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    return hasil;
  }

  static int terpakaiBudget(String kategori, DateTime bulan) {
    int total = 0;
    for (var t in transaksiKantong(kategori, bulan)) {
      total += t.nominal;
    }
    return total;
  }

  // Sisa kantong dibagi hari tersisa termasuk hari ini. null kalau bukan bulan berjalan atau sisanya habis.
  static int? jatahPerHari(
    BudgetItem budget,
    DateTime bulan,
    DateTime hariIni,
  ) {
    if (!_bulanSama(bulan, hariIni)) return null;
    int sisa = budget.limit - terpakaiBudget(budget.kategori, bulan);
    if (sisa <= 0) return null;
    // Hari ke-0 bulan berikutnya = hari terakhir bulan ini.
    int hariTerakhir = DateTime(hariIni.year, hariIni.month + 1, 0).day;
    int hariTersisa = hariTerakhir - hariIni.day + 1;
    return sisa ~/ hariTersisa;
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

  // Ikon impian tidak disimpan di database karena selalu mengikuti kategorinya.
  static IconData ikonImpian(String nama) {
    for (var k in kategoriImpian) {
      if (k.nama == nama) return k.ikon;
    }
    return LucideIcons.star;
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

  static Future<void> hapusTransaksi(CatatanTransaksi item) async {
    daftarTransaksi.remove(item);
    refreshNotifier.value++;
    await DbService.hapus('transaksi', item.id);
  }

  static Future<void> ubahAnggaran(int nominal) async {
    anggaranBulanan = nominal;
    refreshNotifier.value++;
    await DbService.simpanPengaturan('anggaran_bulanan', '$nominal');
  }

  static Future<void> tambahBudget(BudgetItem item) async {
    daftarBudget.add(item);
    refreshNotifier.value++;
    item.id = await DbService.tambah('kantong', item.toMap());
  }

  static Future<void> ubahLimitBudget(BudgetItem item, int limit) async {
    item.limit = limit;
    refreshNotifier.value++;
    await DbService.ubah('kantong', item.toMap());
  }

  // Dompet bawaan yang dipakai langsung oleh kode (tabungan impian, pelunasan), jadi tidak boleh diganti nama atau dihapus.
  static const List<String> dompetTetap = ['Utama', 'Tabungan'];

  static const List<IconData> opsiIkonDompet = [
    LucideIcons.wallet,
    LucideIcons.landmark,
    LucideIcons.smartphone,
    LucideIcons.banknote,
    LucideIcons.piggyBank,
    LucideIcons.creditCard,
    LucideIcons.qrCode,
    LucideIcons.coins,
  ];

  // Nama pendek di bawah setiap ikon, urutannya sama dengan opsiIkonDompet.
  static const List<String> labelIkonDompet = [
    'Dompet',
    'Bank',
    'HP',
    'Tunai',
    'Celengan',
    'Kartu',
    'QR',
    'Koin',
  ];

  // Nama yang tidak ditemukan memakai ikon wallet, sama dengan ikonDariIndeks.
  static IconData ikonDompet(String nama) {
    for (var d in daftarDompet) {
      if (d.nama == nama) return d.ikon;
    }
    return LucideIcons.wallet;
  }

  // Nama dibandingkan tanpa beda huruf besar/kecil. lama = dompet yang sedang diubah, boleh memakai namanya sendiri.
  static bool namaDompetBoleh(String nama, {Dompet? lama}) {
    String kecil = nama.trim().toLowerCase();
    if (kecil.isEmpty) return false;
    for (var k in namaKhusus) {
      if (k.toLowerCase() == kecil) return false;
    }
    for (var d in daftarDompet) {
      if (d != lama && d.nama.toLowerCase() == kecil) return false;
    }
    return true;
  }

  static int jumlahTransaksiDompet(String nama) {
    int jumlah = 0;
    for (var t in daftarTransaksi) {
      if (t.sumberDana == nama || t.sumberTujuan == nama) jumlah++;
    }
    return jumlah;
  }

  static Future<void> tambahDompet(Dompet dompet) async {
    daftarDompet.add(dompet);
    refreshNotifier.value++;
    dompet.id = await DbService.tambah('dompet', dompet.toMap());
  }

  static Future<void> ubahDompet(
    Dompet dompet, {
    required String nama,
    required IconData ikon,
    required int saldoAwal,
  }) async {
    String namaLama = dompet.nama;
    bool gantiNama = nama != namaLama;
    dompet.nama = nama;
    dompet.ikon = ikon;
    dompet.saldoAwal = saldoAwal;
    if (gantiNama) {
      for (var t in daftarTransaksi) {
        if (t.sumberDana == namaLama) t.sumberDana = nama;
        if (t.sumberTujuan == namaLama) t.sumberTujuan = nama;
      }
    }
    refreshNotifier.value++;
    await DbService.ubah('dompet', dompet.toMap());
    if (gantiNama) await DbService.gantiNamaDompet(namaLama, nama);
  }

  // Mengembalikan false kalau dompet masih dipakai transaksi atau termasuk dompet tetap.
  static Future<bool> hapusDompet(Dompet dompet) async {
    if (dompetTetap.contains(dompet.nama)) return false;
    if (jumlahTransaksiDompet(dompet.nama) > 0) return false;
    daftarDompet.remove(dompet);
    refreshNotifier.value++;
    await DbService.hapus('dompet', dompet.id);
    return true;
  }

  static Future<void> hapusBudget(BudgetItem item) async {
    daftarBudget.remove(item);
    refreshNotifier.value++;
    await DbService.hapus('kantong', item.id);
  }
}
