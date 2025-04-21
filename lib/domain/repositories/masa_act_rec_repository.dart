import 'package:app_pd_cocimiento/core/infrastructure/database/db_helper.dart';
import 'package:app_pd_cocimiento/domain/repositories/base_repository.dart';
import 'package:app_pd_cocimiento/domain/models/db/masa_act_rec.dart';

class MasaActRecRepository extends BaseRepository<MasaActRec> {
  MasaActRecRepository() : super(
    tableName: 'fab_masa_act_rec',
    fromMap: (map) => MasaActRec.fromMap(map),
    toMap: (masaActRec) => masaActRec.toMap(),
  );

  /// Retorna los IDs de TipoMasa permitidos para el recipiente seleccionado.
  /// Se consulta para filas donde:
  ///   id_fab_recipiente = ? OR id_fab_recipiente = 0
  ///   y flag_estado = 1.
  Future<List<int>> getTipoMasaIdsForRecipiente() async {
    final db = await DBHelper.database;
    final result = await db.rawQuery('''
      SELECT DISTINCT id_fab_tipo_masa
      FROM $tableName
      WHERE flag_estado = 1
    ''');
    return result.map((row) => row['id_fab_tipo_masa'] as int).toList();
  }

  /// Retorna los IDs de Actividad permitidos para el tipo de masa y recipiente seleccionados.
  Future<List<int>> getActividadIdsForTipoMasaAndRecipiente(int idTipoMasa) async {
    final db = await DBHelper.database;
    final result = await db.rawQuery('''
      SELECT DISTINCT id_fab_actividad
      FROM $tableName
      WHERE id_fab_tipo_masa = ?
        AND flag_estado = 1
    ''', [idTipoMasa]);
    return result.map((row) => row['id_fab_actividad'] as int).toList();
  }

  /// Retorna los IDs de Recipiente permitidos para el tipo de masa y actividad seleccionados.
  Future<List<int>> getRecipienteIdsForTipoMasaAndActividad(int idTipoMasa, int idActividad) async {
    final db = await DBHelper.database;
    final result = await db.rawQuery('''
      SELECT DISTINCT id_fab_recipiente
      FROM $tableName
      WHERE id_fab_tipo_masa = ?
        AND id_fab_actividad = ?
        AND id_fab_recipiente != 0
        AND flag_estado = 1
    ''', [idTipoMasa, idActividad]);
    return result.map((row) => row['id_fab_recipiente'] as int).toList();
  }

}
