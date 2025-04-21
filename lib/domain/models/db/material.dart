import 'dart:convert';

class Materiales {
  int idFabMaterial;
  String descripcion;
  String descCorta;
  int flagEstado;

  Materiales({
    required this.idFabMaterial,
    required this.descripcion,
    required this.descCorta,
    required this.flagEstado,
  });

  factory Materiales.fromJson(String str) => Materiales.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Materiales.fromMap(Map<String, dynamic> json) => Materiales(
    idFabMaterial: json["id_fab_material"],
    descripcion: json["descripcion"],
    descCorta: json["desc_corta"],
    flagEstado: json["flag_estado"],
  );

  Map<String, dynamic> toMap() => {
    "id_fab_material": idFabMaterial,
    "descripcion": descripcion,
    "desc_corta": descCorta,
    "flag_estado": flagEstado,
  };
}
