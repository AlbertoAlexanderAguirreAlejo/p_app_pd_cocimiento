import 'dart:convert';

class Recipiente {
  int idFabRecipiente;
  String descripcion;
  int flagTipo;
  int flagEstado;

  Recipiente({
    required this.idFabRecipiente,
    required this.descripcion,
    required this.flagTipo,
    required this.flagEstado,
  });

  factory Recipiente.fromJson(String str) => Recipiente.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Recipiente.fromMap(Map<String, dynamic> json) => Recipiente(
    idFabRecipiente: json["id_fab_recipiente"],
    descripcion: json["descripcion"],
    flagTipo: json["flag_tipo"],
    flagEstado: json["flag_estado"],
  );

  Map<String, dynamic> toMap() => {
    "id_fab_recipiente": idFabRecipiente,
    "descripcion": descripcion,
    "flag_tipo": flagTipo,
    "flag_estado": flagEstado,
  };
}
