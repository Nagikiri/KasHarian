import 'package:flutter/material.dart';

class UtangScreen extends StatelessWidget {
  const UtangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double x = w * 0.05;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text(
          'Daftar Utang & Piutang',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: x, vertical: 16),
        child: Column(
          children: [
            _itemUtang('Budi', 'Nalangin Makan Siang', '+Rp 50.000', true),
            _itemUtang('Rian', 'Tiket Bioskop', '+Rp 85.000', true),
            _itemUtang('Dimas', 'Patungan Kafe', '-Rp 120.000', false),
          ],
        ),
      ),
    );
  }

  Widget _itemUtang(String nama, String ket, String nominal, bool isPiutang) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(
          '$nama (${isPiutang ? 'Piutang' : 'Utang'})',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(ket),
        trailing: Text(
          nominal,
          style: TextStyle(
            color: isPiutang ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
