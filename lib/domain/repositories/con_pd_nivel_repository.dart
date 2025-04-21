import 'package:app_pd_cocimiento/core/shared/constants/app_constants.dart';
import 'package:app_pd_cocimiento/core/infrastructure/database/db_helper.dart';
import 'package:app_pd_cocimiento/domain/repositories/base_repository.dart';
import 'package:app_pd_cocimiento/domain/models/db/con_pd_nivel.dart';
import 'package:sqflite/sqflite.dart';

class ConPdNivelRepository extends BaseRepository<ConPdNivel> {
  ConPdNivelRepository() : super(
    tableName: 'fab_con_pd_nivel',
    fromMap: (map) => ConPdNivel.fromMap(map),
    toMap: (nivel) => nivel.toMap(),
  );

  /// General: ¿existe al menos un registro para un tipo dado?
  Future<bool> existsNivelByTipo(int cabeceraId, int tipo) async {
    final db = await DBHelper.database;
    final result = await db.rawQuery('''
      SELECT COUNT(*) AS count
      FROM fab_con_pd_nivel n
      JOIN fab_recipiente r ON n.id_fab_recipiente = r.id_fab_recipiente
      WHERE n.id_fab_con_pd_cab = ?
        AND r.flag_tipo = ?
    ''', [cabeceraId, tipo]);
    final count = Sqflite.firstIntValue(result) ?? 0;
    return count > 0;
  }

  /// Para el card "Nivel Tachos y Tanques Miel" + Vacuum Pan:
  /// - flag_tipo=1 y 3 → id_fab_material <> 0
  /// - flag_tipo=4 → basta con existir
  Future<bool> existsAllTanquesValidos(int cabeceraId) async {
    final db = await DBHelper.database;
    final row = (await db.rawQuery('''
      SELECT
        -- Tachos
        SUM(CASE WHEN r.flag_tipo = ${AppConstants.tipoTachos} THEN 1 ELSE 0 END)      AS total_tachos,
        SUM(CASE WHEN r.flag_tipo = ${AppConstants.tipoTachos} AND n.id_fab_material = 0 THEN 1 ELSE 0 END) AS invalid_tachos,
        -- Miel
        SUM(CASE WHEN r.flag_tipo = ${AppConstants.tipoExtensionMiel} THEN 1 ELSE 0 END)      AS total_miel,
        SUM(CASE WHEN r.flag_tipo = ${AppConstants.tipoExtensionMiel} AND n.id_fab_material = 0 THEN 1 ELSE 0 END) AS invalid_miel,
        -- Vacuum Pan
        SUM(CASE WHEN r.flag_tipo = ${AppConstants.tipoVacuumPan} THEN 1 ELSE 0 END)      AS total_vacuum
      FROM fab_con_pd_nivel n
      JOIN fab_recipiente r ON n.id_fab_recipiente = r.id_fab_recipiente
      WHERE n.id_fab_con_pd_cab = ?
    ''', [cabeceraId])).first;

    final totalTachos   = row['total_tachos']   as int? ?? 0;
    final invalidTachos = row['invalid_tachos'] as int? ?? 0;
    final totalMiel     = row['total_miel']     as int? ?? 0;
    final invalidMiel   = row['invalid_miel']   as int? ?? 0;
    final totalVacuum   = row['total_vacuum']   as int? ?? 0;

    // Debe haber al menos 1 de cada tipo,
    // y 0 registros inválidos en tachos y miel.
    return totalTachos > 0
        && invalidTachos == 0
        && totalMiel > 0
        && invalidMiel == 0
        && totalVacuum > 0;
  }
}
