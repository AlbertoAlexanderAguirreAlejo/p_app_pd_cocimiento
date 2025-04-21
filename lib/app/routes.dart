import 'package:flutter/widgets.dart';

import 'package:app_pd_cocimiento/features/auth/views/auth_screen.dart';
import 'package:app_pd_cocimiento/features/home/views/home_screen.dart';
import 'package:app_pd_cocimiento/features/mantenimiento/views/mantenimiento_screen.dart';
import 'package:app_pd_cocimiento/features/actividades_tachos/views/actividades_tachos_screen.dart';
import 'package:app_pd_cocimiento/features/actividades_tachos/views/at_registro_screen.dart';
import 'package:app_pd_cocimiento/features/presion_agua/views/presion_agua_screen.dart';
import 'package:app_pd_cocimiento/features/nivel_graneros/views/nivel_graneros_screen.dart';
import 'package:app_pd_cocimiento/features/nivel_cristalizadores/views/nivel_cristalizadores_screen.dart';
import 'package:app_pd_cocimiento/features/nivel_tanques/views/nivel_tanques_screen.dart';
import 'package:app_pd_cocimiento/features/observaciones_acciones/views/observaciones_acciones_screen.dart';
import 'package:app_pd_cocimiento/features/observaciones_acciones/views/oa_registro_screen.dart';

/// Claves de ruta
class Routes {
  static const auth                  = 'auth';
  static const home                  = 'home';
  static const mantenimiento         = 'mantenimiento';
  static const actividadesTachos     = 'actividades_tachos';
  static const atRegistro            = 'at_registro';
  static const presionAgua           = 'presion_agua';
  static const nivelGraneros         = 'nivel_graneros';
  static const nivelCristalizadores  = 'nivel_cristalizadores';
  static const nivelTanques          = 'nivel_tanques';
  static const observacionesAcciones = 'observaciones_acciones';
  static const oaRegistro            = 'oa_registro';
}

/// Mapa de rutas para MaterialApp
final Map<String, WidgetBuilder> appRoutes = {
  Routes.auth                  : (_) => const AuthScreen(),
  Routes.home                  : (_) => const HomeScreen(),
  Routes.mantenimiento         : (_) => const MantenimientoScreen(),
  Routes.actividadesTachos     : (_) => const ActividadesTachosScreen(),
  Routes.atRegistro            : (_) => const ATRegistroScreen(),
  Routes.presionAgua           : (_) => const PresionAguaScreen(),
  Routes.nivelGraneros         : (_) => const NivelGranerosScreen(),
  Routes.nivelCristalizadores  : (_) => const NivelCristalizadoresScreen(),
  Routes.nivelTanques          : (_) => const NivelTanquesScreen(),
  Routes.observacionesAcciones : (_) => const ObservacionesAccionesScreen(),
  Routes.oaRegistro            : (_) => const OARegistroScreen(),
};