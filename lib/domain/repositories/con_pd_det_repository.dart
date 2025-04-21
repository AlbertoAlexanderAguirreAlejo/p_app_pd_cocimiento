import 'package:app_pd_cocimiento/domain/models/db/con_pd_det.dart';
import 'package:app_pd_cocimiento/domain/models/db/con_pd_det_extended.dart';
import 'package:app_pd_cocimiento/core/infrastructure/database/db_helper.dart';
import 'package:app_pd_cocimiento/domain/repositories/base_repository.dart';
import 'package:sqflite/sqflite.dart';

class ConPdDetRepository extends BaseRepository<ConPdDet> {
  ConPdDetRepository()
      : super(
          tableName: 'fab_con_pd_det',
          fromMap: (map) => ConPdDet.fromMap(map),
          toMap: (det) => det.toMap(),
        );

  Future<int> deleteById(int idFabConPdDet) async {
    return await deleteByConditions(
      conditions: {
        'id_fab_con_pd_det': idFabConPdDet
      }
    );
  }

  Future<List<ConPdDetExtended>> getAllWithDescriptions({required int cabeceraId, String orderBy = 'fecha_notificacion DESC'}) async {
    final Database db = await DBHelper.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT det.*,
        act.descripcion AS descripcionActividad,
        tm.descripcion AS descripcionTipoMasa,
        rec.descripcion AS descripcionRecipiente
      FROM fab_con_pd_det det
      LEFT JOIN fab_actividad act ON act.id_fab_actividad = det.id_fab_actividad
      LEFT JOIN fab_tipo_masa tm ON tm.id_fab_tipo_masa = det.id_fab_tipo_masa
      LEFT JOIN fab_recipiente rec ON rec.id_fab_recipiente = det.id_fab_recipiente
      WHERE det.id_fab_con_pd_cab = ?
      ORDER BY $orderBy
    ''', [cabeceraId]);
    return result.map((map) => ConPdDetExtended.fromMap(map)).toList();
  }

  Future<List<ConPdDetExtended>> getAllWithDescriptionsFiltered({
    required int cabeceraId,
    String? actividadFilter,
    String? tipoMasaFilter,
    String? recipienteFilter,
    String orderBy = 'fecha_notificacion DESC',
  }) async {
    final Database db = await DBHelper.database;
    List<String> conditions = ["det.id_fab_con_pd_cab = '$cabeceraId'"];
    if (actividadFilter != null && actividadFilter.isNotEmpty) {
      final safeActividad = actividadFilter.replaceAll("'", "''");
      conditions.add("act.descripcion LIKE '%$safeActividad%'");
    }
    if (tipoMasaFilter != null && tipoMasaFilter.isNotEmpty) {
      final safeTipoMasa = tipoMasaFilter.replaceAll("'", "''");
      conditions.add("tm.descripcion LIKE '%$safeTipoMasa%'");
    }
    if (recipienteFilter != null && recipienteFilter.isNotEmpty) {
      final safeRecipiente = recipienteFilter.replaceAll("'", "''");
      conditions.add("rec.descripcion LIKE '%$safeRecipiente%'");
    }
    final String whereClause = conditions.isNotEmpty ? 'WHERE ${conditions.join(' AND ')}' : '';
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT det.*,
        act.descripcion AS descripcionActividad,
        tm.descripcion AS descripcionTipoMasa,
        rec.descripcion AS descripcionRecipiente
      FROM fab_con_pd_det det
      LEFT JOIN fab_actividad act ON act.id_fab_actividad = det.id_fab_actividad
      LEFT JOIN fab_tipo_masa tm ON tm.id_fab_tipo_masa = det.id_fab_tipo_masa
      LEFT JOIN fab_recipiente rec ON rec.id_fab_recipiente = det.id_fab_recipiente
      $whereClause
      ORDER BY $orderBy
    ''');
    return result.map((map) => ConPdDetExtended.fromMap(map)).toList();
  }

  // Método para obtener las opciones de filtrado sobre actividades, tipos de masa y recipientes.
  Future<List<String>> getFilterActividades(int cabeceraId) async {
    final Database db = await DBHelper.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT DISTINCT act.descripcion
      FROM fab_con_pd_det det
      INNER JOIN fab_actividad act ON act.id_fab_actividad = det.id_fab_actividad
      WHERE det.id_fab_con_pd_cab = ?
      ORDER BY act.descripcion
    ''', [cabeceraId]);
    return result.map((row) => row["descripcion"] as String).toList();
  }

  Future<List<String>> getFilterTiposMasa(int cabeceraId) async {
    final Database db = await DBHelper.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT DISTINCT tm.descripcion
      FROM fab_con_pd_det det
      INNER JOIN fab_tipo_masa tm ON tm.id_fab_tipo_masa = det.id_fab_tipo_masa
      WHERE det.id_fab_con_pd_cab = ?
      ORDER BY tm.descripcion
    ''', [cabeceraId]);
    return result.map((row) => row["descripcion"] as String).toList();
  }

  Future<List<String>> getFilterRecipientes(int cabeceraId) async {
    final Database db = await DBHelper.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT DISTINCT rec.descripcion
      FROM fab_con_pd_det det
      INNER JOIN fab_recipiente rec ON rec.id_fab_recipiente = det.id_fab_recipiente
      WHERE det.id_fab_con_pd_cab = ?
      ORDER BY rec.descripcion
    ''', [cabeceraId]);
    return result.map((row) => row["descripcion"] as String).toList();
  }

  // Nuevo método: Valida si existe al menos un registro en la tabla 'fab_con_pd_det'
  // para un id de cabecera dado (por ejemplo, el turno activo declarado en las preferencias).
  Future<bool> existsDetalleForCabecera(int cabeceraId) async {
    final Database db = await DBHelper.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT COUNT(*) as count
      FROM fab_con_pd_det
      WHERE id_fab_con_pd_cab = ?
    ''', [cabeceraId]);
    final int? count = Sqflite.firstIntValue(result);
    return count != null && count > 0;
  }
}