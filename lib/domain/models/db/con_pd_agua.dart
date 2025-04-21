import 'dart:convert';

class ConPdAgua {
  int idFabConPdAgua;
  int idFabConPdCab;
  String fechaNotificacion;
  int idFabRecipiente;
  double pSig;
  int flagTipo;
  int flagEstado;
  String usrCreacion;

  ConPdAgua({
    required this.idFabConPdAgua,
    required this.idFabConPdCab,
    required this.fechaNotificacion,
    required this.idFabRecipiente,
    required this.pSig,
    required this.flagTipo,
    required this.flagEstado,
    required this.usrCreacion,
  });

  factory ConPdAgua.fromJson(String str) => ConPdAgua.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ConPdAgua.fromMap(Map<String, dynamic> json) => ConPdAgua(
    idFabConPdAgua: json["id_fab_con_pd_agua"],
    idFabConPdCab: json["id_fab_con_pd_cab"],
    fechaNotificacion: json["fecha_notificacion"],
    idFabRecipiente: json["id_fab_recipiente"],
    pSig: json["p_sig"]?.toDouble(),
    flagTipo: json["flag_tipo"],
    flagEstado: json["flag_estado"],
    usrCreacion: json["usr_creacion"],
  );

  Map<String, dynamic> toMap() => {
    "id_fab_con_pd_agua": idFabConPdAgua == 0? null : idFabConPdAgua,
    "id_fab_con_pd_cab": idFabConPdCab,
    "fecha_notificacion": fechaNotificacion,
    "id_fab_recipiente": idFabRecipiente,
    "p_sig": pSig,
    "flag_tipo": flagTipo,
    "flag_estado": flagEstado,
    "usr_creacion": usrCreacion,
  };
}
