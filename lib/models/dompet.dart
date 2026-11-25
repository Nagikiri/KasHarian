class Dompet {
  int? id;
  final String nama;
  final int saldoAwal;

  Dompet({this.id, required this.nama, this.saldoAwal = 0});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nama': nama, 'saldo_awal': saldoAwal};
  }

  factory Dompet.fromMap(Map<String, dynamic> map) {
    return Dompet(
      id: map['id'],
      nama: map['nama'],
      saldoAwal: map['saldo_awal'],
    );
  }
}
