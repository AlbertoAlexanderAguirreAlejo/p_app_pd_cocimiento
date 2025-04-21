import 'dart:convert';

class MasaActRec {
  int idFabMasaActRec;
  int idFabTipoMasa;
  int idFabActividad;
  int idFabRecipiente;
  int flagEstado;

  MasaActRec({
    required this.idFabMasaActRec,
    required this.idFabTipoMasa,
    required this.idFabActividad,
    required this.idFabRecipiente,
    required this.flagEstado,
  });

  factory MasaActRec.fromJson(String str) => MasaActRec.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MasaActRec.fromMap(Map<String, dynamic> json) => MasaActRec(
    idFabMasaActRec: json["id_fab_masa_act_rec"],
    idFabTipoMasa: json["id_fab_tipo_masa"],
    idFabActividad: json["id_fab_actividad"],
    idFabRecipiente: json["id_fab_recipiente"],
    flagEstado: json["flag_estado"],
  );

  Map<String, dynamic> toMap() => {
    "id_fab_masa_act_rec": idFabMasaActRec,
    "id_fab_tipo_masa": idFabTipoMasa,
    "id_fab_actividad": idFabActividad,
    "id_fab_recipiente": idFabRecipiente,
    "flag_estado": flagEstado,
  };
}
