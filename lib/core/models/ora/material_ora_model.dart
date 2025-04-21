import 'dart:convert';

class MaterialOra {
    String descCorta;
    String descripcion;
    int idFabMaterial;

    MaterialOra({
        required this.descCorta,
        required this.descripcion,
        required this.idFabMaterial,
    });

    factory MaterialOra.fromJson(String str) => MaterialOra.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory MaterialOra.fromMap(Map<String, dynamic> json) => MaterialOra(
        descCorta: json["descCorta"],
        descripcion: json["descripcion"],
        idFabMaterial: json["idFabMaterial"],
    );

    Map<String, dynamic> toMap() => {
        "descCorta": descCorta,
        "descripcion": descripcion,
        "idFabMaterial": idFabMaterial,
    };
}
