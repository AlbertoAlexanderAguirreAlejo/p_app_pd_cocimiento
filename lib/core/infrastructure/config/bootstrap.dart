import 'package:app_pd_cocimiento/app/providers.dart';
import 'package:app_pd_cocimiento/core/infrastructure/config/app_config.dart';
import 'package:app_pd_cocimiento/core/infrastructure/database/db_helper.dart';
import 'package:app_pd_cocimiento/core/infrastructure/preferences/app_preferences.dart';
import 'package:app_pd_cocimiento/core/infrastructure/preferences/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

typedef ProviderList = List<SingleChildWidget>;

Future<ProviderList> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Side‑effects
  await AppConfig.init();                               // Variables de entorno
  final db    = await DBHelper.database;                // SQFLite
  final prefs = await SharedPreferences.getInstance();  // Preferencias
  await initializeDateFormatting('es_ES');

  // 2. Objetos base
  final preferencesService = PreferencesService(prefs);
  final appPreferences     = AppPreferences(preferencesService);

  // 3. Providers preparados
  return [
    // básicos
    Provider<Database>.value(value: db),
    Provider<PreferencesService>.value(value: preferencesService),
    Provider<AppPreferences>.value(value: appPreferences),

    // repos, services y UI (re‑usa tus listas)
    ...repositoryProviders,
    ...serviceProviders,
    ...uiProviders,
  ];
}
