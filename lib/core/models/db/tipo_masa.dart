import 'dart:convert';

class TipoMasa {
  int idFabTipoMasa;
  String descripcion;
  int flagEstado;

  TipoMasa({
    required this.idFabTipoMasa,
    required this.descripcion,
    required this.flagEstado,
  });

  factory TipoMasa.fromJson(String str) => TipoMasa.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TipoMasa.fromMap(Map<String, dynamic> json) => TipoMasa(
    idFabTipoMasa: json["id_fab_tipo_masa"],
    descripcion: json["descripcion"],
    flagEstado: json["flag_estado"],
  );

  Map<String, dynamic> toMap() => {
    "id_fab_tipo_masa": idFabTipoMasa,
    "descripcion": descripcion,
    "flag_estado": flagEstado,
  };
}
