import 'package:app_pd_cocimiento/data/repositories/base_repository.dart';
import 'package:app_pd_cocimiento/core/models/db/actividad.dart';

class ActividadRepository extends BaseRepository<Actividad> {
  ActividadRepository() : super(
    tableName: 'fab_actividad',
    fromMap: (map) => Actividad.fromMap(map),
    toMap: (actividad) => actividad.toMap(),
  );
}
