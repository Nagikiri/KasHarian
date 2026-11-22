const List<String> namaBulan = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

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

String formatRupiah(int nilai) {
  String tanda = nilai < 0 ? '-' : '';
  return '${tanda}Rp ${formatTitik(nilai)}';
}

// weekday di Dart dimulai dari 1 (Senin), sedangkan indeks list dari 0.
String formatTanggal(DateTime t) {
  return '${namaHari[t.weekday - 1]}, ${t.day} ${namaBulan[t.month - 1]}';
}

String formatTanggalPendek(DateTime t) {
  return '${t.day} ${namaBulan[t.month - 1]}';
}

String formatTanggalPanjang(DateTime t) {
  return '${namaHari[t.weekday - 1]}, ${t.day} ${namaBulanPanjang[t.month - 1]} ${t.year}';
}
