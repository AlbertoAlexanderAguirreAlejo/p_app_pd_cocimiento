import 'package:app_pd_cocimiento/core/infrastructure/config/app_config.dart';
import 'package:app_pd_cocimiento/core/infrastructure/endpoints/auth_endpoints.dart';
import 'package:app_pd_cocimiento/domain/models/auth/login_response.dart';
import 'package:app_pd_cocimiento/data/clients/auth_client.dart';

class AuthService {
  final AuthClient _client;

  AuthService({String? baseUrl})
      : _client = AuthClient(
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
