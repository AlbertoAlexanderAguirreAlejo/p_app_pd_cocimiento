import 'package:flutter/material.dart';
import 'package:app_pd_cocimiento/core/config/bootstrap.dart';
import 'package:app_pd_cocimiento/app.dart';

/// Punto de entrada de la aplicación.
Future<void> main() async {
  // Inicializa .env, DB, SharedPreferences e Intl
  await Bootstrap.init();

  // Arranca la app modularizada
  runApp( App());
}