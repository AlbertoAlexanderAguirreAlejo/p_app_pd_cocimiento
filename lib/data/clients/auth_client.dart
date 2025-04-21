import 'dart:convert';
import 'package:app_pd_cocimiento/core/shared/utils/connectivity_utils.dart';
import 'package:app_pd_cocimiento/data/clients/base_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:app_pd_cocimiento/domain/models/auth/login_response.dart';

class AuthClient extends BaseClient {
  AuthClient({required super.baseUrl, super.defaultQueryParameters});

  Future<LoginResponse> get(
    String endpoint, {
    Map<String, String>? additionalParams,
    Map<String, String>? headers,
  }) async {
    // Verifica la conectividad usando la función utilitaria
    await checkInternetConnectivity();

    // Combina los headers por defecto con los que se pasen
    final mergedHeaders = {
      ...defaultHeaders,
      ...?headers,
    };

    final uri = buildUri(endpoint, additionalParams);
    debugPrint(uri.toString());
    final response = await http.get(uri, headers: mergedHeaders);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return LoginResponse.fromJson(jsonResponse);
    } else {
      throw Exception("Error: ${response.statusCode} ${response.body}");
    }
  }
}
