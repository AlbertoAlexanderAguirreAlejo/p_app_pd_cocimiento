import 'package:app_pd_cocimiento/core/preferences/preferences_service.dart';
import 'package:app_pd_cocimiento/core/preferences/keys.dart';

class AppPreferences {
  final PreferencesService _preferencesService;

  AppPreferences(this._preferencesService);

  // General
  String get estacion => _preferencesService.getString(PreferencesKeys.estacion);
  Future<bool> setEstacion(String value) =>
      _preferencesService.setString(PreferencesKeys.estacion, value);

  String get app => _preferencesService.getString(PreferencesKeys.app);
  Future<bool> setApp(String value) =>
      _preferencesService.setString(PreferencesKeys.app, value);

  String get centro => _preferencesService.getString(PreferencesKeys.centro);
  Future<bool> setCentro(String value) =>
      _preferencesService.setString(PreferencesKeys.centro, value);

  String get env => _preferencesService.getString(PreferencesKeys.env);
  Future<bool> setEnv(String value) =>
      _preferencesService.setString(PreferencesKeys.env, value);

  String get ultimaActualizacion =>
      _preferencesService.getString(PreferencesKeys.ultimaActualizacion);
  Future<bool> setUltimaActualizacion(String value) =>
      _preferencesService.setString(PreferencesKeys.ultimaActualizacion, value);

  // Auth
  String get user => _preferencesService.getString(PreferencesKeys.user);
  Future<bool> setUser(String value) =>
      _preferencesService.setString(PreferencesKeys.user, value);

  String get pass => _preferencesService.getString(PreferencesKeys.pass);
  Future<bool> setPass(String value) =>
      _preferencesService.setString(PreferencesKeys.pass, value);

  String get nombres => _preferencesService.getString(PreferencesKeys.nombres);
  Future<bool> setNombres(String value) =>
      _preferencesService.setString(PreferencesKeys.nombres, value);

  String get nroDoc => _preferencesService.getString(PreferencesKeys.nroDoc);
  Future<bool> setNroDoc(String value) =>
      _preferencesService.setString(PreferencesKeys.nroDoc, value);

  // Turno y Cabecera
  int get activeTurno {
    final value = _preferencesService.getString(PreferencesKeys.activeTurno);
    return int.tryParse(value) ?? 1;
  }

  String get activeHeader => _preferencesService.getString(PreferencesKeys.activeHeader);

  int get activeCabeceraId {
    final value = _preferencesService.getString(PreferencesKeys.activeCabeceraId);
    return int.tryParse(value) ?? 0;
  }

  String get activeFecha => _preferencesService.getString(PreferencesKeys.activeFecha);

  /// Almacena el turno activo, header, id de cabecera y la fecha (en formato "yyyy-MM-dd").
  Future<bool> setActiveTurno(int turno, String headerText, int cabeceraId, String fecha) async {
    final result1 = await _preferencesService.setString(PreferencesKeys.activeTurno, turno.toString());
    final result2 = await _preferencesService.setString(PreferencesKeys.activeHeader, headerText);
    final result3 = await _preferencesService.setString(PreferencesKeys.activeCabeceraId, cabeceraId.toString());
    final result4 = await _preferencesService.setString(PreferencesKeys.activeFecha, fecha);
    return result1 && result2 && result3 && result4;
  }

}
