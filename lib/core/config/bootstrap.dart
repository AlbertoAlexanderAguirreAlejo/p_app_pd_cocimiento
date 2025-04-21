// lib/core/config/bootstrap.dart
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/db_helper.dart';
import '../config/app_config.dart';

class Bootstrap {
  static late SharedPreferences prefs;

  /// Llama a este método en main antes de runApp()
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 1. Variables de entorno
    await AppConfig.init();

    // 2. Base de datos
    await DBHelper.database;

    // 3. Preferencias
    prefs = await SharedPreferences.getInstance();

    // 4. Internacionalización de fechas
    await initializeDateFormatting('es_ES', null);
  }
}
