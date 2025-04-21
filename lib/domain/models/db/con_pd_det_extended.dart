import 'con_pd_det.dart';

class ConPdDetExtended extends ConPdDet {
  final String? descripcionActividad;
  final String? descripcionRecipiente;
  final String? descripcionTipoMasa;

  ConPdDetExtended({
    required super.idFabConPdDet,
    required super.idFabConPdCab,
    required super.fechaNotificacion,
    required super.idFabTipoMasa,
    required super.idFabActividad,
    required super.idFabRecipiente,
    required super.cristalizador,
    required super.templa,
    required super.flagEstado,
    required super.usrCreacion,
    this.descripcionActividad,
    this.descripcionRecipiente,
    this.descripcionTipoMasa,
  });

  factory ConPdDetExtended.fromMap(Map<String, dynamic> json) => ConPdDetExtended(
        idFabConPdDet: json["id_fab_con_pd_det"],
        idFabConPdCab: json["id_fab_con_pd_cab"],
        fechaNotificacion: json["fecha_notificacion"],
        idFabTipoMasa: json["id_fab_tipo_masa"],
        idFabActividad: json["id_fab_actividad"],
        idFabRecipiente: json["id_fab_recipiente"],
        cristalizador: json["cristalizador"],
        templa: json["templa"],
        flagEstado: json["flag_estado"],
        usrCreacion: json["usr_creacion"],
        descripcionActividad: json["descripcionActividad"],
        descripcionRecipiente: json["descripcionRecipiente"],
        descripcionTipoMasa: json["descripcionTipoMasa"],
      );
}