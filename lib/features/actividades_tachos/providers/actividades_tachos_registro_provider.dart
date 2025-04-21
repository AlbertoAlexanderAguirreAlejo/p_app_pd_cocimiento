import 'package:app_pd_cocimiento/core/shared/constants/app_constants.dart';
import 'package:app_pd_cocimiento/domain/models/db/actividad.dart';
import 'package:app_pd_cocimiento/domain/models/db/con_pd_det.dart';
import 'package:app_pd_cocimiento/domain/models/db/recipiente.dart';
import 'package:app_pd_cocimiento/domain/models/db/tipo_masa.dart';
import 'package:app_pd_cocimiento/core/infrastructure/preferences/app_preferences.dart';
import 'package:app_pd_cocimiento/domain/repositories/actividad_repository.dart';
import 'package:app_pd_cocimiento/domain/repositories/con_pd_det_repository.dart';
import 'package:app_pd_cocimiento/domain/repositories/masa_act_rec_repository.dart';
import 'package:app_pd_cocimiento/domain/repositories/recipiente_repository.dart';
import 'package:app_pd_cocimiento/domain/repositories/tipo_masa_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActividadesTachosRegistroProvider extends ChangeNotifier {
  // Variables de selección
  Recipiente? selectedTacho;
  DateTime selectedDateTime = DateTime.now();
  TipoMasa? selectedTipoMasa;
  Actividad? selectedActividad;
  Recipiente? selectedTachoDestino;
  Recipiente? selectedCristalizador;

  // Listas precargadas
  List<Recipiente> tachos = [];
  List<TipoMasa> tiposMasa = [];
  List<Actividad> actividades = [];
  List<Recipiente> tachosDestino = [];
  List<Recipiente> cristalizadores = [];

  // Repositorios
  final MasaActRecRepository masaActRecRepository;
  final RecipienteRepository recipienteRepository;
  final TipoMasaRepository tipoMasaRepository;
  final ActividadRepository actividadRepository;
  final ConPdDetRepository conPdDetRepository;

  // Referencia a preferencias para obtener el usuario y el id de cabecera.
  final AppPreferences appPreferences;

  // Registro a editar. Si es null, es modo creación.
  ConPdDet? editingDetalle;

  ActividadesTachosRegistroProvider({
    required this.masaActRecRepository,
    required this.recipienteRepository,
    required this.tipoMasaRepository,
    required this.actividadRepository,
    required this.conPdDetRepository,
    required this.appPreferences,
  });

  /// Inicializa las listas con datos.
  Future<void> initData() async {
    final results = await Future.wait([
      recipienteRepository.getByConditions(conditions: {'flag_tipo': AppConstants.tipoTachos}, orderBy: 'descripcion'),
      recipienteRepository.getByConditions(conditions: {'flag_tipo': AppConstants.tipoGraneros}, orderBy: 'descripcion'),
      tipoMasaRepository.getAll(orderBy: 'descripcion'),
      actividadRepository.getAll(orderBy: 'descripcion'),
      recipienteRepository.getByConditions(conditions: {'flag_tipo': AppConstants.tipoCristalizador}, orderBy: 'descripcion'),
    ]);
    tachos = results[0] as List<Recipiente>;
    tachos.addAll((results[1] as List<Recipiente>).where((recipiente) => recipiente.descripcion.startsWith("Granero")));
    tachosDestino = results[0] as List<Recipiente>;
    tiposMasa = results[2] as List<TipoMasa>;
    actividades = results[3] as List<Actividad>;
    cristalizadores = results[4] as List<Recipiente>;
    notifyListeners();
  }

  // Métodos para actualizar las selecciones…
  void selectTacho(Recipiente? tacho) {
    selectedTacho = tacho;
    // Al cambiar el tacho, reiniciamos las opciones dependientes.
    selectedTipoMasa = null;
    selectedActividad = null;
    selectedTachoDestino = null;
    selectedCristalizador = null;
    notifyListeners();
  }

  void selectTipoMasa(TipoMasa? tipoMasa) {
    selectedTipoMasa = tipoMasa;
    // En modo edición no reiniciamos otros campos
    if (editingDetalle == null) {
      selectedActividad = null;
      selectedTachoDestino = null;
      selectedCristalizador = null;
    }
    notifyListeners();
  }

  void selectActividad(Actividad? actividad) {
    selectedActividad = actividad;
    if (editingDetalle == null) {
      if (actividad != null) {
        if (actividad.flagDestinoActividad == 0) {
          selectedTachoDestino = null;
        }
        if (actividad.flagCristalizador != 1) {
          selectedCristalizador = null;
        }
      } else {
        selectedTachoDestino = null;
        selectedCristalizador = null;
      }
    }
    notifyListeners();
  }

  void selectTachoDestino(Recipiente? tacho) {
    selectedTachoDestino = tacho;
    notifyListeners();
  }

  void selectCristalizador(Recipiente? cristalizador) {
    selectedCristalizador = cristalizador;
    notifyListeners();
  }

  Future<List<TipoMasa>> fetchFilteredTiposMasa() async {
    if (selectedTacho == null) return [];
    final allowedIds = await masaActRecRepository.getTipoMasaIdsForRecipiente();
    return tiposMasa.where((tm) => allowedIds.contains(tm.idFabTipoMasa)).toList();
  }

  Future<List<Actividad>> fetchFilteredActividades() async {
    if (selectedTacho == null || selectedTipoMasa == null) return [];
    final allowedActividadIds = await masaActRecRepository.getActividadIdsForTipoMasaAndRecipiente(selectedTipoMasa!.idFabTipoMasa);
    return actividades.where((a) => allowedActividadIds.contains(a.idFabActividad)).toList();
  }

  Future<List<Recipiente>> fetchFilteredTachosDestino() async {
    if (selectedTipoMasa == null || selectedActividad == null) return [];
    final allowedIds = await masaActRecRepository.getRecipienteIdsForTipoMasaAndActividad(
      selectedTipoMasa!.idFabTipoMasa,
      selectedActividad!.idFabActividad,
    );
    return tachosDestino.where((r) => allowedIds.contains(r.idFabRecipiente)).toList();
  }

  Future<List<Recipiente>> fetchFilteredCristalizadores() async {
    if (selectedTipoMasa == null || selectedActividad == null) return [];
    final allowedIds = await masaActRecRepository.getRecipienteIdsForTipoMasaAndActividad(
      selectedTipoMasa!.idFabTipoMasa,
      selectedActividad!.idFabActividad,
    );
    return cristalizadores.where((r) => allowedIds.contains(r.idFabRecipiente)).toList();
  }

  /// Registra un detalle consecuente basado en la actividad original.
  /// Se usa cuando la actividad seleccionada tiene flagDestinoActividad != 0.
  Future<void> registrarDetalleConcecuente({
    required int idRecipienteOrigen,
    required String fechaNotificacion,
    required int idTipoMasa,
    required Actividad actividadOrigen,
    required int idRecipienteDestino,
    required int cristalizador,
  }) async {
    try {
      // Validar que la actividad origen tenga flagDestinoActividad
      if (actividadOrigen.flagDestinoActividad == 0) return;

      // Buscar la actividad consecuente según el flagDestinoActividad
      final actividadConsecuente = actividades.firstWhere(
        (a) => a.idFabActividad == actividadOrigen.flagDestinoActividad,
        orElse: () => throw Exception("No se encontró la actividad consecuente"),
      );

      final ConPdDet detalleConcecuente = ConPdDet(
        idFabConPdDet: 0,
        idFabConPdCab: appPreferences.activeCabeceraId,
        fechaNotificacion: fechaNotificacion,
        idFabTipoMasa: idTipoMasa,
        idFabActividad: actividadConsecuente.idFabActividad,
        idFabRecipiente: idRecipienteDestino,
        cristalizador: cristalizador,
        templa: 0,
        flagEstado: 1,
        usrCreacion: appPreferences.user,
      );

      await conPdDetRepository.insert(detalleConcecuente);
    } catch (e) {
      debugPrint("Error en registrarDetalleConcecuente: $e");
      rethrow;
    }
  }

  /// Registra (o actualiza) un detalle en la base de datos.
  /// En modo creación se insertan todos los campos.
  /// En modo edición, solo se permiten actualizar: fechaNotificacion, idFabTipoMasa y idFabRecipiente.
  Future<void> registrarActividad() async {
    try {
      if (selectedTacho == null || selectedTipoMasa == null) {
        throw Exception("Faltan datos obligatorios para registrar la actividad");
      }
      final int cabeceraId = appPreferences.activeCabeceraId;
      if (cabeceraId == 0) {
        throw Exception("No se ha asignado una cabecera activa");
      }
      final String fechaNotificacion = DateFormat('yyyy-MM-ddTHH:mm:ss').format(selectedDateTime);
      final int idTipoMasa = selectedTipoMasa!.idFabTipoMasa;

      // En modo edición, mantenemos los otros valores originales.
      if (editingDetalle != null) {
        final ConPdDet original = editingDetalle!;
        final ConPdDet updated = ConPdDet(
          idFabConPdDet: original.idFabConPdDet,
          idFabConPdCab: original.idFabConPdCab,
          fechaNotificacion: fechaNotificacion,
          idFabTipoMasa: idTipoMasa,
          idFabActividad: original.idFabActividad,
          idFabRecipiente: selectedTacho!.idFabRecipiente,
          cristalizador: original.cristalizador,
          templa: 0,
          flagEstado: 1,
          usrCreacion: appPreferences.user,
        );
        await conPdDetRepository.updateFieldsWithConditions(
          fields: updated.toMap(),
          conditions: {'id_fab_con_pd_det': updated.idFabConPdDet},
        );
        editingDetalle = null;
      } else {
        // Modo creación
        if (selectedActividad == null) {
          throw Exception("Se debe seleccionar una actividad");
        }
        final int idActividad = selectedActividad!.idFabActividad;
        int idRecipiente = selectedTacho!.idFabRecipiente;
        int cristalizador = 0;
        int? idRecipienteDestino;

        if (selectedActividad!.flagDestinoActividad != 0) {
          if (selectedTachoDestino == null) {
            throw Exception("Se debe seleccionar un tacho destino para esta actividad");
          }
          idRecipienteDestino = selectedTachoDestino!.idFabRecipiente;
        }

        if (selectedActividad!.flagCristalizador == 1) {
          if (selectedCristalizador == null) {
            throw Exception("Se debe seleccionar un cristalizador para esta actividad");
          }
          cristalizador = selectedCristalizador!.idFabRecipiente;
        }

        // Registrar actividad principal
        final ConPdDet nuevoDetalle = ConPdDet(
          idFabConPdDet: 0,
          idFabConPdCab: appPreferences.activeCabeceraId,
          fechaNotificacion: DateFormat('yyyy-MM-ddTHH:mm:ss').format(selectedDateTime),
          idFabTipoMasa: selectedTipoMasa!.idFabTipoMasa,
          idFabActividad: idActividad,
          idFabRecipiente: idRecipiente,
          cristalizador: cristalizador,
          templa: 0,
          flagEstado: 1,
          usrCreacion: appPreferences.user,
        );

        await conPdDetRepository.insert(nuevoDetalle);


        // Si hay tacho destino, registrar el detalle consecuente
        if (idRecipienteDestino != null) {
          await registrarDetalleConcecuente(
            idRecipienteOrigen: idRecipiente,
            fechaNotificacion: nuevoDetalle.fechaNotificacion,
            idTipoMasa: nuevoDetalle.idFabTipoMasa,
            actividadOrigen: selectedActividad!,
            idRecipienteDestino: idRecipienteDestino,
            cristalizador: cristalizador,
          );
        }
      }
      // Reinicia los campos (manteniendo el tacho seleccionado).
      selectedTipoMasa = null;
      if (editingDetalle == null) {
        selectedActividad = null;
        selectedTachoDestino = null;
        selectedCristalizador = null;
      }
      selectedDateTime = DateTime.now();
      notifyListeners();
    } catch (e) {
      debugPrint("Error en registrarActividad: $e");
      rethrow;
    }
  }

  /// Carga un detalle existente para edición. Solo se permiten editar:
  /// fechaNotificacion, tipo de masa y tacho principal.
  void cargarDetalleParaEdicion(ConPdDet detalle) {
    editingDetalle = detalle;
    selectedDateTime = DateTime.tryParse(detalle.fechaNotificacion) ?? DateTime.now();
    try {
      selectedTacho = tachos.firstWhere((rec) => rec.idFabRecipiente == detalle.idFabRecipiente);
    } catch (e) {
      selectedTacho = null;
    }
    try {
      selectedTipoMasa = tiposMasa.firstWhere((tm) => tm.idFabTipoMasa == detalle.idFabTipoMasa);
    } catch (e) {
      selectedTipoMasa = null;
    }
    // No se cambian actividad, tacho destino y cristalizador en modo edición.
    notifyListeners();
  }
}
