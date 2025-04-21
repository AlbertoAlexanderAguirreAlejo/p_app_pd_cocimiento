import 'package:app_pd_cocimiento/domain/models/db/con_pd_obs.dart';
import 'base_repository.dart';

class ConPdObsRepository extends BaseRepository<ConPdObs> {
  ConPdObsRepository()
      : super(
          tableName: 'fab_con_pd_obs',
          fromMap: (map) => ConPdObs.fromMap(map),
          toMap: (obs) => obs.toMap(),
        );
}
