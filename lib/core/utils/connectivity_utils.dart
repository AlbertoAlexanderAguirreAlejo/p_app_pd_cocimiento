import 'package:app_pd_cocimiento/core/utils/custom_alert.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:app_pd_cocimiento/core/theme/app_theme.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:app_pd_cocimiento/app.dart'; // Asegúrate de importar la GlobalKey para Navigator

Future<bool> hasInternetConnection() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult.contains(ConnectivityResult.none)) {
    return false;
  }
  try {
    final result = await http.get(Uri.parse("https://www.google.com")).timeout(const Duration(seconds: 5));
    return result.statusCode == 200;
  } catch (_) {
    return false;
  }
}

/// Función utilitaria para verificar conectividad y mostrar alerta si no hay internet.
Future<void> checkInternetConnectivity() async {
  if (!await hasInternetConnection()) {
    // Usamos la GlobalKey para obtener un context seguro.
    final context = navigatorKey.currentContext;
    if (context != null) {
      showCustomAlert(
        info: true,
        danger: true,
        descripcion: [
          const WidgetSpan(child: Icon(FontAwesome.circle_xmark, size: 60, color: AppTheme.red)),
          const TextSpan(text: '\n\nSin conexión a Internet\n\n', style: TextStyle(fontWeight: FontWeight.bold)),
          const TextSpan(text: 'No se pudo iniciar sesión debido a la falta de conexión a Internet.'),
        ],
      );
    }
    throw Exception("No internet connection");
  }
}
