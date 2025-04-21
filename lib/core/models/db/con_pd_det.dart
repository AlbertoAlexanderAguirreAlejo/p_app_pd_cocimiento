import 'dart:convert';

class ConPdDet {
  int idFabConPdDet;
  int idFabConPdCab;
  String fechaNotificacion;
  int idFabTipoMasa;
  int idFabActividad;
  int idFabRecipiente;
  int cristalizador;
  int templa;
  int flagEstado;
  String usrCreacion;

  ConPdDet({
    required this.idFabConPdDet,
    required this.idFabConPdCab,
    required this.fechaNotificacion,
    required this.idFabTipoMasa,
    required this.idFabActividad,
    required this.idFabRecipiente,
    required this.cristalizador,
    required this.templa,
    required this.flagEstado,
    required this.usrCreacion,
  });

  factory ConPdDet.fromJson(String str) => ConPdDet.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ConPdDet.fromMap(Map<String, dynamic> json) => ConPdDet(
    idFabConPdDet: json["id_fab_con_pd_det"],
    idFabConPdCab: json["id_fab_con_pd_cab"],
    fechaNotificacion: json["fecha_notificacion"],
    idFabTipoMasa: json["id_fab_tipo_masa"],
    idFabActividad: json["id_fab_actividad"],
    idFabRecipiente: json["id_fab_recipiente"],
    cristalizador: json["cristalizador"],
    templa: json["templa"],
    flagEstado: json["flag_estado"],
    usrCreacion: json["usr_creacion"],
  );

  Map<String, dynamic> toMap() => {
    "id_fab_con_pd_det": idFabConPdDet == 0? null : idFabConPdDet,
    "id_fab_con_pd_cab": idFabConPdCab,
    "fecha_notificacion": fechaNotificacion,
    "id_fab_tipo_masa": idFabTipoMasa,
    "id_fab_actividad": idFabActividad,
    "id_fab_recipiente": idFabRecipiente,
    "cristalizador": cristalizador,
    "templa": templa,
    "flag_estado": flagEstado,
    "usr_creacion": usrCreacion,
  };
}
