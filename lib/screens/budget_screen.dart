import 'package:flutter/material.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double x = w * 0.05;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text(
          'Atur Budget Bulanan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: x, vertical: 16),
        child: Column(
          children: [
            _itemBudget('Makan & Jajan', 'Rp 2.500.000'),
            _itemBudget('Bensin & Ojol', 'Rp 800.000'),
            _itemBudget('Tagihan Rumah', 'Rp 1.200.000'),
            _itemBudget('Tabungan Darurat', 'Rp 500.000'),
          ],
        ),
      ),
    );
  }

  Widget _itemBudget(String kategori, String limit) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(
          kategori,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Batas Bulanan: $limit'),
        trailing: const Icon(Icons.edit_outlined),
      ),
    );
  }
}
