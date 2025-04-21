import 'package:app_pd_cocimiento/core/infrastructure/config/app_config.dart';

class AuthEndpoints {
  static String get baseUrl {
    final config = AppConfig();
    return "https://www.agroparamonga.com${config.authService}";
    // return "https://${config.oraUrl}${config.authService}";
  }

  static const String login = "/vwusuario/id";
}