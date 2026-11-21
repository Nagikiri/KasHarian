import 'dart:convert';
import 'dart:io';

import '../models/kurs.dart';

class ApiService {
  static const _baseUrl = 'https://open.er-api.com/v6/latest';

  Future<dynamic> _get(String path) async {
    final client = HttpClient();

    try {
      final request = await client.getUrl(Uri.parse('$_baseUrl/$path'));
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        return jsonDecode(body);
      } else {
        throw HttpException('Gagal mengambil kurs: ${response.statusCode}');
      }
    } finally {
      client.close();
    }
  }

  Future<Kurs> getKursIdr() async {
    final Map<String, dynamic> data = await _get('IDR');

    if (data['result'] != 'success') {
      throw Exception('API kurs mengembalikan error');
    }

    return Kurs.fromJson(data);
  }
}
