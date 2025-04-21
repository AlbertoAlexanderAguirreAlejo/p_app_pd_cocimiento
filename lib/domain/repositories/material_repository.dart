import 'package:app_pd_cocimiento/domain/repositories/base_repository.dart';
import 'package:app_pd_cocimiento/domain/models/db/material.dart';

class MaterialRepository extends BaseRepository<Materiales> {
  MaterialRepository() : super(
    tableName: 'fab_material',
    fromMap: (map) => Materiales.fromMap(map),
    toMap: (material) => material.toMap(),
  );
}
