import 'format.dart';

// jenis: 0 = Pekan, 1 = Bulan, 2 = Tahun, sama dengan urutan PilihanSegmen di Ringkasan.
DateTime awalPeriode(int jenis, DateTime acuan) {
  if (jenis == 0) {
    // weekday Senin = 1, jadi mundur (weekday - 1) hari untuk sampai ke Senin.
    return DateTime(acuan.year, acuan.month, acuan.day - (acuan.weekday - 1));
  }
  if (jenis == 1) return DateTime(acuan.year, acuan.month);
  return DateTime(acuan.year);
}

// Akhir eksklusif: transaksi dihitung kalau tanggalnya sebelum batas ini.
DateTime akhirPeriode(int jenis, DateTime acuan) {
  DateTime awal = awalPeriode(jenis, acuan);
  if (jenis == 0) return DateTime(awal.year, awal.month, awal.day + 7);
  if (jenis == 1) return DateTime(awal.year, awal.month + 1);
  return DateTime(awal.year + 1);
}

// Dihitung dari awal periode supaya tanggal 31 tidak meloncati bulan yang lebih pendek.
DateTime geserPeriode(int jenis, DateTime acuan, int arah) {
  DateTime awal = awalPeriode(jenis, acuan);
  if (jenis == 0) return DateTime(awal.year, awal.month, awal.day + 7 * arah);
  if (jenis == 1) return DateTime(awal.year, awal.month + arah);
  return DateTime(awal.year + arah);
}

String labelPeriode(int jenis, DateTime acuan) {
  if (jenis == 1) return '${namaBulan[acuan.month - 1]} ${acuan.year}';
  if (jenis == 2) return '${acuan.year}';
  DateTime awal = awalPeriode(0, acuan);
  DateTime akhir = DateTime(awal.year, awal.month, awal.day + 6);
  String teksAkhir = '${formatTanggalPendek(akhir)} ${akhir.year}';
  if (awal.year != akhir.year) {
    return '${formatTanggalPendek(awal)} ${awal.year}–$teksAkhir';
  }
  if (awal.month != akhir.month) {
    return '${formatTanggalPendek(awal)}–$teksAkhir';
  }
  return '${awal.day}–$teksAkhir';
}
