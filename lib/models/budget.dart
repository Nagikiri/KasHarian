class BudgetItem {
  int? id;
  final String kategori;
  int limit;

  BudgetItem({this.id, required this.kategori, required this.limit});

  // Kolomnya bernama batas karena LIMIT adalah kata khusus di SQL.
  Map<String, dynamic> toMap() {
    return {'id': id, 'kategori': kategori, 'batas': limit};
  }

  factory BudgetItem.fromMap(Map<String, dynamic> map) {
    return BudgetItem(
      id: map['id'],
      kategori: map['kategori'],
      limit: map['batas'],
    );
  }
}
