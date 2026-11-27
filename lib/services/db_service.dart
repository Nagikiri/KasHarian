import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../config/app_config.dart';
import '../models/data_contoh.dart';
import '../models/dompet.dart';

// Satu-satunya tempat SQL di aplikasi. AppData memanggil method di sini setiap kali data berubah.
class DbService {
  // null berarti database belum dibuka (misalnya di test), jadi semua method di bawah tidak melakukan apa-apa.
  static Database? _db;

  // Dipanggil sekali di main() sebelum runApp. Test mengisi lokasi dengan database di memori.
  // dataContoh bisa diisi test, karena nilai AppConfig tetap selama aplikasi berjalan.
  static Future<void> buka({
    String? lokasi,
    bool dataContoh = AppConfig.dataContoh,
  }) async {
    lokasi ??= join(await getDatabasesPath(), AppConfig.dbName);
    // onCreate hanya berjalan saat file database belum ada, yaitu saat aplikasi pertama kali dibuka.
    _db = await openDatabase(
      lokasi,
      version: 1,
      onCreate: (db, versi) => _buatTabel(db, dataContoh),
    );
  }

  static Future<void> tutup() async {
    await _db?.close();
    _db = null;
  }

  static Future<void> _buatTabel(Database db, bool dataContoh) async {
    // Tanggal disimpan sebagai teks ISO 8601, bool sebagai 0/1, ikon sebagai nomor urut di daftarIkonKategori.
    await db.execute('''
      CREATE TABLE transaksi (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kategori TEXT NOT NULL,
        catatan TEXT NOT NULL,
        nominal INTEGER NOT NULL,
        indeks_ikon INTEGER NOT NULL,
        tanggal TEXT NOT NULL,
        is_pemasukan INTEGER NOT NULL,
        is_transfer INTEGER NOT NULL,
        sumber_dana TEXT NOT NULL,
        sumber_tujuan TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE kategori (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        indeks_ikon INTEGER NOT NULL,
        is_pemasukan INTEGER NOT NULL,
        indeks_warna INTEGER NOT NULL
      )
    ''');
    // Kolom batas, bukan limit, karena LIMIT adalah kata khusus di SQL.
    await db.execute('''
      CREATE TABLE kantong (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kategori TEXT NOT NULL,
        batas INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE utang (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        jenis TEXT NOT NULL,
        nama TEXT NOT NULL,
        nominal INTEGER NOT NULL,
        keterangan TEXT NOT NULL,
        tanggal TEXT NOT NULL,
        lunas INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE impian (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        kategori TEXT NOT NULL,
        mata_uang TEXT NOT NULL,
        harga_asing INTEGER NOT NULL,
        target_idr INTEGER NOT NULL,
        terkumpul_idr INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE dompet (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        indeks_ikon INTEGER NOT NULL,
        saldo_awal INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE pesan_ai (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dari_pengguna INTEGER NOT NULL,
        teks TEXT NOT NULL,
        waktu TEXT NOT NULL
      )
    ''');
    // Satu baris per pengaturan: anggaran bulanan, mata uang favorit, kurs terakhir, dan waktunya.
    await db.execute('''
      CREATE TABLE pengaturan (
        kunci TEXT PRIMARY KEY,
        nilai TEXT NOT NULL
      )
    ''');
    // Prod hanya mendapat isi bawaan. Dev mendapat saldo contoh dan data contoh lain.
    await _isiBawaan(db, dataContoh ? contohDompet() : dompetBawaan());
    if (dataContoh) await _isiContoh(db);
  }

  // DatabaseExecutor bisa berupa database atau transaction, jadi dipakai juga oleh kosongkan().
  static Future<void> _isiBawaan(
    DatabaseExecutor db,
    List<Dompet> daftarDompet,
  ) async {
    for (var d in daftarDompet) {
      await db.insert('dompet', d.toMap());
    }
    for (var k in kategoriBawaan()) {
      await db.insert('kategori', k.toMap());
    }
  }

  // Data contoh hanya masuk di sini, yaitu saat database pertama kali dibuat.
  static Future<void> _isiContoh(Database db) async {
    for (var b in contohBudget()) {
      await db.insert('kantong', b.toMap());
    }
    // Dibalik karena list ini menaruh data terbaru di depan, sedangkan id terbesar harus milik yang terbaru.
    for (var t in contohTransaksi().reversed) {
      await db.insert('transaksi', t.toMap());
    }
    for (var w in contohWishlist().reversed) {
      await db.insert('impian', w.toMap());
    }
    for (var u in contohUtang().reversed) {
      await db.insert('utang', u.toMap());
    }
  }

  // Kurs terakhir dan pengaturan privasi tidak ikut dihapus.
  static const List<String> _kunciTetap = [
    'kurs_ke_idr',
    'kurs_diperbarui',
    'cakupan_sembunyi',
    'sembunyikan_saat_dibuka',
  ];

  // Dipakai "Hapus semua data". transaction: kalau satu langkah gagal, tidak ada yang terhapus.
  static Future<void> kosongkan() async {
    Database? db = _db;
    if (db == null) return;
    await db.transaction((txn) async {
      for (String tabel in [
        'transaksi',
        'kategori',
        'kantong',
        'utang',
        'impian',
        'dompet',
        'pesan_ai',
      ]) {
        await txn.delete(tabel);
      }
      await txn.delete(
        'pengaturan',
        where: 'kunci NOT IN (?, ?, ?, ?)',
        whereArgs: _kunciTetap,
      );
      await _isiBawaan(txn, dompetBawaan());
    });
  }

  // Mengembalikan id baru dari AUTOINCREMENT, atau null kalau database belum dibuka.
  static Future<int?> tambah(String tabel, Map<String, dynamic> data) async {
    Database? db = _db;
    if (db == null) return null;
    return db.insert(tabel, data);
  }

  static Future<void> ubah(String tabel, Map<String, dynamic> data) async {
    Database? db = _db;
    if (db == null || data['id'] == null) return;
    await db.update(tabel, data, where: 'id = ?', whereArgs: [data['id']]);
  }

  static Future<void> hapus(String tabel, int? id) async {
    Database? db = _db;
    if (db == null || id == null) return;
    await db.delete(tabel, where: 'id = ?', whereArgs: [id]);
  }

  // terbaruDulu dipakai untuk list yang menaruh data baru di depan (transaksi, impian, utang).
  static Future<List<Map<String, dynamic>>> ambilSemua(
    String tabel, {
    bool terbaruDulu = false,
  }) async {
    Database? db = _db;
    if (db == null) return [];
    return db.query(tabel, orderBy: terbaruDulu ? 'id DESC' : 'id ASC');
  }

  // Transaksi menyimpan nama dompet (bukan id), jadi transaksi lama ikut diganti supaya saldonya tidak hilang.
  static Future<void> gantiNamaDompet(String lama, String baru) async {
    Database? db = _db;
    if (db == null) return;
    await db.rawUpdate(
      'UPDATE transaksi SET sumber_dana = ? WHERE sumber_dana = ?',
      [baru, lama],
    );
    await db.rawUpdate(
      'UPDATE transaksi SET sumber_tujuan = ? WHERE sumber_tujuan = ?',
      [baru, lama],
    );
  }

  // replace: kalau kuncinya sudah ada, baris lama ditimpa. Jadi satu method untuk simpan dan ubah.
  static Future<void> simpanPengaturan(String kunci, String nilai) async {
    Database? db = _db;
    if (db == null) return;
    await db.insert('pengaturan', {
      'kunci': kunci,
      'nilai': nilai,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Tabel pengaturan tidak punya kolom id, jadi dibaca tanpa ambilSemua.
  static Future<Map<String, String>> ambilPengaturan() async {
    Map<String, String> hasil = {};
    Database? db = _db;
    if (db == null) return hasil;
    List<Map<String, dynamic>> semua = await db.query('pengaturan');
    for (var baris in semua) {
      hasil[baris['kunci']] = baris['nilai'];
    }
    return hasil;
  }
}
