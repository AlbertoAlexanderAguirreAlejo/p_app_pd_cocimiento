import 'package:app_pd_cocimiento/core/config/app_config.dart';
import 'package:app_pd_cocimiento/core/endpoints/auth_endpoints.dart';
import 'package:app_pd_cocimiento/core/models/auth/login_response.dart';
import 'package:app_pd_cocimiento/data/clients/api_client_auth.dart';

class AuthService {
  final ApiClientAuth _client;

  AuthService({String? baseUrl})
      : _client = ApiClientAuth(
          baseUrl: baseUrl ?? AuthEndpoints.baseUrl,
          defaultQueryParameters: {'env': AppConfig().env},
        );

  Future<LoginResponse> login({
    required String user,
    required String pass,
  }) async {
    return await _client.get(
      AuthEndpoints.login,
      additionalParams: {
        'user': user,
        'passwd': pass,
        'grupo': 'PD_CANA',
      },
    );
  }
}
