import 'dart:convert';

class LoginResponse {
    bool estado;
    String nombre;
    String nrodoc;
    String tipodoc;
    String user;

    LoginResponse({
        required this.estado,
        required this.nombre,
        required this.nrodoc,
        required this.tipodoc,
        required this.user,
    });

    factory LoginResponse.fromRawJson(String str) => LoginResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        estado: json["estado"],
        nombre: json["nombre"],
        nrodoc: json["nrodoc"],
        tipodoc: json["tipodoc"],
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "estado": estado,
        "nombre": nombre,
        "nrodoc": nrodoc,
        "tipodoc": tipodoc,
        "user": user,
    };
}