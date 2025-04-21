import 'dart:convert';

class TipoMasaOra {
    String descripcion;
    int idFabTipoMasa;

    TipoMasaOra({
        required this.descripcion,
        required this.idFabTipoMasa,
    });

    factory TipoMasaOra.fromJson(String str) => TipoMasaOra.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TipoMasaOra.fromMap(Map<String, dynamic> json) => TipoMasaOra(
        descripcion: json["descripcion"],
        idFabTipoMasa: json["idFabTipoMasa"],
    );

    Map<String, dynamic> toMap() => {
        "descripcion": descripcion,
        "idFabTipoMasa": idFabTipoMasa,
    };
}
