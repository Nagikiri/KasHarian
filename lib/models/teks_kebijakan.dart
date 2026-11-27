// Satu teks biasa supaya bisa disalin apa adanya ke halaman web. Bagian dipisah baris kosong, baris pertama = judul.
// Bagian Bendahara AI dan Gemini ditambah di tahap Gemini.
// Kontak pengembang wajib ditambahkan sebelum aplikasi diunggah ke Play Console.
const String teksKebijakan = '''
Ringkas
Semua catatan keuangan tetap berada di perangkat pengguna. Aplikasi ini tidak meminta akun, tidak punya server sendiri, dan tidak menampilkan iklan.

Tempat data disimpan
Transaksi, dompet, kantong, utang, impian, dan percakapan dengan Bendahara AI disimpan di database lokal pada perangkat. Data tersebut tidak diunggah ke mana pun dan tidak bisa dilihat oleh pengembang.

Penggunaan internet
Koneksi internet hanya dipakai untuk mengambil kurs mata uang terbaru dari layanan publik open.er-api.com. Permintaan itu tidak menyertakan nama, catatan transaksi, maupun saldo pengguna. Tanpa internet, aplikasi tetap bisa dipakai dengan kurs terakhir yang tersimpan.

Iklan dan pelacakan
Tidak ada iklan, alat analitik, atau pelacakan aktivitas. Aplikasi juga tidak meminta akses ke lokasi, kontak, kamera, maupun galeri.

Menghapus data
Seluruh catatan bisa dihapus kapan saja melalui Pengaturan → Hapus semua data. Menghapus aplikasi dari perangkat juga ikut menghapus semua data yang tersimpan.

Perubahan kebijakan
Jika ada fitur baru yang mengubah cara data digunakan, misalnya analisis oleh Bendahara AI, kebijakan ini diperbarui lebih dulu dan perubahannya bisa dilihat di halaman ini.''';
