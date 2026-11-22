import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/app_data.dart';
import '../models/budget.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/app_bar_turunan.dart';
import '../widgets/baris_budget.dart';
import '../widgets/dialog_konfirmasi_hapus.dart';
import '../widgets/judul_seksi.dart';
import '../widgets/sheet_tambah_budget.dart';
import '../widgets/tombol_pill.dart';
import '../widgets/tombol_utama.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buatAppBarTurunan('Budget'),
      body: ValueListenableBuilder<int>(
        valueListenable: AppData.refreshNotifier,
        builder: (context, nilai, child) {
          return ListView(
            children: [
              _tepi(_bangunAnggaran()),
              const SizedBox(height: JarakApp.j16),
              Container(height: 8, color: WarnaApp.latarSeksi),
              _tepi(_bangunDaftar()),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(JarakApp.tepiHalaman),
          child: TombolUtama(
            teks: 'Tambah kategori budget',
            onTekan: _bukaTambah,
          ),
        ),
      ),
    );
  }

  Widget _tepi(Widget isi) => Padding(
    padding: const EdgeInsets.fromLTRB(
      JarakApp.tepiHalaman,
      JarakApp.j16,
      JarakApp.tepiHalaman,
      0,
    ),
    child: isi,
  );

  Widget _bangunAnggaran() {
    int anggaran = AppData.anggaranBulanan;
    int totalLimit = AppData.totalLimitBudget();
    int sisa = anggaran - totalLimit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Anggaran bulanan', style: TeksApp.kecil),
        const SizedBox(height: JarakApp.j4),
        Row(
          children: [
            Expanded(
              child: Text(formatRupiah(anggaran), style: TeksApp.angkaBesar),
            ),
            TombolPill(
              teks: 'Ubah',
              kecil: true,
              onTekan: () => _bukaSheetNominal(
                judul: 'Anggaran bulanan',
                nilaiAwal: anggaran,
                onSimpan: AppData.ubahAnggaran,
              ),
            ),
          ],
        ),
        const SizedBox(height: JarakApp.j8),
        Text.rich(
          TextSpan(
            style: TeksApp.kecil,
            children: [
              TextSpan(
                text:
                    'Dialokasikan ${formatRupiah(totalLimit)} · Belum dialokasikan ',
              ),
              TextSpan(
                text: formatRupiah(sisa),
                style: TeksApp.kecil.copyWith(
                  color: sisa < 0 ? WarnaApp.bahaya : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bangunDaftar() {
    List<BudgetItem> daftar = AppData.daftarBudget;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const JudulSeksi(judul: 'Per kategori'),
        const SizedBox(height: JarakApp.j4),
        if (daftar.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: JarakApp.j16),
            child: Text('Belum ada kategori budget', style: TeksApp.kecil),
          ),
        for (int i = 0; i < daftar.length; i++) ...[
          if (i > 0) const Divider(height: 1),
          BarisBudget(
            budget: daftar[i],
            onTekan: () => _bukaSheetNominal(
              judul: daftar[i].kategori,
              nilaiAwal: daftar[i].limit,
              onSimpan: (limit) => AppData.ubahLimitBudget(daftar[i], limit),
              budgetDihapus: daftar[i],
            ),
          ),
        ],
      ],
    );
  }

  Widget _bangunIsiSheet(BuildContext context, List<Widget> isi) {
    return Padding(
      // viewInsets.bottom = tinggi keyboard, supaya isian tidak tertutup.
      padding: EdgeInsets.fromLTRB(
        JarakApp.tepiHalaman,
        JarakApp.j24,
        JarakApp.tepiHalaman,
        JarakApp.j24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: isi,
      ),
    );
  }

  Widget _bangunIsianNominal(int nilaiAwal, ValueChanged<int> onUbah) {
    return TextFormField(
      initialValue: nilaiAwal > 0 ? '$nilaiAwal' : '',
      decoration: const InputDecoration(hintText: 'Nominal'),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      onChanged: (v) => onUbah(int.tryParse(v) ?? 0),
    );
  }

  // Dipakai untuk ubah anggaran dan ubah limit; budgetDihapus diisi kalau perlu tombol hapus.
  void _bukaSheetNominal({
    required String judul,
    required int nilaiAwal,
    required ValueChanged<int> onSimpan,
    BudgetItem? budgetDihapus,
  }) {
    int nominal = nilaiAwal;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheet) => _bangunIsiSheet(context, [
          Text(judul, style: TeksApp.judulHalaman),
          const SizedBox(height: JarakApp.j16),
          _bangunIsianNominal(nilaiAwal, (v) => setSheet(() => nominal = v)),
          const SizedBox(height: JarakApp.j24),
          TombolUtama(
            teks: 'Simpan',
            onTekan: nominal > 0
                ? () {
                    onSimpan(nominal);
                    Navigator.pop(context);
                  }
                : null,
          ),
          if (budgetDihapus != null) ...[
            const SizedBox(height: JarakApp.j8),
            TextButton(
              onPressed: () => _hapusBudget(budgetDihapus, context),
              child: Text(
                'Hapus kategori',
                style: TeksApp.tombolKecil.copyWith(color: WarnaApp.bahaya),
              ),
            ),
          ],
        ]),
      ),
    );
  }

  Future<void> _hapusBudget(
    BudgetItem budget,
    BuildContext konteksSheet,
  ) async {
    final navigator = Navigator.of(konteksSheet);
    bool? hapus = await showDialog<bool>(
      context: context,
      builder: (context) =>
          DialogKonfirmasiHapus(judul: 'Hapus budget ${budget.kategori}?'),
    );
    if (hapus != true) return;
    AppData.hapusBudget(budget);
    navigator.pop();
  }

  void _bukaTambah() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const SheetTambahBudget(),
    );
  }
}
