import 'dart:convert';

class Mantenimiento {
  String tabla;
  String titulo;
  String ultimaActualizacion;

  Mantenimiento({
    required this.tabla,
    required this.titulo,
    required this.ultimaActualizacion,
  });

  factory Mantenimiento.fromJson(String str) => Mantenimiento.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Mantenimiento.fromMap(Map<String, dynamic> json) => Mantenimiento(
    tabla: json["tabla"],
    titulo: json["titulo"],
    ultimaActualizacion: json["ultima_actualizacion"],
  );

  Map<String, dynamic> toMap() => {
    "tabla": tabla,
    "titulo": titulo,
    "ultima_actualizacion": ultimaActualizacion,
  };
}
