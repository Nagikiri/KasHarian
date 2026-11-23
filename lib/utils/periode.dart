import 'package:flutter/material.dart' show DateTimeRange;

import 'format.dart';

// jenis: 0 = Pekan, 1 = Bulan, 2 = Tahun, sama dengan urutan PilihanSegmen di Ringkasan.
// 3 = Rentang, awal dan akhirnya dipilih sendiri, jadi tidak memakai fungsi periode di bawah.
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
  if (jenis == 1) return '${namaBulanPanjang[acuan.month - 1]} ${acuan.year}';
  if (jenis == 2) return '${acuan.year}';
  DateTime awal = awalPeriode(0, acuan);
  return labelRentang(awal, DateTime(awal.year, awal.month, awal.day + 6));
}

// hariTerakhir ikut dihitung (inklusif), karena label dibaca manusia.
String labelRentang(DateTime awal, DateTime hariTerakhir) {
  String teksAkhir =
      '${formatTanggalPendek(hariTerakhir)} ${hariTerakhir.year}';
  if (jumlahHari(awal, hariTerakhir) == 0) return teksAkhir;
  if (awal.year != hariTerakhir.year) {
    return '${formatTanggalPendek(awal)} ${awal.year}–$teksAkhir';
  }
  if (awal.month != hariTerakhir.month) {
    return '${formatTanggalPendek(awal)}–$teksAkhir';
  }
  return '${awal.day}–$teksAkhir';
}

// Kalender Flutter error kalau tanggal awalnya di luar batas, jadi ditahan dulu di dalam batas.
DateTime tahanTanggal(DateTime t, DateTime batasAwal, DateTime batasAkhir) {
  if (t.isBefore(batasAwal)) return batasAwal;
  if (t.isAfter(batasAkhir)) return batasAkhir;
  return t;
}

// Tanggal diubah ke UTC supaya selisihnya selalu hari utuh.
int jumlahHari(DateTime awal, DateTime akhir) {
  DateTime a = DateTime.utc(awal.year, awal.month, awal.day);
  DateTime b = DateTime.utc(akhir.year, akhir.month, akhir.day);
  return b.difference(a).inDays;
}

// Tahun selalu per bulan. Rentang lebih dari 31 hari juga per bulan supaya batangnya tidak terlalu banyak.
bool trenPerHari(int jenis, DateTime awal, DateTime akhir) {
  return jenis != 2 && jumlahHari(awal, akhir) <= 31;
}

DateTime _slotBerikut(DateTime t, bool perHari) {
  if (perHari) return DateTime(t.year, t.month, t.day + 1);
  return DateTime(t.year, t.month + 1);
}

// Awal setiap batang grafik tren. Batang pertama rentang per bulan bisa dimulai di tengah bulan.
List<DateTime> slotTren(int jenis, DateTime awal, DateTime akhir) {
  bool perHari = trenPerHari(jenis, awal, akhir);
  List<DateTime> hasil = [];
  for (DateTime t = awal; t.isBefore(akhir); t = _slotBerikut(t, perHari)) {
    hasil.add(t);
  }
  return hasil;
}

// Label yang kosong tidak ditampilkan, supaya label di bawah grafik tidak berdempetan.
// Per bulan: tiap batang ketiga, jadi mode Tahun menampilkan Januari, April, Juli, Oktober.
List<String> labelTren(int jenis, DateTime awal, DateTime akhir) {
  List<DateTime> slot = slotTren(jenis, awal, akhir);
  bool perHari = trenPerHari(jenis, awal, akhir);
  int jarakBulan = (slot.length / 4).ceil();
  int jarak = jenis == 0
      ? 1
      : (perHari ? 7 : (jarakBulan > 3 ? jarakBulan : 3));
  return [
    for (int i = 0; i < slot.length; i++)
      i % jarak == 0 ? _labelSlot(jenis, slot[i], perHari) : '',
  ];
}

String _labelSlot(int jenis, DateTime t, bool perHari) {
  if (jenis == 0) return namaHari[t.weekday - 1].substring(0, 3);
  if (perHari) return '${t.day}';
  return namaBulanPanjang[t.month - 1];
}

// Isi tooltip saat batang diketuk: tanggal untuk batang per hari, bulan dan tahun untuk batang per bulan.
List<String> labelTooltipTren(int jenis, DateTime awal, DateTime akhir) {
  bool perHari = trenPerHari(jenis, awal, akhir);
  return [
    for (DateTime t in slotTren(jenis, awal, akhir))
      perHari ? formatTanggal(t) : '${namaBulanPanjang[t.month - 1]} ${t.year}',
  ];
}

// Makin sedikit batang, makin lebar, supaya Pekan dan Tahun tidak terlihat kosong.
double lebarBatang(int jumlah) {
  if (jumlah <= 7) return 20;
  if (jumlah <= 12) return 14;
  return 6;
}

// Sumbu dibagi 4 langkah. Langkah dibulatkan ke 1, 2, 2,5, atau 5 kali 10^n supaya labelnya rapi.
int langkahSumbu(int tertinggi) {
  int pangkat = 1;
  while (true) {
    for (int langkah in [pangkat, pangkat * 2, pangkat * 5 ~/ 2, pangkat * 5]) {
      if (langkah * 4 >= tertinggi) return langkah;
    }
    pangkat *= 10;
  }
}

// Periode berjalan dibanding potongan periode lalu yang sama panjang (1–24 Nov vs 1–24 Okt), supaya adil.
DateTimeRange rentangPembanding(int jenis, DateTime acuan, DateTime hariIni) {
  DateTime lalu = geserPeriode(jenis, acuan, -1);
  DateTime awalLalu = awalPeriode(jenis, lalu);
  DateTime akhirLalu = akhirPeriode(jenis, lalu);
  DateTime besok = DateTime(hariIni.year, hariIni.month, hariIni.day + 1);
  if (!akhirPeriode(jenis, acuan).isAfter(besok)) {
    return DateTimeRange(start: awalLalu, end: akhirLalu);
  }
  int hari = jumlahHari(awalPeriode(jenis, acuan), besok);
  DateTime potong = DateTime(
    awalLalu.year,
    awalLalu.month,
    awalLalu.day + hari,
  );
  // 30 hari dari 1 Februari jatuh di bulan Maret, jadi ditahan di akhir Februari.
  if (potong.isAfter(akhirLalu)) potong = akhirLalu;
  return DateTimeRange(start: awalLalu, end: potong);
}

// Periode lalu yang utuh ditulis dengan namanya, yang terpotong ditulis tanggalnya.
String labelPembanding(int jenis, DateTime acuan, DateTimeRange rentang) {
  DateTime lalu = geserPeriode(jenis, acuan, -1);
  if (rentang.end == akhirPeriode(jenis, lalu)) {
    return labelPeriode(jenis, lalu);
  }
  DateTime akhir = rentang.end;
  return labelRentang(
    rentang.start,
    DateTime(akhir.year, akhir.month, akhir.day - 1),
  );
}
