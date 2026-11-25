import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';

// Kartu hijau Beranda. Angka sudah diformat (dan disembunyikan) oleh pemanggil.
class KartuSaldo extends StatelessWidget {
  final String saldo;
  final String pemasukan;
  final String pengeluaran;
  final bool disembunyikan;
  final VoidCallback onMata;
  // Ketuk area kartu membuka halaman Dompet. Tombol mata punya GestureDetector sendiri, jadi tetap hanya menyembunyikan.
  final VoidCallback onTekan;
  final int jumlahDompet;

  const KartuSaldo({
    super.key,
    required this.saldo,
    required this.pemasukan,
    required this.pengeluaran,
    required this.disembunyikan,
    required this.onMata,
    required this.onTekan,
    required this.jumlahDompet,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle labelRedup = TeksApp.kecil.copyWith(
      color: WarnaApp.diAtasPrimerRedup,
    );

    BorderRadius sudut = BorderRadius.circular(RadiusApp.kartuSaldo);
    // Material + InkWell supaya efek ketuk terlihat di atas latar hijau.
    return Material(
      color: WarnaApp.primer,
      borderRadius: sudut,
      child: InkWell(
        onTap: onTekan,
        borderRadius: sudut,
        child: Padding(
          padding: const EdgeInsets.all(JarakApp.j20),
          child: _bangunIsi(labelRedup),
        ),
      ),
    );
  }

  Widget _bangunIsi(TextStyle labelRedup) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onMata,
          // min supaya area mata hanya label + ikon, sisa baris tetap membuka Dompet.
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Saldo', style: labelRedup),
              const SizedBox(width: JarakApp.j4),
              Icon(
                disembunyikan ? LucideIcons.eyeOff : LucideIcons.eye,
                size: 18,
                color: WarnaApp.diAtasPrimer,
              ),
            ],
          ),
        ),
        const SizedBox(height: JarakApp.j4),
        Text(
          saldo,
          style: TeksApp.angkaBesar.copyWith(color: WarnaApp.diAtasPrimer),
        ),
        const SizedBox(height: JarakApp.j16),
        Row(
          children: [
            Expanded(
              child: _bangunArus(
                LucideIcons.arrowDownLeft,
                'Pemasukan',
                pemasukan,
                labelRedup,
              ),
            ),
            Expanded(
              child: _bangunArus(
                LucideIcons.arrowUpRight,
                'Pengeluaran',
                pengeluaran,
                labelRedup,
              ),
            ),
          ],
        ),
        const SizedBox(height: JarakApp.j16),
        const Divider(height: 1, color: WarnaApp.diAtasPrimerRedup),
        const SizedBox(height: JarakApp.j12),
        _bangunDompet(),
      ],
    );
  }

  // Penanda bahwa kartu bisa diketuk untuk membuka halaman Dompet.
  Widget _bangunDompet() {
    TextStyle gaya = TeksApp.kecil.copyWith(color: WarnaApp.diAtasPrimer);
    return Row(
      children: [
        const Icon(LucideIcons.wallet, size: 14, color: WarnaApp.diAtasPrimer),
        const SizedBox(width: JarakApp.j4),
        Expanded(child: Text('$jumlahDompet dompet', style: gaya)),
        Text('Lihat', style: gaya),
        const Icon(
          LucideIcons.chevronRight,
          size: 14,
          color: WarnaApp.diAtasPrimer,
        ),
      ],
    );
  }

  Widget _bangunArus(
    IconData ikon,
    String label,
    String nilai,
    TextStyle gaya,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(ikon, size: 14, color: WarnaApp.aksen),
            const SizedBox(width: JarakApp.j4),
            Text(label, style: gaya),
          ],
        ),
        const SizedBox(height: JarakApp.j4),
        Text(
          nilai,
          style: TeksApp.angka.copyWith(color: WarnaApp.diAtasPrimer),
        ),
      ],
    );
  }
}
