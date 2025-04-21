import 'package:app_pd_cocimiento/data/repositories/base_repository.dart';
import 'package:app_pd_cocimiento/core/models/db/recipiente.dart';

class RecipienteRepository extends BaseRepository<Recipiente> {
  RecipienteRepository() : super(
    tableName: 'fab_recipiente',
    fromMap: (map) => Recipiente.fromMap(map),
    toMap: (recipiente) => recipiente.toMap(),
  );
}
