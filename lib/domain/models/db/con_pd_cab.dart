import 'dart:convert';

class ConPdCab {
  int idFabConPdCab;
  String fechaNotificacion;
  int turno;
  String maestroAzucarero;
  int flagEstado;
  String usrCreacion;

  ConPdCab({
    required this.idFabConPdCab,
    required this.fechaNotificacion,
    required this.turno,
    required this.maestroAzucarero,
    required this.flagEstado,
    required this.usrCreacion,
  });

  factory ConPdCab.fromJson(String str) => ConPdCab.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ConPdCab.fromMap(Map<String, dynamic> json) => ConPdCab(
    idFabConPdCab: json["id_fab_con_pd_cab"],
    fechaNotificacion: json["fecha_notificacion"],
    turno: json["turno"],
    maestroAzucarero: json["maestro_azucarero"],
    flagEstado: json["flag_estado"],
    usrCreacion: json["usr_creacion"],
  );

  Map<String, dynamic> toMap() => {
    "id_fab_con_pd_cab": idFabConPdCab == 0? null : idFabConPdCab,
    "fecha_notificacion": fechaNotificacion,
    "turno": turno,
    "maestro_azucarero": maestroAzucarero,
    "flag_estado": flagEstado,
    "usr_creacion": usrCreacion,
  };
}
