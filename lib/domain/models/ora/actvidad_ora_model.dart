import 'dart:convert';

class ActividadOra {
    String descripcion;
    int flagCristalizador;
    int flagDestinoActividad;
    int flagReqActividad;
    int idFabActividad;

    ActividadOra({
        required this.descripcion,
        required this.flagCristalizador,
        required this.flagDestinoActividad,
        required this.flagReqActividad,
        required this.idFabActividad,
    });

    factory ActividadOra.fromJson(String str) => ActividadOra.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ActividadOra.fromMap(Map<String, dynamic> json) => ActividadOra(
        descripcion: json["descripcion"],
        flagCristalizador: json["flagCristalizador"],
        flagDestinoActividad: json["flagDestinoActividad"],
        flagReqActividad: json["flagReqActividad"],
        idFabActividad: json["idFabActividad"],
    );

    Map<String, dynamic> toMap() => {
        "descripcion": descripcion,
        "flagCristalizador": flagCristalizador,
        "flagDestinoActividad": flagDestinoActividad,
        "flagReqActividad": flagReqActividad,
        "idFabActividad": idFabActividad,
    };
}
