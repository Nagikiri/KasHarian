import 'package:flutter/material.dart';

import '../main.dart';
import '../models/app_data.dart';
import 'budget_screen.dart';

class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  final Color primaryGreen = const Color(0xFF14532D);
  final Color bgGray = const Color(0xFFF1F5F9);
  int _filterIndex = 0;
  String _kataKunci = '';
  int _indexTips = 0;

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

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double x = w * 0.05;

    return ValueListenableBuilder<int>(
      valueListenable: AppData.refreshNotifier,
      builder: (context, _, __) {
        int targetBulanan = 5000000;
        int terpakai = AppData.totalPengeluaran;
        int sisa = targetBulanan - terpakai;
        if (sisa < 0) sisa = 0;
        double rasio = (terpakai / targetBulanan).clamp(0.0, 1.0);

        final daftarFilter = AppData.daftarTransaksi.where((t) {
          if (_filterIndex == 1 && (t.isPemasukan || t.isTransfer))
            return false;
          if (_filterIndex == 2 && !t.isPemasukan) return false;
          if (_filterIndex == 3 && !t.isTransfer) return false;
          if (_kataKunci.isNotEmpty) {
            bool cocokNama = t.catatan.toLowerCase().contains(
              _kataKunci.toLowerCase(),
            );
            bool cocokKat = t.kategori.toLowerCase().contains(
              _kataKunci.toLowerCase(),
            );
            return cocokNama || cocokKat;
          }
          return true;
        }).toList();

        return Scaffold(
          backgroundColor: bgGray,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(x, 20, x, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTargetCard(targetBulanan, terpakai, sisa, rasio),
                  const SizedBox(height: 20),
                  _buildAkumulasiBulanan(),
                  const SizedBox(height: 20),
                  _buildKantongAlokasi(context),
                  const SizedBox(height: 20),
                  _buildPencarianDanFilter(),
                  const SizedBox(height: 16),
                  _buildDaftarTransaksi(daftarFilter),
                  const SizedBox(height: 20),
                  _buildTipsCard(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTargetCard(int target, int terpakai, int sisa, double rasio) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Perhitungan Oktober 2026',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  buatTransisiHalaman(const BudgetScreen()),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Ubah Target',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'TARGET ALOKASI BULANAN',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Rp ${formatTitik(target)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          LinearProgressIndicator(
            value: rasio,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
            minHeight: 8,
            borderRadius: BorderRadius.circular(6),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Terpakai: Rp ${formatTitik(terpakai)} (${(rasio * 100).toInt()}%)',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Sisa: Rp ${formatTitik(sisa)}',
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAkumulasiBulanan() {
    int selisih = AppData.totalPemasukan - AppData.totalPengeluaran;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDeco,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Akumulasi Kas Bulan Ini',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _kolomStat(
                'Total Pemasukan',
                '+Rp ${formatTitik(AppData.totalPemasukan)}',
                Colors.green,
              ),
              _kolomStat(
                'Total Pengeluaran',
                '-Rp ${formatTitik(AppData.totalPengeluaran)}',
                Colors.red,
              ),
              _kolomStat(
                'Selisih Bersih',
                'Rp ${formatTitik(selisih)}',
                primaryGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kolomStat(String label, String nilai, Color warna) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
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

  Widget _buildKantongAlokasi(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kantong Alokasi',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '4 Kategori Aktif',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
            InkWell(
              onTap: () => Navigator.push(
                context,
                buatTransisiHalaman(const BudgetScreen()),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '+ Kategori Baru',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: [
            _kartuKantong(
              Icons.restaurant,
              'Makan & Jajan',
              '1.250.000',
              '2.500.000',
              0.50,
              Colors.green,
            ),
            _kartuKantong(
              Icons.local_gas_station,
              'Bensin & Ojol',
              '680.000',
              '800.000',
              0.85,
              Colors.orange,
            ),
            _kartuKantong(
              Icons.receipt_long,
              'Tagihan Rumah',
              '1.100.000',
              '1.200.000',
              0.91,
              Colors.red,
            ),
            _kartuKantong(
              Icons.savings,
              'Tabungan Darurat',
              '420.000',
              '500.000',
              0.84,
              Colors.teal,
            ),
          ],
        ),
      ],
    );
  }

  Widget _kartuKantong(
    IconData icon,
    String title,
    String spent,
    String total,
    double progress,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDeco,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                'Rp $spent / $total',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 5,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPencarianDanFilter() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: _cardDeco,
          child: TextField(
            onChanged: (val) => setState(() => _kataKunci = val),
            decoration: const InputDecoration(
              icon: Icon(Icons.search, color: Colors.grey, size: 20),
              hintText: 'Cari transaksi atau catatan...',
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _chipFilter('Semua', 0),
              _chipFilter('Pengeluaran', 1),
              _chipFilter('Pemasukan', 2),
              _chipFilter('Transfer', 3),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chipFilter(String label, int idx) {
    bool aktif = _filterIndex == idx;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => setState(() => _filterIndex = idx),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: aktif ? primaryGreen : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: aktif ? Colors.white : Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDaftarTransaksi(List<CatatanTransaksi> daftar) {
    if (daftar.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: _cardDeco,
        alignment: Alignment.center,
        child: const Text(
          'Tidak ada transaksi yang sesuai filter',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      );
    }

    return Column(
      children: daftar.map((item) {
        Color warnaNominal = Colors.red;
        String tanda = '-';
        if (item.isPemasukan) {
          warnaNominal = Colors.green;
          tanda = '+';
        } else if (item.isTransfer) {
          warnaNominal = Colors.teal;
          tanda = '';
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: _cardDeco,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: item.warna.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.ikon, color: item.warna, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.catatan,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.kategori} • ${item.tanggal.day}/${item.tanggal.month}/${item.tanggal.year}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${tanda}Rp ${formatTitik(item.nominal)}',
                    style: TextStyle(
                      color: warnaNominal,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.sumberDana,
                    style: const TextStyle(
                      color: Colors.teal,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTipsCard() {
    return InkWell(
      onTap: () {
        setState(() {
          _indexTips = (_indexTips + 1) % AppData.tipsKeuangan.length;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F2FE),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: primaryGreen,
              radius: 18,
              child: const Icon(
                Icons.lightbulb_outline,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tips Keuangan Harian',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Ketuk ganti (${_indexTips + 1}/${AppData.tipsKeuangan.length})',
                        style: TextStyle(
                          fontSize: 10,
                          color: primaryGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppData.tipsKeuangan[_indexTips],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
