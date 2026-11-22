import 'package:flutter/material.dart';

import '../main.dart';
import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'budget_screen.dart';
import 'utang_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _offsetHari = 0;
  bool _saldoDisembunyikan = false;

  final List<_KantongData> _daftarKantong = [
    _KantongData(
      Icons.restaurant_outlined,
      'Makan & Jajan',
      '1.250.000',
      '2.500.000',
      0.5,
      Colors.green,
    ),
    _KantongData(
      Icons.local_gas_station_outlined,
      'Bensin & Ojol',
      '680.000',
      '800.000',
      0.85,
      Colors.orange,
    ),
    _KantongData(
      Icons.receipt_long_outlined,
      'Tagihan Rumah',
      '1.100.000',
      '1.200.000',
      0.91,
      Colors.red,
    ),
    _KantongData(
      Icons.savings_outlined,
      'Tabungan',
      '420.000',
      '500.000',
      0.84,
      Colors.teal,
    ),
  ];

  final List<_UtangData> _daftarUtang = [
    _UtangData('BS', 'Budi', true, 'Nalangin Makan Siang', '+Rp 50.000'),
    _UtangData('RA', 'Rian', true, 'Tiket Bioskop', '+Rp 85.000'),
    _UtangData('DP', 'Dimas', false, 'Patungan Kafe', '-Rp 120.000'),
  ];

  String get _sapaan {
    final jam = DateTime.now().hour;
    if (jam < 11) return 'Pagi';
    if (jam < 15) return 'Siang';
    if (jam < 18) return 'Sore';
    return 'Malam';
  }

  String _formatBulanTahun(DateTime tanggal) {
    const bulan = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${bulan[tanggal.month - 1]} ${tanggal.year}';
  }

  void _tampilkanNantiYa() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Nanti Ya')));
  }

  DateTime get _tanggalAktif {
    final skr = DateTime.now();
    return DateTime(
      skr.year,
      skr.month,
      skr.day,
    ).subtract(Duration(days: _offsetHari));
  }

  String _formatTanggalHeader(DateTime dt) {
    const bulan = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    const hari = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return '${dt.day} ${bulan[dt.month - 1]}   ${hari[dt.weekday - 1]}';
  }

  String _formatLabelNav(DateTime dt) {
    const bulan = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${dt.day} ${bulan[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double x = w * 0.05;

    return ValueListenableBuilder<int>(
      valueListenable: AppData.refreshNotifier,
      builder: (context, _, _) {
        return Scaffold(
          backgroundColor: bgGray,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(x, 20, x, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildSaldoCard(),
                  const SizedBox(height: 24),
                  _buildKursSection(),
                  const SizedBox(height: 24),
                  _buildRingkasanBulan(),
                  const SizedBox(height: 24),
                  _buildKantongAlokasi(context),
                  const SizedBox(height: 24),
                  _buildCatatanHarian(),
                  const SizedBox(height: 24),
                  _buildUtangPiutang(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Semangat $_sapaan, Dimas!',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 4),
            const Text(
              'Catatan Keuangan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        InkWell(
          onTap: _tampilkanNantiYa,
          child: Icon(Icons.notifications_none, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _buildSaldoCard() {
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
              const Text(
                'TOTAL SALDO TERSEDIA',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () =>
                    setState(() => _saldoDisembunyikan = !_saldoDisembunyikan),
                child: Icon(
                  _saldoDisembunyikan
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _saldoDisembunyikan
                ? 'Rp ••••••'
                : 'Rp ${formatTitik(AppData.saldoTersedia)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_downward,
                        color: Color(0xFF86EFAC),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pemasukan',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              '+Rp ${formatTitik(AppData.totalPemasukan)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_upward,
                        color: Color(0xFFFCA5A5),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pengeluaran',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              '-Rp ${formatTitik(AppData.totalPengeluaran)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKursSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardDecoration,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Row(
                  children: [
                    Icon(Icons.currency_exchange, size: 18, color: Colors.teal),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Pantau Mata Uang',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: _tampilkanNantiYa,
                  child: const Text(
                    '+ Tambah Kurs',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildKursChip('USD', '15.654', '+ 0.12%', Colors.green),
                _buildKursChip('SGD', '11.642', '^ 0.08%', Colors.green),
                _buildKursChip('JPY', '104.2', '- 0.05%', Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKursChip(
    String currency,
    String amount,
    String pct,
    Color pctColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            currency,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(width: 8),
          Text(amount, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 8),
          Icon(
            pct.startsWith('-') ? Icons.trending_down : Icons.trending_up,
            color: pctColor,
            size: 15,
          ),
          const SizedBox(width: 2),
          Text(
            pct.substring(1).trim(),
            style: TextStyle(
              color: pctColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRingkasanBulan() {
    int selisih = AppData.totalPemasukan - AppData.totalPengeluaran;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardDecoration,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    _formatBulanTahun(DateTime.now()),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  InkWell(
                    onTap: _tampilkanNantiYa,
                    child: const Icon(Icons.keyboard_arrow_down, size: 20),
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: _tampilkanNantiYa,
                    child: Icon(
                      Icons.search,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: _tampilkanNantiYa,
                    child: Icon(
                      Icons.calendar_month,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildStatItem(
                  'Pengeluaran',
                  'Rp ${formatTitik(AppData.totalPengeluaran)}',
                  Colors.red,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Pemasukan',
                  'Rp ${formatTitik(AppData.totalPemasukan)}',
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Selisih Bulan Ini',
                  '${selisih >= 0 ? '+' : '-'}Rp ${formatTitik(selisih)}',
                  Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            amount,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
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
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kantong Alokasi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '${_daftarKantong.length} Kategori Aktif',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  buatTransisiHalaman(const BudgetScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add, size: 14, color: Colors.black87),
                    SizedBox(width: 4),
                    Text(
                      'Kategori Baru',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: [
            ..._daftarKantong.map(
              (item) => _buildKantongCard(
                item.icon,
                item.title,
                item.spent,
                item.total,
                item.progress,
                item.color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKantongCard(
    IconData icon,
    String title,
    String spent,
    String total,
    double progress,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: cardDecoration,
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
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Rp $spent / $total',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                ),
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

  Widget _buildCatatanHarian() {
    final tgl = _tanggalAktif;
    final daftarHariIni = AppData.daftarTransaksi.where((t) {
      return t.tanggal.year == tgl.year &&
          t.tanggal.month == tgl.month &&
          t.tanggal.day == tgl.day;
    }).toList();

    int totalKeluarHariIni = 0;
    for (var item in daftarHariIni) {
      if (!item.isPemasukan) totalKeluarHariIni += item.nominal;
    }

    final tglKemarin = tgl.subtract(const Duration(days: 1));
    final tglBesok = tgl.add(const Duration(days: 1));

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        if (details.primaryVelocity! > 0) {
          setState(() => _offsetHari++);
        } else if (details.primaryVelocity! < 0 && _offsetHari > 0) {
          setState(() => _offsetHari--);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: cardDecoration,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTanggalHeader(tgl),
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Pengeluaran: ${formatTitik(totalKeluarHariIni)}',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1),
            ),
            if (daftarHariIni.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'Belum ada catatan transaksi di tanggal ini',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: daftarHariIni.length,
                separatorBuilder: (context, index) => const Divider(height: 20),
                itemBuilder: (context, index) {
                  final item = daftarHariIni[index];
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: item.warna,
                        child: Icon(item.ikon, color: Colors.black87, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.kategori,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            if (item.catatan != item.kategori)
                              Text(
                                item.catatan,
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Text(
                        '${item.isPemasukan ? '+' : '-'}${formatTitik(item.nominal)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: item.isPemasukan
                              ? Colors.green
                              : Colors.black87,
                        ),
                      ),
                    ],
                  );
                },
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => setState(() => _offsetHari++),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatLabelNav(tglKemarin),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Icon(Icons.chevron_left, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (_offsetHari > 0)
                  InkWell(
                    onTap: () => setState(() => _offsetHari--),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.chevron_right, size: 18),
                          Text(
                            _formatLabelNav(tglBesok),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUtangPiutang(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardDecoration,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Flexible(
                      child: Text(
                        'Utang & Piutang Teman',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_daftarUtang.length} Aktif',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    buatTransisiHalaman(const UtangScreen()),
                  );
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Lihat Semua',
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.teal, size: 18),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._buildUtangRows(),
        ],
      ),
    );
  }

  List<Widget> _buildUtangRows() {
    return _daftarUtang
        .asMap()
        .entries
        .map(
          (entry) => <Widget>[
            if (entry.key > 0)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 1),
              ),
            _buildUtangTile(
              entry.value.initials,
              entry.value.name,
              entry.value.isPiutang,
              entry.value.description,
              entry.value.amount,
            ),
          ],
        )
        .expand((widgets) => widgets)
        .toList();
  }

  Widget _buildUtangTile(
    String initials,
    String name,
    bool isPiutang,
    String desc,
    String amount,
  ) {
    Color typeColor = isPiutang ? Colors.green : Colors.red;
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: typeColor.withValues(alpha: 0.1),
          radius: 20,
          child: Text(
            initials,
            style: TextStyle(
              color: typeColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: typeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isPiutang ? 'PIUTANG' : 'UTANG',
                      style: TextStyle(
                        color: typeColor,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                desc,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              amount,
              style: TextStyle(
                color: typeColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: typeColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            isPiutang ? 'Lunas' : 'Bayar',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _KantongData {
  final IconData icon;
  final String title;
  final String spent;
  final String total;
  final double progress;
  final Color color;

  const _KantongData(
    this.icon,
    this.title,
    this.spent,
    this.total,
    this.progress,
    this.color,
  );
}

class _UtangData {
  final String initials;
  final String name;
  final bool isPiutang;
  final String description;
  final String amount;

  const _UtangData(
    this.initials,
    this.name,
    this.isPiutang,
    this.description,
    this.amount,
  );
}
