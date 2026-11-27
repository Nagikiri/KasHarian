// Nilai dibaca dari config/dev.json atau config/prod.json lewat --dart-define-from-file.
// Jangan menyimpan rahasia (misalnya API key) di file itu, karena isinya ikut masuk ke APK.
class AppConfig {
  // defaultValue = nilai dev, supaya flutter run dan flutter test tanpa argumen tetap jalan.
  static const String env = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const String dbName = String.fromEnvironment(
    'DB_NAME',
    defaultValue: 'kasharian_dev.db',
  );
  static const bool dataContoh = bool.fromEnvironment(
    'DATA_CONTOH',
    defaultValue: true,
  );

  static const bool isDev = env == 'dev';
  static const bool isProd = env == 'prod';
}
