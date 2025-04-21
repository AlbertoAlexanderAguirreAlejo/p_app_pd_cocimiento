import 'package:app_pd_cocimiento/domain/repositories/base_repository.dart';
import 'package:app_pd_cocimiento/domain/models/db/con_pd_cab.dart';

class ConPdCabRepository extends BaseRepository<ConPdCab> {
  ConPdCabRepository() : super(
    tableName: 'fab_con_pd_cab',
    fromMap: (map) => ConPdCab.fromMap(map),
    toMap: (cab) => cab.toMap(),
  );
}
