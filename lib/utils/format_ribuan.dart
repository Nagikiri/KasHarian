import 'package:flutter/services.dart';

import 'format.dart';

const int _batasDigit = 10;

class FormatRibuan extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue lama,
    TextEditingValue baru,
  ) {
    String digit = baru.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digit.length > _batasDigit) return lama;
    String teks = digit.isEmpty ? '' : formatTitik(int.parse(digit));
    return TextEditingValue(
      text: teks,
      selection: TextSelection.collapsed(offset: teks.length),
    );
  }
}

int bacaAngka(String teks) {
  return int.tryParse(teks.replaceAll('.', '')) ?? 0;
}
