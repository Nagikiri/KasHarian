import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/data_contoh.dart';

// Satu-satunya tempat SQL di aplikasi. AppData memanggil method di sini setiap kali data berubah.
class DbService {
  // null berarti database belum dibuka (misalnya di test), jadi semua method di bawah tidak melakukan apa-apa.
  static Database? _db;

  // Dipanggil sekali di main() sebelum runApp. Test mengisi lokasi dengan database di memori.
  static Future<void> buka({String? lokasi}) async {
    lokasi ??= join(await getDatabasesPath(), 'kasharian.db');
    // onCreate hanya berjalan saat file database belum ada, yaitu saat aplikasi pertama kali dibuka.
    _db = await openDatabase(lokasi, version: 1, onCreate: _buatTabel);
  }

  static Future<void> tutup() async {
    await _db?.close();
    _db = null;
  }

  static Future<void> _buatTabel(Database db, int versi) async {
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
    await _isiContoh(db);
  }

  // Data contoh hanya masuk di sini, yaitu saat database pertama kali dibuat.
  static Future<void> _isiContoh(Database db) async {
    for (var d in contohDompet()) {
      await db.insert('dompet', d.toMap());
    }
    for (var k in contohKategori()) {
      await db.insert('kategori', k.toMap());
    }
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
