import 'dart:convert';

class ConPdNivel {
  int idFabConPdNivel;
  int idFabConPdCab;
  int idFabConPdRecipiente;
  int idFabMaterial;
  double nivel;
  int flagEstado;
  String usrCreacion;

  ConPdNivel({
    required this.idFabConPdNivel,
    required this.idFabConPdCab,
    required this.idFabConPdRecipiente,
    required this.idFabMaterial,
    required this.nivel,
    required this.flagEstado,
    required this.usrCreacion,
  });

  factory ConPdNivel.fromJson(String str) => ConPdNivel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ConPdNivel.fromMap(Map<String, dynamic> json) => ConPdNivel(
    idFabConPdNivel: json["id_fab_con_pd_nivel"],
    idFabConPdCab: json["id_fab_con_pd_cab"],
    idFabConPdRecipiente: json["id_fab_recipiente"],
    idFabMaterial: json["id_fab_material"],
    nivel: json["nivel"]?.toDouble(),
    flagEstado: json["flag_estado"],
    usrCreacion: json["usr_creacion"],
  );

  Map<String, dynamic> toMap() => {
    "id_fab_con_pd_nivel": idFabConPdNivel == 0 ? null : idFabConPdNivel,
    "id_fab_con_pd_cab": idFabConPdCab,
    "id_fab_recipiente": idFabConPdRecipiente,
    "id_fab_material": idFabMaterial,
    "nivel": nivel,
    "flag_estado": flagEstado,
    "usr_creacion": usrCreacion,
  };
}
