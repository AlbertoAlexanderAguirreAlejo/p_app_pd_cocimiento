import 'package:flutter/material.dart';
import 'package:app_pd_cocimiento/core/infrastructure/config/bootstrap.dart';
import 'package:app_pd_cocimiento/app.dart';
import 'package:provider/provider.dart';

/// Punto de entrada de la aplicación.
void main() async {
  final providers = await bootstrap();
  runApp(
    MultiProvider(
      providers: providers,
      child: const App(),
    ),
  );
}