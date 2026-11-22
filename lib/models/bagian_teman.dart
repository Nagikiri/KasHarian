import '../utils/format.dart';

class BagianTeman {
  String nama;
  int nominal;

  BagianTeman({this.nama = '', this.nominal = 0});
}

int totalBagian(List<BagianTeman> daftar) {
  int total = 0;
  for (var t in daftar) {
    total += t.nominal;
  }
  return total;
}

// Hanya teman yang nama dan bagiannya sudah diisi yang dicatat sebagai piutang.
List<BagianTeman> temanTerisi(List<BagianTeman> daftar) {
  return daftar
      .where((t) => t.nama.trim().isNotEmpty && t.nominal > 0)
      .toList();
}

String ringkasanBagian(List<BagianTeman> daftar) {
  List<BagianTeman> teman = temanTerisi(daftar);
  if (teman.isEmpty) return 'Tidak';
  return '${teman.length} teman · ${formatRupiah(totalBagian(teman))}';
}
