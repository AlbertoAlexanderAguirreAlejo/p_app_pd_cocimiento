import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:app_pd_cocimiento/core/infrastructure/preferences/app_preferences.dart';

import 'package:app_pd_cocimiento/domain/repositories/actividad_repository.dart';
import 'package:app_pd_cocimiento/domain/repositories/material_repository.dart';
import 'package:app_pd_cocimiento/domain/repositories/recipiente_repository.dart';
import 'package:app_pd_cocimiento/domain/repositories/masa_act_rec_repository.dart';
import 'package:app_pd_cocimiento/domain/repositories/con_pd_det_repository.dart';
import 'package:app_pd_cocimiento/domain/repositories/tipo_masa_repository.dart';
import 'package:app_pd_cocimiento/domain/repositories/mantenimiento_repository.dart';
import 'package:app_pd_cocimiento/domain/repositories/con_pd_cab_repository.dart';
import 'package:app_pd_cocimiento/domain/repositories/con_pd_agua_repository.dart';
import 'package:app_pd_cocimiento/domain/repositories/con_pd_nivel_repository.dart';

import 'package:app_pd_cocimiento/data/services/auth_service.dart';
import 'package:app_pd_cocimiento/data/services/cabecera_service.dart';
import 'package:app_pd_cocimiento/data/services/ora_service.dart';
import 'package:app_pd_cocimiento/data/services/sync_service.dart';

import 'package:app_pd_cocimiento/features/auth/providers/auth_provider.dart';
import 'package:app_pd_cocimiento/features/home/providers/home_provider.dart';
import 'package:app_pd_cocimiento/features/mantenimiento/providers/mantenimiento_provider.dart';
import 'package:app_pd_cocimiento/features/actividades_tachos/providers/actividades_tachos_provider.dart';
import 'package:app_pd_cocimiento/features/actividades_tachos/providers/actividades_tachos_registro_provider.dart';
import 'package:app_pd_cocimiento/features/presion_agua/providers/presion_agua_provider.dart';
import 'package:app_pd_cocimiento/features/nivel_graneros/providers/nivel_graneros_provider.dart';
import 'package:app_pd_cocimiento/features/nivel_cristalizadores/providers/nivel_cristalizadores_provider.dart';
import 'package:app_pd_cocimiento/features/nivel_tanques/providers/nivel_tanques_provider.dart';
import 'package:app_pd_cocimiento/features/observaciones_acciones/providers/observaciones_acciones_provider.dart';

/// Repositorios puros
final List<SingleChildWidget> repositoryProviders = [
  Provider(create: (_) => ActividadRepository()),
  Provider(create: (_) => MaterialRepository()),
  Provider(create: (_) => RecipienteRepository()),
  Provider(create: (_) => MasaActRecRepository()),
  Provider(create: (_) => ConPdDetRepository()),
  Provider(create: (_) => TipoMasaRepository()),
  Provider(create: (_) => MantenimientoRepository()),
  Provider(create: (_) => ConPdCabRepository()),
  Provider(create: (_) => ConPdAguaRepository()),
  Provider(create: (_) => ConPdNivelRepository()),
];

/// Servicios (requieren repositorios y AppPreferences)
final List<SingleChildWidget> serviceProviders = [
  Provider(create: (_) => AuthService()),
  Provider(create: (ctx) => CabeceraService(
        repository: ctx.read<ConPdCabRepository>(),
      )),
  Provider(create: (_) => OraService()),
  Provider(create: (ctx) => SyncService(
        actividadRepository: ctx.read<ActividadRepository>(),
        materialRepository: ctx.read<MaterialRepository>(),
        recipienteRepository: ctx.read<RecipienteRepository>(),
        masaActRecRepository: ctx.read<MasaActRecRepository>(),
        tipoMasaRepository: ctx.read<TipoMasaRepository>(),
        mantenimientoRepository: ctx.read<MantenimientoRepository>(),
        oraService: ctx.read<OraService>(),
        appPreferences: ctx.read<AppPreferences>(),
      )),
];

/// ChangeNotifierProviders de UI
final List<SingleChildWidget> uiProviders = [
  ChangeNotifierProvider(create: (ctx) => AuthProvider(
        appPreferences: ctx.read<AppPreferences>(),
        authService: ctx.read<AuthService>(),
        syncService: ctx.read<SyncService>(),
        cabeceraService: ctx.read<CabeceraService>(),
      )),
  ChangeNotifierProvider(create: (ctx) => HomeProvider(
        conPdDetRepository: ctx.read<ConPdDetRepository>(),
        conPdAguaRepository: ctx.read<ConPdAguaRepository>(),
        conPdNivelRepository: ctx.read<ConPdNivelRepository>(),
        appPreferences: ctx.read<AppPreferences>(),
      )),
  ChangeNotifierProvider(create: (ctx) => MantenimientoProvider(
        repository: ctx.read<MantenimientoRepository>(),
        syncService: ctx.read<SyncService>(),
      )),
  ChangeNotifierProvider(create: (ctx) => ActividadesTachosProvider(
        conPdDetRepository: ctx.read<ConPdDetRepository>(),
        appPreferences: ctx.read<AppPreferences>(),
      )),
  ChangeNotifierProvider(create: (ctx) => ActividadesTachosRegistroProvider(
        masaActRecRepository: ctx.read<MasaActRecRepository>(),
        actividadRepository: ctx.read<ActividadRepository>(),
        recipienteRepository: ctx.read<RecipienteRepository>(),
        tipoMasaRepository: ctx.read<TipoMasaRepository>(),
        conPdDetRepository: ctx.read<ConPdDetRepository>(),
        appPreferences: ctx.read<AppPreferences>(),
      )),
  ChangeNotifierProvider(create: (ctx) => PresionAguaProvider(
        conPdAguaRepository: ctx.read<ConPdAguaRepository>(),
        recipienteRepository: ctx.read<RecipienteRepository>(),
        appPreferences: ctx.read<AppPreferences>(),
      )),
  ChangeNotifierProvider(create: (ctx) => NivelGranerosProvider(
        conPdNivelRepository: ctx.read<ConPdNivelRepository>(),
        recipienteRepository: ctx.read<RecipienteRepository>(),
        appPreferences: ctx.read<AppPreferences>(),
      )),
  ChangeNotifierProvider(create: (ctx) => NivelCristalizadoresProvider(
        conPdNivelRepository: ctx.read<ConPdNivelRepository>(),
        recipienteRepository: ctx.read<RecipienteRepository>(),
        appPreferences: ctx.read<AppPreferences>(),
      )),
  ChangeNotifierProvider(create: (ctx) => NivelTanquesProvider(
        materialRepository: ctx.read<MaterialRepository>(),
        conPdNivelRepository: ctx.read<ConPdNivelRepository>(),
        recipienteRepository: ctx.read<RecipienteRepository>(),
        appPreferences: ctx.read<AppPreferences>(),
      )),
  ChangeNotifierProvider(create: (_) => ObservacionesAccionesProvider()),
];

/// Lista completa para MultiProvider
final List<SingleChildWidget> appProviders = [
  ...repositoryProviders,
  ...serviceProviders,
  ...uiProviders,
];