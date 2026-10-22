import 'package:flutter/material.dart';

import '../models/app_data.dart';

class PengaturanKategoriScreen extends StatefulWidget {
  const PengaturanKategoriScreen({super.key});

  @override
  State<PengaturanKategoriScreen> createState() =>
      _PengaturanKategoriScreenState();
}

class _PengaturanKategoriScreenState extends State<PengaturanKategoriScreen> {
  final Color primaryGreen = const Color(0xFF14532D);
  final Color bgGray = const Color(0xFFF1F5F9);
  int _tabIndex = 0;

  void _dialogTambahKategori() {
    final TextEditingController namaCtrl = TextEditingController();
    IconData ikonPilihan = Icons.fastfood_outlined;
    final List<IconData> opsiIkon = [
      Icons.fastfood_outlined,
      Icons.local_cafe_outlined,
      Icons.sports_esports_outlined,
      Icons.movie_outlined,
      Icons.fitness_center_outlined,
      Icons.pets_outlined,
      Icons.shopping_bag_outlined,
      Icons.account_balance_outlined,
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(
                'Tambah Kategori Baru',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: namaCtrl,
                    decoration: InputDecoration(
                      labelText: 'Nama Kategori',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: opsiIkon.map((ic) {
                      bool dipilih = ikonPilihan == ic;
                      return InkWell(
                        onTap: () => setDialogState(() => ikonPilihan = ic),
                        child: CircleAvatar(
                          backgroundColor: dipilih ? primaryGreen : bgGray,
                          child: Icon(
                            ic,
                            color: dipilih ? Colors.white : Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (namaCtrl.text.trim().isNotEmpty) {
                      AppData.tambahKategori(
                        KategoriItem(
                          nama: namaCtrl.text.trim(),
                          ikon: ikonPilihan,
                          warna: primaryGreen,
                          isPemasukan: _tabIndex == 1,
                          isTransfer: _tabIndex == 2,
                        ),
                      );
                      setState(() {});
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = AppData.daftarKategori.where((k) {
      if (_tabIndex == 1) return k.isPemasukan;
      if (_tabIndex == 2) return k.isTransfer;
      return !k.isPemasukan && !k.isTransfer;
    }).toList();

    return Scaffold(
      backgroundColor: bgGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: const Text(
          'Pengaturan Kategori',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _tabBtn('Pengeluaran', 0),
                  _tabBtn('Pemasukan', 1),
                  _tabBtn('Transfer', 2),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: item.warna.withValues(alpha: 0.12),
                      child: Icon(item.ikon, color: item.warna, size: 20),
                    ),
                    title: Text(
                      item.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      onPressed: () =>
                          setState(() => AppData.hapusKategori(item)),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _dialogTambahKategori,
                child: const Text(
                  '+ Tambah Kategori Baru',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabBtn(String judul, int idx) {
    bool aktif = _tabIndex == idx;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _tabIndex = idx),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: aktif ? primaryGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            judul,
            style: TextStyle(
              color: aktif ? Colors.white : Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
