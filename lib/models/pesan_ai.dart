class PesanAi {
  int? id;
  final bool dariPengguna;
  final String teks;
  final DateTime waktu;

  PesanAi({
    this.id,
    required this.dariPengguna,
    required this.teks,
    required this.waktu,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dari_pengguna': dariPengguna ? 1 : 0,
      'teks': teks,
      'waktu': waktu.toIso8601String(),
    };
  }

  factory PesanAi.fromMap(Map<String, dynamic> map) {
    return PesanAi(
      id: map['id'],
      dariPengguna: map['dari_pengguna'] == 1,
      teks: map['teks'],
      waktu: DateTime.parse(map['waktu']),
    );
  }
}
