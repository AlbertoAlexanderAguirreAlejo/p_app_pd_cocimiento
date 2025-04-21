import 'dart:convert';

class MasaActRecOra {
    int idFabActividad;
    int idFabMasaActRec;
    int? idFabRecipiente;
    int idFabTipoMasa;

    MasaActRecOra({
        required this.idFabActividad,
        required this.idFabMasaActRec,
        this.idFabRecipiente,
        required this.idFabTipoMasa,
    });

    factory MasaActRecOra.fromJson(String str) => MasaActRecOra.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory MasaActRecOra.fromMap(Map<String, dynamic> json) => MasaActRecOra(
        idFabActividad: json["idFabActividad"],
        idFabMasaActRec: json["idFabMasaActRec"],
        idFabRecipiente: json["idFabRecipiente"],
        idFabTipoMasa: json["idFabTipoMasa"],
    );

    Map<String, dynamic> toMap() => {
        "idFabActividad": idFabActividad,
        "idFabMasaActRec": idFabMasaActRec,
        "idFabRecipiente": idFabRecipiente,
        "idFabTipoMasa": idFabTipoMasa,
    };
}
