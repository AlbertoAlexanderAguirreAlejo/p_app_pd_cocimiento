import 'dart:convert';

class ConPdObs {
    int idFabConPdObs;
    int idFabConPdCab;
    String descripcion;
    int flagTipo;
    int flagEstado;
    String usrCreacion;

    ConPdObs({
        required this.idFabConPdObs,
        required this.idFabConPdCab,
        required this.descripcion,
        required this.flagTipo,
        required this.flagEstado,
        required this.usrCreacion,
    });

    factory ConPdObs.fromJson(String str) => ConPdObs.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ConPdObs.fromMap(Map<String, dynamic> json) => ConPdObs(
        idFabConPdObs: json["id_fab_con_pd_obs"],
        idFabConPdCab: json["id_fab_con_pd_cab"],
        descripcion: json["descripcion"],
        flagTipo: json["flag_tipo"],
        flagEstado: json["flag_estado"],
        usrCreacion: json["usr_creacion"],
    );

    Map<String, dynamic> toMap() => {
        "id_fab_con_pd_obs": idFabConPdObs,
        "id_fab_con_pd_cab": idFabConPdCab,
        "descripcion": descripcion,
        "flag_tipo": flagTipo,
        "flag_estado": flagEstado,
        "usr_creacion": usrCreacion,
    };
}
