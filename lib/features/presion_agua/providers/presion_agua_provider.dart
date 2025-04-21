import 'package:app_pd_cocimiento/core/constants/app_constants.dart';
import 'package:app_pd_cocimiento/core/constants/turnos.dart';
import 'package:app_pd_cocimiento/core/models/app/turno.dart';
import 'package:app_pd_cocimiento/core/models/db/con_pd_agua.dart';
import 'package:app_pd_cocimiento/core/models/db/recipiente.dart';
import 'package:app_pd_cocimiento/core/preferences/app_preferences.dart';
import 'package:app_pd_cocimiento/data/repositories/con_pd_agua_repository.dart';
import 'package:app_pd_cocimiento/data/repositories/recipiente_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PresionAguaProvider extends ChangeNotifier {
  // Repositorios inyectados.
  final ConPdAguaRepository conPdAguaRepository;
  final RecipienteRepository recipienteRepository;

  // Lista completa de registros de presión de agua (tabla fab_con_pd_agua).
  List<ConPdAgua> presionItems = [];

  // Lista de tachos disponibles.
  List<Recipiente> tachos = [];

  // Referencia a las preferencias (para obtener fecha, turno, cabecera, etc).
  final AppPreferences appPreferences;

  PresionAguaProvider({
    required this.conPdAguaRepository,
    required this.recipienteRepository,
    required this.appPreferences,
  });

  /// Inicializa la data:
  /// - Carga los tachos.
  /// - Basándose en la fecha activa y turno activo definidos en las preferencias,
  ///   verifica que existan los registros por hora (excluyendo la primera hora de cada turno) para cada tipo (Piscina: flagTipo == 1; Columna: flagTipo == 2).
  ///   Si faltan registros, los crea.
  /// - Finalmente, refresca la lista de registros (presionItems) filtrando por activeCabeceraId.
  Future<void> initData() async {
    try {
      // 1. Cargar la lista de tachos.
      tachos = await recipienteRepository.getByConditions(
        conditions: {'flag_tipo': AppConstants.tipoTachos},
        orderBy: 'descripcion',
      );

      // 2. Leer la fecha activa y el turno activo desde las preferencias.
      final String activeFechaStr = appPreferences.activeFecha; // Debe estar en "yyyy-MM-dd"
      final int turnoActivo = appPreferences.activeTurno;
      final Turno turno = Turnos.getTurno(turnoActivo);

      // Parsear la fecha activa.
      final DateTime activeFecha = DateTime.parse(activeFechaStr);

      // 3. Determinar el límite de horas en base al turno.
      DateTime now = DateTime.now();
      DateTime effectiveEnd;
      if (turno.numero == 1 || turno.numero == 2) {
        if (now.year == activeFecha.year &&
            now.month == activeFecha.month &&
            now.day == activeFecha.day &&
            now.hour < turno.end.hour) {
          effectiveEnd = DateTime(activeFecha.year, activeFecha.month, activeFecha.day, now.hour);
        } else {
          effectiveEnd = DateTime(activeFecha.year, activeFecha.month, activeFecha.day, turno.end.hour);
        }
      } else {
        if (now.year == activeFecha.year &&
            now.month == activeFecha.month &&
            now.day == activeFecha.day &&
            now.hour < 23) {
          effectiveEnd = DateTime(activeFecha.year, activeFecha.month, activeFecha.day, 23);
        } else {
          effectiveEnd = DateTime(activeFecha.year, activeFecha.month, activeFecha.day)
              .add(const Duration(days: 1));
          effectiveEnd = DateTime(effectiveEnd.year, effectiveEnd.month, effectiveEnd.day, turno.end.hour);
        }
      }

      // 4. Generar la lista de horas esperadas (excluyendo la primera hora de cada turno).
      List<int> expectedHours = [];
      if (turno.numero != 3) {
        // Para turnos 1 y 2: se generan las horas desde (turno.start.hour + 1) hasta effectiveEnd.hour (inclusive).
        for (int h = turno.start.hour + 1; h <= effectiveEnd.hour; h++) {
          expectedHours.add(h);
        }
      } else {
        // Para turno 3 (o 0): siempre se generan las horas desde (turno.start.hour + 1) hasta las 23
        // y luego desde 0 hasta turno.end.hour (inclusive).
        for (int h = turno.start.hour + 1; h < 24; h++) {
          expectedHours.add(h);
        }
        for (int h = 0; h <= turno.end.hour; h++) {
          expectedHours.add(h);
        }
      }

      // 5. Consultar los registros existentes filtrados por activeCabeceraId.
      final List<ConPdAgua> existingRecords = await conPdAguaRepository.getByConditions(
        conditions: {
          'id_fab_con_pd_cab': appPreferences.activeCabeceraId.toString(),
        },
        orderBy: "fecha_notificacion ASC",
      );

      Set<int> existingHoursPiscina = {};
      Set<int> existingHoursColumna = {};
      for (var record in existingRecords) {
        DateTime dt = DateTime.parse(record.fechaNotificacion);
        if (record.flagTipo == 1) {
          existingHoursPiscina.add(dt.hour);
        } else if (record.flagTipo == 2) {
          existingHoursColumna.add(dt.hour);
        }
      }

      // 6. Para cada hora esperada, si falta un registro para cada tipo, crear el registro.
      for (int hour in expectedHours) {
        // Para Piscina (flagTipo == 1)
        if (!existingHoursPiscina.contains(hour)) {
          DateTime newDt = DateTime(activeFecha.year, activeFecha.month, activeFecha.day, hour, 0);
          if (turno.numero == 3 && newDt.hour < turno.start.hour) {
            newDt = newDt.add(const Duration(days: 1));
          }
          ConPdAgua newRecordPiscina = ConPdAgua(
            idFabConPdAgua: 0,
            idFabConPdCab: appPreferences.activeCabeceraId,
            fechaNotificacion: DateFormat('yyyy-MM-dd HH:mm:ss').format(newDt),
            idFabRecipiente: 0,
            pSig: 0,
            flagTipo: 1,
            flagEstado: 1,
            usrCreacion: appPreferences.user,
          );
          await conPdAguaRepository.insert(newRecordPiscina);
        }
        // Para Columna (flagTipo == 2)
        if (!existingHoursColumna.contains(hour)) {
          DateTime newDt = DateTime(activeFecha.year, activeFecha.month, activeFecha.day, hour, 0);
          if (turno.numero == 3 && newDt.hour < turno.start.hour) {
            newDt = newDt.add(const Duration(days: 1));
          }
          ConPdAgua newRecordColumna = ConPdAgua(
            idFabConPdAgua: 0,
            idFabConPdCab: appPreferences.activeCabeceraId,
            fechaNotificacion: DateFormat('yyyy-MM-dd HH:mm:ss').format(newDt),
            idFabRecipiente: 0,
            pSig: 0,
            flagTipo: 2,
            flagEstado: 1,
            usrCreacion: appPreferences.user,
          );
          await conPdAguaRepository.insert(newRecordColumna);
        }
      }

      // 7. Actualizar la lista de registros.
      await fetchPresionAgua();
    } catch (e) {
      debugPrint("Error en initData de PresionAguaProvider: $e");
    } finally {
      notifyListeners();
    }
  }

  /// Retorna los registros de "Piscina" (flagTipo == 1).
  List<ConPdAgua> get presionPiscina =>
      presionItems.where((item) => item.flagTipo == 1).toList();

  /// Retorna los registros de "Columna" (flagTipo == 2).
  List<ConPdAgua> get presionColumna =>
      presionItems.where((item) => item.flagTipo == 2).toList();

  /// Hace un fetch de los registros de agua filtrados por activeCabeceraId.
  Future<void> fetchPresionAgua() async {
    try {
      presionItems = await conPdAguaRepository.getByConditions(
        conditions: {
          'id_fab_con_pd_cab': appPreferences.activeCabeceraId.toString()
        },
        orderBy: 'fecha_notificacion DESC',
      );
    } catch (e) {
      debugPrint("Error en fetchPresionAgua: $e");
    } finally {
      notifyListeners();
    }
  }

  /// Actualiza el valor de presión (p_sig) de un registro.
  Future<void> updatePsig(int idFabConPdAgua, double newPsig) async {
    try {
      await conPdAguaRepository.updateFieldsWithConditions(
        fields: {'p_sig': newPsig},
        conditions: {'id_fab_con_pd_agua': idFabConPdAgua.toString()},
      );
      await fetchPresionAgua(); // Recargar registros
    } catch (e) {
      debugPrint("Error actualizando pSig: $e");
      rethrow;
    }
  }

  /// Actualiza el tacho (id_fab_recipiente) de un registro.
  Future<void> updateTacho(int idFabConPdAgua, int newIdFabRecipiente) async {
    try {
      await conPdAguaRepository.updateFieldsWithConditions(
        fields: {'id_fab_recipiente': newIdFabRecipiente},
        conditions: {'id_fab_con_pd_agua': idFabConPdAgua.toString()},
      );
      await fetchPresionAgua(); // Recargar registros
    } catch (e) {
      debugPrint("Error actualizando tacho: $e");
      rethrow;
    }
  }
}
