import 'dart:convert';

class Actividad {
  int idFabActividad;
  String descripcion;
  int flagDestinoActividad;
  int flagCristalizador;
  int flagReqActividad;
  int flagEstado;

  Actividad({
    required this.idFabActividad,
    required this.descripcion,
    required this.flagDestinoActividad,
    required this.flagCristalizador,
    required this.flagReqActividad,
    required this.flagEstado,
  });

  factory Actividad.fromJson(String str) => Actividad.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Actividad.fromMap(Map<String, dynamic> json) => Actividad(
    idFabActividad: json["id_fab_actividad"],
    descripcion: json["descripcion"],
    flagDestinoActividad: json["flag_destino_actividad"],
    flagCristalizador: json["flag_cristalizador"],
    flagReqActividad: json["flag_req_actividad"],
    flagEstado: json["flag_estado"],
  );

  Map<String, dynamic> toMap() => {
    "id_fab_actividad": idFabActividad,
    "descripcion": descripcion,
    "flag_destino_actividad": flagDestinoActividad,
    "flag_cristalizador": flagCristalizador,
    "flag_req_actividad": flagReqActividad,
    "flag_estado": flagEstado,
  };
}
