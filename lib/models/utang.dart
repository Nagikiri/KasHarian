class UtangItem {
  final String jenis;
  final String nama;
  final int nominal;
  final String keterangan;
  final DateTime tanggal;
  bool lunas;

  UtangItem({
    required this.jenis,
    required this.nama,
    required this.nominal,
    required this.keterangan,
    required this.tanggal,
    this.lunas = false,
  });
}
