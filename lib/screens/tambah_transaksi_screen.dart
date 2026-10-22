import 'package:flutter/material.dart';

import '../main.dart';
import '../models/app_data.dart';
import 'pengaturan_kategori_screen.dart';

class TambahTransaksiScreen extends StatefulWidget {
  const TambahTransaksiScreen({super.key});

  @override
  State<TambahTransaksiScreen> createState() => _TambahTransaksiScreenState();
}

class _TambahTransaksiScreenState extends State<TambahTransaksiScreen> {
  final Color primaryGreen = const Color(0xFF14532D);
  final Color bgGray = const Color(0xFFF1F5F9);

  int _tabIndex = 0;
  KategoriItem? _kategoriTerpilih;
  int _nominal = 0;
  DateTime _tanggalTerpilih = DateTime.now();
  String _sumberDana = 'Kantong Utama';
  final TextEditingController _catatanCtrl = TextEditingController();

  final List<String> _daftarSumber = [
    'Kantong Utama',
    'Rekening Bank',
    'Saku QRIS',
    'Dompet Tunai',
  ];

  List<KategoriItem> get _kategoriFilter {
    if (_tabIndex == 1) {
      return AppData.daftarKategori.where((k) => k.isPemasukan).toList();
    } else if (_tabIndex == 2) {
      return AppData.daftarKategori.where((k) => k.isTransfer).toList();
    }
    return AppData.daftarKategori
        .where((k) => !k.isPemasukan && !k.isTransfer)
        .toList();
  }

  void _tekanNumpad(String nilai) {
    setState(() {
      if (nilai == 'BACK') {
        String s = _nominal.toString();
        if (s.length > 1) {
          _nominal = int.parse(s.substring(0, s.length - 1));
        } else {
          _nominal = 0;
        }
      } else if (nilai == '000') {
        if (_nominal > 0 && _nominal <= 999999) {
          _nominal = _nominal * 1000;
        }
      } else {
        String s = _nominal == 0 ? nilai : '$_nominal$nilai';
        if (s.length <= 10) {
          _nominal = int.parse(s);
        }
      }
    });
  }

  void _tambahCepat(int tambahan) {
    setState(() {
      _nominal += tambahan;
    });
  }

  Future<void> _pilihTanggal() async {
    DateTime? hasil = await showDatePicker(
      context: context,
      initialDate: _tanggalTerpilih,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (hasil != null) {
      setState(() => _tanggalTerpilih = hasil);
    }
  }

  void _simpanTransaksi() {
    final daftar = _kategoriFilter;
    final kat = _kategoriTerpilih ?? (daftar.isNotEmpty ? daftar.first : null);
    if (kat == null || _nominal <= 0) return;

    AppData.tambahTransaksi(
      CatatanTransaksi(
        kategori: kat.nama,
        catatan: _catatanCtrl.text.trim().isEmpty
            ? kat.nama
            : _catatanCtrl.text.trim(),
        nominal: _nominal,
        ikon: kat.ikon,
        warna: kat.warna,
        tanggal: _tanggalTerpilih,
        isPemasukan: _tabIndex == 1,
        isTransfer: _tabIndex == 2,
        sumberDana: _sumberDana,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final daftar = _kategoriFilter;
    _kategoriTerpilih ??= daftar.isNotEmpty ? daftar.first : null;

    String labelHeaderNominal = 'NOMINAL PENGELUARAN';
    if (_tabIndex == 1) labelHeaderNominal = 'NOMINAL PEMASUKAN';
    if (_tabIndex == 2) labelHeaderNominal = 'NOMINAL TRANSFER BANK';

    return Scaffold(
      backgroundColor: bgGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Catat Transaksi',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  _tabItem('Keluar', Icons.north_east, 0, Colors.red),
                  _tabItem('Masuk', Icons.south_west, 1, Colors.green),
                  _tabItem(
                    'Transfer',
                    Icons.account_balance_outlined,
                    2,
                    Colors.teal,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: primaryGreen.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      labelHeaderNominal,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Rp ${formatTitik(_nominal)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _chipTambah('+10 rb', () => _tambahCepat(10000)),
                      const SizedBox(width: 8),
                      _chipTambah('+50 rb', () => _tambahCepat(50000)),
                      const SizedBox(width: 8),
                      _chipTambah('+100 rb', () => _tambahCepat(100000)),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => setState(() => _nominal = 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              color: Color(0xFFB91C1C),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(children: [_btnNum('1'), _btnNum('2'), _btnNum('3')]),
                  const SizedBox(height: 8),
                  Row(children: [_btnNum('4'), _btnNum('5'), _btnNum('6')]),
                  const SizedBox(height: 8),
                  Row(children: [_btnNum('7'), _btnNum('8'), _btnNum('9')]),
                  const SizedBox(height: 8),
                  Row(children: [_btnNum('000'), _btnNum('0'), _btnHapus()]),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _tabIndex == 0
                            ? 'Kategori Pengeluaran'
                            : (_tabIndex == 1
                                  ? 'Kategori Pemasukan'
                                  : 'Kategori Transfer Bank'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        'Wajib Dipilih',
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.95,
                        ),
                    itemCount: daftar.length + 1,
                    itemBuilder: (context, index) {
                      if (index == daftar.length) {
                        return InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              buatTransisiHalaman(
                                const PengaturanKategoriScreen(),
                              ),
                            );
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: bgGray,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.more_horiz,
                                  color: Colors.black54,
                                  size: 22,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Lainnya',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final item = daftar[index];
                      final bool aktif = _kategoriTerpilih?.nama == item.nama;

                      return InkWell(
                        onTap: () => setState(() => _kategoriTerpilih = item),
                        child: Container(
                          decoration: BoxDecoration(
                            color: aktif ? const Color(0xFFDCFCE7) : bgGray,
                            borderRadius: BorderRadius.circular(12),
                            border: aktif
                                ? Border.all(color: primaryGreen, width: 1.5)
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                item.ikon,
                                color: aktif ? primaryGreen : Colors.black54,
                                size: 22,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.nama,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: aktif
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: aktif ? primaryGreen : Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: bgGray,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryGreen,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'SUMBER DANA',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                _sumberDana,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (val) =>
                              setState(() => _sumberDana = val),
                          itemBuilder: (context) => _daftarSumber
                              .map(
                                (s) => PopupMenuItem(value: s, child: Text(s)),
                              )
                              .toList(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rp ${formatTitik(AppData.saldoTersedia)}',
                                style: TextStyle(
                                  color: primaryGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const Row(
                                children: [
                                  Text(
                                    'Ganti',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: bgGray,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _catatanCtrl,
                      style: const TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.edit_note,
                          color: Colors.grey,
                          size: 20,
                        ),
                        hintText: 'Tulis catatan transaksi...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: _pilihTanggal,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: bgGray,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                                color: Colors.black54,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Tanggal: ${_tanggalTerpilih.day}/${_tanggalTerpilih.month}/${_tanggalTerpilih.year}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Ubah Tanggal',
                            style: TextStyle(
                              fontSize: 11,
                              color: primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _simpanTransaksi,
                icon: const Icon(Icons.check_circle_outline, size: 20),
                label: const Text(
                  'Simpan Transaksi',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(String label, IconData icon, int index, Color activeColor) {
    bool aktif = _tabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _tabIndex = index;
            _kategoriTerpilih = null;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: aktif ? bgGray : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(icon, size: 16, color: aktif ? activeColor : Colors.grey),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: aktif ? FontWeight.bold : FontWeight.normal,
                  color: aktif ? Colors.black87 : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chipTambah(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _btnNum(String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: () => _tekanNumpad(label),
          child: Container(
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bgGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _btnHapus() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: () => _tekanNumpad('BACK'),
          child: Container(
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.backspace_outlined,
              color: Color(0xFFB91C1C),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
