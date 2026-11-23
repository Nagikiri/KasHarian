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
  if (jenis == 1) return '${namaBulan[acuan.month - 1]} ${acuan.year}';
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
List<String> labelTren(int jenis, DateTime awal, DateTime akhir) {
  List<DateTime> slot = slotTren(jenis, awal, akhir);
  bool perHari = trenPerHari(jenis, awal, akhir);
  int jarak = jenis == 0 ? 1 : (perHari ? 7 : (slot.length / 12).ceil());
  return [
    for (int i = 0; i < slot.length; i++)
      i % jarak == 0 ? _labelSlot(jenis, slot[i], perHari) : '',
  ];
}

String _labelSlot(int jenis, DateTime t, bool perHari) {
  if (jenis == 0) return namaHari[t.weekday - 1].substring(0, 3);
  if (perHari) return '${t.day}';
  return namaBulan[t.month - 1];
}
