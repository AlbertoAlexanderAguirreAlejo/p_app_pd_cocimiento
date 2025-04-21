import 'package:app_pd_cocimiento/domain/repositories/base_repository.dart';
import 'package:app_pd_cocimiento/domain/models/db/recipiente.dart';

class RecipienteRepository extends BaseRepository<Recipiente> {
  RecipienteRepository() : super(
    tableName: 'fab_recipiente',
    fromMap: (map) => Recipiente.fromMap(map),
    toMap: (recipiente) => recipiente.toMap(),
  );
}
