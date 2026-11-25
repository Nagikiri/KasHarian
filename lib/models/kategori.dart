import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// Database menyimpan nomor urut di daftar ini, bukan IconData, supaya build release tetap bisa memangkas ikon.
// Ikon baru hanya boleh ditambah di akhir. Mengubah urutan membuat ikon yang sudah tersimpan berganti.
// 16 ikon pertama adalah pilihan di pemilih ikon (AppData.opsiIkonKategori).
const List<IconData> daftarIkonKategori = [
  LucideIcons.utensils,
  LucideIcons.coffee,
  LucideIcons.shoppingCart,
  LucideIcons.bus,
  LucideIcons.fuel,
  LucideIcons.receiptText,
  LucideIcons.zap,
  LucideIcons.wifi,
  LucideIcons.house,
  LucideIcons.stethoscope,
  LucideIcons.dumbbell,
  LucideIcons.shirt,
  LucideIcons.bookOpen,
  LucideIcons.gamepad2,
  LucideIcons.gift,
  LucideIcons.pawPrint,
  LucideIcons.cookie,
  LucideIcons.shoppingBag,
  LucideIcons.bike,
  LucideIcons.circleParking,
  LucideIcons.droplet,
  LucideIcons.smartphone,
  LucideIcons.keyRound,
  LucideIcons.pill,
  LucideIcons.sparkles,
  LucideIcons.graduationCap,
  LucideIcons.clapperboard,
  LucideIcons.tv,
  LucideIcons.plane,
  LucideIcons.heartHandshake,
  LucideIcons.partyPopper,
  LucideIcons.baby,
  LucideIcons.monitorSmartphone,
  LucideIcons.wrench,
  LucideIcons.landmark,
  LucideIcons.shieldCheck,
  LucideIcons.ellipsis,
  LucideIcons.banknote,
  LucideIcons.laptop,
  LucideIcons.award,
  LucideIcons.wallet,
  LucideIcons.store,
  LucideIcons.trendingUp,
  LucideIcons.percent,
  LucideIcons.rotateCcw,
  LucideIcons.arrowLeftRight,
  LucideIcons.handCoins,
  LucideIcons.piggyBank,
];

int indeksIkon(IconData ikon) => daftarIkonKategori.indexOf(ikon);

// Nomor yang tidak dikenal memakai ikon dompet supaya aplikasi tidak error.
IconData ikonDariIndeks(int indeks) {
  if (indeks < 0 || indeks >= daftarIkonKategori.length) {
    return LucideIcons.wallet;
  }
  return daftarIkonKategori[indeks];
}

class KategoriItem {
  int? id;
  final String nama;
  final IconData ikon;
  final bool isPemasukan;
  // Indeks ke WarnaApp.paletKategori: 0 sampai 6 bergiliran, 7 (abu) khusus 'Lainnya'.
  final int indeksWarna;

  KategoriItem({
    this.id,
    required this.nama,
    required this.ikon,
    this.isPemasukan = false,
    required this.indeksWarna,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'indeks_ikon': indeksIkon(ikon),
      'is_pemasukan': isPemasukan ? 1 : 0,
      'indeks_warna': indeksWarna,
    };
  }

  factory KategoriItem.fromMap(Map<String, dynamic> map) {
    return KategoriItem(
      id: map['id'],
      nama: map['nama'],
      ikon: ikonDariIndeks(map['indeks_ikon']),
      isPemasukan: map['is_pemasukan'] == 1,
      indeksWarna: map['indeks_warna'],
    );
  }
}
