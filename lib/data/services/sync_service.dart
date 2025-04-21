import 'package:app_pd_cocimiento/core/constants/db_constants.dart';
import 'package:app_pd_cocimiento/core/models/db/actividad.dart';
import 'package:app_pd_cocimiento/core/models/db/masa_act_rec.dart';
import 'package:app_pd_cocimiento/core/models/db/material.dart';
import 'package:app_pd_cocimiento/core/models/db/recipiente.dart';
import 'package:app_pd_cocimiento/core/models/db/tipo_masa.dart';
import 'package:app_pd_cocimiento/core/preferences/app_preferences.dart';
import 'package:app_pd_cocimiento/data/repositories/actividad_repository.dart';
import 'package:app_pd_cocimiento/data/repositories/mantenimiento_repository.dart';
import 'package:app_pd_cocimiento/data/repositories/masa_act_rec_repository.dart';
import 'package:app_pd_cocimiento/data/repositories/material_repository.dart';
import 'package:app_pd_cocimiento/data/repositories/recipiente_repository.dart';
import 'package:app_pd_cocimiento/data/repositories/tipo_masa_repository.dart';
import 'package:app_pd_cocimiento/data/services/ora_service.dart';
import 'package:flutter/rendering.dart';

class SyncService {
  final ActividadRepository actividadRepository;
  final MaterialRepository materialRepository;
  final RecipienteRepository recipienteRepository;
  final MasaActRecRepository masaActRecRepository;
  final TipoMasaRepository tipoMasaRepository;
  final MantenimientoRepository mantenimientoRepository;
  final OraService oraService;
  final AppPreferences appPreferences;

  SyncService({
    required this.actividadRepository,
    required this.materialRepository,
    required this.recipienteRepository,
    required this.masaActRecRepository,
    required this.tipoMasaRepository,
    required this.mantenimientoRepository,
    required this.oraService,
    required this.appPreferences,
  });

  /// Sincroniza la tabla de actividad.
  Future<void> syncActividades() async {
    final response = await oraService.getActividades();
    final entidades = response.data.map((e) => Actividad(
      idFabActividad: e.idFabActividad,
      descripcion: e.descripcion,
      flagDestinoActividad: e.flagDestinoActividad,
      flagCristalizador: e.flagCristalizador,
      flagReqActividad: e.flagReqActividad,
      flagEstado: 1,
    )).toList();

    await actividadRepository.replaceAll(entidades);
    await mantenimientoRepository.registrarActualizacion(table: DbConstants.dbNameActividad);
  }

  /// Sincroniza la tabla de material.
  Future<void> syncMateriales() async {
    final response = await oraService.getMateriales();
    final entidades = response.data.map((e) => Materiales(
      idFabMaterial: e.idFabMaterial,
      descripcion: e.descripcion,
      descCorta: e.descCorta,
      flagEstado: 1,
    )).toList();

    await materialRepository.replaceAll(entidades);
    await mantenimientoRepository.registrarActualizacion(table: DbConstants.dbNameMaterial);
  }

  /// Sincroniza la tabla de masa_act_rec.
  Future<void> syncMasaActRec() async {
    final response = await oraService.getMasaActRec();
    final entidades = response.data.map((e) => MasaActRec(
      idFabMasaActRec: e.idFabMasaActRec,
      idFabTipoMasa: e.idFabTipoMasa,
      idFabActividad: e.idFabActividad,
      idFabRecipiente: e.idFabRecipiente ?? 0,
      flagEstado: 1,
    )).toList();

    await masaActRecRepository.replaceAll(entidades);
    await mantenimientoRepository.registrarActualizacion(table: DbConstants.dbNameMasaActRec);
  }

  /// Sincroniza la tabla de recipiente.
  Future<void> syncRecipientes() async {
    final response = await oraService.getRecipientes();
    final entidades = response.data.map((e) => Recipiente(
      idFabRecipiente: e.idFabRecipiente,
      descripcion: e.descripcion,
      flagTipo: e.flagTipo,
      flagEstado: 1,
    )).toList();

    await recipienteRepository.replaceAll(entidades);
    await mantenimientoRepository.registrarActualizacion(table: DbConstants.dbNameRecipiente);
  }

  /// Sincroniza la tabla de tipo_masa.
  Future<void> syncTiposMasa() async {
    final response = await oraService.getTiposMasa();
    final entidades = response.data.map((e) => TipoMasa(
      idFabTipoMasa: e.idFabTipoMasa,
      descripcion: e.descripcion,
      flagEstado: 1,
    )).toList();

    await tipoMasaRepository.replaceAll(entidades);
    await mantenimientoRepository.registrarActualizacion(table: DbConstants.dbNameTipoMasa);
  }

  /// Función general que sincroniza todos los maestros.
  Future<void> syncAllMaestros({bool? force}) async {
    // Obtener la fecha actual en formato ISO (los primeros 19 caracteres).
    final today = DateTime.now().toIso8601String().substring(0, 19);
    final String ultimaSync = appPreferences.ultimaActualizacion;

    bool alreadySynced = false;
    if (ultimaSync.length >= 10) {
      alreadySynced = ultimaSync.substring(0, 10) == today.substring(0, 10);
    }

    // Si ya se sincronizó hoy y no se fuerza la sincronización, salir.
    if (alreadySynced && (force == null || force == false)) {
      return;
    }

    try {
      await Future.wait([
        syncActividades(),
        syncMateriales(),
        syncRecipientes(),
        syncMasaActRec(),
        syncTiposMasa(),
      ]);
      await appPreferences.setUltimaActualizacion(today);
    } catch (e) {
      debugPrint("Error en syncAllMaestros: $e");
      // Relanza la excepción para que el provider la capture.
      rethrow;
    }
  }
}