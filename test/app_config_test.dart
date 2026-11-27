import 'package:flutter_test/flutter_test.dart';
import 'package:kasharian/config/app_config.dart';

void main() {
  // flutter test tanpa --dart-define-from-file harus memakai nilai dev.
  test('AppConfig bawaan memakai nilai dev', () {
    expect(AppConfig.env, 'dev');
    expect(AppConfig.dbName, 'kasharian_dev.db');
    expect(AppConfig.dataContoh, isTrue);
    expect(AppConfig.isDev, isTrue);
    expect(AppConfig.isProd, isFalse);
  });
}
