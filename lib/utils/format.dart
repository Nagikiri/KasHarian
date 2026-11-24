const List<String> namaBulanPanjang = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

const List<String> namaHari = [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

String formatTitik(int nilai) {
  String s = nilai.abs().toString();
  String hasil = '';
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) hasil += '.';
    hasil += s[i];
  }
  return hasil;
}

// Dua angka di belakang koma, misalnya 1.234,56. Dibulatkan lewat ratusan supaya 0,999 jadi 1,00.
String formatDesimal(double nilai) {
  int ratusan = (nilai.abs() * 100).round();
  String tanda = nilai < 0 && ratusan > 0 ? '-' : '';
  String desimal = (ratusan % 100).toString().padLeft(2, '0');
  return '$tanda${formatTitik(ratusan ~/ 100)},$desimal';
}

String formatRupiah(int nilai) {
  String tanda = nilai < 0 ? '-' : '';
  return '${tanda}Rp ${formatTitik(nilai)}';
}

// Untuk tempat sempit seperti tengah donat. Dibulatkan ke bawah supaya 999.999 tidak tertulis "1000rb".
String formatRingkas(int nilai) {
  String tanda = nilai < 0 ? '-' : '';
  int n = nilai.abs();
  if (n < 1000) return '${tanda}Rp $n';
  if (n < 1000000) return '${tanda}Rp ${n ~/ 1000}rb';
  int persepuluhJuta = n ~/ 100000;
  int desimal = persepuluhJuta % 10;
  String teksDesimal = desimal == 0 ? '' : ',$desimal';
  return '${tanda}Rp ${formatTitik(persepuluhJuta ~/ 10)}${teksDesimal}jt';
}

// weekday di Dart dimulai dari 1 (Senin), sedangkan indeks list dari 0.
String formatTanggal(DateTime t) {
  return '${namaHari[t.weekday - 1]}, ${t.day} ${namaBulanPanjang[t.month - 1]}';
}

String formatTanggalPendek(DateTime t) {
  return '${t.day} ${namaBulanPanjang[t.month - 1]}';
}

// Lebih dari 12 bulan ditulis dalam tahun supaya lebih mudah dibayangkan.
String formatEstimasiBulan(int bulan) {
  if (bulan < 12) return 'sekitar $bulan bulan lagi';
  if (bulan <= 36) return 'sekitar ${(bulan / 12).ceil()} tahun lagi';
  return 'lebih dari 3 tahun lagi';
}

String formatTanggalPanjang(DateTime t) {
  return '${namaHari[t.weekday - 1]}, ${t.day} ${namaBulanPanjang[t.month - 1]} ${t.year}';
}

// Baris pertama tanpa nominal. Nominalnya ditambahkan widget supaya bisa ditulis tebal.
String kalimatPerbandingan(int sekarang, int lalu) {
  if (sekarang > lalu) return 'Pengeluaranmu naik';
  if (sekarang < lalu) return 'Pengeluaranmu turun';
  return 'Pengeluaranmu sama seperti';
}

String keteranganPerbandingan(int sekarang, int lalu, String label) {
  return sekarang == lalu ? label : 'dibanding $label';
}

// Tanpa rentang tanggal, karena tidak ada angka yang dibandingkan.
String kalimatTanpaPembanding(int jenis) {
  const List<String> namaPeriode = ['pekan lalu', 'bulan lalu', 'tahun lalu'];
  return 'Belum ada data ${namaPeriode[jenis]} untuk dibandingkan.';
}

// Hanya dipanggil kalau lalu > 0. Perubahan kecil yang terbulatkan jadi 0 ditulis "<1%".
String teksPersenPerubahan(int sekarang, int lalu) {
  String tanda = sekarang > lalu ? '+' : '-';
  int persen = ((sekarang - lalu).abs() * 100 / lalu).round();
  return persen == 0 ? '$tanda<1%' : '$tanda$persen%';
}

// lalu null berarti kategori ini tidak ada di periode lalu.
String teksSelisih(int sekarang, int? lalu) {
  if (lalu == null) return 'baru';
  int selisih = sekarang - lalu;
  if (selisih == 0) return 'sama';
  // formatRupiah sudah menulis "-" untuk angka minus, jadi "+" hanya ditambah untuk yang naik.
  return selisih > 0 ? '+${formatRupiah(selisih)}' : formatRupiah(selisih);
}
