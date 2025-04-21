import 'package:app_pd_cocimiento/domain/models/app/turno.dart';
import 'package:flutter/material.dart';

class Turnos {
  static const Turno turno1 = Turno(
      numero: 1,
      start: TimeOfDay(hour: 6, minute: 0),
      end: TimeOfDay(hour: 14, minute: 0));

  static const Turno turno2 = Turno(
      numero: 2,
      start: TimeOfDay(hour: 14, minute: 0),
      end: TimeOfDay(hour: 22, minute: 0));

  // El turno 3 inicia a las 10:00 PM y finaliza a las 6:00 AM (del día siguiente).
  static const Turno turno3 = Turno(
      numero: 3,
      start: TimeOfDay(hour: 22, minute: 0),
      end: TimeOfDay(hour: 6, minute: 0));

  /// Retorna el turno correspondiente.
  /// Se interpreta que 0 equivale a turno 3 (del día anterior)
  static Turno getTurno(int numero) {
    switch (numero) {
      case 1:
        return turno1;
      case 2:
        return turno2;
      case 3:
      case 0:
        return turno3;
      default:
        throw Exception("Turno inválido");
    }
  }

  /// Verifica si [dateTime] está dentro del rango permitido para el [turno].
  /// Para turnos 1 y 2 es sencillo; para turno3 se maneja el cruce de medianoche.
  static bool isWithinTurno(DateTime dateTime, Turno turno) {
    final time = TimeOfDay.fromDateTime(dateTime);
    if (turno.numero != 3) {
      // Calculamos los minutos totales del día.
      final int startMinutes = turno.start.hour * 60 + turno.start.minute;
      final int endMinutes = turno.end.hour * 60 + turno.end.minute;
      final int timeMinutes = time.hour * 60 + time.minute;
      return timeMinutes >= startMinutes && timeMinutes < endMinutes;
    } else {
      // Para turno 3: Se permite si la hora es >= 22:00 o < 6:00.
      return (time.hour >= turno.start.hour) || (time.hour < turno.end.hour);
    }
  }
}