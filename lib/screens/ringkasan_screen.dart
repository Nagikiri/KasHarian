import 'package:flutter/material.dart';

import '../models/app_data.dart';

class RingkasanScreen extends StatefulWidget {
  const RingkasanScreen({super.key});

  @override
  State<RingkasanScreen> createState() => _RingkasanScreenState();
}

class _RingkasanScreenState extends State<RingkasanScreen> {
  final Color primaryGreen = const Color(0xFF14532D);
  final Color bgGray = const Color(0xFFF1F5F9);

  int _periodeIndex = 1;
  final TextEditingController _pesanCtrl = TextEditingController();
  final List<Map<String, String>> _riwayatChat = [];

  BoxDecoration get _cardDeco => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  void _kirimPesan() {
    String teks = _pesanCtrl.text.trim();
    if (teks.isEmpty) return;
    setState(() {
      _riwayatChat.add({'pengirim': 'user', 'isi': teks});
      _pesanCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double x = w * 0.05;

    return ValueListenableBuilder<int>(
      valueListenable: AppData.refreshNotifier,
      builder: (context, _, __) {
        int masuk = AppData.totalPemasukan;
        int keluar = AppData.totalPengeluaran;
        int surplus = masuk - keluar;
        int anggaranBulanan = 5000000;
        int sisaAnggaran = (anggaranBulanan - keluar).clamp(0, anggaranBulanan);
        double rasioAnggaran = (keluar / anggaranBulanan).clamp(0.0, 1.0);

        return Scaffold(
          backgroundColor: bgGray,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(x, 20, x, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterPeriode(),
                  const SizedBox(height: 16),
                  _buildKartuSurplus(masuk, keluar, surplus),
                  const SizedBox(height: 16),
                  _buildAnggaranDonutCard(
                    anggaranBulanan,
                    keluar,
                    sisaAnggaran,
                    rasioAnggaran,
                  ),
                  const SizedBox(height: 16),
                  _buildDistribusiPengeluaran(),
                  const SizedBox(height: 16),
                  _buildChatbotCard(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterPeriode() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _tabPeriode('Pekan', 0),
          _tabPeriode('Bulan', 1),
          _tabPeriode('Tahun', 2),
        ],
      ),
    );
  }

  Widget _tabPeriode(String label, int idx) {
    bool aktif = _periodeIndex == idx;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _periodeIndex = idx),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: aktif ? primaryGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: aktif ? Colors.white : Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKartuSurplus(int masuk, int keluar, int surplus) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDeco,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 18,
                    color: Colors.black87,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Oktober 2026',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Arus Kas Sehat',
                  style: TextStyle(
                    color: primaryGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: bgGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pemasukan',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp ${formatTitik(masuk)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: bgGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pengeluaran',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp ${formatTitik(keluar)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: primaryGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sisa Surplus Bersih',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                    Text(
                      '+Rp ${formatTitik(surplus)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Alokasi Aman',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnggaranDonutCard(
    int anggaran,
    int keluar,
    int sisa,
    double rasio,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDeco,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Anggaran & Proporsi Bulanan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 96,
                height: 96,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: rasio,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryGreen),
                    ),
                    Center(
                      child: Text(
                        '${(rasio * 100).toInt()}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _barisAnggaran(
                      'Tersisa',
                      'Rp ${formatTitik(sisa)}',
                      primaryGreen,
                    ),
                    const Divider(height: 14),
                    _barisAnggaran(
                      'Anggaran',
                      'Rp ${formatTitik(anggaran)}',
                      Colors.black87,
                    ),
                    const SizedBox(height: 6),
                    _barisAnggaran(
                      'Pengeluaran',
                      'Rp ${formatTitik(keluar)}',
                      Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _barisAnggaran(String label, String nilai, Color warna) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label :',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        Text(
          nilai,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: warna,
          ),
        ),
      ],
    );
  }

  Widget _buildDistribusiPengeluaran() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDeco,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Distribusi Pengeluaran',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            '4 Kategori Utama Terbesar',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Row(
              children: [
                Expanded(
                  flex: 36,
                  child: Container(height: 10, color: primaryGreen),
                ),
                Expanded(
                  flex: 32,
                  child: Container(height: 10, color: Colors.teal),
                ),
                Expanded(
                  flex: 20,
                  child: Container(height: 10, color: Colors.orange),
                ),
                Expanded(
                  flex: 12,
                  child: Container(height: 10, color: Colors.greenAccent),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.2,
            children: [
              _kotakDistribusi(
                Icons.restaurant,
                'Makan & Minum',
                '36%',
                'Rp 1.250.000',
                primaryGreen,
              ),
              _kotakDistribusi(
                Icons.receipt_long,
                'Tagihan Rumah',
                '32%',
                'Rp 1.100.000',
                Colors.teal,
              ),
              _kotakDistribusi(
                Icons.local_gas_station,
                'Transportasi',
                '20%',
                'Rp 680.000',
                Colors.orange,
              ),
              _kotakDistribusi(
                Icons.coffee,
                'Hiburan & Kopi',
                '12%',
                'Rp 420.000',
                Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kotakDistribusi(
    IconData icon,
    String nama,
    String pct,
    String nominal,
    Color warna,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: warna, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$nama ($pct)',
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  nominal,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatbotCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDeco,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: primaryGreen,
                radius: 16,
                child: const Icon(
                  Icons.smart_toy_outlined,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Asisten Keuangan AI',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    'Konsultasi pengeluaran & saran alokasi kas',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 24),
          if (_riwayatChat.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
              decoration: BoxDecoration(
                color: bgGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.grey.shade400,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Belum ada percakapan.\nKetik pertanyaan di bawah untuk meminta ringkasan keuangan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: _riwayatChat.map((pesan) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: primaryGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      pesan['isi'] ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: bgGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _pesanCtrl,
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Tanyakan analisis keuanganmu...',
                      hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _kirimPesan,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.send, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
