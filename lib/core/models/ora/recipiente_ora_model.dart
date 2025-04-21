import 'dart:convert';

class RecipienteOra {
    String descripcion;
    int flagTipo;
    int idFabRecipiente;

    RecipienteOra({
        required this.descripcion,
        required this.flagTipo,
        required this.idFabRecipiente,
    });

    factory RecipienteOra.fromJson(String str) => RecipienteOra.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RecipienteOra.fromMap(Map<String, dynamic> json) => RecipienteOra(
        descripcion: json["descripcion"],
        flagTipo: json["flagTipo"],
        idFabRecipiente: json["idFabRecipiente"],
    );

    Map<String, dynamic> toMap() => {
        "descripcion": descripcion,
        "flagTipo": flagTipo,
        "idFabRecipiente": idFabRecipiente,
    };
}
