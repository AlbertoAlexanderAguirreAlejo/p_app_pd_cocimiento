import 'package:app_pd_cocimiento/core/shared/constants/db/mantenimiento_columns.dart';
import 'package:app_pd_cocimiento/domain/repositories/base_repository.dart';
import 'package:app_pd_cocimiento/domain/models/db/mantenimiento.dart';

class MantenimientoRepository extends BaseRepository<Mantenimiento> {
  MantenimientoRepository() : super(
    tableName: 'mantenimiento',
    fromMap: (map) => Mantenimiento.fromMap(map),
    toMap: (info) => info.toMap(),
  );

  Future<int> registrarActualizacion({required String table}) async {
    final ultimaActualizacion = DateTime.now().toIso8601String().substring(0, 19);
    return await updateFieldsWithConditions(
      fields: {
        MantenimientoColumns.ultimaActualizacion: ultimaActualizacion
      },
      conditions: {
        MantenimientoColumns.tabla: table
      }
    );
  }
}