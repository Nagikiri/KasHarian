const int _batasDigit = 10;

int tambahDigit(int nilai, String digit) {
  int hasil = int.parse(nilai == 0 ? digit : '$nilai$digit');
  if (hasil.toString().length > _batasDigit) return nilai;
  return hasil;
}

int hapusDigit(int nilai) => nilai ~/ 10;

int tambahNominal(int nilai, int tambahan) {
  int hasil = nilai + tambahan;
  if (hasil.toString().length > _batasDigit) return nilai;
  return hasil;
}
