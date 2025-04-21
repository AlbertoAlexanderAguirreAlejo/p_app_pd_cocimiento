import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // Singleton
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  /// Carga el enviroment.
  static Future<void> init() async {
    await dotenv.load(fileName: '.aip.env');
  }

  // Getters para cada variable de entorno
  String get sapUrl        => dotenv.env['SAP_URL']        ?? '';
  String get sapService    => dotenv.env['SAP_SERVICE']    ?? '';
  String get oraUrl        => dotenv.env['ORA_URL']        ?? '';
  String get oraService    => dotenv.env['ORA_SERVICE']    ?? '';
  String get env           => dotenv.env['ENV']            ?? '';
  String get authService   => dotenv.env['AUTH_SERVICE']   ?? '';
  String get odataUser     => dotenv.env['ODATA_USER']     ?? '';
  String get odataPassword => dotenv.env['ODATA_PASSWORD'] ?? '';
}