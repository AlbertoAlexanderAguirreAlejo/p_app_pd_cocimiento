import 'package:app_pd_cocimiento/data/repositories/base_repository.dart';
import 'package:app_pd_cocimiento/core/models/db/material.dart';

class MaterialRepository extends BaseRepository<Materiales> {
  MaterialRepository() : super(
    tableName: 'fab_material',
    fromMap: (map) => Materiales.fromMap(map),
    toMap: (material) => material.toMap(),
  );
}
