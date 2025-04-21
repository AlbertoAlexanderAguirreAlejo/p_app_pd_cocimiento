// lib/core/endpoints/ora_endpoints.dart
import 'package:app_pd_cocimiento/core/config/app_config.dart';

class OraEndpoints {
  static String get baseUrl {
    final config = AppConfig();
    return "https://${config.oraUrl}${config.oraService}";
  }

  // Endpoints
  static const String actividad   = "/fabActividad";
  static const String material    = "/fabMaterial";
  static const String masaActRec  = "/fabMasaActRec";
  static const String recipiente  = "/fabRecipiente";
  static const String tipoMasa    = "/fabTipoMasa";
}
