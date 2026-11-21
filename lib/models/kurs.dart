class Kurs {
  String mataUangDasar;
  String waktuUpdate;
  Map<String, double> daftarRate;

  Kurs({
    required this.mataUangDasar,
    required this.waktuUpdate,
    required this.daftarRate,
  });

  factory Kurs.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> ratesJson = json['rates'];
    Map<String, double> rates = {};

    ratesJson.forEach((kode, nilai) {
      rates[kode] = (nilai as num).toDouble();
    });

    return Kurs(
      mataUangDasar: json['base_code'],
      waktuUpdate: json['time_last_update_utc'],
      daftarRate: rates,
    );
  }

  int keRupiah(String kodeMataUang) {
    double? rate = daftarRate[kodeMataUang];
    if (rate == null || rate == 0) return 0;
    return (1 / rate).round();
  }
}
