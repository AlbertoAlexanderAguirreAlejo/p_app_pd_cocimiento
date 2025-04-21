import 'package:app_pd_cocimiento/core/shared/constants/db_constants.dart';
import 'package:app_pd_cocimiento/domain/repositories/mantenimiento_repository.dart';
import 'package:app_pd_cocimiento/data/services/sync_service.dart';
import 'package:app_pd_cocimiento/domain/models/db/mantenimiento.dart';
import 'package:flutter/material.dart';

class MantenimientoProvider extends ChangeNotifier {
  final MantenimientoRepository repository;
  final SyncService syncService;
  List<Mantenimiento> maintenanceItems = [];
  bool isLoading = false;

  MantenimientoProvider({
    required this.repository,
    required this.syncService,
  });

  Future<void> fetchMaintenanceData() async {
    isLoading = true;
    notifyListeners();
    try {
      maintenanceItems = await repository.getAll(orderBy: 'titulo');
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateModule(String dbName) async {
    isLoading = true;
    notifyListeners();
    try {
      // Llama al método de sincronización según la tabla.
      switch (dbName) {
        case DbConstants.dbNameActividad:
          await syncService.syncActividades();
          break;
        case DbConstants.dbNameMaterial:
          await syncService.syncMateriales();
          break;
        case DbConstants.dbNameRecipiente:
          await syncService.syncRecipientes();
          break;
        case DbConstants.dbNameMasaActRec:
          await syncService.syncMasaActRec();
          break;
        case DbConstants.dbNameTipoMasa:
          await syncService.syncTiposMasa();
          break;
        default:
          // Si no se reconoce, no se sincroniza nada.
          break;
      }
      // Actualiza la metadata para la tabla.
      await repository.registrarActualizacion(table: dbName);
      maintenanceItems = await repository.getAll(orderBy: 'titulo');
    } catch (e) {
      debugPrint("Error en updateModule: $e");
      // Relanza la excepción para que el widget pueda capturarla.
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAllModules() async {
    isLoading = true;
    notifyListeners();
    try {
      // Sincroniza globalmente todas las tablas maestras.
      await syncService.syncAllMaestros(force: true);
      // Recarga la información de mantenimiento.
      maintenanceItems = await repository.getAll(orderBy: 'titulo');
    } catch (e) {
      debugPrint("Error en updateAllModules: $e");
      // Relanza la excepción para que el widget que llama pueda capturarla.
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
