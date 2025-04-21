import 'package:flutter/material.dart';
import 'package:app_pd_cocimiento/core/constants/app_constants.dart';
import 'package:app_pd_cocimiento/core/models/db/con_pd_nivel.dart';
import 'package:app_pd_cocimiento/core/models/db/recipiente.dart';
import 'package:app_pd_cocimiento/core/models/db/material.dart';
import 'package:app_pd_cocimiento/data/repositories/con_pd_nivel_repository.dart';
import 'package:app_pd_cocimiento/data/repositories/recipiente_repository.dart';
import 'package:app_pd_cocimiento/data/repositories/material_repository.dart';
import 'package:app_pd_cocimiento/core/preferences/app_preferences.dart';

class NivelTanquesProvider extends ChangeNotifier {
  final ConPdNivelRepository conPdNivelRepository;
  final RecipienteRepository recipienteRepository;
  final MaterialRepository materialRepository;
  final AppPreferences appPreferences;

  // lista global de materiales
  List<Materiales> listaMateriales = [];

  // mapas para cada tipo de tanque
  final Map<int, List<Recipiente>> _recipientesMap = {};
  final Map<int, List<ConPdNivel>> _nivelItemsMap = {};

  NivelTanquesProvider({
    required this.conPdNivelRepository,
    required this.recipienteRepository,
    required this.materialRepository,
    required this.appPreferences,
  });

  // getters por vista
  List<Recipiente> get recipientesTachos =>
    _recipientesMap[AppConstants.tipoTachos] ?? [];
  List<ConPdNivel> get nivelItemsTachos =>
    _nivelItemsMap[AppConstants.tipoTachos] ?? [];

  List<Recipiente> get recipientesExtension =>
    _recipientesMap[AppConstants.tipoExtensionMiel] ?? [];
  List<ConPdNivel> get nivelItemsExtension =>
    _nivelItemsMap[AppConstants.tipoExtensionMiel] ?? [];

  List<Recipiente> get recipientesVacuum =>
    _recipientesMap[AppConstants.tipoVacuumPan] ?? [];
  List<ConPdNivel> get nivelItemsVacuum =>
    _nivelItemsMap[AppConstants.tipoVacuumPan] ?? [];

  Future<void> initData() async {
    try {
      // 1. Cargar materiales para todos los dropdowns
      listaMateriales = await materialRepository.getAll(orderBy: 'descripcion ASC');

      // 2. Cabecera activa
      final cabeceraId = appPreferences.activeCabeceraId;

      // 3. Para cada tipo, cargar recipientes, validar registros y recargar niveles
      for (var tipo in [
        AppConstants.tipoTachos,
        AppConstants.tipoExtensionMiel,
        AppConstants.tipoVacuumPan,
      ]) {
        // 3.1 cargar recipientes
        final recs = await recipienteRepository.getByConditions(
          conditions: {'flag_tipo': tipo},
          orderBy: 'descripcion ASC',
        );
        _recipientesMap[tipo] = recs;

        // 3.2 cargar existentes
        final existing = await conPdNivelRepository.getByConditions(
          conditions: {'id_fab_con_pd_cab': cabeceraId.toString()},
          orderBy: 'id_fab_con_pd_nivel ASC',
        );
        final mapExist = {
          for (var e in existing) e.idFabConPdRecipiente: e
        };

        // 3.3 crear faltantes (asignando material por defecto al primero)
        for (var rec in recs) {
          if (!mapExist.containsKey(rec.idFabRecipiente)) {
            await conPdNivelRepository.insert(ConPdNivel(
              idFabConPdNivel: 0,
              idFabConPdCab: cabeceraId,
              idFabConPdRecipiente: rec.idFabRecipiente,
              idFabMaterial: 0,
              nivel: 0.0,
              flagEstado: 1,
              usrCreacion: appPreferences.user,
            ));
          }
        }

        // 3.4 recargar todos y filtrar sólo los de este tipo
        final all = await conPdNivelRepository.getByConditions(
          conditions: {'id_fab_con_pd_cab': cabeceraId.toString()},
          orderBy: 'id_fab_con_pd_nivel ASC',
        );
        final validIds = recs.map((r) => r.idFabRecipiente).toSet();
        _nivelItemsMap[tipo] =
          all.where((r) => validIds.contains(r.idFabConPdRecipiente)).toList();
      }
    } catch (e) {
      debugPrint('Error initData NivelTanquesProvider: $e');
    } finally {
      notifyListeners();
    }
  }

  /// Actualiza sólo el nivel y recarga
  Future<void> updateNivel(int idNivel, double newNivel) async {
    await conPdNivelRepository.updateFieldsWithConditions(
      fields: {'nivel': newNivel},
      conditions: {'id_fab_con_pd_nivel': idNivel},
    );
    await initData();
  }

  /// Actualiza sólo el material y recarga
  Future<void> updateMaterial(int idNivel, int idMaterial) async {
    await conPdNivelRepository.updateFieldsWithConditions(
      fields: {'id_fab_material': idMaterial},
      conditions: {'id_fab_con_pd_nivel': idNivel},
    );
    await initData();
  }
}
