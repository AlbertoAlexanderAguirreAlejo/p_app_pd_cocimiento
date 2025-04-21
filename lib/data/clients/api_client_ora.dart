import 'dart:convert';
import 'package:app_pd_cocimiento/core/models/ora/api_response_ora.dart';
import 'package:app_pd_cocimiento/core/utils/connectivity_utils.dart';
import 'package:app_pd_cocimiento/data/clients/api_client_base.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiClientOra extends ApiClientBase {
  ApiClientOra({required super.baseUrl, super.defaultQueryParameters, super.defaultHeaders});

  Future<ApiResponseOra<T>> get<T>(
    String endpoint, {
    Map<String, String>? additionalParams,
    Map<String, String>? headers,
    required T Function(dynamic json) fromJsonT,
  }) async {
    // Verifica la conectividad usando la función utilitaria
    await checkInternetConnectivity();

    // Combina los headers por defecto con los que se pasen|
    final mergedHeaders = {
      ...defaultHeaders,
      ...?headers,
    };

    final uri = buildUri(endpoint, additionalParams);
    debugPrint(uri.toString());
    final response = await http.get(uri, headers: mergedHeaders);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return ApiResponseOra<T>.fromJson(jsonResponse, fromJsonT);
    } else {
      throw Exception("Error: ${response.statusCode} ${response.body}");
    }
  }
}