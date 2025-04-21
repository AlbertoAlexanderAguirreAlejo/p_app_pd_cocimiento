import 'package:app_pd_cocimiento/core/infrastructure/database/db_helper.dart';
import 'package:app_pd_cocimiento/domain/repositories/base_repository.dart';
import 'package:app_pd_cocimiento/domain/models/db/con_pd_agua.dart';

class ConPdAguaRepository extends BaseRepository<ConPdAgua> {
  ConPdAguaRepository() : super(
    tableName: 'fab_con_pd_agua',
    fromMap: (map) => ConPdAgua.fromMap(map),
    toMap: (agua) => agua.toMap(),
  );

  /// ¿Todos los registros de presión de agua son válidos?
  Future<bool> existsAllAguaValidForCabecera(int cabeceraId) async {
    final db = await DBHelper.database;
    final row = (await db.rawQuery('''
      SELECT
        COUNT(*) AS total_count,
        SUM(CASE
              WHEN id_fab_recipiente = 0
                OR p_sig <= 0
              THEN 1 ELSE 0
            END) AS invalid_count
      FROM fab_con_pd_agua
      WHERE id_fab_con_pd_cab = ?
    ''', [cabeceraId])).first;

    final total   = row['total_count']   as int? ?? 0;
    final invalid = row['invalid_count'] as int? ?? 0;

    // Debe haber al menos un registro y ninguno inválido
    return total > 0 && invalid == 0;
  }
}
