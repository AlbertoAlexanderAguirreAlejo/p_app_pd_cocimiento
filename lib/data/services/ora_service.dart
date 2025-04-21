import 'package:app_pd_cocimiento/core/config/app_config.dart';
import 'package:app_pd_cocimiento/core/endpoints/ora_endpoints.dart';
import 'package:app_pd_cocimiento/core/models/ora/actvidad_ora_model.dart';
import 'package:app_pd_cocimiento/core/models/ora/api_response_ora.dart';
import 'package:app_pd_cocimiento/core/models/ora/masa_act_rec_ora_model.dart';
import 'package:app_pd_cocimiento/core/models/ora/material_ora_model.dart';
import 'package:app_pd_cocimiento/core/models/ora/recipiente_ora_model.dart';
import 'package:app_pd_cocimiento/core/models/ora/tipo_masa_ora_model.dart';
import '../clients/api_client_ora.dart';

class OraService {
  final ApiClientOra _client;

  OraService({String? baseUrl})
      : _client = ApiClientOra(
          baseUrl: baseUrl ?? OraEndpoints.baseUrl,
          defaultQueryParameters: {'env': AppConfig().env},
        );

  // Obtiene la lista de actividades activas desde el servicio ORA.
  Future<ApiResponseOra<List<ActividadOra>>> getActividades() {
    return _client.get<List<ActividadOra>>(
      OraEndpoints.actividad,
      additionalParams: {
        'estado': '1'
      },
      fromJsonT: (jsonData) {
        final List<dynamic> list = jsonData;
        return list.map((item) => ActividadOra.fromMap(item)).toList();
      },
    );
  }

  // Obtiene la lista de Materiales activos desde el servicio ORA.
  Future<ApiResponseOra<List<MaterialOra>>> getMateriales() {
    return _client.get<List<MaterialOra>>(
      OraEndpoints.material,
      additionalParams: {
        'estado': '1'
      },
      fromJsonT: (jsonData) {
        final List<dynamic> list = jsonData;
        return list.map((item) => MaterialOra.fromMap(item)).toList();
      },
    );
  }

  // Obtiene la lista de Masa-Actividad-Recipiente activas desde el servicio ORA.
  Future<ApiResponseOra<List<MasaActRecOra>>> getMasaActRec() {
    return _client.get<List<MasaActRecOra>>(
      OraEndpoints.masaActRec,
      additionalParams: {
        'estado': '1'
      },
      fromJsonT: (jsonData) {
        final List<dynamic> list = jsonData;
        return list.map((item) => MasaActRecOra.fromMap(item)).toList();
      },
    );
  }

  // Obtiene la lista de Recipientes activos desde el servicio ORA.
  Future<ApiResponseOra<List<RecipienteOra>>> getRecipientes() {
    return _client.get<List<RecipienteOra>>(
      OraEndpoints.recipiente,
      additionalParams: {
        'estado': '1'
      },
      fromJsonT: (jsonData) {
        final List<dynamic> list = jsonData;
        return list.map((item) => RecipienteOra.fromMap(item)).toList();
      },
    );
  }

  // Obtiene la lista de Tipos de Masa activas desde el servicio ORA.
  Future<ApiResponseOra<List<TipoMasaOra>>> getTiposMasa() {
    return _client.get<List<TipoMasaOra>>(
      OraEndpoints.tipoMasa,
      additionalParams: {
        'estado': '1'
      },
      fromJsonT: (jsonData) {
        final List<dynamic> list = jsonData;
        return list.map((item) => TipoMasaOra.fromMap(item)).toList();
      },
    );
  }
}