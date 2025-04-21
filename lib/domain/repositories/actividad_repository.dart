import 'package:app_pd_cocimiento/domain/repositories/base_repository.dart';
import 'package:app_pd_cocimiento/domain/models/db/actividad.dart';

class ActividadRepository extends BaseRepository<Actividad> {
  ActividadRepository() : super(
    tableName: 'fab_actividad',
    fromMap: (map) => Actividad.fromMap(map),
    toMap: (actividad) => actividad.toMap(),
  );
}
