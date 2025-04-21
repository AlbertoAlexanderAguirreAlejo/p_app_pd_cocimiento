import 'package:app_pd_cocimiento/data/repositories/base_repository.dart';
import 'package:app_pd_cocimiento/core/models/db/tipo_masa.dart';

class TipoMasaRepository extends BaseRepository<TipoMasa> {
  TipoMasaRepository() : super(
    tableName: 'fab_tipo_masa',
    fromMap: (map) => TipoMasa.fromMap(map),
    toMap: (tipoMasa) => tipoMasa.toMap(),
  );
}
