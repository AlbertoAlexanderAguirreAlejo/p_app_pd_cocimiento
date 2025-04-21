import 'package:app_pd_cocimiento/domain/models/db/con_pd_cab.dart';
import 'package:app_pd_cocimiento/domain/repositories/con_pd_cab_repository.dart';
import 'package:intl/intl.dart';

class CabeceraService {
  final ConPdCabRepository repository;

  CabeceraService({required this.repository});

  /// Busca (o crea) un registro en fab_con_pd_cab para la fecha y turno indicados.
  /// Si [turno] es 0, se utiliza la fecha del día anterior y se considera el turno 3.
  /// Devuelve el id del registro de cabecera.
  Future<int> getOrCreateCabecera(DateTime date, int turno) async {
    if (turno == 0) {
      date = date.subtract(const Duration(days: 1));
      turno = 3;
    }
    final String datePart = DateFormat('yyyy-MM-dd').format(date);

    // Se busca en la base de datos donde la fecha (solo la parte) y el turno coincidan.
    List<ConPdCab> results = await repository.getByConditions(
      conditions: {
        "fecha_notificacion": datePart,
        "turno": turno,
      },
      orderBy: "id_fab_con_pd_cab ASC",
    );

    if (results.isNotEmpty) {
      return results.first.idFabConPdCab;
    } else {
      // Como no queremos modificar el modelo, creamos el registro con los campos existentes.
      ConPdCab newCab = ConPdCab(
        idFabConPdCab: 0,
        fechaNotificacion: datePart,
        turno: turno,
        maestroAzucarero: "",
        flagEstado: 1,
        usrCreacion: "",
      );
      // Insertamos el registro y obtenemos el id.
      int cabeceraId = await repository.insert(newCab);
      // El header se genera on‑the‑fly, por lo que se usará en la preferencia junto con el id.
      return cabeceraId;
    }
  }
}
