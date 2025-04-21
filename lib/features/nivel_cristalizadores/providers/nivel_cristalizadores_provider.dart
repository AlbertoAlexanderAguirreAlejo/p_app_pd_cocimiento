import 'package:app_pd_cocimiento/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:app_pd_cocimiento/core/models/db/con_pd_nivel.dart';
import 'package:app_pd_cocimiento/core/models/db/recipiente.dart';
import 'package:app_pd_cocimiento/core/preferences/app_preferences.dart';
import 'package:app_pd_cocimiento/data/repositories/con_pd_nivel_repository.dart';
import 'package:app_pd_cocimiento/data/repositories/recipiente_repository.dart';

class NivelCristalizadoresProvider extends ChangeNotifier {
  final ConPdNivelRepository conPdNivelRepository;
  final RecipienteRepository recipienteRepository;
  final AppPreferences appPreferences;

  // Lista de registros de ConPdNivel para la cabecera activa.
  List<ConPdNivel> nivelItems = [];
  // Lista de Recipiente de tipo 6 (Cristalizadores).
  List<Recipiente> recipientes = [];

  NivelCristalizadoresProvider({
    required this.conPdNivelRepository,
    required this.recipienteRepository,
    required this.appPreferences,
  });

  /// Inicializa la data:
  /// 1. Carga los recipientes de tipo 6.
  /// 2. Obtiene la cabecera activa (id) desde las preferencias.
  /// 3. Carga los registros de ConPdNivel para esa cabecera.
  /// 4. Para cada recipiente, si no existe un registro, lo crea con nivel = 0.0.
  /// 5. Finalmente, recarga la lista de registros filtrando solo los items de tipo 6.
  Future<void> initData() async {
    try {
      // 1. Cargar los recipientes con flag_tipo igual al tipo para cristalizadores.
      recipientes = await recipienteRepository.getByConditions(
        conditions: {'flag_tipo': AppConstants.tipoCristalizadorNivel},
        orderBy: 'descripcion ASC',
      );

      // 2. Obtener la cabecera activa.
      final int activeCabeceraId = appPreferences.activeCabeceraId;

      // 3. Cargar los registros existentes de ConPdNivel para la cabecera.
      List<ConPdNivel> existingRecords = await conPdNivelRepository.getByConditions(
        conditions: {'id_fab_con_pd_cab': activeCabeceraId.toString()},
        orderBy: 'id_fab_con_pd_nivel ASC',
      );

      // Mapear por id del recipiente para facilitar la búsqueda.
      final existingMap = {
        for (var rec in existingRecords) rec.idFabConPdRecipiente: rec
      };

      // 4. Para cada Recipiente de tipo 6, si no hay registro correspondiente, crearlo.
      for (Recipiente rec in recipientes) {
        if (!existingMap.containsKey(rec.idFabRecipiente)) {
          ConPdNivel newNivel = ConPdNivel(
            idFabConPdNivel: 0,
            idFabConPdCab: activeCabeceraId,
            idFabConPdRecipiente: rec.idFabRecipiente,
            idFabMaterial: 0, // Siempre 0 en este caso.
            nivel: 0.0, // Valor inicial.
            flagEstado: 1,
            usrCreacion: appPreferences.user,
          );
          await conPdNivelRepository.insert(newNivel);
        }
      }

      // 5. Recargar la lista de registros y filtrar solo los que correspondan a los recipientes de tipo 6.
      List<ConPdNivel> allRecords = await conPdNivelRepository.getByConditions(
        conditions: {'id_fab_con_pd_cab': activeCabeceraId.toString()},
        orderBy: 'id_fab_con_pd_nivel ASC',
      );
      final validRecipienteIds = recipientes.map((r) => r.idFabRecipiente).toSet();
      nivelItems = allRecords.where((record) => validRecipienteIds.contains(record.idFabConPdRecipiente)).toList();
    } catch (e) {
      debugPrint("Error en NivelCristalizadoresProvider.initData: $e");
    } finally {
      notifyListeners();
    }
  }

  /// Actualiza el valor de nivel para un registro dado.
  Future<void> updateNivel(int idFabConPdNivel, double newNivel) async {
    try {
      await conPdNivelRepository.updateFieldsWithConditions(
        fields: {'nivel': newNivel},
        conditions: {'id_fab_con_pd_nivel': idFabConPdNivel.toString()},
      );
      // Recargar la información.
      await initData();
    } catch (e) {
      debugPrint("Error actualizando nivel: $e");
    }
  }
}