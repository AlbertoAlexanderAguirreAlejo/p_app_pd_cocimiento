import 'package:app_pd_cocimiento/core/preferences/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:app_pd_cocimiento/data/repositories/con_pd_det_repository.dart';
import 'package:app_pd_cocimiento/core/models/db/con_pd_det_extended.dart';

class ActividadesTachosProvider extends ChangeNotifier {
  final ConPdDetRepository conPdDetRepository;
  final AppPreferences appPreferences;

  List<ConPdDetExtended> detalles = [];
  bool isLoading = false;

  // Filtros actuales
  String? filterActividad;
  String? filterTipoMasa;
  String? filterRecipiente;

  // Opciones para dropdown
  List<String> filterActividades = [];
  List<String> filterTiposMasa = [];
  List<String> filterRecipientes = [];

  ActividadesTachosProvider({
    required this.conPdDetRepository,
    required this.appPreferences,
  });

  Future<void> loadFilterOptions() async {
    filterActividades = await conPdDetRepository.getFilterActividades(appPreferences.activeCabeceraId);
    filterTiposMasa = await conPdDetRepository.getFilterTiposMasa(appPreferences.activeCabeceraId);
    filterRecipientes = await conPdDetRepository.getFilterRecipientes(appPreferences.activeCabeceraId);
    notifyListeners();
  }

  Future<void> fetchDetalles() async {
    isLoading = true;
    notifyListeners();
    try {
      if ((filterActividad != null && filterActividad!.isNotEmpty) ||
          (filterTipoMasa != null && filterTipoMasa!.isNotEmpty) ||
          (filterRecipiente != null && filterRecipiente!.isNotEmpty)) {
        detalles = await conPdDetRepository.getAllWithDescriptionsFiltered(
          cabeceraId: appPreferences.activeCabeceraId,
          actividadFilter: filterActividad,
          tipoMasaFilter: filterTipoMasa,
          recipienteFilter: filterRecipiente,
        );
      } else {
        detalles = await conPdDetRepository.getAllWithDescriptions(
          cabeceraId: appPreferences.activeCabeceraId
        );
      }
    } catch (e) {
      debugPrint('Error en fetchDetalles: $e');
    } finally {
      await loadFilterOptions();
      isLoading = false;
      notifyListeners();
    }
  }

  /// Elimina un detalle de la lista y de la base de datos.
  Future<void> eliminarDetalle(ConPdDetExtended detalle) async {
    try {
      await conPdDetRepository.deleteById(detalle.idFabConPdDet);
      detalles.removeWhere((d) => d.idFabConPdDet == detalle.idFabConPdDet);
      notifyListeners();
    } catch (e) {
      debugPrint("Error eliminando detalle: $e");
    } finally {
      await loadFilterOptions();
    }
  }
}