class UtangItem {
  int? id;
  final String jenis;
  final String nama;
  final int nominal;
  final String keterangan;
  final DateTime tanggal;
  bool lunas;

  UtangItem({
    this.id,
    required this.jenis,
    required this.nama,
    required this.nominal,
    required this.keterangan,
    required this.tanggal,
    this.lunas = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jenis': jenis,
      'nama': nama,
      'nominal': nominal,
      'keterangan': keterangan,
      'tanggal': tanggal.toIso8601String(),
      'lunas': lunas ? 1 : 0,
    };
  }

  factory UtangItem.fromMap(Map<String, dynamic> map) {
    return UtangItem(
      id: map['id'],
      jenis: map['jenis'],
      nama: map['nama'],
      nominal: map['nominal'],
      keterangan: map['keterangan'],
      tanggal: DateTime.parse(map['tanggal']),
      lunas: map['lunas'] == 1,
    );
  }
}
